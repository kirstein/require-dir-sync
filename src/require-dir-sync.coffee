fs   = require 'fs'
path = require 'path'

VALID_EXTENSIONS = [ 'js', 'coffee', 'json' ]

notIgnored = (fn) -> (fileName, { ignore }) ->
  if ignore
    patterns = [].concat ignore
    return if patterns.some (pattern) -> fileName.match pattern
  fn arguments...

isValidFile = notIgnored (fileName, { ext }) ->
  ext ?= VALID_EXTENSIONS
  extension = fileName.substr fileName.lastIndexOf('.') + 1
  extension in ext

getFileName = (file) ->
  file.substr 0, file.lastIndexOf('.')

extend = (target, obj, base) ->
  for key, mod of obj
    relativeKey = "#{base}/#{key}"
    target[relativeKey] = mod

isDir = (target) ->
  fs.lstatSync(target).isDirectory()

module.exports = requireDir = (folder, options = {}) ->
  files  = fs.readdirSync folder
  result = {}
  for file in files
    longName = path.join folder, file
    if options.recursive and isDir longName
      recRes = requireDir longName, options
      relDir = path.relative folder, longName
      extend result, recRes, relDir
    else if isValidFile file, options
      result[file] = require longName
  result
