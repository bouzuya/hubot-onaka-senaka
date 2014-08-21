{Robot, User, TextMessage} = require 'hubot'
assert = require 'power-assert'
path = require 'path'
sinon = require 'sinon'

describe 'hello', ->
  beforeEach (done) ->
    @sinon = sinon.sandbox.create()
    # for warning: possible EventEmitter memory leak detected.
    # process.on 'uncaughtException'
    @sinon.stub process, 'on', -> null
    @robot = new Robot(path.resolve(__dirname, '..'), 'shell', false, 'hubot')
    @robot.adapter.on 'connected', =>
      @robot.load path.resolve(__dirname, '../../src/scripts')
      done()
    @robot.run()

  afterEach (done) ->
    @robot.brain.on 'close', =>
      @sinon.restore()
      done()
    @robot.shutdown()

  describe 'listeners[0].regex', ->
    beforeEach ->
      @sender = new User 'bouzuya', room: 'hitoridokusho'
      @onaka = @sinon.spy()
      @senaka = @sinon.spy()
      @robot.listeners[0].callback = @onaka
      @robot.listeners[1].callback = @senaka

    describe 'receive "おなか"', ->
      beforeEach ->
        message = 'おなか'
        @robot.adapter.receive new TextMessage(@sender, message)

      it 'matches', ->
        assert @onaka.callCount is 1
        match = @onaka.firstCall.args[0].match
        assert match.length is 1
        assert match[0] is 'おなか'

    describe 'receive "お腹"', ->
      beforeEach ->
        message = 'お腹'
        @robot.adapter.receive new TextMessage(@sender, message)

      it 'matches', ->
        assert @onaka.callCount is 1
        match = @onaka.firstCall.args[0].match
        assert match.length is 1
        assert match[0] is 'お腹'

    describe 'receive "せなか"', ->
      beforeEach ->
        message = 'せなか'
        @robot.adapter.receive new TextMessage(@sender, message)

      it 'matches', ->
        assert @senaka.callCount is 1
        match = @senaka.firstCall.args[0].match
        assert match.length is 1
        assert match[0] is 'せなか'

    describe 'receive "背中"', ->
      beforeEach ->
        message = '背中'
        @robot.adapter.receive new TextMessage(@sender, message)

      it 'matches', ->
        assert @senaka.callCount is 1
        match = @senaka.firstCall.args[0].match
        assert match.length is 1
        assert match[0] is '背中'
