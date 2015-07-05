
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

    addClassName: (className) =>
      if !classDefinitions[className]
        classDefinitions[className] = {"classNameFull":className};

    addClassDefinition: (classDefinition) =>
      if !classDefinitions[classDefinition.classNameFull]
        classDefinitions[classDefinition.classNameFull] = classDefinition;

    searchForClassName: (string) =>
      result = []
      for className,classDefinition of classDefinitions
        if className.search(@escapeRegex(string)) != -1
          result.push(className)
      return result

    getClassDefinition: (className) =>
      result = null;
      result = classDefinitions[className];
      return result;

    escapeRegex: (string) =>
      return string.replace(/[-\/\\^$*+?.()|[\]{}]/g, '\\$&')

    resetContainer: =>
      namespaces = []
      classDefinitions = {}
      factoryMethods = {}
