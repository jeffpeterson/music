#= require ./Component

mocha.timeout 100
mocha.slow 2

describe "L", ->
  it 'taps functions', ->
    dog = bark: L.tap ->
      @name = 'Ralph'
      expect(this).to.equal dog

    expect(dog.bark()).to.equal dog
    expect(dog.name  ).to.equal 'Ralph'

describe 'L.Component', ->
  beforeEach ->
    L.Component.new 'Leg'
    L.Component.new 'Animal', ->
      @requires 'Leg'
    L.Component.Animal.new 'Cat'

  afterEach ->
    L.Component.delete 'Animal', 'Leg'

  it 'exists', ->
    expect(L.Component).to.exist

  it 'prevents duplicates', ->
    expect(-> L.Component.new('Animal')).to.throw(Error)
    expect(-> L.Component.new('Test')  ).not.to.throw(Error)
    L.Component.delete('Test')

  it 'can create child components', ->
    L.Component.Animal.Cat.new 'Lion'
    expect(L.Component.Animal).to.exist

  it 'keeps references to children', ->
    expect(L.Component.children).to.have.property 'Animal', L.Component.Animal
    expect(L.Component.children).to.have.property 'Leg',    L.Component.Leg

  it 'assigns a name', ->
    expect(L.Component._name           ).to.equal 'Component'
    expect(L.Component.Animal._name    ).to.equal 'Animal'
    expect(L.Component.Animal.Cat._name).to.equal 'Animal.Cat'

  it "can dereference names of children", ->
    expect(L.Component.Animal.deref('Cat')).to.equal L.Component.Animal.Cat
    expect(L.Component.deref('Animal.Cat')).to.equal L.Component.Animal.Cat

  it "can dereference names of ancestors", ->
    expect(L.Component.Animal    .deref('Component' )).to.equal L.Component
    expect(L.Component.Animal.Cat.deref('Animal.Cat')).to.equal L.Component.Animal.Cat
    expect(L.Component           .deref('Animal.Cat')).to.equal L.Component.Animal.Cat


  describe '.EmptyComponent', ->
    it 'is the parent of L.Component', ->
      expect(L.Component.parent).to.equal L.Component.EmptyComponent

    it "has L.Component as it's only child", ->
      expect(L.Component.EmptyComponent.children).to.deep.equal {Component: L.Component}

  describe 'requirements', ->
    it "are an object", ->
      expect(L.Component.Animal.requirements).to.be.an.instanceof Object

    it "contain it's prototype", ->
      expect(L.Component.Animal.requirements).to.have.property  'Component', L.Component
      expect(L.Component.Animal.Cat.requirements).to.have.property 'Animal', L.Component.Animal

    it "includes requires", ->
      expect(L.Component.Animal.requirements).to.have.property 'Leg', L.Component.Leg

    it 'lists allRequirements', ->
      expect(L.Component.Animal.allRequirements())    .to.deep.equal {Component: L.Component, Leg: L.Component.Leg}
      expect(L.Component.Animal.Cat.allRequirements()).to.deep.equal {Component: L.Component, Leg: L.Component.Leg, Animal: L.Component.Animal}

    describe 'instance methods', ->
      it 'can be defined', ->
        L.Component.Animal.def 'five', -> 5
        expect((new L.Component.Animal).five()).to.equal 5

      it 'can reference themselves with "this"', ->
        L.Component.Animal.def 'self', -> this
        a = new L.Component.Animal
        expect(a.self()).to.equal a

      it 'passes arguments', ->
        L.Component.Animal.def 'same', (x) -> x
        expect((new L.Component.Animal).same(1)).to.equal 1

      # it 'passes calls with super', ->
      #   L.Component.Animal.test     = (x) -> x + 'd'
      #   L.Component.Animal.Cat.test = (x) ->
      #     @super('test', x + 'c')

      #   L.Component.Animal.Cat.new 'Lion', ->
      #     @test = (x) ->
      #       @super('test', x + 'b')

      #   L.Component.Animal.Cat.new 'Tiger'

      #   expect(L.Component.Animal.Cat.Lion.test('a')).to.equal 'abcd'
      #   expect(L.Component.Animal.Cat.Tiger.test('a')).to.equal 'acd'


  describe 'filters', ->
    beforeEach ->
      L.Component.new 'T', ->
        @def 'go', ->
          @t.push(1)
          @t

      L.Component.T.before 'go', -> @t = []

    afterEach ->
      L.Component.delete('T')

    it 'calls before filters before the method', ->
      t = new L.Component.T
      expect(t.go()).to.deep.equal [1]

    it 'calls after filters after the method', ->
      L.Component.T.after 'go', -> @t.push(2)
      t = new L.Component.T
      expect(t.go()).to.deep.equal [1, 2]

  describe 'an instance', ->
    it 'can be created with new', ->
      expect((new L.Component       ).constructor).to.equal L.Component
      expect((new L.Component.Animal).constructor).to.equal L.Component.Animal
      expect( new L.Component       ).to.be.instanceOf      L.Component

    it 'has a default className', ->
      expect((new L.Component           ).classNames).to.deep.equal ['component']
      expect((new L.Component.Animal    ).classNames).to.deep.equal ['animal']
      expect((new L.Component.Animal.Cat).classNames).to.deep.equal ['animal-cat']

