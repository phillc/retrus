#!/usr/bin/env node

require.main.paths.push(process.cwd() + "/node_modules")

// require(process.cwd() + "/node_modules/" + 'design.io/lib/design.io/command').run(process.argv)
require('design.io/lib/design.io/command').run(process.argv)