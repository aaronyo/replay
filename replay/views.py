from pyramid.view import view_config
from .lib import rdio_service

_music_service = None

def setup_music_service(consumer_secret):
    consumer_key = 'xjyzmxy7pmsn7u38xrpafyjk'
    global _music_service
    _music_service = rdio_service.setup(consumer_key, consumer_secret)

def _get_music_service():
    return _music_service    
    
@view_config(route_name='home', renderer='home.mak')
def my_view(request):
    return {'project':'mak replay'}

@view_config(route_name='track-search', renderer='json')
def track_search(request):
    q = request.params['query']
    print "Query: " + q
    if q:
        results = _get_music_service().track_search(q, 10)
        print "Result: %d tracks" % len(results)
        return results
