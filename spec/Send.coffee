noflo = require 'noflo'
chai = require 'chai' unless chai
Send = require '../components/SendTemplate.coffee'

describe 'Send component', ->
  c = null
  message = null
  key = null
  status = null
  beforeEach ->
    c = Send.getComponent()
    message = noflo.internalSocket.createSocket()
    key = noflo.internalSocket.createSocket()
    status = noflo.internalSocket.createSocket()
    c.inPorts.message.attach message
    c.inPorts.key.attach key
    c.outPorts.status.attach status

  describe 'when instantiated', ->
    it 'should have an key port', ->
      chai.expect(c.inPorts.key).to.be.an 'object'
    it 'should have an status port', ->
      chai.expect(c.outPorts.status).to.be.an 'object'

