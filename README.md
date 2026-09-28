# Tomo

A native macOS e-book library manager. Single-user, local-first. Native handling of language variants and a first-class device delivery workflow.

![Tomo](https://github.com/user-attachments/assets/879c454b-9e31-4662-8811-70f412d2e318)

## What it does

- **Organise your library.** Create collections, swap covers, and edit metadata.
- **Language variants.** Tells `pt-PT` from `pt-BR`, `en-GB` from `en-US`. If it guesses wrong, fix it and it stays fixed.
- **Send to your Kindle or Kobo.** Connect the device and drag books onto it. EPUBs are converted for Kindle inside the app, with no Amazon or Calibre involved. The converter is its own package: [swift-azw3](https://github.com/pdrbrnd/swift-azw3).
- **Download new books.** Install the [included plugins](https://github.com/pdrbrnd/tomo-plugins) to search common sources, or [write your own](docs/plugins.md).
- **In-app reading.** Open a book without leaving the app, or preview one before adding it.
- **Just a folder.** Each book lives in `Author/Title (Year)/` with a `metadata.json` next to it. Delete the app and your library is still there. Works in iCloud Drive.

## Install

```sh
brew install --cask pdrbrnd/tap/tomo
```

Requires macOS 26+.

## Build from source

```sh
git clone https://github.com/pdrbrnd/tomo
cd tomo
open Tomo.xcodeproj
```

Xcode resolves Swift package dependencies on first build. `⌘R` to run.

CLI:

```sh
xcodebuild -project Tomo.xcodeproj -scheme Tomo -configuration Debug build
xcodebuild -project Tomo.xcodeproj -scheme Tomo -destination 'platform=macOS' test
```

## Release

Pushing a tag matching `vX.Y.Z` (or `vX.Y.Z-foo` for pre-releases) to `origin` triggers `.github/workflows/release.yml`, which does the rest:

1. Archives at Release config, signs with Developer ID, notarizes, staples
2. Builds a DMG with `create-dmg`
3. Signs the DMG with the Sparkle ed25519 key
4. Creates a GitHub Release with auto-generated notes and attaches the DMG + SHA256
5. Appends an `<item>` to `docs/appcast.xml` and rewrites `docs/index.html`'s download link, commits to `main`
6. Bumps `version` and `sha256` in `pdrbrnd/homebrew-tap` `Casks/tomo.rb`

```sh
git tag v1.5.0
git push origin v1.5.0
```

## Plugins

Tomo's source-search system loads plugins from `~/Library/Application Support/com.pdrbrnd.tomo/plugins/`. No plugins ship with the app — install from Settings → Plugins (registry-driven) or drop a `.js` file directly into the folder.

The official registry is [`pdrbrnd/tomo-plugins`](https://github.com/pdrbrnd/tomo-plugins). See [docs/plugins.md](docs/plugins.md) for the contract and host API; `gutenberg.js` over there is the canonical example.

## How this was built

Mostly written with Claude. This is my first Swift project. The design, architectural principles, product decisions, and on-disk contract are mine; the SwiftUI is almost exclusively model output. The [CLAUDE.md](/CLAUDE.md) is a good document to understand the opinions that shaped this project.

## License

[AGPL-3.0](LICENSE).
