# LCRP Logging
A simple logging script using discord embeds, written for Lost County RP.

## Dependencies
- es_extended


### Usage
- For a log action::
```exports.LCRP_Logging.discord(message, sourceID, secondPlayerID, 'COLOUR', 'WEBHOOK', isAdmin)```
Parameters:
message = The message you would like to display in the log
sourceID = the server ID of the player
secondPlayerID = The server ID of the second player - if it is an individual action, then use 0
Colour = This should correspond to a value in the Config.Colours list
Webhook = This should correspond to a value in the Config.WebHooks list
isAdmin = boolean, determines whether to publish the player's IP address alongside the other information

For example:
```exports.LCRP_Logging:discord(msg, _source, 0, 'Wash', 'Wash', false)```

This is a log taken of my own wash action:
(https://i.ibb.co/WgbcX9y/Screenshot-2021-11-09-at-10-34-13.png)
The messsage was generated using the following codeline:

```local msg = GetPlayerName(source).. " has Just used the Money Wash. They washed £"..cash.. ", and received £"..newcash .. " they now have £"..xPlayer.getMoney()```

