from os import access, environ, path, W_OK, R_OK
from subprocess import run

def installed(pkg: str) -> bool:
  return not bool(run(f"zsh -i -c \"which {pkg}\"", shell=True, capture_output=True).returncode)

def get_bin() -> str:
  HOME = environ["HOME"]
  PATH = environ["PATH"]
  BIN = path.join(HOME, ".local/bin")

  if BIN not in PATH:
    for dir in PATH.split(":"):
      if access(dir, W_OK|R_OK) and "sbin" not in dir:
        return dir

  return BIN
