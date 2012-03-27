spawn = require("child_process").spawn
fs = require("fs")
path = require("path")
sys = require("sys")

task "test", "Test the app", ->
  mochaTestFolders = ["routes", "models"]
  testFiles = for mochaTestFolder in mochaTestFolders
    fullMochaTestFolder = path.join("test", mochaTestFolder)
    for fileName in fs.readdirSync(fullMochaTestFolder)
      path.join fullMochaTestFolder, fileName

  console.log("Test files: ", testFiles)
  mocha = spawn("mocha", testFiles)
  mocha.stdout.on 'data', sys.print
  mocha.stderr.on 'data', sys.print
