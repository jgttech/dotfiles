#!/usr/bin/env python
from core.sys import Setup
from core.args import parse
from core.json import load_config

if __name__ == "__main__":
  # Parse CLI arguments.
  args = parse()

  # Read the JSON config file.
  config = load_config(args.home)

  # Instantiate the installation setup.
  install = Setup(args, config)

  # Perform any backup work needed
  # to install the tools.
  install.system_backup()

  # Calls "stow" to link system packages.
  # from the "packages" directory within
  # the dotfiles.
  install.link_packages()

  # Builds the CLI associated with the
  # dotfiles.
  install.build_cli()
