(function(base){

var macro;

Object.setPrototypeOf || (Object.setPrototypeOf = function(obj, proto) {
  obj.__proto__ = proto;
});


var State = Backbone.Model.extend({});

base.Component = Backbone.View.extend({});
base.Component.EmptyComponent = function(){};

base.Component.parent           = base.Component.EmptyComponent;
base.Component.parent._name     = 'Component.EmptyComponent';
base.Component.parent.Component = base.Component;

base.Component._name = 'Component';

macro = base.Component.macro = function(name, definition) {
  base.Component[name] = definition;
}

base.Component.def = function(name, definition) {
  this.prototype[name] = definition;
}

macro('superClass', function(superClass){
  if (superClass && superClass.prototype) {
    this.sup = this.prototype.sup = superClass
    _.extend(this.prototype, superClass.prototype);
  }

  return superClass;
});

macro('extras', function (instanceExtension) {
  _.extend(this.prototype, instanceExtension);
  return instanceExtension;
});

macro('new', function(name, superClass, definition) {
  var co, extension;

  if (this.hasOwnProperty(name)) {
    throw new Error(this._name + '.' + name + " already exists!");
  }

  if (!definition) {
    definition = superClass;
    superClass = null;
  }

  if (typeof definition === "function") {
    extension = {};
  } else {
    extension  = definition;
    definition = L.nop;
  }

  co = this[name] = Backbone.View.extend({});
  co.parent = this;
  Object.setPrototypeOf(co, this);

  co.superClass(superClass);
  co.extras(extension);

  if (this === base.Component) {
    co._name = name;
  } else {
    co._name = this._name + '.' + name;
  }

  co.requirements = {};
  definition.apply(co, superClass);

  return co.init(this);
});

macro('requires', function() {
  for (var i = 0; i < arguments.length; i++) {
    this.requirements[arguments[i]] = {}
  }
  [].push.apply(this.requirements, arguments);
});

macro('init', function(parent) {
  this.prototype.template  = JST[this.path()];
  this.className(L.dasherize(this._name.replace(/\./g, '_')));

  return this;
});

base.Component.path = function(name) {
  return (name || this._name).replace(/\./g, '/');
}

base.Component.className = function(className) {
  if (this.prototype.className) {
    this.prototype.className += ' ' + className;
  } else {
    this.prototype.className = className;
  }

  return this.prototype.className;
}

base.Component.events = function(map) {
  return (this.prototype.events =
    _.extend(_.clone(this.prototype.events || {}), map || {}));
}

base.Component.deref = function(name) {
  var match, rest, name;

  if (name === 'Component') {
    return base.Component;
  }

  match = name.match(/^(?:(.*)\.)?([^.]+)$/i);
  rest  = match[1];
  name  = match[2];

  if (rest) {
    return this.deref(rest)[name];
  } else {
    return this[name] || this.parent.deref(name);
  }
}

base.Component.EmptyComponent.deref = function(name) {
  if (this[name]) {
    return this[name];
  }

  throw new Error(L.fmt("Component named '%s' not found!", name));
}

})(this);
