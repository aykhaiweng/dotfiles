paths=(
  /opt/homebrew/bin
  /opt/homebrew/sbin
  ~/.local/bin
  $DOTFILES/bin
)

for p in "${paths[@]}"; do
  [[ -d "$p" ]] && export PATH="$p:$PATH"
done