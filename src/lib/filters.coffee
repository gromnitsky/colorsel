exports.init = (app) ->
  app.filter 'decimals2hex_string', [decimals2hex_string]
  app.filter 'decimals2str', [decimals2str]

decimals2hex_string = ->
  (input) ->
    "#" + ((1 << 24) + (input[0] << 16) + (input[1] << 8) + input[2]).toString(16).slice 1

decimals2str = ->
  (input) ->
    input.join ', '
