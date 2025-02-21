from argparse import ArgumentParser
from dataclasses import dataclass, fields

# [Adding new arguments]
# Add a new property to the @dataclass. Make
# sure it has a type associated with it.
@dataclass
class Args:
  home: str
  dev: bool = False
  lang: str = "go"

def parse() -> Args:
  parser = ArgumentParser(description="Dotfiles setup script")

  for field in fields(Args):
    field_name = field.name
    field_type = field.type
    field_abbr = field_name[0].capitalize()
    field_default = field.default

    if field_type == bool:
      parser.add_argument(
        f"-{field_abbr}",
        f"--{field_name}",
        action='store_true',
        help=f"Enable {field_name}",
        default=field_default
      )
    else:
      parser.add_argument(
        f"-{field_abbr}",
        f"--{field_name}",
        type=field_type,
        help=f"{field_name} value",
        default=field_default
      )

  args = parser.parse_args()
  return Args(**vars(args))
