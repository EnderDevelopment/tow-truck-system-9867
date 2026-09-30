# Tow Truck System

Enhance your FiveM roleplay with a professional tow truck system.

## Features

- Realistic towing mechanics with a lifting and lowering platform
- Boss menu for hiring, firing, promoting, and demoting employees
- Clothing menu for uniform changes

## Requirements

- FiveM server with ESX framework
- MySQL database

## Installation

1. Download the script from the [releases page](https://github.com/EnderDevelopment/tow-truck-system/releases).
2. Extract the files into your FiveM server's `resources` directory.
3. Import the `database.sql` file into your MySQL database.
4. Add the following line to your `server.cfg` file:

```
start tow-truck-system
```

## Usage

### Towing Mechanics

- Enter a tow truck vehicle.
- Press the `E` key to tow a vehicle in front of you.
- Press the `G` key to raise or lower the lifting platform.

### Boss Menu

- Press the `F2` key to open the boss menu.
- Use the menu to hire, fire, promote, or demote employees.

### Clothing Menu

- Press the `F1` key to open the clothing menu.
- Select a uniform to change your appearance.

## Configuration

The script can be configured by editing the `config.lua` file. The following settings are available:

```lua
Config = {}

-- Towing settings
Config.TowDistance = 10.0
Config.TowSpeed = 1.0
Config.TowKey = 38 -- E key

-- Platform settings
Config.PlatformHeight = 1.0
Config.PlatformSpeed = 0.1
Config.PlatformKey = 47 -- G key

-- Boss menu settings
Config.BossMenuKey = 289 -- F2 key

-- Clothing menu settings
Config.ClothingMenuKey = 288 -- F1 key

-- Database settings
Config.DatabaseName = 'towtrucksystem'
Config.DatabaseTable = 'towtruck_data'
```

---

## Generated with EnderDevelopment

This plugin was generated in minutes with [EnderDevelopment](https://enderdevelopment.com) — the AI platform that turns your ideas into working Minecraft plugins, Discord bots and FiveM scripts.

**Want your own?** [Generate this project on EnderDevelopment](https://dash.enderdevelopment.com?utm_source=github&utm_medium=readme&utm_campaign=tow-truck-system&utm_content=bottom) — describe it in one sentence and get the full source code.