# dotfiles

Personal macOS setup managed with [chezmoi](https://www.chezmoi.io/). One repo, one `profile` variable (`personal` | `work`) — see [Profile](#profile-personal--work) below.

**Stack:** chezmoi → Ghostty → tmux (+ [tmux agent workspace](#tmux-agent-workspace)) → Neovim (LazyVim, Rails-tuned) ⟷ Obsidian. Theme: Catppuccin Mocha throughout.

## Bootstrap (new machine)

```sh
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply jemelyah
```

This clones the repo, prompts once for `profile` (`personal` or `work` — pick `work` on a work machine), and applies everything. Re-running `chezmoi init` never re-prompts (`promptStringOnce`); to change profile later edit `~/.config/chezmoi/chezmoi.toml` directly.

## What happens automatically on apply

- `run_once_before_install-packages.sh.tmpl` → `brew bundle` (all formulae/casks in one shared Brewfile — see [Known gaps](#known-gaps--first-run-todo-especially-on-work))
- `run_once_after_install-tmux-plugins.sh` → clones tpm, installs tmux plugins
- `run_once_after_install-vscode-extensions.sh` → installs the VSCode extension list, turns off Settings Sync
- `run_once_` scripts only re-run when their content changes (tracked by hash in chezmoi's state, not by whether the target file exists) — `chezmoi status`/`chezmoi diff` shows a pending one with `R`

## Manual steps after apply

Not chezmoi-managed — do these yourself, in roughly this order:

1. **gh CLI:** `gh auth login` — `.gitconfig`'s `credential.helper` shells out to `gh auth git-credential` for github.com/gist.github.com.
2. **tmux:** if `run_once_after_install-tmux-plugins.sh` didn't fire (e.g. re-applying on an already-set-up machine), open tmux and press `prefix I` to install plugins manually.
3. **Neovim:** open once, let `:Lazy sync` finish, then `:checkhealth`.
4. **mise:** `mise install` inside a project directory to pick up its pinned tool versions (Ruby, etc.) — not run automatically.
5. **Claude Code / OpenCode CLIs:** installed via Brewfile, but `claude login` / OpenCode auth are separate, not chezmoi-managed.
6. **Bitwarden (only if/when a template starts calling `bitwardenFields`):** `bwu personal` / `bwu work` unlock the two independent CLI sessions (`bw-personal`/`bw-work` aliases wrap the `BITWARDENCLI_APPDATA_DIR` split). Nothing in the repo calls `bitwardenFields` yet — see [Known gaps](#known-gaps--first-run-todo-especially-on-work).
7. **Obsidian vaults:** chezmoi only points `obsidian.nvim` at vault paths — it doesn't create or sync vault content. Personal (`Emelianotes`) and work (`eazyBI`) vaults must already exist at the paths in `private_dot_config/nvim/lua/plugins/obsidian.lua`, synced however Obsidian itself is set up (iCloud on the personal machine).

## Profile (`personal` / `work`)

One repo, ~95% shared. What's actually gated by `.profile`:

| File | Personal | Work |
|---|---|---|
| `.gitconfig` (`dot_gitconfig.tmpl`) | `[user]` direct, no override | `includeIf` → `~/.config/git/work` for `~/rails`, `~/rubygems`, `~/java` |
| `.chezmoiignore` | — | `.config/git/work` skipped entirely on personal |
| `private_dot_config/sesh/sesh.toml.tmpl` | 9 explicit `[[session]]` entries under `~/parachutes` | empty branch, ready for real project names (see below) |

Everything else (tmux, Neovim, Ghostty, VSCode, Obsidian config) is identical on both profiles.

## tmux agent workspace

`prefix D` builds a layout: nvim + shell on top, three tmux panes below (`coder`/`planner`/`architect`, tagged via the `@agent_role` pane option) running Claude Code / OpenCode. Message a pane with `~/.config/tmux/agent-msg.sh <role> "text"`. `claudecode.nvim`/`opencode.nvim` are configured as IDE bridges only (no built-in terminal UI) so the CLI running in a pane gets selection/diagnostic context from nvim. Full detail lives in the (private) Obsidian effort note `tmux Agent Workspace` — not duplicated here since it changes faster than this README should.

## Known gaps / first-run TODO (especially on work)

These are placeholders, not bugs — fill them in once real values exist on the work machine, don't guess ahead of time:

- **Brewfile work section** — `run_once_before_install-packages.sh.tmpl` is a single shared list; add work-only formulae/casks (JVM tooling via mise, etc.) directly in the template once you know what's needed.
- **sesh work sessions** — `sesh.toml.tmpl`'s `work` branch is empty; add `[[session]]` entries for real project names under `~/rails`/`~/rubygems`/`~/java` (same pattern as the personal branch). Until then `sesh` still finds work projects via its zoxide-history fallback.
- **Work git identity** — `private_dot_config/git/work.tmpl` has `TODO-work-name`/`TODO-work-email` placeholders. Real fix: create a work Bitwarden item, swap the placeholders for a `bitwardenFields` call, log in via `bwu work` first.
- **SSH keys** — not yet decided whether work uses a separate key or shares the personal one. `~/.ssh/config` is intentionally never chezmoi-managed (`.chezmoiignore`) since it can contain real hostnames/IPs — decide and set up by hand on the work machine.

## Repo hygiene

This repo is public. Never commit employer names, internal hostnames, corporate domains, or real secrets — use `promptString`/`bitwardenFields` in a template instead. `~/.ssh/config` is excluded outright for the same reason.
