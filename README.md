# ~/dotfiles

![screenshot](./assets/2023-01-18_18-16.png)

## Install

```bash
sudo ./install.sh
```

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
- [ ] Support Fedora
- [ ] Support Arch (EndeavourOS)
- [ ] Support macOS
  - [ ] Configuration
    - Built-in
      - [ ] Disable `Desktop & Dock` -> `Mission Control` -> `Automatically rearrange Spaces based on most recent use`
      - [ ] Enable `Accessibility` -> `Display` -> `Reduce motion`

## Acknowledgments

- [folke/dot](https://github.com/folke/dot)
- [tjdevries/config_manager](https://github.com/tjdevries/config_manager)
- [jdhao/nvim-config](https://github.com/jdhao/nvim-config)
- [LunarVim/LunarVim](https://github.com/LunarVim/LunarVim)
- [khuedoan/linux-setup](https://github.com/khuedoan/linux-setup)
- [khuedoan/macos-setup](https://github.com/khuedoan/macos-setup)
- [FelixKratz/dotfiles](https://github.com/FelixKratz/dotfiles)
- [LazyVim/LazyVim](https://github.com/LazyVim/LazyVim)
