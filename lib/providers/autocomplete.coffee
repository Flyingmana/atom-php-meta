

module.exports =
  class AutocompleteProvider
    #functionOnly: true
    inclusionPriority: 2

    # This will work on JavaScript and CoffeeScript files, but not in js comments.
    selector: '.source.php'
    disableForSelector: '.comment'

    namespaces = [
      '\\Illuminate\\Foundation',
      '\\Illuminate\\Contracts\\Foundation',
      '\\Illuminate\\Contracts\\Container',
    ]

    classNames = [
      '\\Illuminate\\Foundation\\Application',
      '\\Illuminate\\Contracts\\Foundation\\Application',
      '\\Illuminate\\Contracts\\Container\\Container',
    ]

    methodsStatic = {
      '\\Illuminate\\Foundation\\Application': ['make'],
      '\\Illuminate\\Contracts\\Foundation\\Application': ['make'],
      '\\Illuminate\\Contracts\\Container\\Container': ['make'],
      '\\Illuminate\\Container\\Container': ['make'],
      '\\App': ['make'],
    }

    factoryMethods = {
      '\\Illuminate\\Foundation\\Application': {
        'make': [
          {'argument': 'events',  'class': '\\Illuminate\\Events\\Dispatcher'},
          {'argument': 'router',  'class': '\\Illuminate\\Routing\\Router'},
          {'argument': 'url',     'class': '\\Illuminate\\Routing\\UrlGenerator'},
        ]
        },
    }

    getSuggestions: ({editor, bufferPosition, scopeDescriptor, prefix}) =>
      console.log(bufferPosition,scopeDescriptor.getScopeChain(),prefix)
      previousScopeDescriptor = @getPreviousScopeDescriptor(editor,bufferPosition,prefix)
      console.log(previousScopeDescriptor.getScopeChain())
      new Promise (resolve) =>
        suggestions = []

        if previousScopeDescriptor.getScopesArray().indexOf('meta.function-call.static.php')
            className = @getClassNameBeforePosition(editor, bufferPosition, prefix)
            methodName = @getMethodNameBeforePosition(editor, bufferPosition, prefix)
            for argumentObject in @getFactoryArgumentsForMethod({className, methodName})
              if prefix == '(' or
                argumentObject.argument.search(@escapeRegex(prefix)) != -1 or
                argumentObject.class.search(@escapeRegex(prefix)) != -1
                  suggestions.push
                    displayText: argumentObject.argument+'('+argumentObject.class+')'
                    snippet: "'"+argumentObject.argument+"'"
                    type: 'namespace'
            resolve(suggestions)

        if scopeDescriptor.getScopesArray().indexOf('meta.namespace.php') != -1 or
          scopeDescriptor.getScopesArray().indexOf('meta.use.php') != -1
            for namespace in namespaces
              if namespace.search(@escapeRegex(prefix))
                suggestions.push
                  text: namespace
                  snippet: namespace.replace /\\/g,"\\\\"
                  type: 'namespace'

        #if previousScopeDescriptor && previousScopeDescriptor.getScopesArray().indexOf('keyword.other.new.php') != -1
        if true
          classes = @getClasses()
          console.log(classes)
          for className in classes
            if className.search(@escapeRegex(prefix))
              suggestions.push
                text: className
                snippet: className.replace /\\/g,"\\\\"
                type: 'class'

        if scopeDescriptor.getScopesArray().indexOf('keyword.operator.class.php') != -1 or
          scopeDescriptor.getScopesArray().indexOf('constant.other.class.php') != -1
              className = @getClassNameBeforePosition(editor, bufferPosition, prefix)
              methods = @getStaticMethodsOfClass(className)
              console.log(className,methods)
              for methodName in methods
                  suggestions.push
                    text: methodName
                    snippet: methodName+'($1)'
                    type: 'method'

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

    getClassNameBeforePosition: (editor, bufferPosition, prefix) ->
      line = editor.lineTextForBufferRow(bufferPosition.row)
      line = line.substring(0, bufferPosition.column)
      #protect from overkill parsing
      if line.length > 300
        return ''
      prefix = @escapeRegex(prefix)
      classes = line.match(new RegExp('(\\\\[a-z]+)+(?=(::)?)','ig'))
      console.log(line,classes,prefix);
      if classes && classes.length
        return classes.pop();
      else
        return ''

    getMethodNameBeforePosition: (editor, bufferPosition, prefix) ->
      line = editor.lineTextForBufferRow(bufferPosition.row)
      line = line.substring(0, bufferPosition.column)
      #protect from overkill parsing
      if line.length > 300
        return ''
      prefix = @escapeRegex(prefix)
      classes = line.match(new RegExp('([a-z0-9]+)+(?=\\()','ig'))
      console.log(line,classes,prefix);
      if classes && classes.length
        return classes.pop()
      else
        return ''


    getStaticMethodsOfClass: (className) ->
      return methodsStatic[className] || []

    getFactoryArgumentsForMethod: ({className, methodName}) ->
      if !factoryMethods[className] || !factoryMethods[className][methodName]
        return []
      return factoryMethods[className][methodName]

    escapeRegex: (string) ->
      return string.replace(/[-\/\\^$*+?.()|[\]{}]/g, '\\$&')

    # (optional): called _after_ the suggestion `replacementPrefix` is replaced
    # by the suggestion `text` in the buffer
  #  onDidInsertSuggestion: ({editor, triggerPosition, suggestion}) ->

    # (optional): called when your provider needs to be cleaned up. Unsubscribe
    # from things, kill any processes, etc.
  #  dispose: ->
