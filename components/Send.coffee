noflo = require 'noflo'
mandrill = require 'mandrill-api/mandrill'

class Send extends noflo.AsyncComponent
  constructor: ->
    @client = null
    @async = false
    @inPorts =
      message: new noflo.Port 'object'
      key: new noflo.Port 'string'
      async: new noflo.Port 'boolean'
    @outPorts =
      status: new noflo.Port 'object'
      error: new noflo.Port 'object'

    @inPorts.key.on 'data', (key) =>
      @client = new mandrill.Mandrill key
    @inPorts.async.on 'data', (@async) =>

    super 'message', 'status'

  doAsync: (message, callback) ->
    return callback new Error 'Missing Mandrill API key' unless @client
    @client.messages.send
      message: message
      async: @async
    , (result) =>
      for status in result
        @outPorts.status.send status
      @outPorts.status.disconnect()
    , (error) =>
      callback error

exports.getComponent = -> new Send
