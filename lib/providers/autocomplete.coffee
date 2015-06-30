

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
      '\\Illuminate\\Contracts\\Container\\Container',
    ]

    classNames = [
      '\\Illuminate\\Foundation\\Application',
      '\\Illuminate\\Contracts\\Foundation\\Application',
      '\\Illuminate\\Contracts\\Container\\Container',
    ]

    getSuggestions: ({editor, bufferPosition, scopeDescriptor, prefix}) =>
      console.log(bufferPosition,scopeDescriptor.getScopeChain(),prefix)
      previousScopeDescriptor = @getPreviousScopeDescriptor(editor,bufferPosition,prefix)
      console.log(previousScopeDescriptor.getScopeChain())
      new Promise (resolve) =>
        suggestions = []

        if scopeDescriptor.getScopesArray().indexOf('meta.namespace.php') != -1
          for namespace in namespaces
            if namespace.search(prefix)
              suggestions.push
                text: namespace
                snippet: namespace.replace /\\/g,"\\\\"
                type: 'namespace'

        if previousScopeDescriptor && previousScopeDescriptor.getScopesArray().indexOf('keyword.other.new.php') != -1
          classes = @getClasses()
          console.log(classes)
          for className in classes
            if className.search(prefix)
              suggestions.push
                text: className
                snippet: className.replace /\\/g,"\\\\"
                type: 'class'

        console.log(suggestions)
        resolve(suggestions)


    preloading: ->
      console.log 'preload phpstorm meta autocomplete stuff'


    getPreviousScopeDescriptor: (editor, bufferPosition, prefix) ->
      console.log(bufferPosition, prefix, prefix.length)
      if(bufferPosition)
        bufferPositionArray = bufferPosition.toArray()
        targetBufferPosition = [
          bufferPositionArray[0],
          bufferPositionArray[1] - prefix.length - 2
         ]
        #console.log(targetBufferPosition)
        return editor.scopeDescriptorForBufferPosition(targetBufferPosition)


    getClasses: ->
      return classNames

    # (optional): called _after_ the suggestion `replacementPrefix` is replaced
    # by the suggestion `text` in the buffer
  #  onDidInsertSuggestion: ({editor, triggerPosition, suggestion}) ->

    # (optional): called when your provider needs to be cleaned up. Unsubscribe
    # from things, kill any processes, etc.
  #  dispose: ->
