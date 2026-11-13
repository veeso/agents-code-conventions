"""Build a compact digest of the Microsoft Rust guidelines.

Reads the concatenated upstream guidelines (Markdown) and prints one line per
`M-` rule: its ID, title, and the `<why>` rationale. Code examples and long
explanations are dropped to keep the skill's token footprint small.

Usage: python3 make-digest.py <concatenated-guidelines.md>
"""

import re
import sys

HEADING = re.compile(r"^## ([^\n]+?) \{ #(M-[A-Z0-9-]+) \}[ \t]*$", re.MULTILINE)
WHY = re.compile(r"<why>(.*?)</why>", re.DOTALL)
TRAILING_ID = re.compile(r"\s*\(M-[A-Z0-9-]+\)$")


def main() -> None:
    with open(sys.argv[1], encoding="utf-8") as fh:
        text = fh.read()

    headings = list(HEADING.finditer(text))
    if not headings:
        sys.exit("error: no M- guideline headings found")

    print("<!-- Copyright (c) Microsoft Corporation. Licensed under the MIT license. -->")
    print()
    print("# Microsoft Rust Guidelines (M- prefix), digest")
    print()
    print(
        "Generated from https://github.com/microsoft/rust-guidelines by "
        "scripts/fetch-guidelines.sh. Do not edit by hand."
    )
    print()
    print("One line per rule: ID, title and rationale. Follow every rule that applies to the code you write.")
    print()
    for index, heading in enumerate(headings):
        end = headings[index + 1].start() if index + 1 < len(headings) else len(text)
        body = text[heading.end():end]
        title = TRAILING_ID.sub("", heading.group(1))
        why = WHY.search(body)
        rationale = " ".join(why.group(1).split()) if why else ""
        print(f"- **{heading.group(2)}** {title}. {rationale}".rstrip())


if __name__ == "__main__":
    main()
