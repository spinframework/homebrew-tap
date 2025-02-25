# Spinframework Tap

## How do I install these formulae?

### [Spin](https://github.com/spinframework/spin)

`brew tap spinframework/tap && brew install spinframework/tap/spin`

## Documentation

`brew help`, `man brew` or check [Homebrew's documentation](https://docs.brew.sh).

## Contributing

Contributors are encouraged to run Homebrew's test-bot locally before submitting
a pull request.

```sh
brew test-bot --only-tap-syntax
```

### Updating the Spin Formula for a New Release

Run the [`bump-spin-formula.sh`](scripts/bump-spin-formula.sh) to update the
formula to use the assets of a specific release (say `v2.4.0`):

```sh
./scripts/bump-spin-formula.sh v2.4.0
```

The script will update the version in the formula, get the checksums file from
the specified release, and update the checksum for each architecture and OS.