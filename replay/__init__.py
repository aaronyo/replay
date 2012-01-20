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
    config.scan()
    return config.make_wsgi_app()
