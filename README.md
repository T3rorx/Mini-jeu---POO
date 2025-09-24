# Wish Fortnite

Wish Fortnite is a small Ruby command-line brawler built to practice object-oriented programming. Two scripts are available:

- `app.rb`: runs a fully automated duel between two AI-controlled players.
- `app_2.rb`: lets you play as a human contender against two AI opponents.

Both experiences share the same `Player` and `HumanPlayer` classes defined in `lib/player.rb`, providing reusable combat logic that powers every round.

## Requirements

- Ruby 3.4.2 (defined in `.ruby-version`)
- Bundler (`gem install bundler` if you do not have it)

All dependencies are declared in the `Gemfile` (`dotenv`, `pry`, `rspec`, `rubocop` and extensions).

## Installation

```bash
bundle install
```

This resolves the gems needed to run the games and optional developer tooling.

## Usage

Run either entry point with Ruby from the project root.

### Automated duel

```bash
ruby app.rb
```

Two AI fighters take turns attacking until one is defeated. This is useful for observing the battle loop and checking balance tweaks.

### Playable survival mode

```bash
ruby app_2.rb
```

Enter your player name, then choose actions every round:

- `a`: search for a stronger sword.
- `s`: search for a health pack.
- `0` / `1`: attack one of the two enemies.
- `e`: exit the game early.

Enemy combatants respond after your turn, so keep an eye on everyone’s health totals.

You can change the global `DELAY` constant near the top of `app_2.rb` to slow down or speed up the in-game narration (default is `0` for instant feedback).

## Development

- Player logic lives in `lib/player.rb`.
- `lib/game.rb` is reserved for future game management features.
- `spec/` contains the RSpec configuration scaffold, ready for adding tests.

Use `bundle exec rspec` to run the test suite once specs are added.

## License

No explicit license is provided. Treat the project as "all rights reserved" unless the author specifies otherwise.
