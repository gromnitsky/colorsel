exports.init = (app) ->
  app.directive 'csClipText', [csClipText]

csClipText = ->
  (scope, elm, attrs) ->
    elm.bind 'click', (event) ->
      clipboard = document.getElementById('clipboard')
      clipboard.value = event.target.innerText
      clipboard.select()
      document.execCommand "copy", false, null
      # remove focus from textarea element
      document.querySelector('body').focus()
