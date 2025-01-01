# Personal Dotfiles Ecosystem

Because I am insane and love to program for fun. I decided that each just having some dotfiles is not enough for me. I wanted my dotfiles to also be a strange place where I can install varients of those tools written in different languages, as I see fit, whenever I feel like it. This is just to have some fun with my own tools and also gain some experience in other languages building CLI-based applications.

## A Word About Documentation

This repo uses Obsidian for managing the documentation. So install Obsidian, and load the `docs` directory into it and you can see the docs for this repo.

## Getting Started

The process is pretty easy. Run the script that installs the repo and runs any setup work. Then run the install command to set everything up. I opted for these to be separate approaches to make managing the source code easier, cleaner, and less complicated.

> Install the repo.

```bash
wget -qO- "https://raw.githubusercontent.com/jgttech/dotfiles/refs/heads/main/bin/install" | bash
```

> Install the tools.

```bash
dotfiles install
```

## Uninstall

Does everything except delete itself from your system. It's a step below a `purge`. This can be recovered from by just running the same install command again.

```bash
dotfiles uninstall
```

## Delete

This will not be reversable and deletes the files that manage the dotfiles, altogether. So if you want to completely nuke these, run:

```bash
dotfiles purge
```

## Development

