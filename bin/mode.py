#!/usr/bin/env python
from argparse import ArgumentParser
from os import getcwd, path

if __name__ == "__main__":
  filename = "Containerfile.archlinux"

  parser = ArgumentParser(description=f"Change the {filename} based on what mode is being used.")
  parser.add_argument("--mode", type=str, default="dev", help="Sets the mode.")

  args = parser.parse_args()
  mode = args.mode

  container_file = path.join(getcwd(), filename)
  target_line = "COPY . /root/.dotfiles"
  should_update = False
  file_content: list[str] = []

  with open(container_file, "r") as file:
    for data in file:
      line = data.strip()

      if target_line in line:
        if mode == "prod" and line[0] != "#":
          should_update = True
          line = f"# {line}"
        elif mode == "dev" and line[0] == "#":
          should_update = True
          line = line[2:]

      file_content.append(line + "\n")

  if should_update:
    with open(container_file, "w") as file:
      for line in file_content:
        file.write(line)
