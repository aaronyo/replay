import rdioapi

def setup(consumer_key, consumer_secret):
    return RdioService(consumer_key, consumer_secret)
    
class RdioService(object):
    def __init__(self, consumer_key, consumer_secret):
        self.rdio_websvc = rdioapi.Rdio(consumer_key, consumer_secret, {})
        
    def authenticated(self):
        return self.rdio_websvc.authenticated
        
    def begin_authentication(self, callback_url):
        return self.rdio_websvc.begin_authentication(callback_url)

    def complete_authentication(self, oauth_verifier):
        return self.rdio_websvc.complete_authentication(oauth_verifier)

    def track_search(self, query, limit):
        results = self.rdio_websvc.call('search', query=query, types='Track', count=limit)
        return [self._build_track(r) for r in results['results']]
    
    def get_tracks(self, track_keys):
        results = self.rdio_websvc.call('get', keys=','.join(track_keys))
        return [self._build_track(r) for r in results.values()]
        
    def get_playlist_tracks(self, playlist_key):
        results = self.rdio_websvc.call('get',
                                        keys=playlist_key,
                                        extras='trackKeys')
        track_keys = results[playlist_key]['trackKeys']
        return self.get_tracks(track_keys)

    def get_playlists(self):
        playlists = self.rdio_websvc.call('getPlaylists')
        if playlists:
            # Replay only works with playlists that you own -- not with
            # collaborations or subscriptions
            return playlists['owned']
        
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
                 'duration': rt['duration'] }