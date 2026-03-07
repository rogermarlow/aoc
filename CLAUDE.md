# CLAUDE.md

## Project Overview

Personal Advent of Code solutions repository covering years 2022, 2023, and 2025.

## Directory Structure

```
<year>/<day>/
```

Each day's directory contains:
- `answer.rb` — combined solution for both parts, OR
- `part1.rb` / `part2.rb` — separate files per part
- `test.txt` / `tiny.txt` — sample inputs (committed)
- `input.txt` — personal puzzle input (gitignored, not committed per AoC policy)

## Running Solutions

Solutions read input via `ARGF`, passed as a command-line argument:

```sh
./answer.rb input.txt
./part1.rb test.txt
```

Output format: `puts "Part 1: #{answer}"` / `puts "Part 2: #{answer}"`

## Languages

- **Ruby 3.4** (primary) — uses modern features: `it` implicit block parameter, safe navigation (`&.`), method chaining
- **Python** (occasional, e.g. 2023/1, 2023/2, 2025/10)

## Code Conventions

- Executable scripts with `#!/usr/bin/env ruby` shebang
- Class-based structure wrapping puzzle logic with `part1`/`part2` methods
- Input parsed via `ARGF.read` or `ARGF.readlines`
- Standard library only — no Gemfile or external gems; no requirements.txt for Python (exception: `regex` module in 2023/2)

## Linting

Rubocop with relaxed settings (see `.rubocop.yml`):
- Target: Ruby 3.4
- Disabled: `FrozenStringLiteralComment`, `Documentation`, short parameter names, all `Metrics/*` cops

Run: `rubocop` from the repo root.

## Git

- `input.txt` and `answer.txt` are gitignored (personal puzzle inputs/answers)
- `__pycache__/` and `*.py[cod]` are gitignored
