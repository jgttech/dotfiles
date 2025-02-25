from time import time
from os import path
from json import load
from dataclasses import dataclass, field

class Json:
  version: str

  def __init__(self, home: str) -> None:
    file = path.join(home, "dotfiles.json")

    if path.exists(file):
      with open(file, "r") as fp:
        data = load(fp)

        self.version = data["version"]

# The data used for the build configuration
# After the dotfiles are all setup.
@dataclass
class Build:
  # When the install and build config was created.
  created_at: str = str(int(time()))

  # The home path to the dotfiles.
  home: str = ""

  # Which tools where installed.
  tools: str = ""

  # The name of the binary built.
  binary: str = ""

  # Where the binary was located.
  where: str = ""

  # What version of the dotfiles was the CLI.
  version: str = ""

  # The name of the backup .zshrc file on install.
  # If it was blank, then there was no .zshrc file
  # when the install was run.
  zshrc: str = ""

  # The command that built the CLI. This gets used
  # by the updating process to ensure that if/when
  # the CLI gets rebuilt, it does so in the exact
  # same way it was first created.
  cli: str = ""

  # List of all the packages stow installed from
  # the repo packages. This should be all of them
  # and just serves as a config environment output.
  packages: list[str] = field(default_factory=list)
