"""Patch safe single-byte glyph slots to point at local font tiles."""

from __future__ import annotations

import argparse
import json
from pathlib import Path

try:
    from .analyze_single_byte_slots import RESERVED, classify
    from .export_glyph_map import GLYPH_TABLE_CPU, lorom_file_offset
except ImportError:
    from analyze_single_byte_slots import RESERVED, classify
    from export_glyph_map import GLYPH_TABLE_CPU, lorom_file_offset


def patch_slots(rom: bytes, assignments: dict[int, int], *, force: bool = False) -> bytes:
    categories = classify(rom)
    available = {int(str(row["code"])[1:], 16) for row in categories["available"]}
    result = bytearray(rom)
    table = lorom_file_offset(GLYPH_TABLE_CPU)
    for code, tile in assignments.items():
        if not 0 <= code <= 0xAF:
            raise ValueError(f"code outside single-byte range: ${code:02X}")
        if code >= 0x88:
            raise ValueError(f"extended remap slot requires collision analysis: ${code:02X}")
        if not force and (code in RESERVED or code not in available):
            raise ValueError(f"code is not an available glyph slot: ${code:02X}")
        if not 0 <= tile <= 0x3FF:
            raise ValueError(f"tile index out of range: ${tile:X}")
        entry = table + code * 4
        normal = 0x0300 + tile
        red = 0x0310 + tile
        result[entry : entry + 2] = normal.to_bytes(2, "little")
        result[entry + 2 : entry + 4] = red.to_bytes(2, "little")
    return bytes(result)


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("rom", type=Path)
    parser.add_argument("assignments", type=Path, help="JSON object: code -> tile index")
    parser.add_argument("output", type=Path)
    parser.add_argument("--force", action="store_true", help="allow replacing an occupied glyph")
    args = parser.parse_args()
    raw = json.loads(args.assignments.read_text(encoding="utf-8"))
    assignments = {int(str(code), 0): int(tile) for code, tile in raw.items()}
    args.output.write_bytes(patch_slots(args.rom.read_bytes(), assignments, force=args.force))
    print(f"patched {len(assignments)} single-byte glyph slots")


if __name__ == "__main__":
    main()
