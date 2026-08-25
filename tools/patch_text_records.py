"""Safely write edited single-byte text records back into a ROM image."""

from __future__ import annotations

import argparse
import json
from pathlib import Path

try:
    from .export_text_records import TABLE_COUNT, TABLE_FILE_OFFSET, pointer_targets, record_end
    from .text_codec import encode_markup
except ImportError:
    from export_text_records import TABLE_COUNT, TABLE_FILE_OFFSET, pointer_targets, record_end
    from text_codec import encode_markup


def load_rows(path: Path) -> list[dict[str, object]]:
    return [json.loads(line) for line in path.read_text(encoding="utf-8").splitlines()]


def build_patches(rom: bytes, rows: list[dict[str, object]]) -> list[tuple[int, bytes]]:
    targets = pointer_targets(rom, TABLE_FILE_OFFSET, TABLE_COUNT)
    boundaries = sorted({file_offset for _, file_offset in targets})
    by_index = {index: start for index, start in targets}
    patches = []
    for row in rows:
        index = int(row["index"])
        if index not in by_index:
            raise ValueError(f"unknown text record index: {index}")
        start = by_index[index]
        next_boundary = next((value for value in boundaries if value > start), len(rom))
        end = record_end(rom, start, next_boundary)
        declared_start = int(str(row["file_start"])[1:], 16)
        declared_end = int(str(row["file_end"])[1:], 16)
        if (declared_start, declared_end) != (start, end):
            raise ValueError(f"record {index} boundary does not match the ROM")
        encoded = encode_markup(str(row["text"]))
        if not encoded.endswith(b"\x03\x00"):
            raise ValueError(f"record {index} must end with <03><00>")
        capacity = end - start
        if len(encoded) > capacity:
            raise ValueError(
                f"record {index} needs {len(encoded)} bytes, capacity is {capacity}"
            )
        patches.append((start, encoded + bytes(capacity - len(encoded))))
    return patches


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("rom", type=Path)
    parser.add_argument("records", type=Path)
    parser.add_argument("output", type=Path)
    args = parser.parse_args()

    rom = args.rom.read_bytes()
    patches = build_patches(rom, load_rows(args.records))
    result = bytearray(rom)
    for start, payload in patches:
        result[start : start + len(payload)] = payload
    args.output.write_bytes(result)
    print(f"patched {len(patches)} text records")


if __name__ == "__main__":
    main()
