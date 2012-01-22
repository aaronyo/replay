import ConfigParser
import pkg_resources
import pyechonest.config
import pyechonest.song
import pyechonest.playlist


def setup( api_key=None,
           base_url='http://developer.echonest.com/api/v4/' ):
    pyechonest.config.ECHO_NEST_API_KEY = api_key
    return EchoService()
    
class EchoService(object):
    def __init__(self):
        pass
        
    def lookup(self, artist, track_title, key_space=None):
        if key_space:
            key_space_args={'buckets': ['id:'+key_space],
                            'limit':True}
        else:
            key_space_args = {}
        result = pyechonest.song.search(artist=artist, title=track_title, results=1, **key_space_args)
        if not result:
            return None, None
        else:
            song = result[0]
        return song.id, self._id_value(song.get_foreign_id(key_space)) if key_space else None

    def similar_track_keys(self, echo_key, seed_catalog, key_space, limit):
        key_space_args={'buckets': ['id:'+key_space],
                        'limit':True}
                        
        #Grab extras -- it's possible we'll get a different version of the same song, and
        #in the next step, this could get mapped to the _exact_ same track
        songs = pyechonest.playlist.static( song_id=echo_key, seed_catalog=seed_catalog,
                                          type='catalog', results=limit+5, **key_space_args)
                                           
        keys = []
        for s in songs:
            if s.cache['foreign_ids']:
                key = self._id_value( s.get_foreign_id(key_space) )
            else:
                _, key = self.lookup(s.artist_name, s.title, key_space=key_space)
            if key != self._id_value(echo_key):
                keys.append(key)
        
        return keys[:limit]

    @staticmethod
    def _id_value(foreign_id):
        return foreign_id.split(':')[-1]
    