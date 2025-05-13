from cli import cli
from cmds.version import version

cli.add_command(version)

cli()
