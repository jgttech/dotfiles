from argparse import ArgumentParser

class Argv:
  home: str = ""
  tools: str = ""
  binary: str = ""
  config: str = ""

  def __init__(self) -> None:
    parser = ArgumentParser(description="Dotfiles install script")

    parser.add_argument("-H", "--home", help="Directory to download repo to.")
    parser.add_argument("-T", "--tools", help="The tools path within the repo.")
    parser.add_argument("-B", "--binary", help="The name of the CLI binary.")
    parser.add_argument("-C", "--config", help="The name of the config JSON file.")

    args = parser.parse_args()

    self.home = args.home
    self.tools = args.tools
    self.binary = args.binary
    self.config = args.config
