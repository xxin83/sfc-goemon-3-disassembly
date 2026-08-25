"""Relocate the system-font block into an expanded LoROM image."""

from __future__ import annotations

import argparse
import math
from pathlib import Path

try:
    from .export_glyph_map import lorom_file_offset
    from .konami_c import compress
except ImportError:
    from export_glyph_map import lorom_file_offset
    from konami_c import compress


FONT_POINTER_CPU = 0x888020
ROM_SIZE_HEADER = 0x7FD7
MIN_EXPANDED_SIZE = 0x400000


def file_offset_to_cpu(offset: int) -> int:
    bank, remainder = divmod(offset, 0x8000)
    if not 0 <= bank <= 0x7F:
        raise ValueError(f"file offset is outside 4 MiB LoROM space: ${offset:X}")
    return ((0x80 + bank) << 16) | (0x8000 + remainder)


def patch_relocated_font(rom: bytes, font: bytes, target: int) -> bytes:
    if target < len(rom) or target % 0x8000:
        raise ValueError("target must be a new LoROM bank boundary")
    packed = compress(font)
    required = target + len(packed)
    size = max(MIN_EXPANDED_SIZE, required)
    size = 1 << (size - 1).bit_length()
    if size > MIN_EXPANDED_SIZE:
        raise ValueError("font relocation currently supports up to 4 MiB")
    result = bytearray(rom)
    result.extend(b"\xFF" * (size - len(result)))
    result[target : target + len(packed)] = packed
    pointer_file = lorom_file_offset(FONT_POINTER_CPU)
    pointer_cpu = file_offset_to_cpu(target)
    result[pointer_file : pointer_file + 3] = pointer_cpu.to_bytes(3, "little")
    result[ROM_SIZE_HEADER] = int(math.log2(size)) - 10
    return bytes(result)


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("rom", type=Path)
    parser.add_argument("font", type=Path)
    parser.add_argument("output", type=Path)
    parser.add_argument("--target", type=lambda value: int(value, 0), default=0x3F0000)
    args = parser.parse_args()
    args.output.write_bytes(
        patch_relocated_font(args.rom.read_bytes(), args.font.read_bytes(), args.target)
    )
    print(f"relocated font to file ${args.target:06X}")


if __name__ == "__main__":
    main()
