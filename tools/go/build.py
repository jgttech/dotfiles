#!/usr/bin/env python
from dataclasses import dataclass, field
from subprocess import call
from os import environ, path
from json import load

if __name__ == "__main__":
  CONFIG = ".dotfiles.build.json"
  HOME = environ["HOME"]

  # Data in the config file.
  @dataclass
  class Config:
    created_at: str = ""
    version: str = ""
    home: str = ""
    tools: str = ""
    binary: str = ""
    zshrc: str = ""
    out_dir: str = ""
    cli_dir: str = ""
    config_dir: str = ""
    binary_dir: str = ""
    packages: list[str] = field(default_factory=list)

  config_file = path.join(HOME, CONFIG)
  config = Config()

  # Loading in the config file.
  with open(config_file, "r") as file:
    config = Config(**load(file))

  # Config variables.
  home = config.home
  tools = config.tools
  binary = config.binary
  zshrc = config.zshrc
  out_dir = config.out_dir
  cli_dir = config.cli_dir
  config_dir = config.config_dir
  binary_dir = config.binary_dir
  packages = config.packages

  # Paths for building and sumlinking the CLI.
  build_dir = path.join(home, out_dir)
  tools_dir = path.join(home, tools)
  cli_file = path.join(config.cli_dir, binary)
  cli_cmd = f"go build -o {cli_file} main.go"
  stow_file = path.join(binary_dir, binary)

  # Build the CLI.
  call(cli_cmd, shell=True, cwd=tools_dir)

  # If the symlink does not exist, create it.
  if not path.exists(stow_file):
    call(f"stow -t {binary_dir} cli", shell=True, cwd=build_dir)
