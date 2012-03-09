# Pathfinder.js

> Code for the File Ninja

## Install

```
npm install pathfinder
```

## Goals

- make it so any node.js code works in the browser
- make it easy to piece together code from modules without `require` (copy the code from one place to another)
- compile out asset digests
- make it easy to wrap any code in `require` for the browser
- be a foundation for any rich watching functionality
- cache requirements globally, so there's just a list.  makes things much faster
- `global ||= window` in browser

## API

### Require

Here's what it outputs

``` javascript
require.define("/myModule/file.js", function(require, module, exports, __dirname, __filename) {
  // your module code
});
```

Then when you call `require('./anotherFile.js');`, it knows that the path of this file is `/myModule/file.js`, so it knows that must be `/myModule/anotherFile.js`.

For things like jQuery, if you only need it in the browser, you can just assume it's a global variable.

If you want to have it be required, you can do this:

``` javascript
require.define("/jquery.js", function(require, module, exports, __dirname, __filename) {
  return module.exports = exports.$ = $;
});
```

That makes it so you can still take advantage of things like Google's CDN.

For browser-only libraries, you're free to manually write the require statements:

``` coffeescript
require.define '/jquery.js', (require, module, exports) ->
  module.exports = exports.$ = $

require.define '/jquery.form.js', (require, module, exports) ->
  module.exports = exports.$ = $
```

If you want to be able to use it in node (forgetting about the fact that jQuery requires some sort of dom), you actually have to wrap the code in this method.  You can do that by downloading the library into your project and generating the output like this:

``` coffeescript
# ./jquery.coffee

# @include './vendor/jquery.1.7.0.js'
module.exports = $
```

Then when you compile it, it will import the jquery source code, and wrap it in the define block!

``` javascript
require.define("/jquery.js", function(require, module, exports, __dirname, __filename) {
  // all the jquery 1.7.0 code...
  
  module.exports = $;
});
```

### Notes

- For javascripts that will [realistically] only be used in the browser (jquery and plugins), you don't really need to wrap them into define blocks; assume they're global variables like you normally would.
- For javascripts that will be used in both places and are built to work in both places (e.g. underscore, backbone), it is better to use the node.js version and compile that into a define block.  This way you're only using one version which makes debugging easier to handle.  At some point though I want to make it easy to piggyback off CDN's, which would mean the node.js version needs to be loaded from the CDN.  That's a ways away though.  This means that you shouldn't use them as global variables, even if they allow you to use them like that, because your code will fail in node.js.  You need to `require('backbone')` for example, in any of your client side code that will also be used server side.  Unless you're not going to be using your code as a library, in which case it doesn't really matter.  In that case, just create an `index.js` file or something that sets all the global variables for node like you use them in the browser, i.e. `global.Backbone = require('backbone'); global._ = require('underscore');`.  This also makes it so you don't have to wrap them in require blocks for your app code.
- For javascripts that need to be used in both places but are built only for the browser, then you have to manually write the define block.  These are usually new/small projects.  You just need to specify what the exports are.  I don't like the idea of creating a github project for each one of these, just create a gist, or post on the wiki here how you did it.  At some point the author should include it in their project.
- For javascripts that are only built as node.js modules, this will work fine.
- If you have to create a wrapper for the library, either the author didn't build their framework well enough, or you're using the code for something it wasn't meant for.  As a library author, you can write your own build task that replaces the `require` statements in your node code with the actual code, which outputs as your client version of the file.  This is basically what jade does to give you jade in the browser.

### Directives

JavaScript and CSS files can have two types of directives: `@import` and `@include`.

Files referenced with the `@import` directive will be directly copied into the location of the directive.

Files referenced with the `@include` directive will be compiled into either JavaScript or CSS (from CoffeeScript, Stylus, etc.) and then copied into the location of the directive.  That's the only difference from the `@import` directive.

For instance

``` javascript
// @import './models'
// @import './views'
// @import './controllers'

alert "application"
```

might become this CoffeeScript

``` javascript
alert "models"
alert "views"
alert "controllers"

alert "application"
```

which is then rendered to JavaScript

``` javascript
alert("models");
alert("views");
alert("controllers");

alert("application");
```

## Paths

Paths work just like they do in Node.js:

- `./relative/path`: relative paths are relative to the current file
- `/absolute/path`: absolute paths are relative to the current project
- `library`: libraries are keys

### Compile

``` javascript
Pathfinder  = require 'pathfinder'
pathfinder  = new Pathfinder(root: process.cwd())
    
pathfinder.compile (file, string) ->
  console.log string
  
pathfinder.requirements()
```

### Write to file

``` javascript
outputPath = (file) ->
  relativePath = file.relativePath()
  if relativePath.match(/^app\/javascripts\/(.*)/)
    "public/#{RegExp.$1}"
  else
    "public/#{relativePath}"
    
pathfinder.write outputPath: outputPath, (file, string) ->
  console.log("Done!") unless file
```

### Find the first file from an ambiguous source

``` javascript
file = pathfinder.find "application"
```

### Update with a Watcher

Pathfinder.js doesn't include a watcher, but it's setup to be easy to use with one.  It's used in Design.io for example.

``` javascript
watch /\.(js|coffee)/
  update: (file) ->
    file.dirname()
```

### Compile `require` libraries for the browser

``` javascript
patfinder.writeRequirements()
```

### Manifests and Digests

Outputs a JSON map of key to compressed, digest version of a file!

## License

(The MIT License)

Copyright &copy; 2011 [Lance Pollard](http://twitter.com/viatropos) &lt;lancejpollard@gmail.com&gt;

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the 'Software'), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
