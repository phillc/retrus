task :default => :test

desc "jslint"
task :jslint do
  puts `jslint public/javascripts/retrus.js`
end

desc "test"
task :test do
  puts `mocha test/**/*_test.coffee`
end
