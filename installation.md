# Anti-Troll Protection System Installation Guide

## Prerequisites
- QBCore Framework
- oxmysql

## Installation Steps

1. Copy the `hate-antitroll` folder to your server's resources directory

2. Add the following to your `server.cfg`:
```
ensure hate-antitroll
```

3. Configure the settings in `config.lua`:
- `ProtectionTime`: Protection duration in minutes
- `StartingMoney`: Cash given after protection ends
- `StartingBank`: Bank money given after protection ends

## Features
- New player protection system
- Ghost mode for protected players
- Visual timer interface
- Automatic rewards after protection period
- Vehicle damage prevention
- Weapon usage prevention during protection

## Dependencies
- QBCore
- oxmysql

## Support
For support, please contact Hate on Discord.
