noflo = require 'noflo'
mandrill = require 'mandrill-api/mandrill'

class SendTemplate extends noflo.AsyncComponent
  constructor: ->
    @client = null
    @template = null
    @content = null
    @async = false
    @inPorts =
      template: new noflo.Port 'string'
      content: new noflo.Port 'object'
      message: new noflo.Port 'object'
      key: new noflo.Port 'string'
      async: new noflo.Port 'boolean'
    @outPorts =
      status: new noflo.Port 'object'
      error: new noflo.Port 'object'

    @inPorts.key.on 'data', (key) =>
      @client = new mandrill.Mandrill key
    @inPorts.template.on 'data', (@template) =>
    @inPorts.content.on 'data', (@content) =>
    @inPorts.async.on 'data', (@async) =>

    super 'message', 'status'

  doAsync: (message, callback) ->
    return callback new Error 'Missing Mandrill API key' unless @client
    return callback new Error 'Missing email template' unless @template
    return callback new Error 'Missing email contents' unless @content
    @client.messages.sendTemplate
      template_name: @template
      template_content: @content
      message: @message
      async: @async
    , (result) =>
      for status in result
        @outPorts.status.send status
      @outPorts.status.disconnect()
    , (error) =>
      callback error

exports.getComponent = -> new SendTemplate
