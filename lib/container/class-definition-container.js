"use babel";
// jshint esnext: true
(function(){
  "use strict";
  var escapeRegex = function (string) {
    return string.replace(/[-\/\\^$*+?.()|[\]{}]/g, '\\$&');
  };


  module.exports = class PhpClassDefinitionContainer {

    constructor() {
      this.namespaces = [];
      this.classDefinitions = new Map();
      this.factoryMethods = {};
    }

    addNamespace(namespace) {
      this.namespaces.push(namespace);
    }

    searchForNamespaces(needle) {
      let result = [];
      for (var namespace of this.namespaces) {
        if (namespace.search(escapeRegex(needle)) != -1) {
          result.push(namespace);
        }
      }
      return result;
    }

    addClassName(className) {
      if (!this.classDefinitions.has(className)) {
        this.classDefinitions.set(className,{"classNameFull": className});
      }
    }

    addClassDefinition(classDefinition) {
      if (!this.classDefinitions.has(classDefinition.classNameFull)) {
        this.classDefinitions.set(classDefinition.classNameFull,classDefinition);
      }
    }

    searchForClassName(needle) {
      let result = [];
      for (let [key, definition] of this.classDefinitions) {
        let className = definition.classNameFull;
        if (className.search(escapeRegex(needle)) != -1) {
          result.push(className);
        }
      }
      return result;
    }

    getClassDefinition(className) {
      return this.classDefinitions.get(className);
    }

    resetContainer() {
      console.log("deprecated");
    }

  };

})();
