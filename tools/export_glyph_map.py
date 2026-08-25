"""Export the runtime character-code to tilemap-word mapping."""

from __future__ import annotations

import argparse
import json
from pathlib import Path

from export_text_records import GLYPHS


GLYPH_TABLE_CPU = 0x8188E9
EXTENDED_MAP_CPU = 0x818A81
MAX_CHARACTER = 0xAF


def lorom_file_offset(cpu_address: int) -> int:
    bank = (cpu_address >> 16) & 0x7F
    address = cpu_address & 0xFFFF
    if address < 0x8000:
        raise ValueError(f"not a LoROM CPU address: ${cpu_address:06X}")
    return bank * 0x8000 + (address - 0x8000)


def export(rom: bytes) -> list[dict[str, object]]:
    glyph_base = lorom_file_offset(GLYPH_TABLE_CPU)
    extended_base = lorom_file_offset(EXTENDED_MAP_CPU)
    rows = []
    for code in range(MAX_CHARACTER + 1):
        normalized = code
        if code >= 0x88:
            normalized = rom[extended_base + code]
        entry = glyph_base + normalized * 4
        rows.append(
            {
                "code": f"${code:02X}",
                "glyph": GLYPHS.get(code, f"<{code:02X}>"),
                "normalized_code": f"${normalized:02X}",
                "table_address": f"${GLYPH_TABLE_CPU + normalized * 4:06X}",
                "tile_words": [
                    f"${int.from_bytes(rom[entry:entry + 2], 'little'):04X}",
                    f"${int.from_bytes(rom[entry + 2:entry + 4], 'little'):04X}",
                ],
            }
        )
    return rows


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("rom", type=Path)
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args()
    rows = export(args.rom.read_bytes())
    args.output.write_text(
        "\n".join(json.dumps(row, ensure_ascii=False) for row in rows) + "\n",
        encoding="utf-8",
    )
    print(f"exported {len(rows)} character mappings")


if __name__ == "__main__":
    main()
