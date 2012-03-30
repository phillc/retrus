task :default => :test

task :server do
  system "./node_modules/nodemon/nodemon.js app.coffee"
end

task :test do
  system "./node_modules/mocha/bin/mocha test/**/*.coffee"
end
