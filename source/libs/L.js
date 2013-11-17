(function(base){

var L;

L = base.L = {};

L.nop = function(){};

L.tap = function(fn) {
  return function() {
    fn.apply(this, arguments);
    return this;
  }
}

L.tail = function(lst) {
  return Array.prototype.slice.call(lst, 1);
}

L.fmt = function(str) {
  var replacements = L.tail(arguments);

  return str.replace(/%(s)/g, function(match, directive){
    var rep = replacements.shift();
    if (!rep) {
      return match;
    }

    switch (directive) {
      case 's':
        return JSON.stringify(rep);
      default:
        return match;
    }
  });
}

L.underscore = function(camelizedWord) {
  return camelizedWord
    .replace(/-/g, '_')
    .replace(/([a-z])([A-Z])/g, function(match, lower, upper) {
      return lower + "_" + upper;
    })
    .toLowerCase();
}

L.camelize = function(underscoredWord, capitalizeFirstLetter) {
  var regex;

  if (typeof capitalizeFirstLetter === "undefined") {
    capitalizeFirstLetter = true
  }

  regex = capitalizeFirstLetter ?
    /(?:^|_|-)([a-z])/g : /(?:_|-)([a-z])/g;

  return underscoredWord.replace(regex, function(match, start) {
    return start.toUpperCase();
  });
}

L.singularize = function(pluralWord) {
  return pluralWord.replace(/s$/, '');
}


L.pluralize = function(singularWord) {
  return singularWord + 's';
}

L.dasherize = function(camelCaseOrUnderscoreWord) {
  return L.underscore(camelCaseOrUnderscoreWord).replace(/_/g, '-')
}

})(this);
