from os import mkdir, path, remove, access, listdir, R_OK, W_OK
from dataclasses import asdict
from shutil import copyfile
from subprocess import call
from json import dumps
from platform import system
from core.cfg import Json, Build
from core.cli import Argv
from core.env import HOME, ZSHRC, PATH

class Install:
  system = system().lower()
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
      packages=self.get_packages(packages),
      version=json.version,
    )

    if path.exists(ZSHRC):
      self.build.zshrc = f".zshrc.{self.build.created_at}.backup"

  def get_packages(self, packages: list[str]):
    remove_fonts: list[str] = []

    # Based on the platform, detect which fonts
    # are not needed to install the fonts on that
    # system through using stow to symlink the
    # correct fonts.
    if "linux" in self.system:
      for package in packages:
        if "fonts-" in package and "linux" not in package:
          remove_fonts.append(package)
    elif "darwin" in self.system:
      for package in packages:
        if "fonts-" in package and "darwin" not in package:
          remove_fonts.append(package)

    # Remove the fonts that we do not need
    # for that platform.
    for unnecessary_fonts in remove_fonts:
      packages.remove(unnecessary_fonts)

    return packages

  def config(self):
    build_dir = path.join(self.build.home, ".build")
    build_config = path.join(build_dir, self.build_config)

    if not path.exists(build_dir):
      mkdir(build_dir)

    with open(build_config, "w") as fp:
      fp.write(dumps(asdict(self.build), indent=2))
      fp.write("\n")

    call(f"stow -t {HOME} .build", shell=True, cwd=self.build.home)

  def backup(self):
    if self.build.zshrc != "":
      copyfile(ZSHRC, self.build.zshrc)
      remove(ZSHRC)

  def stow(self):
    cwd = path.join(self.build.home, "packages")
    packages = self.build.packages

    call(f"stow -t {HOME} {" ".join(packages)}", shell=True, cwd=cwd)

  def cli(self):
    cwd = path.join(self.build.home, self.build.tools)

    args: list[str] = []
    args.append(f"--home={self.build.home}")
    args.append(f"--binary={self.build.binary}")
    args.append(f"--where={self.build.where}")
    args.append(f"--cwd={cwd}")

    cmd = f"python build {" ".join(args)}"
    self.build.cli = cmd

    call(cmd, shell=True, cwd=cwd)

  def summary(self):
    build_dir = path.join(self.build.home, ".build")
    build_config = path.join(build_dir, self.build_config)

    call(f"cat {build_config}", shell=True, cwd=HOME)
