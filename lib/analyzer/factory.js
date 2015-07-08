var FactoryAnalyzer;

module.exports = FactoryAnalyzer = (function() {
  function FactoryAnalyzer() {
      var self = this;

      var inMetaNamespace = false;
      var methodTypes = [
        'STATIC_METHOD_TYPES'
      ];
      var methodType = null;
      var className = null;
      var methodName = null;

      var argumentKey = null;
      var argumentClass = null;

      var classResult = {};

      this.processToken = function(token){
        if(token.value.trim() === ''){
          return;
        }
        if(token.value.trim() === '\''){
          return;
        }
        if(inMetaNamespace === false){
          if(
            token.value === "PHPSTORM_META" &&
            token.scopes.indexOf("entity.name.type.namespace.php") !== -1
            ){
            inMetaNamespace = true;
          }
          return;
        }
        if(token.value === "STATIC_METHOD_TYPES"){
          methodType = "STATIC_METHOD_TYPES";
          return;
        }
        if(methodType){
          if(token.scopes.indexOf("punctuation.section.array.end.php") !== -1){
            if(className === null && methodName === null){
              methodType = null;
            }else{
              className = null;
              methodName = null;
            }
            return;
          }
          if( methodName === null && (
              token.scopes.indexOf("support.other.namespace.php") !== -1 ||
              token.scopes.indexOf("support.class.php") !== -1
          )){
            if(className === null){
              className = '';
            }
              className = className + token.value;
              return;
          }
          if( methodName === null && (
              token.scopes.indexOf("meta.function-call.static.php") !== -1
          )){
              methodName = token.value;
              return;
          }
          if( methodName === null && (
              token.scopes.indexOf("meta.function-call.php") !== -1
          )){
              className = 'function';
              methodName = token.value;
              return;
          }
          if( token.value === ","){
            argumentKey = null;
            argumentClass = null;
            return;
          }
          if(className && methodName){
            if(token.scopes.indexOf("string.quoted.single.php")  !== -1){
              argumentKey = token.value;
              return;
            }
            if(
                token.scopes.indexOf("support.other.namespace.php") !== -1
            ){
                if(argumentClass === null){
                  argumentClass = '';
                }
                argumentClass = argumentClass + token.value;
                return;
            }
            if(
                token.scopes.indexOf("support.class.php") !== -1
            ){
              if(argumentClass === null){
                argumentClass = '';
              }
                argumentClass = argumentClass + token.value;
                addEntry();
                return;
            }
          }
        }

      };

      var addEntry = function(){
        if(typeof classResult[methodType] == "undefined"){
          classResult[methodType] = {};
        }
        if(typeof classResult[methodType][className] == "undefined"){
          classResult[methodType][className] = {};
        }
        if(typeof classResult[methodType][className][methodName] == "undefined"){
          classResult[methodType][className][methodName] = {};
        }
        classResult[methodType][className][methodName][argumentKey] = argumentClass;
      };

      this.getResult = function(){
        return classResult;
      };

  }

  return FactoryAnalyzer;

})();
