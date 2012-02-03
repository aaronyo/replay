# valid for local host
g = {}
g._playback_token = 'GAlNi78J_____zlyYWs5ZG02N2pkaHlhcWsyOWJtYjkyN2xvY2FsaG9zdEbwl7EHvbylWSWFWYMZwfc='

class Player
  constructor: (playback_token) ->
    @rdio_player = $('#rdio_player').rdio playback_token
    @current_track = null
    @bar_width = parseInt( $('#position_bar').css 'width' )
    $('#rdio_player').bind 'positionChanged.rdio', @_rdio_position_changed
    $('#rdio_player').bind 'playingTrackChanged.rdio', @_rdio_track_changed
    $('#position_bar').click @_click_bar

  play: (track_key) =>
    @rdio_player.play(track_key)
    
  _rdio_position_changed: (e, position) =>    
    format_time = (seconds) ->
      zero_pad = (num) ->
        if num < 10 then return "0#{num}" else return num
      min = Math.floor(seconds / 60)
      sec = zero_pad( Math.floor(seconds % 60) )
      return "#{min}:#{sec}"
    dur = @current_track.duration
    tick_width = position/dur * @bar_width
    $('#time_elapsed').html format_time( position )
    $('#time_remaining').html format_time( dur - position )    
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
    
#class Playlist
#  constructor: (playlist_elm_id, playlist_model)
#    @playlist_jq = $('playlist_elem')
#    @_fill(playlist_model)
#    
#  _fill(playlist_model):
  
    
call_playlists = ->
  request = $.get '/playlists'
  request.success load_playlists
  request.error (req, status, error) -> $('body').append 'Error: ' + error

call_playlist_tracks = (playlist_key) ->
  if playlist_key == '999select999'
    load_playlist_tracks {}
    return
  request = $.get '/playlist-tracks', {playlist_key: playlist_key}
  request.success load_playlist_tracks
  request.error (req, status, error) -> $('body').append 'Error: ' + error

call_search = ->
  request = $.get '/track-search', {query: $('#track_search_field').val()}
  request.success (data) -> g.current_tracks = data
  request.success show_tracks 
  request.error (req, status, error) -> $('body').append 'Error: ' + error
  
call_add_to_playlist = (playlist_key, track_key)->
  playlist_processing()
  request = $.get( '/add-to-playlist',
    { playlist_key: playlist_key, track_key: track_key } )
  request.error (req, status, error) -> $('body').append 'Error: ' + error
  playlist_processing_done()
  
call_similar_tracks = (track_key) ->
  request = $.get '/similar-tracks', {'track_key': track_key}
  console.log(request)
  request.success update_tracks
  request.success -> show_tracks g.current_tracks
  request.error (req, status, error) -> $('body').append 'Error: ' + error

window.call_similar_tracks = call_similar_tracks

playlist_processing = ->


playlist_processing_done = ->


load_playlists = (data) ->
  $('#playlist_select').empty()
  $('#playlist_select').append '<option value="999select999">-- select --</option>'
  for playlist in data
    opt = "<option value=#{ playlist.key }> #{ playlist.name } </option>"
    $('#playlist_select').append opt

load_playlist_tracks = (data) ->
  $('#playlist').empty()
  for t in data
    $('#playlist').append($(window.ecoTemplates['track'] {'track': t}))
  
follow_track = (track_key) ->
  tracks = g.current_tracks
  for t in $('#browse_list .track')
    if t.id != track_key
      $(t).fadeTo(300, 0.0)

  for t, i in tracks
    if t.track_key == track_key
      g.selected_track = t
      g.selected_track_idx = i
      call_similar_tracks t.track_key
      break
  return false

add_track = (track_key) ->
  tracks = g.current_tracks
  for t in tracks
    if t.track_key == track_key
      $('#playlist').append($(window.ecoTemplates['track'] {'track': t}))
      break
  playlist_key = $("#playlist_select").val()
  console.log playlist_key
  call_add_to_playlist playlist_key, track_key
    
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
  context = $('#context').attr('value')
  if context == 'bookmarklet'
    g.player = new APIPlayer
    track_key = $('#track_key').attr('value')
    call_similar_tracks track_key
  else if context == 'home'
    g.player = new Player g._playback_token
  call_playlists()
  $('#track_search_btn').click call_search
  $('#playlist').disableSelection();
  $('#playlist_select').change -> call_playlist_tracks @value
