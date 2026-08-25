"""Greedy compressor matching the Konami SNES decompressor in konami_d.py."""

from __future__ import annotations

from pathlib import Path


WINDOW = 0x400
MAX_LZ = 33


def lz_command(length: int, offset: int) -> bytes:
    encoded = (offset + 0x3DF) & 0x3FF
    return bytes((((length - 2) << 2) | (encoded >> 8), encoded & 0xFF))


def best_lz(data: bytes, pos: int) -> tuple[int, int]:
    best_length = 0
    best_offset = 0
    first = max(0, pos - WINDOW)
    for source in range(first, pos):
        length = 0
        while (
            length < MAX_LZ
            and pos + length < len(data)
            and data[source + (length % (pos - source))] == data[pos + length]
        ):
            length += 1
        if length > best_length:
            best_length = length
            best_offset = source % WINDOW
            if length == MAX_LZ:
                break
    return best_length, best_offset


def run_length(data: bytes, pos: int, value: int, limit: int) -> int:
    length = 0
    while length < limit and pos + length < len(data) and data[pos + length] == value:
        length += 1
    return length


def compress_stream(data: bytes) -> bytes:
    output = bytearray()
    pos = 0
    while pos < len(data):
        value = data[pos]
        zero_run = run_length(data, pos, 0, 257)
        if value == 0 and zero_run >= 33:
            output.extend((0xFF, zero_run - 2))
            pos += zero_run
            continue
        if value == 0 and zero_run >= 3:
            length = min(zero_run, 32)
            output.append(0xE0 + length - 2)
            pos += length
            continue

        repeated = run_length(data, pos, value, 33)
        if repeated >= 3:
            length = min(repeated, 33)
            output.extend((0xC0 + length - 2, value))
            pos += length
            continue

        if pos + 1 < len(data) and value == 0:
            pairs = 0
            while (
                pos + pairs * 2 + 1 < len(data)
                and data[pos + pairs * 2] == 0
                and pairs < 33
            ):
                pairs += 1
            if pairs >= 2:
                output.append(0xA0 + pairs - 2)
                output.extend(data[pos + 1 : pos + pairs * 2 : 2])
                pos += pairs * 2
                continue

        length, offset = best_lz(data, pos)
        if length >= 3:
            output.extend(lz_command(length, offset))
            pos += length
            continue

        raw = bytearray()
        while pos < len(data) and len(raw) < 31:
            length, _ = best_lz(data, pos)
            zero_run = run_length(data, pos, 0, 3)
            repeated = run_length(data, pos, data[pos], 3)
            pair = pos + 1 < len(data) and data[pos] == 0 and data[pos + 1] != 0
            if raw and (length >= 3 or zero_run >= 3 or repeated >= 3 or pair):
                break
            raw.append(data[pos])
            pos += 1
        output.append(0x80 | len(raw))
        output.extend(raw)
    return bytes(output)


def compress(data: bytes, interleaved: bool = False) -> bytes:
    stream = compress_stream(data)
    size = len(stream) + 2
    if size > 0x7FFF:
        raise ValueError("compressed stream exceeds the 15-bit size field")
    header = size | (0x8000 if interleaved else 0)
    return header.to_bytes(2, "little") + stream


def main() -> None:
    import argparse

    parser = argparse.ArgumentParser()
    parser.add_argument("input", type=Path)
    parser.add_argument("output", type=Path)
    args = parser.parse_args()
    packed = compress(args.input.read_bytes())
    args.output.write_bytes(packed)
    print(f"compressed {args.input.stat().st_size} -> {len(packed)} bytes")


if __name__ == "__main__":
    main()
