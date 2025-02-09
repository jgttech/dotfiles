#!/usr/bin/env python
from core.sys import configure

if __name__ == "__main__":
  setup = configure()

  # Perform any backup work needed
  # to install the tools.
  setup.backup()

  print(f"bin............: {setup.bin}")
  print(f"home...........: {setup.home}")

  print(f"argv.dev.......: {setup.argv.dev}")
  print(f"argv.lang......: {setup.argv.lang}")
  print(f"argv.home......: {setup.argv.home}")

  print(f"config.version.: {setup.config.version}")
  print(f"config.binary..: {setup.config.binary}")
