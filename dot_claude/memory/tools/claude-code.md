---
name: claude-code-subagent-model-tiering
description: Model selection tiering (haiku/sonnet/opus) for the model field in .claude/agents/*.md subagent frontmatter
metadata:
  type: reference
---

Claude Code subagent frontmatter (`.claude/agents/*.md`) takes a `model:` field with values `haiku`, `sonnet`, `opus`, or `inherit`. Official tiering guidance (from the `claude-code-setup` plugin's `claude-automation-recommender` skill, `references/subagent-templates.md`):

- **haiku** — simple, repetitive, mechanical checks. Fast/cheap, less thorough.
- **sonnet** — most review/analysis/generation tasks. Balanced, the recommended default.
- **opus** — complex reasoning: architecture, migrations, multi-step judgment calls. Thorough, slower, expensive.

**Why:** user asked (2026-08-04) how to make agents/subagents more cost-effective; all three of their global agents were pinned to `sonnet` by default with no tiering applied.

**How to apply:** when creating a new subagent, or auditing existing ones, assess the task's judgment load rather than defaulting to `sonnet` everywhere:
- Mechanical/repetitive extraction or summarization with low stakes if slightly rougher → `haiku`.
- Anything involving nuanced judgment, accuracy-critical output (e.g. citation correctness), or cross-document reasoning → keep `sonnet` (or `opus` for genuinely complex multi-step reasoning).

**Don't confuse with:** API model-id guidance in `~/parachutes/skills/skills/claude-api/SKILL.md` ("always use `claude-opus-5` unless told otherwise") — that's for code that calls the Claude API directly (a different context, full model-id strings like `claude-opus-5`), not for Claude Code's `.claude/agents/*.md` `model:` field (which uses the short aliases `haiku`/`sonnet`/`opus`/`inherit`).

**Applied so far:** `~/.claude/agents/reading-notes.md` switched from `sonnet` to `haiku` (2026-08-04); `critical-reader` and `vault-wiki` kept on `sonnet` (judgment/citation-accuracy-heavy work). (Note: these three agents now live at `Emelianotes/.claude-content/agents/`, symlinked into the vault's `.claude/agents/`, not under the global `~/.claude/agents/` — that global path no longer exists post-split.)
