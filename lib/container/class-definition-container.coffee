
module.exports =
  class PhpClassDefinitionContainer

    namespaces = []

    classDefinitions = {}

    factoryMethods = {}


    addNamespace: (namespace) =>
      namespaces.push(namespace);

    searchForNamespaces: (string) =>
      result = []
      for namespace in namespaces
        if namespace.search(@escapeRegex(string)) != -1
          result.push(namespace)

      return result;


    escapeRegex: (string) =>
      return string.replace(/[-\/\\^$*+?.()|[\]{}]/g, '\\$&')

    resetContainer: =>
      namespaces = []
      classDefinitions = {}
      factoryMethods = {}
