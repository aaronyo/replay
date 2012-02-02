<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" xmlns:tal="http://xml.zope.org/namespaces/tal">
<head>
  <title>Replay</title>
  <meta http-equiv="no-cache">
  <meta http-equiv="Expires" content="-1">
  <meta http-equiv="Cache-Control" content="no-cache">
  <script type="text/javascript"
          src="https://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.js" ></script>
  <script type="text/javascript"
          src="https://ajax.googleapis.com/ajax/libs/jqueryui/1.8.16/jquery-ui.js" ></script>
  <script type="text/javascript" src="/static/js/replay.js" ></script>
  <script type="text/javascript" src="/static/js/track.js" ></script>
  <script type="text/javascript" src="/static/js/3p/jquery.rdio.js" ></script>
  <link type="text/css" href="/static/css/replay.css" rel="stylesheet"/>
  <link type="text/css" href="/static/css/player.css" rel="stylesheet"/>
  <link type="text/css" href="/static/css/${track_style}.css" rel="stylesheet"/>
</head>
<body>
  <div id="top_tools">
    <div id="track_search">
      <input type="text" id="track_search_field" value="Dire Straits Money for Nothing" />
      <button id="track_search_btn">Search</button>
    </div>
    <div id="player">
      <div id="time_elapsed">0:00</div>
      <div id="position_containter">
        <div id="position_bar"><div id="tick">&nbsp;</div></div>
        <div id="track_title"></div>
      </div>
      <div id="time_remaining">0:00</div>
    </div>
  </div>
  <div id="browse_list"></div>
  <div id="playlist_container">
    <div id="playlist_select_container">
      Playlists:
      <select id="playlist_select"></select>
      <button id="add_playlist_button">+</button>
    </div>
    <div id="playlist"></div>
  </div>
  <div id="rdio_player"></div>
  <input type='hidden' id='context' value='home'/>
</body>
</html>