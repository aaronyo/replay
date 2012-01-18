from pyramid.view import view_config

@view_config(route_name='home', renderer='home.mak')
def my_view(request):
    return {'project':'mak replay'}

@view_config(route_name='track-search', renderer='json')
def track_search(request):
    return {'message':'success'}
