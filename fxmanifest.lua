fx_version 'cerulean'
game 'gta5'

description 'Universal Map Loader Example'
author 'Evo Hosting'
version '1.0.0'

this_is_a_map 'yes'

files {
    'stream/**/*.ymap',
    'stream/**/*.ytyp',
    'stream/**/*.ydd',
    'stream/**/*.ydr',
    'stream/**/*.ytd',
    'maps/**/*.xml',
    'maps/**/*.meta'
}

data_file 'DLC_ITYP_REQUEST' 'stream/**/*.ytyp'

client_script 'client.lua'
