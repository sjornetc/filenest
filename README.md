# FileNest

**filenest** is a playful and didactic representation of a GNU/Linux filesystem as if it were a house — rooms, drawers, keys, bills, magazines... all made from folders and files.

This project was designed as a teaching tool to introduce learners to basic GNU/Linux concepts in a fun, tangible way. Inside this "nest of files", you'll explore how users, commands, paths, permissions and structures work — through the metaphor of a cozy, organized home.

## What is this?

`filenest` builds a fake GNU/Linux-like filesystem inside a folder structure that looks like a real house, with:

- A `home` directory that mimics the real `/home`
- A `hall`, `kitchen`, `bedroom`, and more — all as directories
- Files as real-world objects (e.g., `keys`, `magazine_gaming_world`, `electric_bill_25-09-01.txt`)
- Commands and scripts to interact with the house in terminal
- Emojis as file contents (just for fun!)
- Hidden files, wildcard patterns, redirections... all taught with hands-on examples

## Goals

- Help beginners understand the **Unix file structure**
- Practice **basic shell commands** in context
- Learn about **users, permissions, paths, files, directories**
- Encourage curiosity through metaphor and exploration

## Usage

```txt
filenest [OPTIONS] [PATH]
```

For run from GitHub repository use:

``` bash
bash <(wget -qO- https://raw.githubusercontent.com/sjornetc/filenest/main/run.sh) [OPTIONS] [PATH]
```

If no options or path are provided, the script will generate a fully structured file "casa" that you can navigate and manipulate using standard shell commands such as `ls`, `cd`, `cat`, `mv`, `rm`, etc.

## Included Tools

- Bash scripts for renaming, cleaning, making coffee ☕️
- Helpers to visualize `stdout`, `stderr`, and redirections
- Fake users and `sudo` exercises
- Files with and without extensions
- Path navigation challenges

## For Educators

This project is great for:

- Classroom demonstrations
- Terminal practice in a sandboxed environment
- Gamifying CLI exercises
- Customizing with your own "household items"

Feel free to adapt and expand it!
