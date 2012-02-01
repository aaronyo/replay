#track=window.API.player.currentTrack.key
#track="t2231251"
# open('http://localhost:6543/bookmarklet?track_key='+track,'Replay','toolbar=no,width=700,height=350');
# open('http://yahoo.com','Replay','toolbar=no,width=700,height=350');
#$("body").append '<div id="rdio_api_access"></div>'

replayEvent = document.createEvent('Event')
replayEvent.initEvent('launchReplay', true, true)

launch_replay = ->
  track_key = API.player.currentTrack.key
  $('#replay_proxy').get()[0].innerText = track_key
  $('#replay_proxy').get()[0].dispatchEvent replayEvent

$("#replay_button").click launch_replay
