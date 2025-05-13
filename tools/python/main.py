from cli import cli
from cmds.version.command import version

cli.add_command(version)

cli()
