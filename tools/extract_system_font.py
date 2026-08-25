"""Extract the runtime system font as editable SNES 2bpp tile data."""

from __future__ import annotations

import argparse
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
from konami_d import konami_decompress  # noqa: E402


FONT_FILE_OFFSET = 0x0B0CFB
FONT_SIZE = 0x600
FONT_TILE_SIZE = 0x10


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("rom", type=Path)
    parser.add_argument("output", type=Path)
    args = parser.parse_args()

    konami_decompress(args.rom, f"{FONT_FILE_OFFSET:X}", "1", args.output)
    size = args.output.stat().st_size
    if size != FONT_SIZE:
        raise SystemExit(
            f"unexpected system font size: 0x{size:X}; expected 0x{FONT_SIZE:X}"
        )
    print(
        f"system font: {size} bytes, {size // FONT_TILE_SIZE} tiles, "
        "SNES 2bpp 8x8"
    )


if __name__ == "__main__":
    main()
