'use strict'

exports.handler = function (event, context, callback) {
  var response = {
    statusCode: 200,
    headers: {
      'Content-Type': 'text/html; charset=utf-8',
    },
    body: '<h1>Hello world!</h1><h2>This is a function</h2><h3>Not an HTML page hosted from a server</h3><p><i>Strange huh?</i></p>',
  }
  callback(null, response)
}
