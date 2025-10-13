# Personal Dotfiles

When it comes to dotfiles and configruation you can carry from system to system, I have experienced some things that I like and don't. Ultimately, the problems that created the largest headaches for me was anything having to do with different file systems. Like trying to install fonts for macOS and Linux in ways that are automatically detected. The moment different file systems are introduced, logic is now required if I want to maintain configurations in 1 repo for multiple systems. However, I have tried several options that, ultimately, do not cleanly address these issues.

Due to the hyper-personal nature of this kind of thing, I have decided to build my own CLI management tool over the system tools and configs I am trying to manage.

## Prerequisites

- [direnv](https://direnv.net)
- [aqua](https://aquaproj.github.io)
- [just](https://just.systems/man/en)

## Getting Started

> Run the install for local development.

```bash
just
```

> Invoke the CLI (from the docker container).

```bash
dotfiles <args>
```
