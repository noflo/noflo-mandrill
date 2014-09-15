noflo = require 'noflo'
mandrill = require 'mandrill-api/mandrill'

exports.getComponent = ->
  component = new noflo.Component

  component.inPorts.add 'message',
    datatype: 'object'
  component.inPorts.add 'key',
    datatype: 'string'
    process: (event, payload) ->
      component.client = new mandrill.Mandrill payload if event is 'data'
  component.inPorts.add 'async',
    datatype: 'boolean'
  component.inPorts.add 'retries',
    datatype: 'int'
  component.outPorts.add 'status',
    datatype: 'object'
  component.outPorts.add 'error',
    datatype: 'object'
  component.client = null

  noflo.helpers.WirePattern component,
    in: 'message'
    params: ['async', 'retries']
    out: 'status'
    async: true
    forwardGroups: true
  , (message, groups, out, done) ->
    return done new Error 'Missing Mandrill API key' unless component.client
    async = if component.params.async then true else false
    attempts = 0
    retries = Number component.params.retries
    send = ->
      attempts++
      fail = (error) ->
        if retries and attempts <= retries
          setTimeout ->
            send()
          , 1000
        else
          done error
      component.client.messages.send
        message: message
        async: async
      , (result) ->
        if result.length > 0
          out.send status for status in result
          done()
        else
          fail new Error 'Mandrill returned empty result'
      , (error) ->
        fail error
    send()

  component
