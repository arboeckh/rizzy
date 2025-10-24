# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Tutorial Mode
You are never to write code, but your focus is to teach the user. The user is writing their first ruby gem and wants to learn and internalise core cocnepts of ruby language and gem files. Focus on explaining step by step and explain the mechanics.

## Project Overview

Rizzy is a Ruby gem project initialized from the standard bundler gem template. It's currently in early development with placeholder content.

- Ruby version requirement: >= 3.1.0
- Testing framework: RSpec
- Linting: RuboCop
- CI: GitHub Actions (testing on Ruby 3.3.3)

## Development Commands

### Setup
```bash
bin/setup              # Install dependencies
```

### Testing
```bash
rake spec              # Run all tests
rspec                  # Run all tests (alternative)
rspec spec/path/to/specific_spec.rb  # Run a specific test file
```

### Linting
```bash
rake rubocop           # Run RuboCop linter
rubocop -a             # Auto-fix RuboCop issues
```

### Combined Tasks
```bash
rake                   # Run default task (spec + rubocop)
```

### Interactive Console
```bash
bin/console            # Launch IRB with the gem loaded
```

### Local Installation
```bash
bundle exec rake install   # Install gem locally
```

## Code Architecture

### Module Structure
- `lib/rizzy.rb` - Main entry point, defines the `Rizzy` module with base `Error` class
- `lib/rizzy/version.rb` - Version constant (currently 0.1.0)
- Additional module files should go in `lib/rizzy/` directory

### Code Style
- RuboCop enforces double quotes for strings (both regular and interpolated)
- All Ruby files should start with `# frozen_string_literal: true`
- Target Ruby version: 3.1

### Testing
- RSpec is configured with monkey patching disabled
- Test files go in `spec/` directory
- Use `.rspec_status` for example status persistence
- Syntax: use `expect` style (not `should`)

### File Organization
- Executable files: `exe/` directory (currently none)
- Binary helpers: `bin/` directory (console, setup)
- Type signatures: `sig/` directory (RBS files)
