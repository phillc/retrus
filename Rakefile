task :default => :test

task :server do
  system "./node_modules/nodemon/nodemon.js --delay 3 app.js"
end

task :compile do
	system "./node_modules/coffee-script/bin/coffee -bw -o ./lib -c ./src"
end

task :test do
  system "./node_modules/mocha/bin/mocha test/**/*test.coffee"
end
