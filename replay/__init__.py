from pyramid.config import Configurator
from . import views

def main(global_config, **settings):
    """ This function returns a Pyramid WSGI application.
    """
    config = Configurator(settings=settings)
    views.setup_music_service(settings['rspot.password'])
    print 'here'
    config.add_static_view('static', 'static', cache_max_age=3600)
    config.add_route('home', '/')
    config.add_route('track-search', '/track-search')
    config.add_route('similar-tracks', '/similar-tracks')
    config.add_route('bookmarklet', '/bookmarklet')
    config.add_route('playlists', '/playlists')
    config.add_route('playlist-tracks', '/playlist-tracks')
    config.add_route('add-to-playlist', '/add-to-playlist')
    config.add_route('oauth', '/oauth')
    config.scan()
    return config.make_wsgi_app()
