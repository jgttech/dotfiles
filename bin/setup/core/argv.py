from argparse import ArgumentParser

class Parser(ArgumentParser):
  class Args:
    dev: bool
    lang: str
    path: str

    def __init__(self, dev: bool, lang: str, path: str):
      self.dev = dev
      self.lang = lang
      self.path = path

  def argv(self) -> Args:
    args = self.parse_args()

    return self.Args(
      dev=args.dev,
      lang=args.lang,
      path=args.path,
    )

def parse():
  parser = Parser(description="Dotfiles install script")

  parser.add_argument("-D", "--dev", action="store_true", dest='dev', default=False)
  parser.add_argument("-L", "--lang", action="store", dest="lang", default="go")
  parser.add_argument("-P", "--path", action="store", dest="path", default=".dotfiles", type=str)

  return parser.argv()
