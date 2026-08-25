# Rebuild Status

This repository is based on the exact v1.0 ROM and the upstream Goemon 3
disassembly.  The current baseline is reproducible: assembling the upstream
sources produces the same SHA-1 as `base.sfc`:

```text
24832a8a054a83bbca241f8daf8b39ed2932996f
```

## Verified

- Asset extraction runs from `base.sfc` using `tools/extract_assets.py`.
- The SPC-700 and main 65816 sources assemble with the bundled Asar.
- The text pointer table has 27 entries at file offset `$03C28F` / SNES
  address `$87C28F`.
- Entry 0 is `7E 55`, resolving to text offset `$557E`, file offset
  `$1B557E`, and SNES address `$B6D57E`.
- The first stream contains `F0`-`FF` nested references.  These are exported
  by `tools/resolve_text_pointer_table.py` to
  `docs/text-pointer-table.tsv`.

## Not Yet Runtime-Confirmed

- The exact descriptor fields for `$B5`, plus context-dependent
  `$B0/$B1/$B8/$B9` payloads.
- Record termination and the complete grammar for `$B0`-`$EF` formatting
  commands.
- The full relationship between the text records, their graphics resources,
  and the runtime decompression/upload path.

The resolver deliberately does not label `$B0-$BF` operands as text pointers.
Runtime tracing is required before converting the context-dependent commands
into an editable high-level representation.
