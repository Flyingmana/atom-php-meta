PhpstormMetaView = require './phpstorm-meta-view'
{CompositeDisposable} = require 'atom'
AutocompleteProviderClass = require "./providers/autocomplete"

module.exports = PhpstormMeta =
  phpstormMetaView: null
  modalPanel: null
  subscriptions: null
  autocompleteProvider: null

  activate: (state) ->
    console.log 'PhpstormMeta was activated!'
    @phpstormMetaView = new PhpstormMetaView(state.phpstormMetaViewState)
    @modalPanel = atom.workspace.addModalPanel(item: @phpstormMetaView.getElement(), visible: false)
    @autocompleteProvider = new AutocompleteProviderClass
    @autocompleteProvider.preloading()

    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'phpstorm-meta:toggle': => @toggle()

  deactivate: ->
    @modalPanel.destroy()
    @subscriptions.dispose()
    @phpstormMetaView.destroy()

  serialize: ->
    phpstormMetaViewState: @phpstormMetaView.serialize()

  getAutocompleteProvider: ->
    console.log "phpstorm meta get Provider";
    return @autocompleteProvider

  toggle: ->
    console.log 'PhpstormMeta was toggled!'

    if @modalPanel.isVisible()
      @modalPanel.hide()
    else
      @modalPanel.show()
