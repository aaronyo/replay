from pyramid.view import view_config
from .lib import rdio_service
from .lib import echo_service

_music_service = None
_echo_service = None
_echo_catalog = 'CAMQJMD133B59A5B1C'
def setup_music_service(consumer_secret):
    #FIMXE: private - do not commit to git
    consumer_key = 'xjyzmxy7pmsn7u38xrpafyjk'
    echonest_key = 'EQW4T6NJOAR2BUXSO'
    global _echo_service
    _echo_service = echo_service.setup(echonest_key)
    global _music_service
    _music_service = rdio_service.setup(consumer_key, consumer_secret)

def _get_music_service():
    return _music_service    

def _get_echo_service():
    return _echo_service    
    
@view_config(route_name='home', renderer='home.mak')
def home(request):
    style = request.params.get('style', 'small')
    return {'track_style': style+'_covers'}

@view_config(route_name='bookmarklet', renderer='bookmarklet.mak')
def bookmarklet(request):
    style = request.params.get('style', 'small')
    print 'track_key: ' + request.params['track_key']
    return { 'track_style': style+'_covers',
             'track_key': request.params['track_key'] }

@view_config(route_name='track-search', renderer='json')
def track_search(request):
    q = request.params['query']
    print "Query: " + q
    if q:
        results = _get_music_service().track_search(q, 10)
        print "Result: %d tracks" % len(results)
        return results

@view_config(route_name='similar-tracks', renderer='json')
def similar_tracks(request):
    p = request.params
    print "Similar: " + str(p)

    track_key = 'rdio-us-streaming:song:' + p.get('track_key', None)

    rdio_keys = _get_echo_service().similar_track_keys(track_key, _echo_catalog,
                                          key_space='rdio-us-streaming', limit=10)
    print "Similar Keys: %s" % rdio_keys
    results = _get_music_service().get_tracks(rdio_keys)
    
    print "Result: %s" % len(results)
    return results
