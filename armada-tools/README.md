# add-to-steam (Armada OS)

Adds a Windows `.exe` (or any file) to Steam as a non-Steam game, set up to run through Proton with
Armada's launch wrapper (`/usr/libexec/armada/armada-game-launch %command%`), so you don't need a file
picker. Copy `add-to-steam` to `~/.local/bin/` and `add-to-steam.desktop` to `~/.local/share/applications/`,
then right-click a game `.exe` → *Add to Steam* (or run `add-to-steam /path/to/game.exe`) and restart Steam.
