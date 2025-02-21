from json import load
from os import environ, path

class Config:
  version: str
  binary: str

def load_config(home: str) -> Config:
  HOME = environ["HOME"]

  config = Config()
  file_path = path.join(HOME, home, "dotfiles.json")

  with open(file_path, "r") as file:
    data = load(file)
    config.version = data["version"]
    config.binary = data["binary"]

  return config
