do_search = ->
  request = $.get '/track-search', $('#search_field').value
  request.success show_search_results 
  request.error( (req, status, error) -> alert (error) )
  
show_search_results = (data, status, req) ->
  alert data['message']
  $('body').append(data)

jQuery ($) ->
  $('#track_search').click do_search
