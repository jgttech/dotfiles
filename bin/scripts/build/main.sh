#!/usr/bin/env bash
outdir="$DOTFILES_HOME/$DOTFILES_BUILD"
os="$DOTFILES_HOME/os"
shared="$os/shared"
platform="$os"

if [[ "$OSTYPE" == "darwin"* ]]; then
  platform+="/macos"
elif [[ "$OSTYPE" == "linux"* ]]; then
  platform+="/linux"
else
  echo "Unsupported OSTYPE: $OSTYPE" >&2
  exit 1
fi

contexts=(\
  $shared \
  $platform \
)

install="#!/usr/bin/env bash\n"
uninstall="#!/usr/bin/env bash\n"

for ctx in "${contexts[@]}"; do
  dirs=()

  for dir in "${ctx}"/*; do
    dirs+=($(basename "$dir"))
  done

  install+="stow -t \"\$HOME\" -d \"$ctx\" ${dirs[@]}\n"
  uninstall+="stow -D -t \"\$HOME\" -d \"$ctx\" ${dirs[@]}\n"
done

if [[ -d "$outdir" ]]; then
  rm -rfv "$outdir"
fi

mkdir -p "$outdir"

printf '%b' "$install" > "$outdir/install"
printf '%b' "$uninstall" > "$outdir/uninstall"

chmod +x "$outdir/install" "$outdir/uninstall"
