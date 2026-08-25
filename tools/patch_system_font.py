"""Replace the in-place system-font compression block in a new ROM image."""

from __future__ import annotations

import argparse
from pathlib import Path

try:
    from .konami_c import compress
except ImportError:
    from konami_c import compress


FONT_FILE_OFFSET = 0x0B0CFB
FONT_CAPACITY = 0x1F8


def patch_font(rom: bytes, font: bytes) -> bytes:
    packed = compress(font)
    if len(packed) > FONT_CAPACITY:
        raise ValueError(
            f"compressed font needs 0x{len(packed):X} bytes, "
            f"capacity is 0x{FONT_CAPACITY:X}"
        )
    result = bytearray(rom)
    result[FONT_FILE_OFFSET : FONT_FILE_OFFSET + FONT_CAPACITY] = packed.ljust(
        FONT_CAPACITY, b"\0"
    )
    return bytes(result)


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("rom", type=Path)
    parser.add_argument("font", type=Path)
    parser.add_argument("output", type=Path)
    args = parser.parse_args()
    args.output.write_bytes(patch_font(args.rom.read_bytes(), args.font.read_bytes()))
    print(f"patched system font at ${FONT_FILE_OFFSET:06X}, capacity ${FONT_CAPACITY:X}")


if __name__ == "__main__":
    main()
