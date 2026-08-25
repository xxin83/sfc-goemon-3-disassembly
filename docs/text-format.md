# Text Format

Text in Ganbare Goemon 3 is stored as a byte stream containing character codes and commands used to compress text.

This document describes the structure of these text streams.

## Text Data Offset

A 16-bit offset is used to reference text data. The offset corresponds to the following ROM address ranges:

| Offset        | ROM Address       | Notes                             |
| ------------- | ----------------- | --------------------------------- |
| 0x0000-0x7FFF | `$B68000-$B6FFFF` | Lower portion contains other data |
| 0x8000-0xFFFF | `$BD8000-$BDFFFF` |                                   |

The corresponding ROM address can be calculated as follows:

```python
if offset < 0x8000:
    address = 0xB68000 + offset
else:
    address = 0xBD0000 + offset
```

## Text Stream Format

The first byte determines how the following data is interpreted.

| Range     | Type                  |
| --------- | --------------------- |
| 0x00-0xAF | Single-byte character |
| 0xB0-0xBF | Multi-byte sequence   |
| 0xC0-0xFF | Compression command   |

### Character Codes (0x00-0xAF)

The character mapping is defined by the following table. (WIP)

|          | +0  | +1 | +2 | +3 | +4 | +5 | +6  | +7  | +8 | +9 | +A | +B | +C | +D | +E | +F |
| -------- |:---:|:--:|:--:|:--:|:--:|:--:|:---:|:---:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|
| **0x00** | NUL |    |    |    | LF |    |     |     |    |    |    |    |    |    |    |    |
| **0x10** |     |    |    |    |    |    | ROF | RON | SP |    | あ | い | う | え | お | か |
| **0x20** | き  | く | け | こ | さ | し | す  | せ  | そ | た | ち | つ | て | と | な | に |
| **0x30** | ぬ  | ね | の | は | ひ | ふ | へ  | ほ  | ま | み | む | め | も | や | ゆ | よ |
| **0x40** | ら  | り | る | れ | ろ | わ | を  | ん  | っ | ゃ | ゅ | ょ | ぉ | 重 | 禄 | 兵 |
| **0x50** | 衛  |    | ◀  | ▶  | ▲ | ▼ |     |     | ０ | １ | ２ | ３ | ４ | ５ | ６ | ７ |
| **0x60** | ８  | ９ |    |    |    |    |     |     | コ | エ | モ | ン | ヒ | ス | サ | ケ |
| **0x70** | ヤ  |    |    |    | 両 | 丸 | ー  | 金  | ・ | ？ | ！ | 「 | 」 |    |    |    |
| **0x80** |     | 。 | （ | ） |    |    |     |     | が | ぎ | ぐ | げ | ご | ざ | じ | ず |
| **0x90** | ぜ  | ぞ | だ | ぢ | づ | で | ど  | ば  | び | ぶ | べ | ぼ | ゴ | ビ | ズ | ザ |
| **0xA0** | ゲ  |    |    |    |    |    |     |     | ぱ | ぴ | ぷ | ぺ | ぽ | ピ |    |    |

The following values have special meanings:

| Code | Description            |
| ---- | ---------------------- |
| 0x00 | Null terminator ('\0') |
| 0x04 | Line feed (`\n`)       |
| 0x16 | Switch to normal text  |
| 0x17 | Switch to red text     |
| 0x18 | Space                  |

### Extended Tokens (0xB0-0xBF)

These values are returned as stream tokens by `get_next_char`. The upper-level
reader handles some values in context: `$B0/$B1` and `$B8/$B9` consume an
additional 16-bit value in the routines around `$80A3EC` and `$80A398`.
The dispatch table at `$809DA8` maps `$B0-$BA` to separate handlers. `$B5`
maps to `$80A02A`, consumes one selector byte followed by a variable
descriptor terminated by `$FF`, and sets the text-layout state at `$7C4C`;
it is not a two-byte pointer command. The remaining descriptor field semantics
are not yet fully named.

The currently verified handler shape is:

