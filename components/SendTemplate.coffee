noflo = require 'noflo'
mandrill = require 'mandrill-api/mandrill'

exports.getComponent = ->
  c = new noflo.Component
    inPorts:
      template:
        datatype: 'string'
        control: true
      content:
        datatype: 'object'
        control: true
      message:
        datatype: 'object'
        control: true
      key:
        datatype: 'string'
        control: true
      retries:
        datatype: 'int'
        control: true
        default: 0
      async:
        datatype: 'boolean'
        control: true
        default: false
    outPorts:
      async:
        datatype: 'boolean'
      retries:
        datatype: 'int'
      status:
        datatype: 'object'
      error:
        datatype: 'object'

  c.process (input, output) ->
    return unless input.has 'message', 'content', 'key'

    async = input.getData 'retries'
    retries = Number input.getData 'retries'
    key = input.getData 'key'
    client = new mandrill.Mandrill key
    template = input.getData 'template'

    send = ->
      attempts++
      fail = (error) ->
        if retries and attempts <= retries
          setTimeout send, 1000
        else
          output.done error
      client.messages.sendTemplate
        template_name: template
        template_content: content
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
