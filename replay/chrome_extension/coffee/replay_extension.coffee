injectJs = (link) ->
  scr = document.createElement("script")
  scr.type="text/javascript"
  scr.src=link
  (document.head || document.body || document.documentElement).appendChild(scr)

do_it = (w) ->
  track=w.API.player.currentTrack.key
  open('http://localhost:6543/bookmarklet?track_key='+track,'Replay','toolbar=no,width=700,height=350');

console.log chrome.extension.getURL("inject.js")

replay_button = '<button id="replay_button">Replay</button>'
replay_proxy = '<div id="replay_proxy" type="hidden" />'
$("#inner_container").after replay_button 
$("#inner_container").after replay_proxy 

injectJs chrome.extension.getURL("inject.js")

base_html = null

get_base_html = ->
  request = $.get 'http://localhost:6543/static/rdio_insert.html'
  request.success (data) -> base_html = data

get_base_html()

open_replay = (track_key) ->
  $('#c_column').empty()
  $('#c_column').append(base_html)
  window.call_similar_tracks track_key

$('#replay_proxy').get()[0].addEventListener 'launchReplay', ->
  open_replay $('#replay_proxy').get()[0].innerText

do_this = () ->
#  console.log $("#playButton").click
#  ($("#playButton").click)()
  api = $('#rdio_api_access').get()[0].innerText
  api.player.play("t2231251")
  
#setTimeout do_this, 3000