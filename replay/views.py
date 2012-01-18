from pyramid.view import view_config

@view_config(route_name='home', renderer='home.mak')
def my_view(request):
    return {'project':'mak replay'}

@view_config(route_name='track-search', renderer='json')
def track_search(request):
    return [
            {'artist':'Jethro Tull', 'album':'Thick as a Brick', 'track':'Part 1'},
            {'artist':'Dire Straits', 'album':'Brothers in Arms', 'track':'Brothers in Arms'},
            {'artist':'Jimmy Cliff', 'album':'Many Rivers', 'track':'Time Will Tell'},    
           ]
