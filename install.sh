
#!/usr/bin/env bash
set -euo pipefail

# Dynamic Zsh installer for Fedora, Arch and Debian/Ubuntu
# Installs zsh, git, curl and unzip; installs Oh My Zsh and recommended plugins

install_pkgs() {
    local pkgs=(zsh git curl unzip fzf)

    if command -v dnf >/dev/null 2>&1; then
        echo "Detected Fedora (dnf). Installing: ${pkgs[*]}"
        sudo dnf install -y "${pkgs[@]}"
        return
    fi

    if command -v pacman >/dev/null 2>&1; then
        echo "Detected Arch (pacman). Installing: ${pkgs[*]}"
        sudo pacman -Syu --noconfirm "${pkgs[@]}"
        return
    fi

    if command -v apt >/dev/null 2>&1 || command -v apt-get >/dev/null 2>&1; then
        echo "Detected Debian/Ubuntu (apt). Installing: ${pkgs[*]}"
        sudo apt update
        sudo apt install -y "${pkgs[@]}"
        return
    fi

    echo "Unsupported distribution: cannot find dnf, pacman or apt." >&2
    exit 1
}

install_oh_my_zsh() {
    if [ -d "$HOME/.oh-my-zsh" ]; then
        echo "Oh My Zsh already installed at $HOME/.oh-my-zsh"
        return
    fi
    echo "Installing Oh My Zsh..."
    # RUNZSH=no and CHSH=no to avoid interactive steps; we'll handle chsh later
    RUNZSH=no CHSH=no KEEP_ZSHRC=yes \
      sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
}

clone_plugin() {
    local repo=$1 dest=$2
    if [ -d "$dest" ]; then
        echo "Plugin already present: $dest"
    else
        echo "Cloning $repo -> $dest"
        git clone "$repo" "$dest"
    fi
}

install_plugins() {
    local base="$HOME/.oh-my-zsh/custom/plugins"
    mkdir -p "$base"
    clone_plugin https://github.com/zsh-users/zsh-autosuggestions "$base/zsh-autosuggestions"
    clone_plugin https://github.com/zsh-users/zsh-syntax-highlighting.git "$base/zsh-syntax-highlighting"
    clone_plugin https://github.com/zsh-users/zsh-history-substring-search "$base/zsh-history-substring-search"
    clone_plugin https://github.com/plutowang/zsh-ollama-command "$base/zsh-ollama-command"
}


set_default_shell_to_zsh() {
    if [ "$(basename -- "$SHELL")" = "zsh" ]; then
        echo "Default shell is already zsh"
        return
    fi
    if command -v chsh >/dev/null 2>&1; then
        echo "Changing default shell to zsh for user $USER"
        chsh -s "$(command -v zsh)" || echo "chsh failed; you may need to run it manually." >&2
    else
        echo "chsh not found; please change your shell to zsh manually." >&2
    fi
}

install_starship() {
    if command -v starship >/dev/null 2>&1; then
        echo "Starship already installed"
        return
    fi
    echo "Installing Starship prompt..."
    curl -sS https://starship.rs/install.sh | sh -s -- --yes || echo "Starship installer failed"
}

install_zsh_config() {
    local zipfile="zsh-config.zip"
    if [ -f "$zipfile" ]; then
        echo "Extracting $zipfile to $HOME"
        unzip -o "$zipfile" -d "$HOME"
    else
        echo "$zipfile not found in current directory; skipping extraction"
    fi
}

main() {
    install_pkgs
    install_oh_my_zsh
    install_plugins
    install_zsh_config
    set_default_shell_to_zsh
    install_starship
    echo "Done. Please restart your terminal or log out/in to start using zsh."
}


main "$@"

