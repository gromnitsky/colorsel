class ColorSource

  constructor: (@raw_data, @params) ->
    throw new Error "invalid @raw_data" unless @raw_data?.length > 10
    throw new Error "invalid @params" unless @params

    @colors = []
    @parse()

  _errmsg: (line, msg) ->
    "#{@params.url || '(no name)'}:#{line}: #{msg}"

  parse: ->
    for line,index in @raw_data.split "\n"
      continue if line.match /^\s*$/

      # 144 238 144    LightGreen
      match = line.match /(\d+)\s+(\d+)\s+(\d+)\s+([0-9a-zA-Z_ -]+)/
      throw new Error @_errmsg index+1, 'invalid data' unless match?.length != 7
      name = match[4].trim()
      # skip the line if color name contains a space char and @params
      # doesn't allow that
      continue if name.indexOf(' ') != -1 && !@params.spaces

      decimals = []
      decimals.push parseInt(idx) for idx in [match[1], match[2], match[3]]
      for digit in decimals
        throw new Error @_errmsg index+1, "invalid decimal: #{digit}" unless 0 <= digit <= 255

      @colors.push {
        name: name
        decimals: decimals
      }

module.exports = ColorSource
