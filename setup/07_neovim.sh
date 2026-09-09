#!/usr/bin/env bash
# Neovim: fonts, binary, PATH, Lua/LuaRocks, Lazy bootstrap.
set -euo pipefail

# --- 1. Fonts used by kitty/statusline (SF Mono Nerd Ligaturized) ---
if ! fc-list 2>/dev/null | rg -qi 'SFMono Nerd'; then
  _tgt="$HOME/.local/share/fonts"
  mkdir -p "$_tgt"
  _tmp="$(mktemp -d)"
  git clone --depth 1 https://github.com/shaunsingh/SFMono-Nerd-Font-Ligaturized.git \
    "$_tmp/sf" >/dev/null 2>&1 || true
  find "$_tmp/sf" -type f \( -iname '*.otf' -o -iname '*.ttf' \) \
    -exec cp {} "$_tgt/" \; 2>/dev/null || true
  rm -rf "$_tmp"
  fc-cache -f >/dev/null 2>&1 || true
fi

# --- 2. nvim binary ---
if [[ ! -x /opt/nvim-linux-x86_64/bin/nvim ]]; then
  curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
  sudo rm -rf /opt/nvim
  sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
  rm -f nvim-linux-x86_64.tar.gz
fi

# --- 3. PATH in .zshrc ---
rg -q '/opt/nvim-linux-x86_64/bin' "$HOME/.zshrc" 2>/dev/null \
  || printf '\nexport PATH="$PATH:/opt/nvim-linux-x86_64/bin"\n' >> "$HOME/.zshrc"

# --- 4. Lua 5.4 + LuaRocks (needed by some plugins) ---
if ! command -v luarocks >/dev/null 2>&1; then
  LUA_VERSION=5.4.6
  curl -R -O "https://www.lua.org/ftp/lua-${LUA_VERSION}.tar.gz"
  tar zxf "lua-${LUA_VERSION}.tar.gz"
  make -C "lua-${LUA_VERSION}" linux test
  sudo make -C "lua-${LUA_VERSION}" install
  rm -rf "lua-${LUA_VERSION}" "lua-${LUA_VERSION}.tar.gz"

  LUAROCKS_VERSION=3.12.2
  curl -R -O "https://luarocks.org/releases/luarocks-${LUAROCKS_VERSION}.tar.gz"
  tar zxpf "luarocks-${LUAROCKS_VERSION}.tar.gz"
  ./luarocks-${LUAROCKS_VERSION}/configure --with-lua=/usr/local
  make -C "luarocks-${LUAROCKS_VERSION}"
  sudo make -C "luarocks-${LUAROCKS_VERSION}" install
  rm -rf "luarocks-${LUAROCKS_VERSION}" "luarocks-${LUAROCKS_VERSION}.tar.gz"
  sudo luarocks install luasocket >/dev/null 2>&1 || true
fi

# --- 5. Bootstrap Lazy.nvim (run once) ---
NYIM_CONFIG="$HOME/.config/nvim"
mkdir -p "$NYIM_CONFIG"
if [[ ! -d "$HOME/.local/share/nvim/lazy/lazy.nvim" ]]; then
  cp "$REPO/bootstrap-init.lua" "$NYIM_CONFIG/bootstrap-init.lua"
  cp "$NYIM_CONFIG/init.lua" /tmp/init.lua.bak
  cp "$NYIM_CONFIG/bootstrap-init.lua" "$NYIM_CONFIG/init.lua"
  if command -v nvim >/dev/null 2>&1; then
    nvim --headless +"quitall" || echo "warn: lazy bootstrap had issues — open nvim once manually"
  fi
  cp /tmp/init.lua.bak "$NYIM_CONFIG/init.lua"
fi

echo "Neovim ready."