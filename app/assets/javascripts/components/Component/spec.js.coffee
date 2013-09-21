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

describe 'App.Component', ->
  beforeEach ->
    App.Component.new 'Leg'
    App.Component.new 'Animal', ->
      @requires 'Leg'
    App.Component.Animal.new 'Cat'

  afterEach ->
    App.Component.delete 'Animal', 'Leg'

  it 'exists', ->
    expect(App.Component).to.exist

  it 'prevents duplicates', ->
    expect(-> App.Component.new('Animal')).to.throw(Error)
    expect(-> App.Component.new('Test')  ).not.to.throw(Error)
    delete App.Component.Test

  it 'can create child components', ->
    App.Component.Animal.Cat.new 'Lion'
    expect(App.Component.Animal).to.exist

  it 'keeps references to children', ->
    expect(App.Component.children).to.have.property 'Animal', App.Component.Animal
    expect(App.Component.children).to.have.property 'Leg',    App.Component.Leg

  it 'assigns a name', ->
    expect(App.Component._name           ).to.equal 'Component'
    expect(App.Component.Animal._name    ).to.equal 'Animal'
    expect(App.Component.Animal.Cat._name).to.equal 'Animal.Cat'

  it "can dereference names of children", ->
    expect(App.Component.Animal.deref('Cat')).to.equal App.Component.Animal.Cat
    expect(App.Component.deref('Animal.Cat')).to.equal App.Component.Animal.Cat

  it "can dereference names of ancestors", ->
    expect(App.Component.Animal    .deref('Component' )).to.equal App.Component
    expect(App.Component.Animal.Cat.deref('Animal.Cat')).to.equal App.Component.Animal.Cat
    expect(App.Component           .deref('Animal.Cat')).to.equal App.Component.Animal.Cat


  describe '.EmptyComponent', ->
    it 'is the parent of App.Component', ->
      expect(App.Component.parent).to.equal App.Component.EmptyComponent

    it "has App.Component as it's only child", ->
      expect(App.Component.EmptyComponent.children).to.deep.equal {Component: App.Component}

  describe 'requirements', ->
    it "are an object", ->
      expect(App.Component.Animal.requirements).to.be.an.instanceof Object

    it "contain it's prototype", ->
      expect(App.Component.Animal.requirements).to.have.property  'Component', App.Component
      expect(App.Component.Animal.Cat.requirements).to.have.property 'Animal', App.Component.Animal

    it "includes requires", ->
      expect(App.Component.Animal.requirements).to.have.property 'Leg', App.Component.Leg

    it 'lists allRequirements', ->
      expect(App.Component.Animal.allRequirements())    .to.deep.equal {Component: App.Component, Leg: App.Component.Leg}
      expect(App.Component.Animal.Cat.allRequirements()).to.deep.equal {Component: App.Component, Leg: App.Component.Leg, Animal: App.Component.Animal}

    describe 'instance methods', ->
      it 'can be defined', ->
        App.Component.Animal.def 'five', -> 5
        expect((new App.Component.Animal).five()).to.equal 5

      it 'can reference themselves with "this"', ->
        App.Component.Animal.def 'self', -> this
        a = new App.Component.Animal
        expect(a.self()).to.equal a

      it 'passes arguments', ->
        App.Component.Animal.def 'same', (x) -> x
        expect((new App.Component.Animal).same(1)).to.equal 1

      # it 'passes calls with super', ->
      #   App.Component.Animal.test     = (x) -> x + 'd'
      #   App.Component.Animal.Cat.test = (x) ->
      #     @super('test', x + 'c')

      #   App.Component.Animal.Cat.new 'Lion', ->
      #     @test = (x) ->
      #       @super('test', x + 'b')

      #   App.Component.Animal.Cat.new 'Tiger'

      #   expect(App.Component.Animal.Cat.Lion.test('a')).to.equal 'abcd'
      #   expect(App.Component.Animal.Cat.Tiger.test('a')).to.equal 'acd'


  describe 'filters', ->
    beforeEach ->
      App.Component.new 'T', ->
        @def 'nogo', -> throw new Error('Uh oh!')

    afterEach ->
      delete App.Component.T

    it 'stops the call if a before filter returns false', ->
      t = new App.Component.T
      App.Component.T.before 'nogo', -> true
      expect(t.nogo).to.throw(Error)
      App.Component.T.before 'nogo', -> false
      expect(t.nogo).to.not.throw(Error)

  describe 'an instance', ->
    it 'can be created with new', ->
      expect((new App.Component       ).constructor).to.equal App.Component
      expect((new App.Component.Animal).constructor).to.equal App.Component.Animal
      expect( new App.Component       ).to.be.instanceOf      App.Component

    it 'has a default className', ->
      expect((new App.Component           ).classNames).to.deep.equal ['component']
      expect((new App.Component.Animal    ).classNames).to.deep.equal ['animal']
      expect((new App.Component.Animal.Cat).classNames).to.deep.equal ['animal-cat']

