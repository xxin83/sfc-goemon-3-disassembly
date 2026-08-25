"""Convert SNES 2bpp 8x8 tile data to and from grayscale PNG images."""

from __future__ import annotations

import argparse
from pathlib import Path

from PIL import Image


TILE_BYTES = 16
TILE_SIZE = 8
LEVELS = (0, 85, 170, 255)


def chr_to_image(data: bytes, columns: int) -> Image.Image:
    if len(data) % TILE_BYTES:
        raise ValueError("CHR data length must be a multiple of 16")
    tiles = len(data) // TILE_BYTES
    rows = (tiles + columns - 1) // columns
    image = Image.new("L", (columns * TILE_SIZE, rows * TILE_SIZE), 0)
    for tile in range(tiles):
        base = tile * TILE_BYTES
        x0 = (tile % columns) * TILE_SIZE
        y0 = (tile // columns) * TILE_SIZE
        for y in range(TILE_SIZE):
            plane0 = data[base + y]
            plane1 = data[base + 8 + y]
            for x in range(TILE_SIZE):
                bit = 7 - x
                value = ((plane1 >> bit) & 1) << 1 | ((plane0 >> bit) & 1)
                image.putpixel((x0 + x, y0 + y), LEVELS[value])
    return image


def image_to_chr(image: Image.Image, columns: int) -> bytes:
    image = image.convert("L")
    if image.width % TILE_SIZE or image.height % TILE_SIZE:
        raise ValueError("image dimensions must be multiples of 8")
    if image.width // TILE_SIZE != columns:
        raise ValueError("image width does not match the tile column count")
    rows = image.height // TILE_SIZE
    data = bytearray()
    for tile_y in range(rows):
        for tile_x in range(columns):
            base_x = tile_x * TILE_SIZE
            base_y = tile_y * TILE_SIZE
            plane0 = bytearray(8)
            plane1 = bytearray(8)
            for y in range(8):
                for x in range(8):
                    sample = image.getpixel((base_x + x, base_y + y))
                    value = min(range(4), key=lambda level: abs(LEVELS[level] - sample))
                    bit = 7 - x
                    plane0[y] |= (value & 1) << bit
                    plane1[y] |= ((value >> 1) & 1) << bit
            data.extend(plane0)
            data.extend(plane1)
    return bytes(data)


def main() -> None:
    parser = argparse.ArgumentParser()
    sub = parser.add_subparsers(dest="command", required=True)

    to_png = sub.add_parser("chr-to-png")
    to_png.add_argument("chr", type=Path)
    to_png.add_argument("png", type=Path)
    to_png.add_argument("--columns", type=int, default=16)
    to_png.add_argument("--scale", type=int, default=1)

    to_chr = sub.add_parser("png-to-chr")
    to_chr.add_argument("png", type=Path)
    to_chr.add_argument("chr", type=Path)
    to_chr.add_argument("--columns", type=int, default=16)
    to_chr.add_argument("--scale", type=int, default=1)

    args = parser.parse_args()
    if args.command == "chr-to-png":
        image = chr_to_image(args.chr.read_bytes(), args.columns)
        if args.scale != 1:
            image = image.resize((image.width * args.scale, image.height * args.scale), Image.Resampling.NEAREST)
        image.save(args.png)
    else:
        image = Image.open(args.png)
        if args.scale != 1:
            if image.width % args.scale or image.height % args.scale:
                raise ValueError("PNG dimensions are not divisible by the scale")
            image = image.resize((image.width // args.scale, image.height // args.scale), Image.Resampling.NEAREST)
        args.chr.write_bytes(image_to_chr(image, args.columns))


if __name__ == "__main__":
    main()
