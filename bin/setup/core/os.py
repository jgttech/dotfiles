from subprocess import run

def installed(pkg: str) -> bool:
  return bool(run(f"zsh -i -c \"{pkg}\"", shell=True, capture_output=True).returncode)
