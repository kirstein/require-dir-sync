(function() {
  var VALID_EXTENSIONS, extend, fs, getFileName, isDir, isValidFile, notIgnored, path, requireDir,
    __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

  fs = require('fs');

  path = require('path');

  VALID_EXTENSIONS = ['js', 'coffee', 'json'];

  notIgnored = function(fn) {
    return function(fileName, _arg) {
      var ignore, patterns;
      ignore = _arg.ignore;
      if (ignore) {
        patterns = [].concat(ignore);
        if (patterns.some(function(pattern) {
          return fileName.match(pattern);
        })) {
          return;
        }
      }
      return fn.apply(null, arguments);
    };
  };

  isValidFile = notIgnored(function(fileName, _arg) {
    var ext, extension;
    ext = _arg.ext;
    if (ext == null) {
      ext = VALID_EXTENSIONS;
    }
    extension = fileName.substr(fileName.lastIndexOf('.') + 1);
    return __indexOf.call(ext, extension) >= 0;
  });

  getFileName = function(file) {
    return file.substr(0, file.lastIndexOf('.'));
  };

  extend = function(target, obj, base) {
    var key, mod, relativeKey, _results;
    _results = [];
    for (key in obj) {
      mod = obj[key];
      relativeKey = "" + base + "/" + key;
      _results.push(target[relativeKey] = mod);
    }
    return _results;
  };

  isDir = function(target) {
    return fs.lstatSync(target).isDirectory();
  };

  module.exports = requireDir = function(folder, options) {
    var file, files, longName, recRes, relDir, result, _i, _len;
    if (options == null) {
      options = {};
    }
    files = fs.readdirSync(folder);
    result = {};
    for (_i = 0, _len = files.length; _i < _len; _i++) {
      file = files[_i];
      longName = path.join(folder, file);
      if (options.recursive && isDir(longName)) {
        recRes = requireDir(longName, options);
        relDir = path.relative(folder, longName);
        extend(result, recRes, relDir);
      } else if (isValidFile(file, options)) {
        result[file] = require(longName);
      }
    }
    return result;
  };

}).call(this);
