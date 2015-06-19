Helper = require('hubot-test-helper')
helper = new Helper('../src')

_ = require 'lodash'
chai = require 'chai'
expect = chai.expect


describe 'bookmark', ->
  successMsg =  "I\'ve stuck that bookmark into my robot brain."

  beforeEach ->
    @room = helper.createRoom()
    @lastMessage = -> _.last(@room.messages)[1]

  afterEach ->
    @room.destroy()

  describe 'add', ->
    tests = [
      {name: 'http + www', url: 'http://www.google.com', expected: true},
      {name: 'https + www', url: 'https://www.google.com', expected: true},
      {name: 'http', url: 'http://google.com', expected: true},
      {name: 'https', url: 'https://google.com', expected: true},
    ];

    for test in tests
      it test.name, ->
        @room.user.say 'user', 'hubot bookmark add ' + test.url + ' as ' + test.name
        expect(@lastMessage()).to.contain(successMsg)


