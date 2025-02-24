from os import mkdir, path, remove, access, listdir, R_OK, W_OK
from dataclasses import asdict
from shutil import copyfile
from subprocess import call
from json import dumps
from core.cfg import Json, Build
from core.cli import Argv
from core.env import HOME, ZSHRC, PATH

class Install:
  build: Build
  build_config: str

  def __init__(self) -> None:
    argv = Argv()
    json = Json(argv.home)

    home = path.abspath(argv.home)
    packages = listdir(path.join(home, "packages"))
    where = path.join(HOME, ".local/bin")

    if where not in PATH:
      for dir in PATH.split(":"):
        if access(dir, R_OK|W_OK) and "sbin" not in dir:
          where = dir
          break

    self.build_config = argv.config
    self.build = Build(
      home=home,
      tools=argv.tools,
      binary=argv.binary,
      where=where,
      packages=packages,
      version=json.version,
    )

    if path.exists(ZSHRC):
      self.build.zshrc = f".zshrc.{self.build.created_at}.backup"

  def backup(self):
    if self.build.zshrc != "":
      copyfile(ZSHRC, self.build.zshrc)
      remove(ZSHRC)

  def stow(self):
    cwd = path.join(self.build.home, "packages")
    packages = " ".join(self.build.packages)

    call(f"stow -t {HOME} {packages}", shell=True, cwd=cwd)

  def cli(self):
    cwd = path.join(self.build.home, self.build.tools)

    args: list[str] = []
    args.append(f"--home={self.build.home}")
    args.append(f"--binary={self.build.binary}")
    args.append(f"--where={self.build.where}")
    args.append(f"--cwd={cwd}")

    call(f"python build {" ".join(args)}", shell=True, cwd=cwd)

  def config(self):
    build_dir = path.join(self.build.home, ".build")
    build_config = path.join(build_dir, self.build_config)

    if not path.exists(build_dir):
      mkdir(build_dir)

    with open(build_config, "w") as fp:
      fp.write(dumps(asdict(self.build), indent=2))

    call(f"stow -t {HOME} .build", shell=True, cwd=self.build.home)
