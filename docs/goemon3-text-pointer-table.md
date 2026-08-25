# Goemon 3 Text Pointer Table

The record header begins at `$87C289`; the 16-bit text-offset table begins at
`$87C28F` and contains 27 entries.  The first entry is
`7E 55`, which resolves to offset `$557E` and then to file offset `$1B557E`
(`$B6D57E` in the SNES address space).

The target is not a flat text stream.  Its records contain special commands
and `F0`-`FF` copy commands whose two-byte arguments reference another text
offset.  Therefore text extraction must preserve a graph of references:

```text
$87C289 -> $557E -> $B6D57E -> F0/F1/F2... -> another 16-bit text offset
```

Generate a reproducible table with:

```text
python tools/resolve_text_pointer_table.py base.sfc \
  --output docs/text-pointer-table.tsv
```

The parser intentionally reports nested references instead of decoding them
as ordinary characters.  It reports the observed `$B5` command separately;
its two-byte argument still needs runtime confirmation.  Other `B0`-`BF`
bytes are not treated as pointers because `$B2` is used as a formatting command
in the same stream.
