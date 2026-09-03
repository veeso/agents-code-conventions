# Format all sources (Markdown) with dprint
[group('code_check')]
fmt args="":
    dprint fmt {{ args }}

# Check formatting of all sources with dprint (no writes)
[group('code_check')]
fmt_check args="":
    dprint check {{ args }}
