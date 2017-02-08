noflo = require 'noflo'
mandrill = require 'mandrill-api/mandrill'

exports.getComponent = ->
  c = new noflo.Component
    inPorts:
      message:
        datatype: 'object'
      key:
        datatype: 'string'
        control: true
      async:
        datatype: 'boolean'
        control: true
        default: false
      retries:
        datatype: 'int'
        control: true
        default: 0
    outPorts:
      status:
        datatype: 'object'
      error:
        datatype: 'object'

  c.process (input, output) ->
    return unless input.has 'message', 'key'

    async = input.getData 'async'
    retries = Number input.getData 'retries'
    key = input.getData 'key'
    client = new mandrill.Mandrill key

    attempts = 0
    send = ->
      attempts++
      fail = (error) ->
        if retries and attempts <= retries
          setTimeout send, 1000
        else
          output.done error

      client.messages.send
        message: message
        async: async
      , (result) ->
        if result.length > 0
          output.send status: status for status in result
          output.done()
        else
          fail new Error 'Mandrill returned empty result'
      , (error) ->
        fail error
    send()
