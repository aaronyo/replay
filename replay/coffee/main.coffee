do_search = ->
  request = $.get '/track-search', {'query': $('#search_field').val()}
  request.success show_search_results 
  request.error( (req, status, error) -> alert (error) )
  
show_search_results = (data, status, req) ->
  $('body').append window.ecoTemplates['track_list'] {tracks: data}

jQuery ($) ->
  $('#track_search').click do_search
