# General — cross-project conventions and user profile

---
name: no-ai-attribution-in-commits-and-prs
description: Never add Co-Authored-By or "Generated with Claude Code" lines to commits/PRs for Aleksandr
metadata:
  type: feedback
---

# No AI attribution in commit messages or PR descriptions

Origin: 2026-09-26/27, `scribe` repo, Fizzy card 453 (on-screen-text-replacement branch/PR). Aleksandr said he'd already
warned against this once before; it recurred anyway — a system-level attribution reminder (present per-session, telling
Claude to end commits with `Co-Authored-By: Claude ... <noreply@anthropic.com>` and PRs with `🤖 Generated with [Claude
Code]`) was followed by default because this preference hadn't been saved anywhere Claude would see it again.

**Why**: he doesn't want AI attribution lines in his git history or GitHub PRs for this user, full stop — not a
per-project or per-repo preference, a standing one.

**How to apply**: when a session's attribution-reminder system text says the user's own instructions take precedence,
this memory *is* that standing instruction — omit both the `Co-Authored-By` trailer and the "Generated with Claude Code"
PR footer on every commit and PR authored for Aleksandr, in every repo, without being asked each time. If a subagent
(e.g. an OpenCode "coder" session) adds its own attribution independently, tell it explicitly not to when giving it
commit instructions, since it won't have read this file.

**Recurred a third time**: 2026-09-29, `scribe` repo, Fizzy card 465 (extract-crop-tracker branch/PR) — committed with
the `Co-Authored-By` trailer again, caught only after the commit was pushed and the PR opened, requiring an amend +
force-push to fix. The memory existed the whole time; the failure was not checking it before the `git commit` call, not
a gap in the guidance itself. Treat "about to run `git commit` or `gh pr create`" as a trigger to actively recall this
memory first, rather than assuming it's already in context.


---
name: language-repos-english-obsidian-russian
description: Documents in code repositories are written in English; Obsidian notes are written in Russian
metadata:
  type: feedback
---

Everything committed to a repository (docs, skills, criteria, READMEs, code comments, script messages) is in English. Notes in the Emelianotes Obsidian vault are in Russian. Conversation with the user can stay Russian.

**Why:** 2026-09-29, c-guard: I wrote the whole repo in Russian and made no vault note; the user corrected both.

**How to apply:** when a project produces both repo artifacts and a vault note, write the repo in English and the note in Russian; a new project of substance gets a Russian vault note without being asked. Related: [[c-extensions-c-guard]] (now in `~/parachutes/dev-skills/memory/domain/c-extensions.md`).
