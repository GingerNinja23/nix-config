# nix-config

Declarative macOS configuration using [nix-darwin](https://github.com/nix-darwin/nix-darwin),
[home-manager](https://github.com/nix-community/home-manager), and
[nix-homebrew](https://github.com/zhaofengli/nix-homebrew).

## Structure

- `flake.nix` — entry point; exports `lib.mkMac` and the `personal` machine target
- `configuration.nix` — system-level config (macOS defaults, Homebrew brews/casks)
- `home.nix` — user-level config (shell, git, starship, CLI tools)

The `personal` target uses username `gingerninja`. A separate private work overlay
(GitFarm) composes an `amazon` target on top of this base via `lib.mkMac`.

## Usage

```sh
./rebuild.sh          # applies the `personal` target
```

## Manual installation required

A few things can't be (or aren't) managed declaratively and must be installed by hand:

### Mac App Store apps

These are **not** managed via Nix. `mas` (the CLI Homebrew uses for App Store
installs) has a bug in v7.0.0 — it returns a non-zero exit code
(`Failed to find receipt to import`) even when the install succeeds. Because
`brew bundle` runs before home-manager during activation, that false failure
aborts the entire rebuild. To avoid that, install these from the App Store manually:

| App | App Store ID |
|-----|--------------|
| Things 3 | 904280696 |
| Bear | 1091189122 |
| AutoMute - No More Oopsies | 1118136179 |
| WhatsApp Messenger | 310633997 |
| Apple Configurator | 1037126344 |

If `mas` ships a fix, these can move back into `homebrew.masApps` in `configuration.nix`.

### First-time setup on a new machine

1. Install [Determinate Nix](https://docs.determinate.systems/)
2. Clone this repo
3. Bootstrap nix-darwin (before `darwin-rebuild` exists):
   ```sh
   nix run nix-darwin -- switch --flake .#personal
   ```
4. Subsequent rebuilds: `./rebuild.sh`

If the machine's username isn't `gingerninja`, update the `user` value in `flake.nix`.
