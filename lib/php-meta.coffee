path = require 'path'
{CompositeDisposable} = require 'atom'
AutocompleteProviderClass = require "./providers/autocomplete"

module.exports = PhpMeta =
  modalPanel: null
  subscriptions: null
  autocompleteProvider: null

  activate: (state) ->
    console.log 'PhpMeta was activated!'
    @autocompleteProvider = new AutocompleteProviderClass
    @autocompleteProvider.preloading()

    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'php-meta:toggle': => @toggle()
    @subscriptions.add atom.commands.add 'atom-text-editor', 'php-meta:goto': => @goto()

  deactivate: ->
    @subscriptions.dispose()

  serialize: ->

  getAutocompleteProvider: ->
    console.log "php meta get Provider";
    return @autocompleteProvider

  toggle: ->
    console.log 'PhpMeta was toggled!'

  goto: ->
    console.log 'php-meta:goto was toggled!'
    editor = atom.workspace.getActiveTextEditor()
    line = 22
    atom.workspace.open(path.join(__dirname, 'php-meta.coffee')).done =>
      editor.scrollToBufferPosition([line,0], center: true)
      editor.setCursorBufferPosition([line,0])
      editor.moveToFirstCharacterOfLine()
