###*
 * @type {PhpClassDefinitionContainer}
###
ContainerClass = require '../../lib/container/class-definition-container'

describe "PHP Class Container", ->
  [container] = []

  beforeEach ->
    container = new ContainerClass()
    container.resetContainer()

  describe "when a namespace is added", ->
    it "is found via search", ->
      expect(container.searchForNamespaces("Illum").length).toEqual(0)
      container.addNamespace('\\Illuminate\\Foundation')
      expect(container.searchForNamespaces("Illum").length).toEqual(1)


  describe "when multiple namespaces are added", ->
    it "is found via search", ->
      expect(container.searchForNamespaces("Illum").length).toEqual(0)
      container.addNamespace('\\Illuminate\\Foundation')
      container.addNamespace('\\Illuminate\\Contracts\\Foundation')
      container.addNamespace('\\Illuminate\\Contracts\\Container')
      container.addNamespace('\\Sandbox\\Sooo\\Empty')
      console.log(container.searchForNamespaces("Illum"))
      expect(container.searchForNamespaces("Illum").length).toEqual(3)
