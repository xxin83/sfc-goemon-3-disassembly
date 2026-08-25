# Resource Pipeline

The resource path is now mapped from the asset table through decompression to
the hardware destination. The entry point is `load_asset` at `$84BBB0`; its
input `X` points into the resource tables assembled in bank `$88`.

## Dispatch

The first byte selects the destination:

| Type | Handler | Terminator |
| ---- | ------- | ---------- |
| `$00` | `load_asset_vram` at `$84BC19` | byte `$FF` |
| `$01` | `load_asset_wram` at `$84BCDA` | word `$FFFF` |
| `$02` | `load_asset_spc` at `$84C138` | handler-specific block end |
| `$80` | no-op | none |
| `$81-$FE` | special transfer at `$84C13F` | handler-specific |
| `$FF` | sprite definition / optional transfer | asset-specific |

The first two bytes of a VRAM/WRAM asset are the transfer type and mode. Each
source entry uses a 24-bit ROM pointer. The `$400000` bit is a source flag:
the remaining address selects an uncompressed block; without the flag the
source is passed to the Konami decompressor.

## Decompression

`parse_block_header` at `$84BCBA` reads the decompressed block size and source
pointer. The shared decoder is `decompress_stream` at `$84C231`; the bounded
helper `decompress_block_to_wram` at `$84BDB5` writes into WRAM and returns the
active output range.

The three normal asset contexts use these direct-page and WRAM bases:

| Context | Direct page | WRAM output base |
| ------- | ----------- | ---------------- |
| VRAM | `$0100` | `$7E:2000` |
| WRAM | `$1F00` | `$7E:2400` |
| SPC | `$1E00` | `$7E:2800` |

These values come from `upload_dp_base_table` and `asset_ram_base_table` at
`$84C502` and `$84C508`.

## VRAM

`dispatch_vram_transfer` at `$84BE42` selects one of four paths based on the
transfer mode and the compressed-size flags:

- Normal transfers call `upload_to_vram` at `$84BF45`.
- Interleaved transfers call `rearrange_tile_data` at `$84BEA1` first.
- Deferred variants call `prepare_vram_upload` at `$84BF9A`.

`rearrange_tile_data` converts each 16-byte block from sequential order
`0 1 2 ... F` to `0 8 1 9 ... 7 F`, matching the SNES interleaved tile layout.
`upload_to_vram` programs `VMAIN`, DMA mode, destination register, VRAM
address, source address, and transfer size before starting DMA.

## WRAM and SPC

WRAM assets use `CODE_FL_84BFF4` to copy or rearrange decompressed blocks and
advance the destination pointer. SPC assets use `spc_upload_decompressed` at
`$84C980`; it requests a `$0400`-byte decompression block and sends the result
through the APU data port. The initial SPC transfer destination also supplies
the driver entry point.

The remaining reverse-engineering work is to replace raw bank includes with
named asset records and verify each resource table against this pipeline.
