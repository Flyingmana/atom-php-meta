
module.exports =
  class PhpMethodDefinition
    constructor: (@name, @arguments, @file, @line) ->

    getName: ->
      return @name;

    getArguments: ->
      return @arguments;

    getFile: ->
      return @file;

    getLine: ->
      return @line;
