# Documentation

- [Asset Table Format](asset-table.md)
- [Konami SNES Compression Format](konami-snes-compression.md)
- [Text Format](text-format.md)
- [Text Font](text-font.md)
- [Text Pointer Table](goemon3-text-pointer-table.md)
- [Resource Pipeline](resource-pipeline.md)
- [Resource Transfer Index](resource-index.tsv)

`resource-index.tsv` is generated from `disassembly/bank_88.asm` with
`tools/index_asset_table.py`. It records the transfer-table relationship
between a resource, its destination, and its compressed ROM source; it does
not claim that the source symbol is an uncompressed tile or font address.

For the localization workflow, `tools/export_text_records.py` exports the
27 pointer-table records as JSONL. Confirmed `$C0-$FF` compression commands
are expanded, while unresolved `$B0-$BA` commands remain explicit tags.

## Bank Overview

| Bank       | Summary                                                      |
| ---------- | ------------------------------------------------------------ |
| `$80`      | Program code                                                 |
| `$81`      | Program data (constants and tables)                          |
| `$82`      | Unknown code                                                 |
| `$83`      | Unknown code                                                 |
| `$84`      | Asset loading, decompression, transfer, and 65816 sound code |
| `$85`      | Unknown code                                                 |
| `$86`      | Unknown code                                                 |
| `$87`      | Unknown data and code                                        |
| `$88`      | Asset location and transfer information                      |
| `$89`      | Unknown data and code                                        |
| `$8A`      | Unknown data and code                                        |
| `$8B`      | Unknown code                                                 |
| `$8C`      | Unknown code                                                 |
| `$8D`      | Unknown code                                                 |
| `$8E-$B4`  | Primarily asset data, with minor code                        |
| `$B5`      | Level data                                                   |
| `$B6`      | Unknown data and text data (low bank)                        |
| `$B7`      | SPC700 code and unknown data                                 |
| `$B8-$BC`  | Unknown data                                                 |
| `$BD`      | Text data (high bank)                                        |
| `$BE-$BF`  | Unknown data                                                 |
