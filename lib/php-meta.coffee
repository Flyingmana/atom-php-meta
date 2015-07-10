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

  deactivate: ->
    @subscriptions.dispose()

  serialize: ->

  getAutocompleteProvider: ->
    console.log "php meta get Provider";
    return @autocompleteProvider

  toggle: ->
    console.log 'PhpMeta was toggled!'
