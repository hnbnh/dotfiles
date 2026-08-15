# ~/dotfiles & automated machine setup

> Commit hash: [1bc1701](https://github.com/hnbnh/dotfiles/tree/1bc170100bf58d01b002498b6b9adbba1d306e19)

![screenshot](./assets/2025-01-27-10.21.png)

## Installation

> [!WARNING]
> Consider forking this repo

```bash
git clone --recurse-submodules -j8 git@github.com:hnbnh/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

The repo must live at `~/dotfiles` — dotfile symlinks point back at that path.

On macOS, `install.sh` bootstraps Nix and Homebrew, then hands everything to
nix-darwin. Afterwards, apply changes with:

```bash
darwin-rebuild switch --flake ~/dotfiles#hnbnh
```

Config files under `modules/home/` are symlinked live, so editing them takes
effect immediately. A rebuild is only needed when adding or removing a file.
New files must be `git add`ed before Nix can see them.

When adding a `modules/home/.config/<tool>/`, ask whether the tool writes
state, logs, sockets, or credentials into its own config dir. If so, `touch
.split` inside it so the directory's contents are linked individually
instead of the whole directory being linked into the repo.

## TODO

- [ ] All

  - [ ] Add a cron job to send a notification of `Hydrate 💧`

    - [ ] Linux

      ```bash
      */20 * * * * notify-send "Health notification" "Hydrate 💧"
      ```

    - [ ] macOS

      ```bash
      */20 * * * * osascript -e 'display notification "Hydrate 💧" with title "Health notification"'
      ```

## Acknowledgments

- [folke/dot](https://github.com/folke/dot)
- [tjdevries/config_manager](https://github.com/tjdevries/config_manager)
- [jdhao/nvim-config](https://github.com/jdhao/nvim-config)
- [LunarVim/LunarVim](https://github.com/LunarVim/LunarVim)
- [khuedoan/linux-setup](https://github.com/khuedoan/linux-setup)
- [khuedoan/macos-setup](https://github.com/khuedoan/macos-setup)
- [FelixKratz/dotfiles](https://github.com/FelixKratz/dotfiles)
- [LazyVim/LazyVim](https://github.com/LazyVim/LazyVim)
- [dreamsofautonomy/zen-omp](https://github.com/dreamsofautonomy/zen-omp)
