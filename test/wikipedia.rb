#!/usr/bin/env ruby

require 'open-uri'
require 'nokogiri'

url = 'https://en.wikipedia.org/wiki/List_of_colors_by_shade'
doc = Nokogiri::HTML URI.open(url)

colors = doc.css('td[class="mw-no-invert"]')
      .map {|v| v["style"].match(/#....../)[0] }
desc = doc.css('table.wraplinks td>a[href]').map {|v|
  v.text == '#FFA3B1' ? 'Strawberry Frappe' : v.text
}

def hex2rgb(hex_color)
  hex_color[1..].scan(/../).map {|v| v.to_i(16)}
end

puts colors.map.with_index {|v,idx|
  "%3d %3d %3d\t\t%s" % [*hex2rgb(v), desc[idx]]
}.join("\n")
