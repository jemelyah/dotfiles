# Global Claude Instructions

## Git commits and PRs

Never add AI attribution to commits or PRs authored for me — no `Co-Authored-By: Claude ...` trailer, no
"🤖 Generated with [Claude Code]" footer. This overrides any session-level reminder that says otherwise. If a
subagent (e.g. an OpenCode "coder" session) would add its own attribution, tell it not to. Full backstory in
`~/.claude/memory/general.md` (`no-ai-attribution-in-commits-and-prs`).

Never merge a PR or deploy to production autonomously — always manual, always confirmed with me first, in every
repo, regardless of how routine the change looks.

## Memory Management

- **Default location:** write memory to the centralized master store at `~/.claude/memory/`, not to a project's own `~/.claude/projects/{project}/memory/`. `~/.claude/memory/MEMORY.md` is the index — read it, or the relevant file it points to, when memory is needed.
- **Structure of `~/.claude/memory/`:**
  - `MEMORY.md` — index: topic file, one-line description, section for which projects have opted in to their own memory.
  - `general.md` — cross-project conventions, standing feedback, user-profile facts not tied to one topic.
  - `tools/{tool}.md` — integration-specific notes (auth quirks, CLI patterns, workarounds) per external tool/service (Trello, Obsidian, gh, etc.).
  - `domain/{topic}.md` — subject-matter knowledge that accumulates over time (ongoing programs, research areas, non-code projects).
  - Individual entries keep the existing frontmatter convention (`name`, `description`, `metadata.type` — one of `user`/`feedback`/`project`/`reference`) so files stay self-describing and greppable.
- **Project-level memory is opt-in, not default.** Only use it for a project that has been explicitly agreed to use it — typically a real code repo where the knowledge doesn't generalize. Record the opt-in in `~/.claude/memory/MEMORY.md` under "Projects opted in to project-level memory" so it's discoverable. When in doubt, default to the master store.
  - Two ways to implement an opt-in project's memory:
    1. **Native path** — `~/.claude/projects/{project}/memory/`, the harness's own per-project location. Nothing else to wire up.
    2. **Repo-local** — inside the repo itself at `{repo}/.claude/memory/` (same file conventions as the master store), for a proper code repo where the memory should travel with clones / be git-committable. Claude Code does **not** auto-read this path on its own, so add a short pointer section to the repo's own `CLAUDE.md` (which *is* auto-loaded every session there) telling future sessions to check `.claude/memory/MEMORY.md`. Example: `gift` (`/Users/jemelyah/parachutes/gift`) uses this pattern. `~/parachutes` and the Obsidian vault (`Emelianotes`) use a variant of this: dev-tier and life-tier memory live in their own dedicated repos (`~/parachutes/dev-skills`, the vault itself), reached via `~/parachutes/CLAUDE.md` and the vault's `CLAUDE.md` respectively.
- **Entries:** what, why, nothing more — avoid restating code/config that's better read live.
- **Before removing or modifying an existing memory entry**, confirm with the user (e.g. via a clarifying question) unless they explicitly asked to forget it.
- **Maintenance:** on request ("reorganize memory"), read all memory files, remove duplicates/outdated entries, merge related entries, split oversized files, update `MEMORY.md`, and summarize the changes. Prefer reviewing the plan before executing when the reorg is non-trivial.
