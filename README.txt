replay README

Tech Debt
* rdio login check w/ redirect on any request
* error handling on basically all web service calls
  * e.g., if a playlist is not found
* design API more sensibly (e.g. RESTful)
  * organize code accordingly (not just "views.py")
* figure out how to autodiscover web service methods and ditch those annoying view_config
  decorators and __init__.py editing