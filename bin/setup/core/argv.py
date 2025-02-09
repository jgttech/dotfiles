from argparse import ArgumentParser

# Object instance we need to setup
# the dotfiles in a way that is inferable
# so that they can be easy to maintain.
class Argv:
  dev: bool
  lang: str
  home: str

  # Automatically loads the instance with the
  # data passed in from the CLI arguments parser.
  def __init__(self, **kwargs) -> None:
    for kw in kwargs:
      self.__setattr__(kw, kwargs[kw])

# [Adding New Arguments]
# 1. Add to the parser.
# 2. Add to the "Argv" class.
# 3. Add to the "Argv" constructor arguments.
def parse():
  # The CLI arguments we parse for the
  # entire setup process.
  parser = ArgumentParser(description="Dotfiles install script")
  parser.add_argument("-D", "--dev", action="store_true", dest='dev')
  parser.add_argument("-L", "--lang", action="store", dest="lang")
  parser.add_argument("-H", "--home", action="store", dest="home")
  args = parser.parse_args()

  # Creates and returns a typed and managed
  # instance of the arguments that where passed
  # in and parse from the CLI.
  return Argv(
    dev=args.dev,
    lang=args.lang,
    home=args.home,
  )

