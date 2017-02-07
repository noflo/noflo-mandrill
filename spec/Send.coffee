noflo = require 'noflo'
Send = require '../components/Send.coffee'

unless noflo.isBrowser()
  chai = require 'chai'
  path = require 'path'
  baseDir = path.resolve __dirname, '../'
else
  baseDir = 'noflo-mandril'

describe 'Send component', ->
  c = null
  message = null
  key = null
  status = null

  before (done) ->
    c = Send.getComponent()
    message = noflo.internalSocket.createSocket()
    key = noflo.internalSocket.createSocket()
    c.inPorts.message.attach message
    c.inPorts.key.attach key
    done()
    return

    loader = new noflo.ComponentLoader baseDir
    loader.load 'noflo-mandril/Send', (err, instance) ->
      return done err if err
      c = instance
      message = noflo.internalSocket.createSocket()
      key = noflo.internalSocket.createSocket()
      c.inPorts.message.attach message
      c.inPorts.key.attach key
      done()

  beforeEach ->
    status = noflo.internalSocket.createSocket()
    c.outPorts.status.attach status
  afterEach ->
    c.outPorts.status.detach status

  describe 'when instantiated', ->
    it 'should have an key port', ->
      chai.expect(c.inPorts.key).to.be.an 'object'
    it 'should have an status port', ->
      chai.expect(c.outPorts.status).to.be.an 'object'

