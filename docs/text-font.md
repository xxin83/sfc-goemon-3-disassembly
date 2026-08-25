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

Convert the extracted CHR to an editable grayscale PNG and back with:

```text
python tools/snes_2bpp.py chr-to-png output/system-font.chr output/system-font.png --columns 16 --scale 4
python tools/snes_2bpp.py png-to-chr output/system-font.png output/system-font-edited.chr --columns 16 --scale 4
```

The converter uses four grayscale levels and preserves the SNES plane order;
an unedited PNG round-trips byte-for-byte.

The matching compressor is available as:

```text
python tools/konami_c.py output/system-font-edited.chr output/system-font.konamiz
```

The generated block must fit the original `$1F8` bytes at `$968CFB`, or it
must be relocated and the source pointer at `$888020` changed. The compressor
is validated separately against the existing Python decompressor.

To create a new ROM with an in-place replacement:

```text
python tools/patch_system_font.py goemon3.sfc output/system-font-edited.chr output/goemon3-font.sfc
```

The input ROM is never modified. The generated ROM must still be assembled or
checked against the original source layout before it is used for a release.

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

## Runtime VRAM Probe

Mesen save states restore VRAM, so loading a state can hide a ROM font patch
that was uploaded during boot.  The repository includes
`tools/mesen_font_vram_probe.lua`, which rewrites tile 5 through the SNES VRAM
ports on every frame.  Load it in Mesen's script window (`Ctrl+N`, `Ctrl+O`,
then `F5`) while a dialogue state is active.  A solid tile in the dialogue is
then a direct visual check of the runtime tile mapping, independent of the
compressed font block being restored by the save state.

The runtime character mapping can be exported with:

```text
python tools/export_glyph_map.py goemon3.sfc --output output/glyph-map.jsonl
```

Each row records the original byte, the normalized code used by the extended
character path, and the two tilemap words consumed by `put_char` at `$809C64`.
The words include PPU attributes; they are not being misidentified as raw
compressed font bytes.
