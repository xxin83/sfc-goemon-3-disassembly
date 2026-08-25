"""Classify single-byte text slots for a first-pass Chinese patch."""

from __future__ import annotations

import argparse
import json
from pathlib import Path

try:
    from .export_glyph_map import export
    from .export_text_records import GLYPHS
except ImportError:
    from export_glyph_map import export
    from export_text_records import GLYPHS


RESERVED = {0x00, 0x04, 0x16, 0x17, 0x18}


def classify(rom: bytes) -> dict[str, list[dict[str, object]]]:
    rows = export(rom)
    result = {"available": [], "reserved": [], "occupied": []}
    for row in rows:
        code = int(str(row["code"])[1:], 16)
        blank = row["tile_words"] == ["$0300", "$0300"]
        if code in RESERVED:
            category = "reserved"
        elif blank and code not in GLYPHS:
            category = "available"
        else:
            category = "occupied"
        result[category].append(row)
    return result


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("rom", type=Path)
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args()
    result = classify(args.rom.read_bytes())
    args.output.write_text(
        json.dumps(result, ensure_ascii=False, indent=2) + "\n", encoding="utf-8"
    )
    print(
        "available={available} reserved={reserved} occupied={occupied}".format(
            **{key: len(value) for key, value in result.items()}
        )
    )


if __name__ == "__main__":
    main()
