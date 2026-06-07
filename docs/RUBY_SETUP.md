# Ruby Development Setup

Tags: #development #ruby #rspec

## Overview

This guide recommends a setup using **rbenv** for managing Ruby versions and **Bundler** for dependency management. Use
**Rails** for web applications and **RSpec** for testing.

### Recommended Tools

- **rbenv** — Isolate Ruby versions per project without polluting system Ruby
- **Bundler** — Manage gem dependencies with `Gemfile` and `Gemfile.lock`
- **Rails** (optional) — Web application framework
- **RSpec** (optional) — Testing framework for Ruby

---

## Setup

### Install rbenv & ruby-build

```bash
brew install rbenv ruby-build
eval "$(rbenv init - zsh)"  # Add to ~/.zshrc or ~/.bashrc
```

### Manage Ruby Versions

```bash
rbenv versions              # List installed
rbenv install 3.4.2        # Install version
rbenv install --list       # Show available
rbenv global 3.4.2         # Set default
rbenv local 3.2.8          # Per-project (creates .ruby-version)
ruby -v                    # Check active version
```

---

## Bundler - Gem Management

**Gemfile** — dependencies (like package.json)
**Gemfile.lock** — locked versions (commit to git)

```bash
bundle init                # Create new Gemfile
bundle install             # Install gems
bundle add rails           # Add dependency
bundle add rspec --group test
bundle remove rails        # Remove dependency
bundle update              # Update gems
bundle list                # List installed
bundle exec <command>      # Run with bundled gems
```

---

## Rails

```bash
bundle exec rails new myapp --database=postgresql
bundle exec rails s                    # Start server
bundle exec rails c                    # Console
bundle exec rails generate model User name:string
bundle exec rails db:migrate
bundle exec rails db:create
bundle exec rails db:rollback
```

---

## RSpec - Testing

```ruby
# Gemfile
group :test do
  gem 'rspec-rails'
end
```

```bash
bundle install
bundle exec rails generate rspec:install
bundle exec rspec                      # Run all tests
bundle exec rspec spec/models
bundle exec rspec --fail-fast
bundle exec rspec --format documentation
```

---

## Rubocop - Code Style

```ruby
# Gemfile
group :development, :test do
  gem 'rubocop'
  gem 'rubocop-rails'
  gem 'rubocop-rspec'
end
```

```bash
bundle exec rubocop              # Check style
bundle exec rubocop -A           # Autofix
```

### Check Last N Commits

```bash
# Add to ~/.zshrc
rubolast() {
  local depth=${1:-1}
  rubocop $(git diff --name-only HEAD~$depth HEAD | grep "\.rb$") -A
}
```

```bash
rubolast         # Check & fix last 1 commit
rubolast 3       # Check & fix last 3 commits
```

---

## Workflow Examples

### Simple Script

```bash
rbenv local 3.4.2
bundle init
bundle add httparty nokogiri
bundle exec ruby script.rb
```

### Rails App

```bash
rbenv local 3.2.8
bundle exec rails new myapp
cd myapp
bundle exec rails db:create
bundle exec rails db:migrate
bundle exec rspec
bundle exec rails s
```

### Existing Project

```bash
git clone <repo>
cd <project>
# rbenv auto-activates from .ruby-version
bundle install
bundle exec rspec
bundle exec rails s
```

### Multi-Version Testing

```bash
rbenv local 3.2.8 && bundle install && bundle exec rspec
rbenv local 3.4.2 && bundle install && bundle exec rspec
```

---

## Quick Reference

| Task                | Command                        |
|---------------------|--------------------------------|
| Ruby version        | `ruby -v`                      |
| Install version     | `rbenv install 3.4.2`          |
| Set project version | `rbenv local 3.2.8`            |
| Install gems        | `bundle install`               |
| Add gem             | `bundle add rails`             |
| Run tests           | `bundle exec rspec`            |
| Fix code style      | `bundle exec rubocop -A`       |
| Start server        | `bundle exec rails s`          |
| Rails console       | `bundle exec rails c`          |
| Database migrate    | `bundle exec rails db:migrate` |
