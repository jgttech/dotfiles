#!/usr/bin/env python
from core.os import installed
from core.argv import parse

if __name__ == "__main__":
  argv = parse()

  print(f"dev..: {argv.dev}")
  print(f"lang.: {argv.lang}")
  print(f"path.: {argv.path}")
  print(f"git..: {installed("git")}")
