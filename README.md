# Homebrew Tap

A custom Homebrew tap by EloB.

## Installation

```bash
brew tap EloB/tap
```

## Usage

Once the tap is installed, you can install any formula from it:

```bash
brew install EloB/tap/<formula>
```

Or install a cask:

```bash
brew install --cask EloB/tap/<cask>
```

## Available Formulas

*No formulas available yet.*

## Available Casks

*No casks available yet.*

## Adding a Formula

To add a new formula, create a Ruby file in the `Formula/` directory:

```bash
mkdir -p Formula
touch Formula/example.rb
```

## Adding a Cask

To add a new cask, create a Ruby file in the `Casks/` directory:

```bash
mkdir -p Casks
touch Casks/example.rb
```

## License

MIT
