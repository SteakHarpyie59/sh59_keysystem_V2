# SH59_Keysystem V2
This FiveM resource allows players to manage their vehicle keys.
<br>It is based on [SH59_Keysystem](https://github.com/SteakHarpyie59/sh59_keysystem) brings a lot of improvements.

![This is an image](https://raw.githubusercontent.com/SteakHarpyie59/images-for-my-work/main/KeysysV2_Image.png)
<br>

## Overview
#### Showcase Video: SOON
#### Showcase Video of V1: https://youtu.be/YqnhZakHxKA

#### Features
- Transfer master-keys (vehicle ownership) to other players
- Create new (secondary) keys at the locksmith
- Exchanging vehicle lock at the locksmith (invalidates all keys for the vehicle)
- Transfer (secondary) keys to other players
- Compatibility with ox_lib and ox_target
- Easy Configuration (config.lua)
- Discord Logging (Optional)
- ESX callbacks and events to implement in other scripts (e.g. carlock, garage, etc.)


#### Requirements
- ESX
- oxmysql
- ox_lib (optional)
- ox_target (optional)


#### Important Note
This script provides only the Key Management system.
- You have to code the function of the vehicle keys in your scripts (e.g. carlock, garage, etc.) by yourself using the callbacks and events or download scripts that are compatible with SH59_Keysystem.
- Here are some scripts, that are compatible with SH59_Keysystem:
- [esx_carlock (optimized fork)](https://github.com/SteakHarpyie59/esx_carlock)
- [sh59_garage](https://github.com/SteakHarpyie59/sh59_garage)
<br>
<br>

## Reporting Bugs / Feature Request
To report bugs or request features, please use the Issuses tab.
Please keep in mind that I'm developing this resource as a hobby project, so I can't work on it 24/7.
<br>
<br>

## Documentation
~~visit the Wiki Tab of this repository~~ *(SOON)*
There will be a Wiki soon. Right now the [Wiki Tab of V1](https://github.com/SteakHarpyie59/sh59_keysystem/wiki) can explain pretty good.
<br>
<br>
<br>

## Changes in comparison to V1
⚠ Important if your are Upgrading from [SH59_Keysystem](https://github.com/SteakHarpyie59/sh59_keysystem) (V1)
```diff
+ An (optional) rework with ox_lib
+ Security improvements in server.lua
+ Keeping most of the compatibility with scripts that were made for SH59_Keysystem (V1)
- Deprecation of sh59_KeySystem:RemoveMoney event
! Some NetEvents are now normal server-to-setver events
```
> Following events are no longer NetEvents, but just normal server-to-server Events, due to security reasons:
> - sh59_KeySystem:GiveKey
> - sh59_KeySystem:RemoveKey
> - sh59_KeySystem:RemoveAllKeys
