noflo = require 'noflo'
Send = require '../components/Send.coffee'

unless noflo.isBrowser()
  chai = require 'chai'
  path = require 'path'
  baseDir = path.resolve __dirname, '../'
else
  baseDir = 'noflo-mandrill'

describe 'Send component', ->
  c = null
  message = null
  key = null
  status = null

  before (done) ->
    loader = new noflo.ComponentLoader baseDir
    loader.load 'mandrill/Send', (err, instance) ->
      return done err if err
      c = instance
      message = noflo.internalSocket.createSocket()
      key = noflo.internalSocket.createSocket()
      c.inPorts.message.attach message
      c.inPorts.key.attach key
      done()

  beforeEach (done) ->
    status = noflo.internalSocket.createSocket()
    c.outPorts.status.attach status
    done()
  afterEach (done) ->
    c.outPorts.status.detach status
    done()

  describe 'when instantiated', ->
    it 'should have an key port', (done) ->
      chai.expect(c.inPorts.key).to.be.an 'object'
      done()
    it 'should have an status port', (done) ->
      chai.expect(c.outPorts.status).to.be.an 'object'
      done()
