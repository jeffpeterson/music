#= require monkey_patches

describe "Inflections", ->
  describe '#underscore', ->
    it 'underscores camelized words', ->
      expect("CamelCase".underscore()).to.equal "camel_case"
      expect("camelCase".underscore()).to.equal "camel_case"
      expect("CSI".underscore()      ).to.equal "csi"

  describe '#dasherize', ->
    it 'dasherizes camelized words', ->
      expect("CamelCase".dasherize()).to.equal 'camel-case'
      expect("camelCase".dasherize()).to.equal 'camel-case'
      expect("CSI".dasherize()      ).to.equal 'csi'

    it 'dasherizes underscored words', ->
      expect("thing_one".dasherize()).to.equal 'thing-one'

  describe '#camelize', ->
    it 'camelizes underscored words', ->
      expect("camel_case".camelize()).to.equal 'CamelCase'
    it "doesn't capitalize first letter if passed false", ->
      expect("camel_case".camelize(false)).to.equal 'camelCase'

  describe '#singularize', ->
    it 'returns the singular form of simple words', ->
      expect('cats'.singularize()).to.equal 'cat'
      expect('words'.singularize()).to.equal 'word'

    it 'returns the singular form of complex words', ->
      expect('moose'.singularize()).to.equal 'moose'
      # expect('people'.singularize()).toEqual 'person'

    it "doesn't change singular words", ->
      expect('word'.singularize()).to.equal 'word'

  describe '#pluralize', ->
    it 'returns the plural form of simple words', ->
      expect('cat'.pluralize()).to.equal 'cats'
      expect('word'.pluralize()).to.equal 'words'

    # it 'returns the plural form of complex words', ->
    #   expect('moose'.pluralize()).toEqual 'moose'
    #   expect('person'.pluralize()).toEqual 'people'

