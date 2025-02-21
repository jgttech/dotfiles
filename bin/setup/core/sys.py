from dataclasses import dataclass
from os import access, environ, path, remove, R_OK, W_OK
from shutil import copyfile
from os import environ, path, listdir
from subprocess import call
from time import time
from core.args import Args
from core.json import Config

# The BackupState is used to keep track
# of what was changed about the file system
# before the dotfiles setup was completed.
# This allows me the ability to restore the
# system to the pre-setup state, if I want.
@dataclass
class BackupState:
  zshrc = ""

class Setup:
  args: Args
  config: Config
  home: str
  packages: str
  bin: str
  zshrc: str
  zshrc_backup: str
  backup = BackupState()

  def __init__(self, args: Args, config: Config) -> None:
    HOME = environ["HOME"]
    PATH = environ["PATH"]

    self.args = args
    self.config = config
    self.home = path.join(HOME, args.home)
    self.packages = path.join(self.home, "packages")
    self.bin = path.join(HOME, ".local/bin")
    self.zshrc = path.join(HOME, ".zshrc")
    self.zshrc_backup = path.join(HOME, f".zshrc.{int(time())}.backup")

    if self.bin not in PATH:
      for dir in PATH.split(":"):
        if access(dir, R_OK|W_OK) and "sbin" not in dir:
          self.bin = dir
          break

    self.bin = path.join(self.bin)

  # Backup anything that is needed to be backed-up
  # before starting to overwrite things.
  def system_backup(self):
    if path.exists(self.zshrc):
      self.backup.zshrc = self.zshrc_backup
      copyfile(self.zshrc, self.zshrc_backup)
      remove(self.zshrc)

  def link_packages(self):
    base = path.abspath(path.join(self.home, ".."))
    call(f"stow -t {base} {" ".join(listdir(self.packages))}", shell=True, cwd=self.packages)

  def build_cli(self):
    lang = self.args.lang

    tools_home = path.join(self.home, "tools", lang)
    tools_script = path.join(tools_home, "build")
    tools_script_exists = path.exists(tools_script)

    if not tools_script_exists:
      print(f"Failed to find '{lang}' build script.")
      exit(1)

    call(
      f"python build --path={self.bin} --binary={self.config.binary}",
      shell=True,
      cwd=tools_home,
    )
