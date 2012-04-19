task :default => :test

task :server do
  system "./node_modules/nodemon/nodemon.js --exec 'meteor'"
end

task :test do
  system "./node_modules/mocha/bin/mocha test/**/*test.coffee"
end
