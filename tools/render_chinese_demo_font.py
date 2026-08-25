"""Render a small Chinese glyph set into unused SNES 2bpp font tiles."""

from __future__ import annotations

import argparse
import json
from pathlib import Path

from PIL import Image, ImageDraw, ImageFont

try:
    from .analyze_single_byte_slots import classify
    from .snes_2bpp import image_to_chr
except ImportError:
    from analyze_single_byte_slots import classify
    from snes_2bpp import image_to_chr


def render_glyph(font: ImageFont.FreeTypeFont, glyph: str) -> bytes:
    image = Image.new("L", (8, 8), 0)
    draw = ImageDraw.Draw(image)
    box = draw.textbbox((0, 0), glyph, font=font)
    width = box[2] - box[0]
    height = box[3] - box[1]
    draw.text(((8 - width) // 2 - box[0], (8 - height) // 2 - box[1]), glyph, font=font, fill=255)
    return image_to_chr(image, 1)


def build_demo(
    rom: bytes, base_font: bytes, glyphs: str, font_path: Path, tile_base: int
) -> tuple[bytes, dict[str, int], dict[str, str]]:
    available = [
        int(str(row["code"])[1:], 16)
        for row in classify(rom)["available"]
        if int(str(row["code"])[1:], 16) < 0x88
    ]
    if len(glyphs) > len(available):
        raise ValueError(f"need {len(glyphs)} direct slots, only {len(available)} available")
    if tile_base < 0 or tile_base + len(glyphs) > len(base_font) // 16:
        raise ValueError("demo tiles exceed the extracted font")
    font = ImageFont.truetype(str(font_path), 8)
    result = bytearray(base_font)
    assignments: dict[str, int] = {}
    table: dict[str, str] = {}
    for index, glyph in enumerate(glyphs):
        code = available[index]
        tile = tile_base + index
        result[tile * 16 : tile * 16 + 16] = render_glyph(font, glyph)
        assignments[f"0x{code:02X}"] = tile
        table[f"{code:02X}"] = glyph
    return bytes(result), assignments, table


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("rom", type=Path)
    parser.add_argument("font", type=Path, help="extracted 0x600-byte SNES 2bpp font")
    parser.add_argument("--glyphs", required=True)
    parser.add_argument("--font-file", type=Path, required=True)
    parser.add_argument("--tile-base", type=int, default=56)
    parser.add_argument("--output-font", type=Path, required=True)
    parser.add_argument("--output-assignments", type=Path, required=True)
    parser.add_argument("--output-table", type=Path, required=True)
    args = parser.parse_args()
    font, assignments, table = build_demo(
        args.rom.read_bytes(), args.font.read_bytes(), args.glyphs, args.font_file, args.tile_base
    )
    args.output_font.write_bytes(font)
    args.output_assignments.write_text(json.dumps(assignments, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    args.output_table.write_text(json.dumps(table, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    print(f"rendered {len(assignments)} Chinese glyphs")


if __name__ == "__main__":
    main()
