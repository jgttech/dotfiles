#!/usr/bin/env python
from core.os import installed, get_bin
from core.argv import parse

if __name__ == "__main__":
  argv = parse()
  dir = get_bin()

  print(f"dev......: {argv.dev}")
  print(f"lang.....: {argv.lang}")
  print(f"path.....: {argv.path}")
  print(f"bin......: {dir}")
  print(f"git......: {installed("git")}")
