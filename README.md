# dotfiles

Personal macOS setup managed with [chezmoi](https://www.chezmoi.io/). One repo, one `profile` variable (`personal` | `work`) — see [Profile](#profile-personal--work) below.

**Stack:** chezmoi → Ghostty → tmux (+ [agent workspace](#agent-workspace)) → Neovim (LazyVim, Rails-tuned) ⟷ Obsidian. Theme: Catppuccin Mocha throughout.

## Bootstrap (new machine)

```sh
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply jemelyah
```

This clones the repo, prompts once for `profile` (`personal` or `work` — pick `work` on a work machine), and applies everything. Re-running `chezmoi init` never re-prompts (`promptStringOnce`); to change profile later edit `~/.config/chezmoi/chezmoi.toml` directly.

## What happens automatically on apply

- `run_once_before_install-packages.sh.tmpl` → `brew bundle --no-upgrade`: a shared list plus a `work` or a `personal` section. On work it also starts postgresql@14, redis and colima as brew services.
- `run_once_after_install-tmux-plugins.sh` → clones tpm, installs tmux plugins into `~/.config/tmux/plugins`
- `run_once_after_install-vscode-extensions.sh.tmpl` → installs the profile's VSCode extension list (personal also turns off Settings Sync)
- `run_once_` scripts only re-run when their rendered content changes (tracked by hash in chezmoi's state) — `chezmoi status` shows a pending one with `R`

## Manual steps after apply

Not chezmoi-managed — do these yourself, in roughly this order:

1. **SSH key:** one key is shared by both machines and registered on GitHub. Copy it by hand; `~/.ssh` is never chezmoi-managed.
2. **gh CLI:** `gh auth login` — `.gitconfig`'s `credential.helper` shells out to `gh auth git-credential` for github.com/gist.github.com.
3. **tmux:** if the tpm script didn't fire, open tmux and press `prefix I`. `~/.tmux.conf` must not exist — tmux reads it in preference to `~/.config/tmux/tmux.conf`.
4. **Neovim:** open once, let `:Lazy sync` finish, then `:checkhealth`.
5. **mise:** `mise install` (global tools) and inside each project for its pinned versions.
6. **Claude Code / OpenCode:** `claude login` / OpenCode auth are separate.
7. **Work only — eazyherd:** clone the private eazyherd repo to `~/.eazyherd` and run its `install.sh`. It provides the agent workspace, work Claude skills, hooks and memory, and the tmux include the work profile sources.
8. **Karabiner-Elements:** grant its macOS permissions on first launch.
9. **Obsidian vaults:** chezmoi only points `obsidian.nvim` at vault paths. Personal (`Emelianotes`) and work (`eazyBI`) vaults must already exist at the paths in `private_dot_config/nvim/lua/plugins/obsidian.lua`.

## Profile (`personal` / `work`)

One repo, mostly shared. What is gated by `.profile`:

| What | Personal | Work |
|---|---|---|
| Brewfile (`run_once_before_install-packages.sh.tmpl`) | personal tools and apps | work toolchain, databases as services, colima at login |
| `.gitconfig` | personal name | work-machine name, `insteadOf` ssh for github.com (same email on both) |
| `.zshrc` | `claude()` dev-plugin wrapper | `~/bin`, Atlassian SDK and product aliases, `JAVA_OPTS`, gcloud, qlty, eazybi `git_helpers.sh` |
| mise | shared tools | adds global `java` and `ruby` |
| tmux | `prefix D` agent layout, `@agent_role` borders, vim-tmux-navigator | sources `~/.eazyherd/include/eazyherd.tmux.conf` |
| nvim | agent-pane bridges (`claude.lua`, `opencode.lua`, `diffview.lua`, `vim-tmux-navigator.lua`, `agent-panes.lua`) | eazyherd provides its own specs |
| Claude Code, OpenCode, VSCode | `.chezmoitemplates/*/*.personal.*`, plus memory and statusline | `.chezmoitemplates/*/*.work.*` |
| sesh | `~/parachutes` projects | main repos under `~/rails`, `~/rubygems`, `~/java` |

Homebrew paths come from `.chezmoitemplates/brew-prefix` (`/opt/homebrew` on Apple Silicon, `/usr/local` on Intel).

## Agent workspace

- **Personal:** `prefix D` builds a layout: nvim + shell on top, three tmux panes below (`coder`/`planner`/`architect`, tagged via the `@agent_role` pane option) running Claude Code / OpenCode. Message a pane with `~/.config/tmux/agent-msg.sh <role> "text"`. `claudecode.nvim`/`opencode.nvim` are IDE bridges only.
- **Work:** eazyherd (private repo at `~/.eazyherd`) owns roles (`@role`), pane borders and ctrl+hjkl navigation.

## Follow-ups

- Drop VSCode on both machines: remove the per-profile variants, the extension script and the cask.
- Move the personal agent stack out of this repo into its own module, symmetric to eazyherd.

## Repo hygiene

This repo is public. Never commit credentials, internal hostnames, work email addresses or other secrets. The work profile does name local work repo paths (`~/rails/eazybi`…) and the eazyherd include; that is fine. `~/.ssh` is excluded outright.
