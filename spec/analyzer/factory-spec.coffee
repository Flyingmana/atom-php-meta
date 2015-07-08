{TextEditor, File} = require 'atom'

###*
 * @type {FactoryAnalyzer}
###
AnalyzerClass = require '../../lib/analyzer/factory'

describe "PHP FactoryAnalyzer", ->
  [analyzer] = []
  grammar = null

  beforeEach ->
    waitsForPromise ->
      atom.packages.activatePackage 'language-php'

    runs ->
      grammar = atom.grammars.grammarForScopeName 'text.html.php'
      analyzer = new AnalyzerClass()
      console.log(grammar,analyzer)

  it 'parses the grammar', ->
    expect(grammar).toBeTruthy()
    expect(grammar.scopeName).toBe 'text.html.php'

  it 'analyzes the file', ->
    file = new File('/home/flyingmana/github/phpstorm-meta/local/.phpstorm.meta.php', false);
    phpMetaTokens = grammar.tokenizeLines(file.readSync());

    for line in phpMetaTokens
      for token in line
        analyzer.processToken(token);
    result = analyzer.getResult();
    expect(result['STATIC_METHOD_TYPES']['\\Illuminate\\Foundation\\Application']['make']['auth']).toBe '\\Illuminate\\Auth\\AuthManager'
    console.log(analyzer.getResult());
