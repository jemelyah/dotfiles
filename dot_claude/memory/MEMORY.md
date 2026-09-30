# Memory Index

Master, cross-project memory. See the "Memory Management" section in `~/.claude/CLAUDE.md` for the rules
governing what goes here vs. in a project's own memory. As of the dev/life split, this file only holds what's
genuinely universal — dev-tier memory lives in `~/parachutes/dev-skills/memory/`, life-tier memory lives in the
Obsidian vault's `.claude-content/memory/`.

## general.md
- No AI attribution (Co-Authored-By / "Generated with Claude Code") in commits or PRs, ever — standing rule
- Language: repo documents in English, Obsidian notes in Russian

## tools/
- [Claude Code](tools/claude-code.md) — subagent `model:` field tiering (haiku/sonnet/opus) for `.claude/agents/*.md`, cost-effectiveness

## Projects opted in to project-level memory
- **gift** (`/Users/jemelyah/parachutes/gift`) — memory lives **in the repo itself** at `.claude/memory/MEMORY.md`, not the native `~/.claude/projects/.../memory/` path, so it travels with clones and can be git-committed. Discoverability works via a pointer in the repo's own `CLAUDE.md`.
- **`~/parachutes`** (all nested dev repos) — dev-tier memory lives in `~/parachutes/dev-skills/memory/MEMORY.md`, reached via `~/parachutes/CLAUDE.md`'s pointer. Covers: Rails/SQLite portable lessons, c-guard/C-extensions project, electronics/Blender hobby project.
- **Obsidian vault** (`Emelianotes`) — life-tier memory lives in `.claude-content/memory/MEMORY.md` (non-standard path — the vault's `.claude` is Claudian's directory, see the vault's own `CLAUDE.md` for why), reached via a pointer in the vault's `CLAUDE.md`. Covers: prose-style reference, edit-markers convention, critical-reader campaign, Van Til/Marxism debate prep.
