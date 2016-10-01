chai = require 'chai'
sinon = require 'sinon'
chai.use require 'sinon-chai'

expect = chai.expect

describe 'synonyms', ->
  beforeEach ->
    @robot =
      respond: sinon.spy()
      hear: sinon.spy()

    require('../src/synonyms')(@robot)

  it 'responds to thesaurus request', ->
    expect(@robot.respond).to.have.been.calledWith(/(what is an? |give me )?(synonym|antonym)s? for ([a-z]+)/i)
