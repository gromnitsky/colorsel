assert = require 'assert'
fs = require 'fs'

CS = require '../src/lib/colorsource'

suite 'ColorSource smoke', ->

  test 'invalid constructor call', ->
    assert.throws ->
      new CS()
    , Error

    assert.throws ->
      new CS 'too short', {}
    , Error

    assert.throws ->
      new CS '123 456 789 0', null
    , Error

  test 'simple x11 entry', ->
    cs = new CS ' 65 105 225		RoyalBlue', {}
    assert.equal 1, cs.colors.length
    assert.deepEqual [65, 105, 225], cs.colors[0].decimals

  test 'invalid x11 entry', ->
    assert.throws ->
      new CS ' -655 105 225		RoyalBlue', {}
    , Error




suite 'ColorSource RGB.txt', ->

  setup ->
    rgb = fs.readFileSync('../src/rgb.txt').toString()
    @cs1 = new CS rgb, {spaces: true}
    @cs2 = new CS rgb, {spaces: false}

  test 'with spaces', ->
    assert.equal 752, @cs1.colors.length

  test 'w/o spaces', ->
    assert.equal 657, @cs2.colors.length
