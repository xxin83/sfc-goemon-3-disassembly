import unittest

try:
    from . import patch_single_byte_slots as slots
except ImportError:
    import patch_single_byte_slots as slots


class SingleBytePatchTests(unittest.TestCase):
    def test_patches_normal_and_red_tile_words(self):
        rom = bytearray(0x200000)
        table = slots.lorom_file_offset(slots.GLYPH_TABLE_CPU)

        for code in range(0xB0):
            rom[table + code * 4 : table + code * 4 + 4] = bytes.fromhex(
                "00 03 00 03"
            )
        result = slots.patch_slots(bytes(rom), {0x01: 0x2A})
        self.assertEqual(result[table + 4 : table + 8], bytes.fromhex("2A 03 3A 03"))

    def test_rejects_reserved_and_extended_slots(self):
        rom = bytes(0x200000)
        with self.assertRaises(ValueError):
            slots.patch_slots(rom, {0x00: 1})
        with self.assertRaises(ValueError):
            slots.patch_slots(rom, {0x88: 1})

    def test_force_replaces_an_existing_glyph(self):
        rom = bytearray(0x200000)
        table = slots.lorom_file_offset(slots.GLYPH_TABLE_CPU)
        for code in range(0xB0):
            rom[table + code * 4 : table + code * 4 + 4] = bytes.fromhex("00 03 00 03")
        rom[table + 0x1E * 4 : table + 0x1E * 4 + 4] = bytes.fromhex("05 03 15 03")
        result = slots.patch_slots(bytes(rom), {0x1E: 0x38}, force=True)
        self.assertEqual(result[table + 0x1E * 4 : table + 0x1E * 4 + 4], bytes.fromhex("38 03 48 03"))


if __name__ == "__main__":
    unittest.main()
