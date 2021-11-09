fx_version 'cerulean'

game 'gta5'


client_scripts {
  '@mysql-async/lib/MySQL.lua',
  '@es_extended/locale.lua',
  'en.lua',
  'config.lua',
  'client.lua',
}

server_scripts {
  '@es_extended/locale.lua',
  'config.lua',
  'server.lua'
}

dependencies {
	'es_extended',
}

file 'postals.json'
postal_file 'postals.json'
