noflo = require 'noflo'
Send = require '../components/SendTemplate.coffee'

unless noflo.isBrowser()
  chai = require 'chai'
  path = require 'path'
  baseDir = path.resolve __dirname, '../'
else
  baseDir = 'noflo-mandril'

describe 'SendTemplate component', ->
  c = null
  template = null
  content = null
  message = null
  key = null
  status = null

  before (done) ->
    c = Send.getComponent()
    template = noflo.internalSocket.createSocket()
    content = noflo.internalSocket.createSocket()
    message = noflo.internalSocket.createSocket()
    key = noflo.internalSocket.createSocket()
    c.inPorts.template.attach template
    c.inPorts.content.attach content
    c.inPorts.message.attach message
    c.inPorts.key.attach key
    done()
    return

    loader = new noflo.ComponentLoader baseDir
    loader.load 'mandril/SendTemplate', (err, instance) ->
      return done err if err
      c = instance
      template = noflo.internalSocket.createSocket()
      content = noflo.internalSocket.createSocket()
      message = noflo.internalSocket.createSocket()
      key = noflo.internalSocket.createSocket()
      c.inPorts.template.attach template
      c.inPorts.content.attach content
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
