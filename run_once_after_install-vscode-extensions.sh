#!/bin/bash
code --sync off

extensions=(
  anthropic.claude-code
  asvetliakov.vscode-neovim
  britesnow.vscode-toggle-quotes
  eamodio.gitlens
  marcoroth.herb-lsp
  ms-azuretools.vscode-containers
  ms-vscode-remote.remote-containers
  shopify.ruby-lsp
  tal7aouy.icons
)

for ext in "${extensions[@]}"; do
  code --install-extension "$ext"
done
