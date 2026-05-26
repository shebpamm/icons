from pathlib import Path
import argparse

import fontforge
import psMat


class Glyph:
    def __init__(self, name: str, codepoint: str, src: Path):
        self.name = name
        self.src = src

        self.codepoint = codepoint

        if codepoint.startswith("U+"):
            self.raw_codepoint: int = int(codepoint[2:], 16)
        else:
            raise ValueError(f"Invalid codepoint: {codepoint}")

    def add_to_font(self, font: fontforge.font):
        glyph = font.createChar(self.raw_codepoint)
        glyph.importOutlines(str(self.src))
        glyph.removeOverlap()
        glyph.simplify()
        glyph.autoHint()

        glyph.width = 1000

GLYPHS = [
    Glyph("ansible", "U+F845", Path("glyphs/ansible.svg")),
]


def parse():
    parser = argparse.ArgumentParser(prog="main.py")
    subparsers = parser.add_subparsers(dest="command", required=True)

    # generate subcommand
    generate_parser = subparsers.add_parser("generate", help="Generate output")
    generate_parser.set_defaults(func=generate)

    # print subcommand
    print_parser = subparsers.add_parser("print", help="Print output")
    print_parser.set_defaults(func=print_glyphs)

    return parser.parse_args()


def generate():
    font = fontforge.font()

    font.fontname = "sheb-icons"
    font.familyname = "Sheb Icons"
    font.fullname = "Sheb Icons Regular"

    for glyph in GLYPHS:
        glyph.add_to_font(font)

    font.generate("icons.ttf")

def print_glyphs():
    for glyph in GLYPHS:
        print(f"{glyph.name}: {chr(glyph.raw_codepoint)} ({glyph.codepoint})")

if __name__ == "__main__":
    args = parse()
    args.func()
