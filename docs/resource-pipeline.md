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

The first source block converted from `incbin` is `VRAM_968CFB`, the system
font stream at `$968CFB-$968EF2`. Its bytes are kept in
`disassembly/data_font_968cfb.asm`; the block remains compressed by design and
is fed through the normal `$84` decompressor at runtime.

The logo's first source `$968000-$9680B8` is also extracted in
`disassembly/data_vram_968000.asm` from its `$00B9` header; the remaining
`$9680B9-$968AB8` interval is intentionally still raw.

The adjacent logo-support sources `$968AB9-$968CFA` are likewise isolated in
`disassembly/data_logo_support_968ab9.asm`; their boundaries come directly
from the next `$88` source pointers.

The same extraction now covers `$968EF3-$969176` and `$969D44-$969E43` in
`disassembly/data_bank96_small_sources.asm`. The intervening
`$969177-$969D43` block is now in `disassembly/data_vram_969177.asm`; its
header `$8BCD` independently proves a 3021-byte compressed block with the
interleaving flag set, matching the next source pointer exactly.

`VRAM_969E44` is separately bounded by its own `$00BF` header, so only
`$969E44-$969F02` is extracted; the following bytes up to `$96A203` are not
assumed to belong to that resource.

`SPRITE_96A203` and `VRAM_96A2FF` are consecutive complete blocks with header
sizes `$00FC` and `$00C3`; both are stored in
`disassembly/data_bank96_96a203.asm`.

`VRAM_96B9C2` and `VRAM_96BB25` are also extracted by their `$0063` and
`$0088` headers. The intervening `$96BA25-$96BB24` bytes remain unchanged
because the source table does not identify them as a separate transfer.

The bounded tail sources from `$96C5AD` through `$96F66E` are represented in
`disassembly/data_bank96_tail_sources.asm`; unreferenced gaps and labels such
as `$96CBB0` remain in the original bank include until their callers are
identified.

Bank `$98` now has 24 referenced compressed blocks extracted into
`disassembly/data_bank98_sources.asm`, ending at `$98F35E`; all gaps between
those blocks remain `incbin` data.

Bank `$99` now has 23 referenced compressed blocks in
`disassembly/data_bank99_sources.asm`, ending at `$99FC2C`; the remaining
gaps and final bank tail are left as raw data.

Bank `$9A` now has 6 referenced compressed blocks in
`disassembly/data_bank9a_sources.asm`, ending at `$9AF646`; the remaining
gaps and bank tail remain raw.

Bank `$A5` now has 28 referenced compressed blocks in
`disassembly/data_bankA5_sources.asm`, ending at `$A5FFEC`; the remaining
gaps and bank tail remain raw.

Bank `$A4` now has 20 referenced compressed blocks in
`disassembly/data_bankA4_sources.asm`, ending at `$A4FFC3`; the remaining
gaps and bank tail remain raw.

Bank `$A3` now has 27 referenced compressed blocks in
`disassembly/data_bankA3_sources.asm`, ending at `$A3FCBF`; the remaining
gaps and bank tail remain raw.

Bank `$A2` now has 25 referenced compressed blocks in
`disassembly/data_bankA2_sources.asm`, ending at `$A2FFBC`; the remaining
gaps and bank tail remain raw.

Bank `$A1` now has 19 referenced compressed blocks in
`disassembly/data_bankA1_sources.asm`, ending at `$A1FFF2`; the remaining
gaps and bank tail remain raw.

Bank `$A0` now has 4 referenced compressed blocks in
`disassembly/data_bankA0_sources.asm`, ending at `$A0EF50`; the remaining
gaps and bank tail remain raw.

Bank `$9F` now has 6 referenced compressed blocks in
`disassembly/data_bank9f_sources.asm`, ending at `$9FFB9D`; the remaining
gaps and bank tail remain raw.

Bank `$9E` now has 3 referenced compressed blocks in
`disassembly/data_bank9e_sources.asm`, ending at `$9EFF45`; the remaining
gaps and bank tail remain raw.

Bank `$9D` now has 5 referenced compressed blocks in
`disassembly/data_bank9d_sources.asm`, ending at `$9DF264`; the remaining
gaps and bank tail remain raw.

Bank `$9C` now has 6 referenced compressed blocks in
`disassembly/data_bank9c_sources.asm`, ending at `$9CFD52`; the remaining
gaps and bank tail remain raw.

Bank `$9B` now has 6 referenced compressed blocks in
`disassembly/data_bank9b_sources.asm`, ending at `$9BF1B3`; the remaining
gaps and bank tail remain raw.

Bank `$97` now has 35 referenced compressed blocks extracted into
`disassembly/data_bank97_sources.asm`, covering `$978581-$97FC5E`; gaps
between the blocks remain raw `incbin` data. Each block was bounded by its
own two-byte compressed-size header before extraction.

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

Bank `$A6` now has 43 referenced compressed blocks in
`disassembly/data_bankA6_sources.asm`, ending at `$A6FFE2`; the remaining
gaps and bank tail remain raw.

Bank `$A7` now has 51 bounded referenced blocks in
`disassembly/data_bankA7_sources.asm`, ending at `$A7D313`; the remaining
gaps and bank tail remain raw.
