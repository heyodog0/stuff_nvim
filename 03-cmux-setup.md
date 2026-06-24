# 03 — cmux setup

[cmux](https://github.com/manaflow-ai/cmux) is the terminal app I run Neovim
inside. It's a desktop app (not a CLI multiplexer like tmux), so it has a GUI
and a JSON config file.

## Where the config lives

```
~/.config/cmux
├── cmux.json          # active config
└── settings.json      # mirror of cmux.json (legacy filename) — keep in sync
```

Both files are kept identical. cmux reads them as **JSONC** (JSON with
comments). After editing, reload with `cmd+shift+,` (reloadConfiguration) or
restart the app. The original templates are backed up as `*.bak.<date>`.

## My tuning, section by section

The config is deliberately trimmed for a stable, private, low-memory setup.

### `app` — stable layout + privacy
```jsonc
"app": {
  "iMessageMode": false,
  "reorderOnNotification": false,   // don't shuffle tabs when something pings
  "sendAnonymousTelemetry": false
}
```

### `browser` — disable the embedded browser
Stops cmux from spawning WebKit processes for links:
```jsonc
"browser": {
  "openTerminalLinksInCmuxBrowser": false,
  "interceptTerminalOpenCommandInCmuxBrowser": false,
  "discardHiddenWebViews": true,
  "hiddenWebViewDiscardDelaySeconds": 30
}
```
Links open in my real browser instead.

### `sidebar` — route links out + trim noise
```jsonc
"sidebar": {
  "openPortLinksInCmuxBrowser": false,
  "openPullRequestLinksInCmuxBrowser": false,
  "showLog": false,
  "showProgress": false,
  "showSSH": false,
  "showCustomMetadata": false
}
```
Kept: branch directory, pull requests, ports, notification message.

### `terminal.agentHibernation` — free RAM from idle agents
cmux has no scrollback cap, so hibernation is the real memory lever:
```jsonc
"terminal": {
  "agentHibernation": {
    "enabled": true,
    "idleSeconds": 30,       // hibernate an agent after 30s idle
    "maxLiveTerminals": 4    // keep at most 4 live at once
  }
}
```

## If you edit the config

1. Edit `cmux.json`.
2. Copy the same change into `settings.json` so they stay in sync.
3. Press `cmd+shift+,` in cmux to reload (or restart the app).

The JSON schema (`$schema` at the top of each file) gives autocomplete and
validation if you open these in Neovim with the LSP running.
