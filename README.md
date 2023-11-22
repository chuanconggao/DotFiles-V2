# Introduction

This repo provides modern yet lightweight configurations (including dot files) for macOS (and Linux in most cases) setup, with minimal dependencies.

# How to Use

1. Clone this repo to local
2. For each configuration you want to use, create a symbol link (via `ln -s`) from the expected location to respective file/directory in this repo.

## Zsh

You need to install following GNU packages via `brew`:
- `coreutils`
- `grep`

### Git Prompt

Assuming using Zsh, you need a script named `print_git_prompt` in `PATH` to print Git prompt for current directory:
- Either use our preferred library:
    1. Install `pipx` via `brew`
    2. Update `PATH` by `.zprofile` in this repo
    3. Install `extratools-gittools` via `pipx install git+https://github.com/chuanconggao/extratools-gittools.git`
- Or use any other script that can generate Git prompt, as long as you create a symbol link with the name `print_git_prompt`.

## Git

Remember to update `name` and `email` under `user` section.

## xbar Plugins

Recommend using [SwiftBar](https://github.com/swiftbar/SwiftBar) which is actively updated instead [xbar](https://github.com/matryer/xbar).
