do_search = ->
  request = $.get '/track-search', {'query': $('#track_search_field').val()}
  request.success (data, _, _) -> window.current_tracks = data
  request.success show_search_results 
  request.error (req, status, error) -> $('body').append 'Error: ' + error
  
do_follow_track = (track_key) ->
  console.log(track_key)
  tracks = window.current_tracks
  t = (t for t in tracks when t.track_key == track_key)[0]
  alert t.track_title
  
  
show_search_results = (data, status, req) ->
  $('#track-list').empty()
  $('#track-list').append window.ecoTemplates['track_list'] {tracks: data}
  for track_title in $('.track-title')
    $(track_title).click -> do_follow_track track_title.id

jQuery ($) ->
  $('#track_search_btn').click do_search
