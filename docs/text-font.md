# Text Font

The system text font is the compressed block `VRAM_968CFB` in the asset table.
Its ROM file range is `$0B0CFB-$0B0EF2`; the asset loader decompresses it and
uploads the result to VRAM `$4000` in the normal font transfer at
`asset_system_font` (`$88801C`).

The decompressed result is `0x600` bytes:

- `96` tiles
- `8x8` pixels per tile
- SNES `2bpp` tile layout
- no tile deinterleave flag

Extract it for editing with:

```text
python tools/extract_system_font.py goemon3.sfc output/system-font.chr
```

The source block remains compressed in the ROM. A changed font must therefore
be recompressed or relocated, and the asset source pointer at `$888020` must
be updated if the replacement no longer fits the original block.

The text byte table and the font tile index relationship are separate layers:
changing a glyph tile does not change the text encoding, while changing the
encoding requires updating the text decoder and the translation table.
