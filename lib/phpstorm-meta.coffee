PhpstormMetaView = require './phpstorm-meta-view'
{CompositeDisposable} = require 'atom'

module.exports = PhpstormMeta =
  phpstormMetaView: null
  modalPanel: null
  subscriptions: null

  activate: (state) ->
    @phpstormMetaView = new PhpstormMetaView(state.phpstormMetaViewState)
    @modalPanel = atom.workspace.addModalPanel(item: @phpstormMetaView.getElement(), visible: false)

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

  toggle: ->
    console.log 'PhpstormMeta was toggled!'

    if @modalPanel.isVisible()
      @modalPanel.hide()
    else
      @modalPanel.show()
