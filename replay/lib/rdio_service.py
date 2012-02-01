import rdioapi

def setup(consumer_key, consumer_secret):
    return RdioService(consumer_key, consumer_secret)
    
class RdioService(object):
    def __init__(self, consumer_key, consumer_secret):
        self.rdio_websvc = rdioapi.Rdio(consumer_key, consumer_secret, {})

    def track_search(self, query, limit):
        results = self.rdio_websvc.call('search', query=query, types='Track', count=limit)
        return [self._build_track(r) for r in results['results']]
    
    def get_tracks(self, track_keys):
        results = self.rdio_websvc.call('get', keys=','.join(track_keys))
        return [self._build_track(r) for r in results.values()]
        
    @staticmethod
    def _build_track(rdio_track):
        rt = rdio_track
        return { 'artist': rt['artist'],
                 'album_title': rt['album'],
                 'track_title': rt['name'],
                 'cover_url': rt['icon'],
                 'track_number': rt['trackNum'],
                 'album_key': rt['albumKey'],
                 'artist_key': rt['artistKey'],
                 'track_key': rt['key'],
                 'duration': rt['duration']}