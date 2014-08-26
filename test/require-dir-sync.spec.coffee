sinon      = require 'sinon'
fs         = require 'fs'
path       = require 'path'
requireDir = require '../src/require-dir-sync'

FIXTURE_DIR = path.join __dirname, './fixtures'

describe 'require-dir', ->
  it 'should find all the files in a directory', ->
    res = requireDir FIXTURE_DIR
    Object.keys(res).length.should.eql 3

  it 'should have module name as a key', sinon.test ->
    @stub(fs, 'readdirSync').returns [ 'requireTest.json' ]
    res = requireDir FIXTURE_DIR
    res['requireTest.json'].should.be.ok

  it 'should ignore any other types', sinon.test ->
    @stub(fs, 'readdirSync').returns [ 'requireTest.xxx' ]
    (-> requireDir FIXTURE_DIR).should.not.throw

  describe 'ignore', ->
    it 'should ignore files that match the ignore statement', ->
      res = requireDir FIXTURE_DIR, ignore: /requireTest/
      Object.keys(res).length.should.eql 0

    it 'should ignore files that match the ignore statements', ->
      res = requireDir FIXTURE_DIR, ignore: [ 'hello', /requireTest/ ]
      Object.keys(res).length.should.eql 0

  describe 'extensions', ->
    it 'should only load files whos extensions are added', ->
      res = requireDir FIXTURE_DIR, ext: [ 'js' ]
      res['requireTest.js'].should.be.ok
      Object.keys(res).length.should.eql 1

    it 'should try to require js file', sinon.test ->
      @stub(fs, 'readdirSync').returns [ 'requireTest.js' ]
      res = requireDir FIXTURE_DIR
      res['requireTest.js'].should.be.ok

    it 'should try to require json file', sinon.test ->
      @stub(fs, 'readdirSync').returns [ 'requireTest.json' ]
      res = requireDir FIXTURE_DIR
      res['requireTest.json'].should.be.ok

    it 'should try to require coffee file', sinon.test ->
      @stub(fs, 'readdirSync').returns [ 'requireTest.coffee' ]
      res = requireDir FIXTURE_DIR
      res['requireTest.coffee'].should.be.ok

  describe 'recursive', ->
    it 'should require all files in folder', ->
      res = requireDir FIXTURE_DIR, recursive: true
      Object.keys(res).length.should.eql 5

    it 'should give paths relative to starting folder', ->
      res = requireDir FIXTURE_DIR, recursive: true
      res['recursive/recursive/recursive.recursive.coffee'].should.be.ok
