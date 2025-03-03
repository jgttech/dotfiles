#!/usr/bin/env python
from os import access, listdir, path, environ, makedirs, W_OK, R_OK
from dataclasses import dataclass, field, asdict
from argparse import ArgumentParser
from subprocess import call
from platform import system
from time import time
from json import dumps, load

if __name__ == "__main__":
  # Environment
  HOME = environ["HOME"]
  PATH = environ["PATH"]
  OS = system().lower()
  ZSHRC = path.join(HOME, ".zshrc")
  BIN = path.join(HOME, "/.local/bin")

  # Unix timestamp.
  timestamp = str(int(time()))
  packages: list[str] = []
  version = "0.0.0"

  # CLI arguments.
  parser = ArgumentParser(description="Generates the dotfiles config.")
  parser.add_argument("--home", help="Path to the dotfiles")
  parser.add_argument("--tools", help="Path to the language tools within the dotfiles.")
  parser.add_argument("--binary", help="Name of the binary/entrypoint to create.")
  parser.add_argument("--config", help="Name of the config file to generate.")
  parser.add_argument("--out", help="Build path for the binary within the dotfiles.")

  # Parse CLI arguments.
  args = parser.parse_args()

  # CLI variables.
  home = args.home
  tools = args.tools
  binary = args.binary
  config = args.config
  out_dir = args.out

  # Dynamic variables
  packages_dir = path.join(home, "packages")
  build_dir = path.join(home, out_dir)
  cli_dir = path.join(home, out_dir, "cli")
  config_dir = path.join(home, out_dir, "config")
  config_file = path.join(config_dir, config)

  with open(path.join(home, "dotfiles.json"), "r") as file:
    data = load(file)
    version = data["version"]

  # Detect all the packages we need
  # to use GNU stow on.
  for dir in listdir(packages_dir):
    if "fonts-" in dir:
      if "linux" in OS and "linux" in dir:
        packages.append(dir)
      elif "darwin" in OS and "darwin" in dir:
        packages.append(dir)
    else:
      packages.append(dir)

  # Make sure that the output directory exists.
  if not path.exists(config_dir):
    makedirs(config_dir, exist_ok=True)

  # Checks if the given string contains any of
  # the ignore_paths within the string. It returns
  # False if it failed and True, if is passed.
  def is_valid(string: str) -> bool:
    ignore_paths = ["sbin", "nvm", "oh-my-zsh", "gnu-getopt"]
    failed = False

    for ignore in ignore_paths:
      if ignore in string:
        failed = True
        break

    return not failed

  # Detect a place to link the CLI to that we have
  # read and write access to. We use this location
  # to link the binary to the system for specialized
  # behavior. Like being able to uninstall the packages
  # but NOT the CLI so they can be re-installed, for example.
  if BIN not in PATH:
    for entry in PATH.split(":"):
      if is_valid(entry) and access(entry, R_OK|W_OK):
        BIN = entry
        break

  # Data in the config file.
  @dataclass
  class Config:
    created_at: str = timestamp
    version: str = version
    home: str = home
    tools: str = tools
    binary: str = binary
    zshrc: str = f".zshrc.{timestamp}.backup" if path.exists(ZSHRC) else ""
    out_dir: str = out_dir
    cli_dir: str = cli_dir
    config_dir: str = config_dir
    binary_dir: str = BIN
    packages: list[str] = field(default_factory=list)

  # Write the JSON data to the config file.
  with open(config_file, "w") as file:
    file.write(dumps(asdict(Config(packages=packages)), indent=2) + "\n")

  # Symlink the config to the $HOME of the user.
  call(f"stow -t {HOME} config", shell=True, cwd=build_dir)
