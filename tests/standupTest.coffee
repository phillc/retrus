casper.start "http://localhost:3000", ->
  console.log @test
  console.log Object.keys(@test)
  console.log @test.prototype
  console.log @test.processAssertionResult
  console.log @options.failText
  console.log @test.on
  @test.assertExists "login-buttons"

casper.run ->
  @test.done()
