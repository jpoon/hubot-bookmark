Helper = require('hubot-test-helper')
helper = new Helper('../src/bookmark.coffee')

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
    successMsg = "Sweet photons. I don't know if that bookmark was a wave or particle, but it went down smooth."
    failureMsg = "Bite my shiny metal daffodil. I need a URL and that ain't one."

    tests = [
      { url: 'http://www.google.com', success: true },
      { url: 'https://www.google.com', success: true },
      { url: 'http://google.com', success: true },
      { url: 'https://google.com', success: true },
      { url: 'www.google.com', success: true },
      { url: 'google.com', success: true },
      { url: 'http://google', success: true },
      { url: 'https://www.google.com/calendar/embed?src=jg1einhar1lo89av9utlfe0cig@group.calendar.google.com&ctz=America/New_York', success: true },
      { url: 'https://google', success: true },
      { url: 'google.com/test/?foo=bar&foo1=bar1', success: true },
      { url: 'google', success: false },
    ]

    tests.forEach (test) ->
      it test.url, ->
        @room.user.say('alice', '@hubot bookmark add ' + test.url + ' as ' + test.url).then =>
          if test.success
            expect(@lastMessage()).to.contain(successMsg)
          else
            expect(@lastMessage()).to.contain(failureMsg)

    it 'duplicate', ->
      url = 'www.test-url-.com'
      @room.user.say('user', 'hubot bookmark add ' + url + ' as ' + url).then =>
        @room.user.say('user', 'hubot bookmark add ' + url + ' as ' + url).then =>
          expect(@lastMessage()).to.contain('I have a vague memory of that same bookmark link.')

    it 'case insensitive', ->
      @room.user.say('user', 'hubot bookmark add CASEINSENSITIVE.com as test').then =>
        @room.user.say('user', 'hubot bookmark add caseinsensitive.com as test1').then =>
          expect(@lastMessage()).to.contain('I have a vague memory of that same bookmark link.')

  describe 'find', ->
    it 'no results', ->
      @room.user.say('user', 'hubot bookmark find search-term').then =>
        expect(@lastMessage()).to.contain('0 link(s)')

    it 'result', ->
      @room.user.say('user', 'hubot bookmark add test-url-1.com as test-description-1').then =>
        @room.user.say('user', 'hubot bookmark add test-url-2.com as test-description-2').then =>
          @room.user.say('user', 'hubot bookmark find description').then =>
            expect(@lastMessage()).to.contain('2 link(s)')
            expect(@lastMessage()).to.contain('test-url-1')
            expect(@lastMessage()).to.contain('test-url-2')

  describe 'find', ->
    it 'no results', ->
      @room.user.say('user', 'hubot bookmark find search-term').then =>
        expect(@lastMessage()).to.contain('0 link(s)')

  describe 'list', ->
    it 'empty', ->
      @room.user.say('user', 'hubot bookmark list').then =>
        expect(@lastMessage()).to.contain('Please insert liquor. My robot brain is empty.')

    it '1 item', ->
      url = 'test-url.com'
      description = 'test-description'
      @room.user.say('user', 'hubot bookmark add ' + url + ' as ' + description).then =>
        @room.user.say('user', 'hubot bookmark list').then =>
          expect(@lastMessage()).to.contain(url)
          expect(@lastMessage()).to.contain(description)

  describe 'delete', ->
    it 'unknown url', ->
      @room.user.say('user', 'hubot bookmark delete www.test-url.com').then =>
        expect(@lastMessage()).to.contain("I have no memory of that bookmark in my robot brain.")

    it 'basic delete', ->
      url = 'test-url.com'
      description = 'test-description'
      @room.user.say('user', 'hubot bookmark add ' + url + ' as ' + description).then =>
        @room.user.say('user', 'hubot bookmark delete ' + url).then =>
          expect(@lastMessage()).to.contain("It has been forgotten.")
          @room.user.say('user', 'hubot bookmark list').then =>
            expect(@lastMessage()).to.contain('Please insert liquor. My robot brain is empty.')

    it 'exact url match', ->
      @room.user.say('user', 'hubot bookmark add test.com as test-description-1').then =>
        @room.user.say('user', 'hubot bookmark delete test').then =>
          expect(@lastMessage()).to.contain("I have no memory of that bookmark in my robot brain.")

    it 'case insensitive', ->
      @room.user.say('user', 'hubot bookmark add TeSt123.cOm as test-description-1').then =>
        @room.user.say('user', 'hubot bookmark delete test123.COM').then =>
          expect(@lastMessage()).to.contain("It has been forgotten.")
