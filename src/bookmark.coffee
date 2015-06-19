# Description:
#   Manage your bookmark. Bookmarks get stored in the robot brain.
#
# Commands:
#   hubot bookmark add <url> as <description> - add a url to the robot brain
#   hubot bookmark find <description> - find a link by description
#   hubot bookmark list - List all of the links that are being tracked
#
# Authors:
#   Jason Poon <github@jasonpoon.ca>

module.exports = (robot) ->

  # bookmark <url> as <description>
  robot.respond /bookmark add (.+) as (.+)/i, (msg) ->
    url = msg.match[1]
    description = msg.match[2]

    urlPattern = /// ^                        # begin of line
       (http(s)?://)?                       # optional http/https
       ([\w-]+\.)+[\w-]+(/[\w-;,./?{}%&=]*)?  # domain name with at least two components, allow trailing dot
       $ ///i                                 # end of line and ignore case

    match = url.match urlPattern
    if !url.match urlPattern
      msg.reply "Is that even a URL?"
    else
      link = new Link url, description
      bookmark = new Bookmark robot

      bookmark.add link, (err, message) ->
        if err?
          msg.reply "I have a vague memory of hearing about that bookmark link sometime in the past."
        else
          msg.reply "I've stuck that bookmark into my robot brain."

  # bookmark find <description>
  robot.respond /bookmark find (.+)/i, (msg) ->
    description = msg.match[1]
    bookmark = new Bookmark robot

    bookmark.find description, (links) ->
        message = "Found " + links.length + " link(s)"
        if links.length > 0
            message += ":\n\n"
        for link in links
            message += link.description + " (" + link.url + ")\n"
        msg.reply message

  # bookmark list
  robot.respond /bookmark list/i, (msg) ->
    bookmark = new Bookmark robot

    bookmark.list (links) ->
      if links.length > 0
        message = "These are the links I'm remembering:\n\n"
        for link in links
          if link
            message += link.description + " (" + link.url + ")\n"
        msg.reply message
      else
        msg.reply "Bookmarks? What bookmarks? I don't remember any bookmarks."

# Classes
class Link
  constructor: (url, description) ->
    @url = url
    @description = description

class Bookmark
  constructor: (@robot) ->
    @robot.brain.data.links ?= []

  all: ->
    @robot.brain.data.links

  add: (link, callback) ->
    result = []
    @all().forEach (entry) ->
      if entry
        if entry.url is link.url
          result.push link
    if result.length > 0
      callback "Link already exists"
    else
      @robot.brain.data.links.push link
      callback null, "Link added"

  list: (callback) ->
    callback @all()

  find: (description, callback) ->
    result = []
    @all().forEach (link) ->
      if link && link.description
        if RegExp(description, "i").test link.description
          result.push link
    callback result
