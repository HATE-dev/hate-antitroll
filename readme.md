# Anti-Troll Protection System

[![License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE.txt)
[![QB-Core](https://img.shields.io/badge/QB--Core-framework-green.svg)](https://github.com/qbcore-framework)

A QBCore resource that provides protection for new players against trolling.

## Features

- 🛡️ New player protection system
- 👻 Ghost mode for protected players
- ⏲️ Visual timer interface
- 💰 Automatic rewards after protection period
- 🚗 Vehicle damage prevention
- 🔫 Weapon usage prevention during protection

## Dependencies

- [QB-Core Framework](https://github.com/qbcore-framework)
- [oxmysql](https://github.com/overextended/oxmysql)

## Installation

1. Copy the `hate-antitroll` folder to your server's resources directory
2. Add to your `server.cfg`:
```lua
ensure hate-antitroll
```

## Configuration

Edit `config.lua` to customize:
- `ProtectionTime` - Protection duration in minutes
- `StartingMoney` - Cash given after protection ends
- `StartingBank` - Bank money given after protection ends

## Support

For support, join our Discord server or create an issue in this repository.

## License

This project is licensed under the MIT License - see the [LICENSE.txt](LICENSE.txt) file for details.
