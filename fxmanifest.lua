fx_version 'cerulean'
game 'gta5'

author 'SteakHarpyie59'
description 'Github: SteakHarpyie59'
version '2.0.0'


client_scripts {
    'config.lua',
    'client.lua',
    'client_ox.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'config.lua',
    'server.lua'
}

dependencies {
    'oxmysql'
}

shared_scripts { '@es_extended/imports.lua', '@ox_lib/init.lua' }

lua54 'yes'
