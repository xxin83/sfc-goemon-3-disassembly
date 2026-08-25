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

## Chinese Capacity Assessment

The current block decompresses to `0x600` bytes: `96` tiles.  Its original
compressed form is `496` bytes inside a `504`-byte slot, leaving only `8` bytes
of in-place growth.  Adding a meaningful Chinese glyph set therefore requires
relocating the compressed block or adding another VRAM upload; it cannot be
solved by putting more bytes into the existing slot.

For a larger replacement, `tools/relocate_system_font.py` expands the LoROM to
4 MiB, writes the compressed block at a new bank boundary, and updates the
24-bit source pointer stored at `$888020`.  The old block is left untouched:

```text
python tools/relocate_system_font.py goemon3.sfc edited-font.chr goemon3-expanded.sfc --target 0x3F0000
```

The relocation path is verified by decompressing the new pointer target and
comparing all `0x600` output bytes with the edited CHR input.  The original
2 MiB ROM remains unchanged; the expanded ROM necessarily has a different
hash and must be tested separately in the emulator.

The runtime table has single-byte entries for `$00-$AF`.  The `$88-$AF`
entries are remapped through the extended map, but they still resolve to a
single normalized table entry.  The `$B0-$BA` handlers are layout and control
records, not a generic lead-byte/trail-byte glyph decoder.  Consequently, a
DBCS translation needs all of the following changes:

1. A lead/trail decoder state in the text reader.
2. A two-byte character map that resolves to a tilemap word.
3. Additional glyph storage and a VRAM upload path.
4. Text wrapping and width handling for the new glyph units.

For a first Chinese patch, the practical route is a selected single-byte
subset: reuse unused `$00-$AF` slots, repoint their glyph table entries to
newly drawn tiles, and keep the existing decoder.  This is limited by the
available code slots and 96-tile font budget, but it avoids changing the
control parser.  A full DBCS implementation should be treated as a separate
engine change rather than an extension of `data/text-code-table.json` alone.

Generate the current slot classification before assigning translation glyphs:

```text
python tools/analyze_single_byte_slots.py goemon3.sfc --output output/single-byte-slots.json
```

The report separates reusable blank entries from reserved controls and
occupied entries, and records each candidate's runtime table address and
tilemap words.

After drawing the replacement tiles into the editable font image, patch safe
direct slots with a JSON assignment such as `{"0x01": 42}`:

```text
python tools/patch_single_byte_slots.py goemon3.sfc assignments.json goemon3-slots.sfc
```

The patcher writes the normal and red tilemap words together, rejects control
codes and extended remap slots, and never modifies the input ROM.  The glyph
label still needs to be added to `data/text-code-table.json` so exporters and
encoders use the same assignment.

Replacing an existing Japanese glyph is intentionally explicit:

```text
python tools/patch_single_byte_slots.py goemon3.sfc assignments.json translated.sfc --force
```

Use `--force` only when the corresponding text bytes are also being translated;
otherwise every occurrence of the original glyph will display the replacement
character.

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

Changing a glyph tile does not change the text encoding, while changing the
encoding requires updating the text decoder and the translation table.

## Runtime Character Upload Path

The confirmed single-byte character path is:

1. `put_char` at `$809C64` resolves the byte through `$8188E9` (and the
   `$88-$AF` remap table), producing a tile word such as `$0300 + tile`.
2. `CODE_FN_809D2F` calculates the destination tilemap position as
   `$5000 + row * $20 + column` (the special room mode uses `$4800`).
3. The tile word is written to the WRAM character buffer at `$7E7400`.
4. The DMA descriptor queue begins at `$7E0000`; it uses the `$7E7400`
   buffer as its source and uploads the tilemap data to VRAM.

This is distinct from the system-font upload at `$88801C`, which writes the
compressed font result to VRAM `$4000`. A font replacement alone does not alter
existing text; the code table or the generated `$7E7400` tile words must also
select the new tile.

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
