# Loom

A minimal menubar scratchpad for macOS. Press a shortcut, type a thought, get back to work — your text is always there, even after a restart.

## Features

- **Lives in the menubar** — no Dock icon, no window clutter.
- **Instant access** — click the menubar icon or press **⌥ Option + Space** from anywhere.
- **Liquid Glass** — a floating, translucent panel in the macOS 26 design language, with Monaco 14 for that classic plain-text feel.
- **Always persistent** — whatever you type is continuously saved. Hide the panel, quit the app, restart your Mac — your text is right where you left it.
- **Pin it** — the pin button keeps the panel floating above every app. Unpinned (default), it politely disappears when you click anywhere else. `Esc` hides it too.
- **Snapshot notes** — the save button archives the current text as a timestamped Markdown file (the editor keeps your text). Snapshots live in
  `~/Library/Containers/com.wisp-security.Loom/Data/Library/Application Support/Loom/`.
- **Starts at login** — automatically, when installed in `/Applications` (toggle it off anytime in System Settings → General → Login Items).

## Requirements

macOS 26 (Tahoe) or later.

## Install

1. Download `Loom.zip` from the [latest release](../../releases/latest).
2. Unzip and drag `Loom.app` into `/Applications`.
3. **First launch:** Loom isn't notarized (no $99 Apple Developer subscription), so macOS will refuse to open it at first:
   - Double-click `Loom.app` → macOS shows a warning → click **Done**.
   - Open **System Settings → Privacy & Security**, scroll down, and click **Open Anyway** next to the Loom message.
   - Confirm in the dialog that appears.

   You only do this once. Alternatively, clear the quarantine flag from Terminal:
   ```sh
   xattr -d com.apple.quarantine /Applications/Loom.app
   ```
4. Look for the scribble icon in your menubar, or press **⌥ Space**.

## Build from source

```sh
git clone https://github.com/vigneshsb403/Loom.git
cd Loom
open Loom.xcodeproj   # build & run in Xcode
```

Or with `xcodebuild`:

```sh
xcodebuild -project Loom.xcodeproj -scheme Loom -configuration Release build
```

## License

[MIT](LICENSE)
