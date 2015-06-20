Helper = require('hubot-test-helper')
helper = new Helper('../src')

_ = require 'lodash'
chai = require 'chai'
expect = chai.expect

describe 'bookmark', ->

  beforeEach ->
    @room = helper.createRoom()
    @lastMessage = -> _.last(@room.messages)[1]

  afterEach ->
    @room.destroy()

  describe 'add', ->
    successMsg = "I\'ve stuck that bookmark into my robot brain."
    failureMsg = "Is that even a URL?"

    tests = [
      { url: 'http://www.google.com', success: true },
      { url: 'https://www.google.com', success: true },
      { url: 'http://google.com', success: true },
      { url: 'https://google.com', success: true },
      { url: 'www.google.com', success: true },
      { url: 'google.com', success: true },
      { url: 'http://google', success: true },
      { url: 'https://google', success: true },
      { url: 'google.com/test/?foo=bar&foo1=bar1', success: true },
      { url: 'google', success: false },
    ];

    tests.forEach (test) ->
      it test.url, ->
        @room.user.say 'user', 'hubot bookmark add ' + test.url + ' as ' + test.url

        if test.success
          expect(@lastMessage()).to.contain(successMsg)
        else
          expect(@lastMessage()).to.contain(failureMsg)


    it 'duplicate', ->
      url = 'www.test-url-.com'
      @room.user.say 'user', 'hubot bookmark add ' + url + ' as ' + url
      @room.user.say 'user', 'hubot bookmark add ' + url + ' as ' + url
      expect(@lastMessage()).to.contain('I have a vague memory of that same bookmark link.')

  describe 'find', ->
    it 'no results', ->
      @room.user.say 'user', 'hubot bookmark find search-term'
      expect(@lastMessage()).to.contain('0 link(s)')

    it 'result', ->
      @room.user.say 'user', 'hubot bookmark add test-url-1.com as test-description-1'
      @room.user.say 'user', 'hubot bookmark add test-url-2.com as test-description-2'
      @room.user.say 'user', 'hubot bookmark find description'
      expect(@lastMessage()).to.contain('2 link(s)')
      expect(@lastMessage()).to.contain('test-url-1')
      expect(@lastMessage()).to.contain('test-url-2')

  describe 'find', ->
    it 'no results', ->
      @room.user.say 'user', 'hubot bookmark find search-term'
      expect(@lastMessage()).to.contain('0 link(s)')

    it '1 result', ->

  describe 'list', ->
    it 'empty', ->
      @room.user.say 'user', 'hubot bookmark list'
      expect(@lastMessage()).to.contain('Bookmarks? What bookmarks? I don\'t remember any bookmarks.')

    it '1 item', ->
      url = 'test-url.com'
      description = 'test-description'
      @room.user.say 'user', 'hubot bookmark add ' + url + ' as ' + description
      @room.user.say 'user', 'hubot bookmark list'
      expect(@lastMessage()).to.contain(url)

  describe 'list', ->
    it 'empty', ->
      @room.user.say 'user', 'hubot bookmark list'
      expect(@lastMessage()).to.contain('Bookmarks? What bookmarks? I don\'t remember any bookmarks.')

    it '1 item', ->
      url = 'test-url.com'
      description = 'test-description'
      @room.user.say 'user', 'hubot bookmark add ' + url + ' as ' + description
      @room.user.say 'user', 'hubot bookmark list'
      expect(@lastMessage()).to.contain(url)
      expect(@lastMessage()).to.contain(description)
