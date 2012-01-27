# valid for local host
g = {}
g._playback_token = 'GAlNi78J_____zlyYWs5ZG02N2pkaHlhcWsyOWJtYjkyN2xvY2FsaG9zdEbwl7EHvbylWSWFWYMZwfc='
window.main_g = g


class Player
  constructor: (playback_token) ->
    console.log('here')
    @rdio_player = $('#rdio_player').rdio playback_token
    @current_track = null
    @bar_width = parseInt( $('#position_bar').css 'width' )
    $('#rdio_player').bind 'positionChanged.rdio', @_rdio_position_changed
    $('#rdio_player').bind 'playingTrackChanged.rdio', @_rdio_track_changed
    $('#position_bar').click @_click_bar

  play: (track_key) =>
    @rdio_player.play(track_key)
    
  _rdio_position_changed: (e, position) =>
    #tick_width = parseInt( $('#position_bar #tick').css 'width' )
    tick_width = position/@current_track.duration * @bar_width
    $('#position_bar #tick').css 'width', tick_width
    
  _rdio_track_changed: (e, track, position) =>
    @current_track = track
    title_str = "(#{ track.artist }) #{ track.name }"
    $('#player #track_title').html(title_str)
  
  _click_bar: (event) =>
    if not @current_track?
      return
    newX = event.pageX - $('#position_bar').offset().left
    pos = newX / @bar_width * @current_track.duration
    console.log(pos)
    @rdio_player.seek(pos)
    


call_search = ->
  request = $.get '/track-search', {query: $('#track_search_field').val()}
  request.success (data) -> g.current_tracks = data
  request.success show_tracks 
  request.error (req, status, error) -> $('body').append 'Error: ' + error
  
call_similar_tracks = (track) ->
  request = $.get '/similar-tracks',
    {track_key: track.track_key
    artist: track.artist
    track_title: track.track_title}
  request.success update_tracks
  request.success -> show_tracks g.current_tracks
  request.error (req, status, error) -> $('body').append 'Error: ' + error
  
follow_track = (track_key) ->
  tracks = g.current_tracks
  for t in $('#browse_list .track')
    if t.id != track_key
      $(t).fadeTo(300, 0.0)

  for t, i in tracks
    if t.track_key == track_key
      g.selected_track = t
      g.selected_track_idx = i
      call_similar_tracks t
      break
  return false

add_track = (track_key) ->
  tracks = g.current_tracks
  for t in tracks
    if t.track_key == track_key
      $('#play_list').append($(window.ecoTemplates['track'] {'track': t}))
      break
    
  update_tracks = (data) ->
  if g.selected_track?
    data[g.selected_track_idx] = g.selected_track
  g.current_tracks = data
  
show_buttons = (track) ->
  for btn in track.find('.track_button')
    $(btn).show()

hide_buttons = (track) ->
  for btn in track.find('.track_button')
    $(btn).hide()

show_tracks = (tracks) ->
  track_divs = []
  for track in tracks
    track_divs.push $(window.ecoTemplates['track'] {'track': track})
  console.log(track_divs)
  for td in track_divs
    if not (g.selected_track? and g.selected_track.track_key == td.attr('id'))
      td.fadeTo(0, 0.0)
      hide_buttons (td)
  $('#browse_list').empty()  
  $('#browse_list').append track_divs...
  
  for track in track_divs
    do (track) ->
      track = $(track)
      track.fadeTo(300, 1.0)
      track.hover (-> show_buttons track), (-> hide_buttons(track))
      track.find('.bump').click -> follow_track track.attr('id')
      track.find('.add').click -> add_track track.attr('id')
      track.find('.play').click -> g.player.play track.attr('id')
      

jQuery ($) ->
  g.player = new Player g._playback_token
  $('#track_search_btn').click call_search
  $('#play_list' ).sortable();
  $('#play_list').disableSelection();
