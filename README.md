# polar-shell

Wayland-native desktop shell built with Quickshell and tailored for Hyprland.

<div align="center">

https://github.com/user-attachments/assets/d92dfe3f-ec85-40c0-98b7-2754c2c8589f

</div>

## Table of Contents

- [Dependencies](#dependencies)
- [Installation](#installation)
- [Usage](#usage)
    - [Hyprland Keybinds (IPC)](#hyprland-keybinds-ipc)
- [Detailed description](#detailed-description)
    - [Dynamic theme](#dynamic-theme)
- [Links](#links)

## Dependencies

Ensure you have the following packages installed on your system to make
everything work as intended:

- **Core:** `quickshell`
- **Capture service:** `wf-recorder`, `ffmpeg`, `jq`
- **Calendar:** `gcalcli` (Requires Google OAuth configuration)
- **Brightness control:** `ddcutil`
- **Widgets:** `ddcutil`, `hyprpicker`

## Installation

1. Clone the repository to your local machine:
    ```bash
    git clone [https://github.com/Martan03/polar-shell.git](https://github.com/Martan03/polar-shell.git)
    cd polar-shell
    ```
2. Link or copy the `quickshell` configuration directory to the config path.
   (symlinking ensures live updates on after git pull):
    ```bash
    ln -s $(pwd)/quickshell ~/.config/quickshell
    ```
3. Authenticate Google Calendar (Optional, for the Calendar widget):

    > Follow the `gcalcli` instructions to setup OAuth.

    ```bash
    gcalcli agenda
    ```

## Usage

Start the shell by running `quickshell` in your terminal, or add it to your
`hyprland.lua` to launch on startup:

```lua
hl.on("hyprland.start", function()
    hl.exec_cmd("quickshell")
)
```

### Hyprland Keybinds (IPC)

`polar-shell` exposes global states via Quickshell's IPC handler. This is the
supported list:

- `togglePowermenu`: Shows/hides the power menu

You can trigger them by adding this to you `hyprland.lua` file, for example:

```lua
hl.bind(mainMod .. " + ESCAPE", hl.dsp.exec_cmd("qs ipc call myshell togglePowermenu"))
```

## Detailed description

> [!NOTE]
> To make your experience identical to mine, you can consider using my
> [dotfiles](https://github.com/Martan03/dotfiles) as well.

When using `waybar`, I felt limited. For that reason I decided to leverage the
power of QML and build my own solution. My focus for `polar-shell` is:

- **Design cohesion:** Match design across everything.
- **Usefulness:** Simplify my Hyprland experience and make it better.

`polar-shell` will constantly evolve based on my needs. My plan is to create
quickshell alternatives for other programs I use, such as `rofi` for creating
custom menus - currently I use it for wallpaper picker and clipboard history.

### Dynamic theme

To change the theme colors, you can edit
`quickshell/Services/GecolColors.qml` file to have custom colors. Personally
I use [`gecol`](https://github.com/Martan03/gecol) for this (created by me).
You can consider setting it up in order to have the same dynamic colors based
wallpaper.

You can checkout my [dotfiles](https://github.com/Martan03/dotfiles), where
I have the [`gecol`](https://github.com/Martan03/gecol) configuration.

## Links

- **Author:** [Martan03](https://github.com/Martan03)
- **GitHub repository:** [quickshell](https://github.com/Martan03/polar-shell)
- **Author website:** [martan03.github.io](https://martan03.github.io)
