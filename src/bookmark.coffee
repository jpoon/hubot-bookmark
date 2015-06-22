# Description:
#   Manage your bookmark. Bookmarks get stored in the robot brain.
#
# Commands:
#   hubot bookmark add <url> as <description> - add a url to the robot brain
#   hubot bookmark find <description> - find a link by description
#   hubot bookmark list - list all of the links that are being tracked
#   hubot bookmark delete <url> - delete url from robot brain
#
# Authors:
#   Jason Poon <github@jasonpoon.ca>

module.exports = (robot) ->

  # bookmark <url> as <description>
  robot.respond /bookmark add (.+) as (.+)/i, (msg) ->
    url = msg.match[1]
    description = msg.match[2]

    internetUrlPattern = /// ^               # begin of line
      (http(s)?://)?                         # optional http/https
      ([\w-]+\.)+[\w-]+(/[\w-;,./?{}%&=@]*)? # domain name with at least two
                                             # components, allow trailing dot
      $ ///i                                 # end of line and ignore case

    intranetUrlPattern = /// ^               # begin of line
      http(s)?://                            # http/https
      [\w-]+(/[\w-;,./?{}%&=]*)?             # domain name
      $ ///i                                 # end of line and ignore case

    if (url.match intranetUrlPattern) or (url.match internetUrlPattern)
      link = new Link url, description

      bookmark = new Bookmark robot
      bookmark.add link, (err, message) ->
        if err?
          msg.reply "I have a vague memory of that same bookmark link."
        else
          msg.reply "Sweet photons. I don't know if that bookmark was a wave or particle, but it went down smooth."
    else
      msg.reply "Bite my shiny metal daffodil. I need a URL and that ain't one."

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
        message = "It's just like making love! Y'know...left, down...rotate 62 degrees...engage rotor..."
        for link in links
          if link
            message += link.description + " (" + link.url + ")\n"
        msg.reply message
      else
        msg.reply "Please insert liquor. My robot brain is empty."

  # bookmark delete <url>
  robot.respond /bookmark delete (.+)/i, (msg) ->
    url = msg.match[1]

    bookmark = new Bookmark robot
    bookmark.delete url, (deleted) ->
      if deleted
        msg.reply "It has been forgotten."
      else
        msg.reply "I have no memory of that bookmark in my robot brain."


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
        if entry.url.toUpperCase() is link.url.toUpperCase()
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

  delete: (url, callback) ->
    result = []
    @all().forEach (link, i) =>
      if link && link.url
        if link.url.toUpperCase() is url.toUpperCase()
          @all().splice(i, 1)
          result.push i

    if result.length > 0
      callback true
    else
      callback false
