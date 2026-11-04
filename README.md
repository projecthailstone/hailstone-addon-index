# Hailstone add-on index

Some EQEmu servers have a [Hailstone](https://github.com/projecthailstone/hailstone-client) add-on of their own: a
plugin or script that adds the server's custom windows and features. This repository lists those servers, so that
Hailstone can point a new player to the right add-on.

When a player logs in to a server whose world is listed here and they don't have its add-on yet, Hailstone's login
screen says so and offers **Look at it**, **Not now** and **Don't ask again**. **Look at it** opens the add-on
manager's usual install card. The card shows what the add-on is and what it asks to do, and nothing is installed
until the player says yes. Hailstone fetches this file at most every few hours (`addons.check_hours`). A player can
turn the suggestions off with `addons.suggest = 0` in `hailstone.ini`.

## The file

`hailstone-addon-index.txt` is plain text, one record per line:

```
hailstone-addon-index 1
addon <name> <owner/repo> <key>
world <name> <login server> <world name>
signature <128 hex digits>
```

| Record | Meaning |
|---|---|
| `addon` | The add-on. `name` is the `name` in its `hailstone-addon.txt`, `owner/repo` is its GitHub repository (public: where players install it from), and `key` is the Ed25519 public key (64 hex digits) its manifest is signed with. Hailstone refuses to install a suggested add-on whose manifest has another name or isn't signed with this key. |
| `world` | A world the add-on is for. `login server` is the login server's host as players type it (`*` matches any), and `world name` is the rest of the line, exactly as the login server lists the world (case doesn't matter). An add-on may have several `world` lines. |
| `signature` | The Hailstone release key's signature over everything above it. Hailstone ignores an index that isn't signed with that key. |

Lines starting with `#` are comments. Hailstone skips records it doesn't know.

## Adding a server

Open a pull request that adds an `addon` line and its `world` lines. Your add-on must already install from its
repository with Hailstone's add-on manager, and its manifest must be signed (`hailstone_sign sign`, see Hailstone's
docs/addons.md "For authors"). A maintainer signs the file after merging.

A server can also suggest its add-on by itself: `[addons] suggest = owner/repo` in its `hailstone.cfg`. Players only
receive that file at their first zone-in, though, so this index is how a first-time player hears about the add-on
before they log in.

## Signing (maintainers)

```sh
tools/sign.sh            # signs with ~/.config/hailstone-release/release-key.secret, then verifies
```

`tools/sign.sh` uses `hailstone_sign` from a Hailstone build (`HAILSTONE_SIGN=/path/to/hailstone_sign` to name
another one).