| Token | Handler | Observed payload shape |
| ----- | ------- | ---------------------- |
| `$B0` | `$809F04` | One 16-bit value; a second value may be read depending on layout state |
| `$B1` | `$809F77` | One 16-bit value; a second value may be read depending on layout state |
| `$B2` | `$80A935` | One 16-bit value |
| `$B3` | `$80ABCD` | One 16-bit value |
| `$B4` | `$80A011` | One 16-bit value, then switches text stream |
| `$B5` | `$80A02A` | One selector byte plus a variable `$FF`-terminated descriptor |
| `$B6` | `$80A04E` | No immediate payload observed |
| `$B7` | `$80A1C2` | Variable-length descriptor, terminator/shape still being traced |
| `$B8/$B9` | `$80A356/$80A35B` | Layout mode markers; follow-up payload is context-dependent |
| `$BA` | `$80A344` | Record/control transition |

### Compression Commands (0xC0-0xFF)

For commands that produce multiple characters, the output length is determined by the command byte.

| Range     | Command          | Extra Bytes | Output Length      |
| --------- | ---------------- | ----------: | -----------------: |
| 0xC0-0xCF | Repeat Space     |           0 |               2-17 |
| 0xD0-0xDF | Predefined Text  |           0 | varies (see below) |
| 0xE0-0xEF | Repeat Character |           1 |               3-18 |
| 0xF0-0xFF | Copy from Offset |           2 |               4-19 |

#### Predefined Text (0xD0-0xDF)

The following table lists the predefined text sequences.

| Code | ROM Address | Output Text    | Bytes               |
| ---- | ----------- | -------------- | ------------------- |
| 0xD0 | `$BD8000`   | `した。」\n`   | `25 29 81 7C 04`    |
| 0xD1 | `$BD8006`   | `！」\n`       | `7A 7C 04`          |
| 0xD2 | `$BD800A`   | `。」\n`       | `81 7C 04`          |
| 0xD3 | `$BD800E`   | `」\n`         | `7C 04`             |
| 0xD4 | `$BD8011`   | `ゴエモン　「` | `9C 69 6A 6B 18 7B` |
| 0xD5 | `$BD8018`   | `エビス丸　「` | `69 9D 6D 75 18 7B` |
| 0xD6 | `$BD801F`   | `サスケ　　「` | `6E 6D 6F 18 18 7B` |
| 0xD7 | `$BD8026`   | `ヤエ　　　「` | `70 69 18 18 18 7B` |
| 0xD8 | `$BD802D`   | `・・・`       | `78 78 78`          |
| 0xD9 | `$BD8031`   | 6 spaces       | `18 18 18 18 18 18` |
| 0xDA | `$BD8038`   | 5 spaces       | `18 18 18 18 18`    |
| 0xDB | `$BD803E`   | 4 spaces       | `18 18 18 18`       |
| 0xDC | `$BD8043`   | 3 spaces       | `18 18 18`          |
| 0xDD | `$BD8047`   | 2 spaces       | `18 18`             |
| 0xDE | `$BD804A`   | `はん`         | `33 47`             |
| 0xDF | `$BD804D`   | `ござる`       | `8C 8D 42`          |

A table of offsets for these predefined text sequences is located at `$818B3D`.
Each text is terminated by 0x00.

#### Copy from Offset (0xF0-0xFF)

The command is followed by a two-byte text offset.
The referenced bytes are copied to the output as character codes.

For example:

```
F2 5A 95
```

This command copies 6 characters from the text at offset `0x955A`,
which corresponds to ROM address `$BD955A`.

The referenced bytes are treated as character codes, not text stream commands.
Values in the 0xC0-0xFF range are therefore not normally expected in the referenced data.

The runtime reader is visible in `disassembly/bank_80.asm`: `$80A65B` reads
16-bit stream units from `$B68000` or `$BD0000` using the pointer at
`$7E:7C16`, and `$80A66F` dispatches the resulting command value. The general
character decoder starts at `$80A502`; its `$F0-$FF` path stores the copy source
in `!r_text_copy_ptr_l` and reads source bytes directly, so copy sources are
not recursively decoded as command streams.
