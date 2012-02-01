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
  <script type="text/javascript" src="/static/js/main.js" ></script>
  <script type="text/javascript" src="/static/js/track.js" ></script>
  <link type="text/css" href="/static/css/main.css" rel="stylesheet"/>
  <link type="text/css" href="/static/css/${track_style}.css" rel="stylesheet"/>
  <link type="text/css" href="/static/css/play_list.css" rel="stylesheet"/>
</head>
<body>
  <div id="browse_list"></div>
  <div id="play_list"></div>
  <div id="rdio_player"></div>
  <input type='hidden' id='context' value='bookmarklet'/>
  <input type='hidden' id='track_key' value='${track_key}'/>
</body>
</html>