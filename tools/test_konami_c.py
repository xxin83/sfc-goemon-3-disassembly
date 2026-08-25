import unittest

try:
    from .konami_c import compress
    from .konami_d import konami_decompress
except ImportError:
    from konami_c import compress
    from konami_d import konami_decompress


class KonamiCompressionTests(unittest.TestCase):
    def test_font_round_trip(self):
        source = bytes((index * 37) & 0xFF for index in range(256))
        packed = compress(source)
        self.assertGreater(len(packed), 2)

    def test_rle_pair_reads_one_value_per_pair(self):
        from pathlib import Path
        import tempfile

        with tempfile.TemporaryDirectory() as directory:
            packed = Path(directory) / "pair.konamiz"
            output = Path(directory) / "pair.bin"
            packed.write_bytes(bytes.fromhex("06 00 A1 10 20 30"))
            konami_decompress(packed, "0", "1", output)
            self.assertEqual(output.read_bytes(), bytes.fromhex("00 10 00 20 00 30"))


if __name__ == "__main__":
    unittest.main()
