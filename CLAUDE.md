# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Common Development Commands

### Build and Test
```bash
# Run all tests
bundle exec rake spec
# or simply
bundle exec rake

# Run a specific test file
bundle exec rspec spec/path/to/specific_spec.rb

# Run a specific test by line number
bundle exec rspec spec/path/to/specific_spec.rb:42

# Run linter
bundle exec rubocop

# Run linter with auto-correction
bundle exec rubocop -a

# Build the gem
bundle exec rake build

# Run interactive console with gem loaded
bundle exec rake console
```

### Development Workflow
```bash
# Install dependencies
bundle install

# The default task runs both tests and rubocop
rake
```

### Git Workflow

- **NEVER** force push (`git push --force` / `--force-with-lease`). It can destroy teammates' commits.
- **ALWAYS** run `git pull --rebase` before pushing, to integrate remote changes on top of your local commits.

```bash
git pull --rebase origin main
git push origin main
```

## High-Level Architecture

This is a Ruby gem that serves as an API client for the Kobana platform, providing a clean interface for financial operations.

### Core Components

1. **Configuration System** (`lib/kobana/configuration.rb`)
   - Manages API tokens and environment settings (development, sandbox, production)
   - Accessed via `Kobana.configure` block

2. **Resource Architecture**
   - Base class: `Kobana::Resources::Base` - provides common functionality
   - Connection handling: `Kobana::Resources::Connection` - manages Faraday HTTP client
   - Operations module: `Kobana::Resources::Operations` - implements CRUD operations
   - All resources inherit from Base and include Operations

3. **Resource Categories**
   - **Charge Resources** (`lib/kobana/resources/charge/`)
     - Pix payments
     - Bank billets (boletos)
   - **Financial Resources** (`lib/kobana/resources/financial/`)
     - Account balances
     - Financial accounts
     - Statement imports
   - **Administrative Resources** (`lib/kobana/resources/admin/`)
     - Subaccount management

### Key Design Patterns

1. **ActiveModel-like Interface**
   - Resources behave like ActiveRecord models with methods like `save`, `create`, `find`, `all`
   - Supports `new_record?` and `created?` states
   - Attributes are dynamically accessible

2. **HTTP Client Management**
   - Uses Faraday with multipart support
   - Automatic JSON request/response handling
   - Environment-specific base URLs

3. **Testing Infrastructure**
   - RSpec with FactoryBot for test data
   - VCR for recording/replaying HTTP interactions
   - Test fixtures stored in `spec/fixtures/`
   - 1Password integration for secure credential management in tests

### Important Considerations

- The gem is currently in BETA (v0.2.0) - expect breaking changes
- API tokens are redacted in `inspect` output for security
- Pre-commit hooks run RuboCop automatically via Lefthook
- CI runs tests across Ruby 3.3.6, 3.4.5, and 4.0.5 (Ruby 3.2 dropped — EOL 2026-04-01)