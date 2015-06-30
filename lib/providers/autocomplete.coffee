

module.exports =
  class AutocompleteProvider
    #functionOnly: true
    inclusionPriority: 2

    # This will work on JavaScript and CoffeeScript files, but not in js comments.
    selector: '.source.php'
    disableForSelector: '.comment'

    namespaces = [
      '\\Illuminate\\Foundation\\Application',
      '\\Illuminate\\Contracts\\Foundation\\Application',
      '\\Illuminate\\Contracts\\Container\\Container'
    ]

    getSuggestions: ({editor, bufferPosition, scopeDescriptor, prefix}) ->
      console.log(bufferPosition,scopeDescriptor.getScopeChain(),prefix)
      new Promise (resolve) ->
        suggestions = []

        if scopeDescriptor.getScopesArray().indexOf('meta.namespace.php') != -1
          for namespace in namespaces
            if namespace.search(prefix)
              suggestions.push
                text: namespace
                snippet: namespace.replace /\\/g,"\\\\"
                type: 'namespace'
        console.log(suggestions)
        resolve(suggestions)


    preloading: ->
      console.log 'preload phpstorm meta autocomplete stuff'


    # (optional): called _after_ the suggestion `replacementPrefix` is replaced
    # by the suggestion `text` in the buffer
  #  onDidInsertSuggestion: ({editor, triggerPosition, suggestion}) ->

    # (optional): called when your provider needs to be cleaned up. Unsubscribe
    # from things, kill any processes, etc.
  #  dispose: ->
