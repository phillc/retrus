spawn = require("child_process").spawn
fs = require("fs")
path = require("path")
sys = require("sys")

task "test", "Test the app", ->
  testFolder = "test/routes"
  testFiles = (path.join(testFolder, fileName) for fileName in fs.readdirSync(testFolder))
  console.log("Test files: ", testFiles)
  mocha = spawn("mocha", testFiles)
  mocha.stdout.on 'data', sys.print
  mocha.stderr.on 'data', sys.print
