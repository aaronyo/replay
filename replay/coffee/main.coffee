# valid for local host
_playback_token = 'GAlNi78J_____zlyYWs5ZG02N2pkaHlhcWsyOWJtYjkyN2xvY2FsaG9zdEbwl7EHvbylWSWFWYMZwfc='

call_search = ->
  request = $.get '/track-search', {query: $('#track_search_field').val()}
  request.success (data) -> window.current_tracks = data
  request.success show_tracks 
  request.error (req, status, error) -> $('body').append 'Error: ' + error
  
call_similar_tracks = (track) ->
  request = $.get '/similar-tracks',
    {track_key: track.track_key
    artist: track.artist
    track_title: track.track_title}
  request.success update_tracks
  request.success -> show_tracks window.current_tracks
  request.error (req, status, error) -> $('body').append 'Error: ' + error
  
follow_track = (track_key) ->
  tracks = window.current_tracks
  for t in $('.track')
    if t.id != track_key
      $(t).fadeTo(300, 0.0)

  for t, i in tracks
    if t.track_key == track_key
      window.selected_track = t
      window.selected_track_idx = i
      call_similar_tracks t
      break
  return false
  
play_track = (track_key) ->
  $('#rdio-player').rdio().play(track_key)
  
update_tracks = (data) ->
  if window.selected_track?
    data[window.selected_track_idx] = window.selected_track
  window.current_tracks = data
  
show_buttons = (track) ->
  for btn in track.find('.track-button')
    $(btn).show()

hide_buttons = (track) ->
  for btn in track.find('.track-button')
    $(btn).hide()

show_tracks = (tracks) ->
  tracks = $(window.ecoTemplates['track_list'] {tracks: tracks})
  for track in tracks
    if not (window.selected_track? and window.selected_track.track_key == track.id)
      $(track).fadeTo(0, 0.0)
      hide_buttons $(track)
      
  $('#track-list').html( tracks )
  
  for track in tracks
    do (track) ->
      track = $(track)
      track.fadeTo(300, 1.0)
      track.hover (-> show_buttons track), (-> hide_buttons(track))
      track.find('.bump').click -> follow_track track.attr('id')
      track.find('.play').click -> play_track track.attr('id')
      

jQuery ($) ->
  $('#rdio-player').rdio(_playback_token)
  $('#track_search_btn').click call_search
