# Aquarium

A tool to display an aquarium using emojis in the terminal built with Elixir. \
It also can update the aquarium in the terminal - moving the fish and spawning new ones.

### Example Aquarium
```
🏊 　 　 ⛴️ 🏄 　 🚤 　
　 　 　 🫧 　 　 🐟 🐡
　 　 　 　 🐡 　 　 　
　 　 　 🦑 　 　 　 🫧
　 　 　 　 　 　 　 　
　 🌱 🌱 🌱 🌿 🪸 　 🌱
```

## Cli

### build

`mix escript.build` then `./aquarium` with either 0 / 1 / 2 arguments.

### Arguments Meaning:

**0** - Generates a simple 12\*8 aquarium. \
**1** - An aquarium that updates in the terminal. \
**2** - Generate a custom size of an aquarium (minimum 4\*4).

## License
MIT License - see `LICENSE` file.
