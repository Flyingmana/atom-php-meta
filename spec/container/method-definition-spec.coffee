###*
 * @type {PhpClassDefinitionContainer}
###
PhpMethodDefinition = require '../../lib/container/method-definition'


describe "PHP Method Definition", ->
  definition_1 = definition_2 = null;

  it "is created", ->
    definition_1 = new PhpMethodDefinition(
      'getExample',
      {},
      '/test/path/file_1.php',
      '23'
    );
    definition_2 = new PhpMethodDefinition(
      'getExample',
      {},
      '/test/path/file_2.php',
      '22'
    )

  it "has the correct file Path", ->
    expect(definition_1.getFile()).toEqual('/test/path/file_1.php')
    expect(definition_2.getFile()).toEqual('/test/path/file_2.php')

  it "has the correct Line Number", ->
    expect(definition_1.getLine()).toEqual('23')
    expect(definition_2.getLine()).toEqual('22')


  it "has the correct Name", ->
    expect(definition_1.getName()).toEqual('getExample')
    expect(definition_2.getName()).toEqual('getExample')
