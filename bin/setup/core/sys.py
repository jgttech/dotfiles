from os import access, environ, path, remove, R_OK, W_OK
from shutil import copyfile
from time import time
from core.argv import parse, Argv
from core.json import load_config, Config

HOME = environ["HOME"]
PATH = environ["PATH"]

def configure():
  # Parse the CLI arguments.
  argv = parse()

  # Read the JSON config file.
  config = load_config(argv.home)

  class Setup:
    argv: Argv
    config: Config
    bin: str
    home: str
    zshrc: str
    zshrc_backup: str

    def __init__(self, argv: Argv, config: Config) -> None:
      self.argv = argv
      self.config = config
      self.home = path.join(HOME, argv.home)
      self.zshrc = path.join(HOME, ".zshrc")
      self.zshrc_backup = path.join(HOME, f".zshrc.{int(time())}.backup")
      self.bin = path.join(HOME, ".local/bin")

      if self.bin not in PATH:
        for dir in PATH.split(":"):
          if access(dir, R_OK|W_OK) and "sbin" not in dir:
            self.bin = dir
            break

      self.bin = path.join(self.bin, config.binary)

    def backup(self):
      # Backup the existing ".zshrc" file,
      # if it exists.
      if path.exists(self.zshrc):
        copyfile(self.zshrc, self.zshrc_backup)
        remove(self.zshrc)

  return Setup(argv, config)
