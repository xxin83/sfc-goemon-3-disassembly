import unittest

try:
    from .text_codec import encode_markup
except ImportError:
    from text_codec import encode_markup


class TextCodecTests(unittest.TestCase):
    def test_glyphs_and_controls(self):
        self.assertEqual(encode_markup("おみつ \\n<B2:1E54>"), bytes.fromhex("1E 39 2B 18 04 B2 54 1E"))

    def test_b5_descriptor_is_preserved(self):
        self.assertEqual(
            encode_markup("<B5:000003781904FF>"),
            bytes.fromhex("B5 00 00 03 78 19 04 FF"),
        )


if __name__ == "__main__":
    unittest.main()
