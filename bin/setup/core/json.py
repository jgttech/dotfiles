from json import load
from os import environ, path

class Config:
  version: str
  binary: str

def load_config(home: str) -> Config:
  config = Config()

  with open(path.join(environ["HOME"], home, "dotfiles.json"), "r") as file:
    data = load(file)
    config.version = data["version"]
    config.binary = data["binary"]

  return config
