# Design.io

> CSS3 + TextMate + Node.js = Real-Time Web Design

## Video Tutorial

[![Here's a video tutorial on vimeo](http://i.imgur.com/JunAS.png)](http://player.vimeo.com/video/31589739?title=0&amp;byline=0&amp;portrait=0&autoplay=true)

Here is the [example app](https://github.com/viatropos/design.io-example) for the video.

## Install

```
npm install design.io -g
```

**Note**: Design.io uses Ruby to watch files on a Mac, using Mac's FSEvents.  FSEvents is the most efficient way of getting notified when a file changes on a Mac.  The other solution is to iterate over the project file tree every <n> milliseconds, but that quickly becomes a problem with decently sized projects.  The reason design.io uses Ruby to do this is because the Node.js `fs.watch` command does not work correctly across different versions of node and even sometimes on different versions of the Mac OS.  There are several issues posted about this: https://github.com/joyent/node/issues/search?q=fs.watch.  If you know of a better workaround, please let me know - this is only temporary, but Mac comes with Ruby and this solution works very well.  Do note though, if you don't have [RVM (Ruby Version Manager)](https://rvm.beginrescueend.com/rvm/install/) installed, you most likely have to install design.io with `sudo npm install design.io -g`.

## Run

First, you need design.io to setup a global HTTP server that will send your changed/processed files to the apps using them.  This can run in the background and will always be on.

```
design.io start
```

Then, in your specific project that you want to watch files in, run

```
design.io # equivalent to `design.io watch`
```

This will set up a watcher that watches every file and directory within your project folder tree.  Anytime a file changes, design.io will iterate through all of the `watch` tasks defined in your projects `Watchfile`.  It will then test the path of the changed file against each `watch` task, and if it matches, will run its `update`, `destroy`, or `create` method.  Within those 3 methods, you can then say `this.broadcast({some: "json"})` (maybe you've compiled CSS and want to inject it into the browser).

That `broadcast` method is called from within the process defined by the `design.io watch` command within your project directory.  Somehow this must communicate this to the global HTTP server defined with `design.io start`.  It does this through the amazingness that is [hook.io](https://github.com/hookio/hook.io).

Hook.io works by allowing totally separate command-line processes communicate with each other through events.

In design.io, you are running two commands:

1. `design.io start` to start <1> global node HTTP server
2. `design.io watch` in <n> project directories
  
Both of those commands instantiate a hook through hook.io: `design.io start` listens for file change events dispatched from `design.io watch`, and `design.io watch` listen for "shut down all design.io processes" from `design.io start`.

This is extremely powerful.  It means you can have several projects, all with their own file watcher system, and have a way of notifying the central hub HTTP server when something changes.  And you can manage the operating system processes easily.

To list all of the processes design.io is using, run

```
forever list
```

This is from the awesome [forever](https://github.com/nodejitsu/forever) module from Nodejitsu, which allows you to easily manage multiple child processes.  Hook.io also uses forever in some places.

## The Watchfile

The real power of design.io comes from the `Watchfile`.

The `Watchfile` is like a Makefile, Cakefile, Rakefile, or Jakefile: it defines a set of tasks, but these are "watch" tasks.

This is what a blank `watch` task looks like:

``` coffeescript
# ./Watchfile

watch /\.(styl|less|sass|scss|css)$/
  initialize: (path) ->
    
  create: (path) ->
    @update(path)
    
  update: (path) ->
      
  delete: (path) ->
  
  client:
    # id, path, body
    create: (data) ->
      # this is in the browser's context!
    
    update: (data) ->
      
    delete: (data) ->
      
```

Each `watch` task defines a `Watcher` object which has 4 methods that you can define in both the file system and client scopes:

- `initialize(path, callback)`: run when you boot up `design.io watch` and it reads all the files in the project directory.  You might use this to compile all your CoffeeScript or LESS for your app when it starts.
- `create(path, callback)`: run when a file is added anywhere in your project tree.
- `update(path, callback)`: run when a file is saved (technically, when the `mtime` changes, which can happen when you run the unix `touch path/to/file` command)
- `delete(path, callback)`: run when a file is removed.

You can also define what you want the browser (`client`) to do on each of these actions.  Everything defined in the `client` object within a `watch` task is executed in the browsers scope.  It receives JSON sent from the browser.  The convention is to send an object with these default properties:

``` json
{
  "body": "function() { alert('!'); }",
  "path": "public/javascripts/application.js",
  "id":   "public-javascripts-application-js"
}
```

You can add any property really.  With that, you can eval the code or whatever you want in the browser.  That's it.

A lot of the common cases have been solved so far:

- [design.io-stylesheets](https://github.com/viatropos/design.io-stylesheets)
- [design.io-javascripts](https://github.com/viatropos/design.io-javascripts)

Also, by adding the following line to the top of your `Watchfile`, you can edit the `Watchfile` without restarting `design.io` and the next file you save will reflect the state of the new `Watchfile`:

``` coffeescript
require('design.io').extension('watchfile')()
```

## Client Side

Add the [design.io.js](https://raw.github.com/viatropos/design.io/master/design.io.js) client to your html head.  You also need jQuery, and [Socket.IO](http://socket.io/).

``` html
<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.0/jquery.min.js"></script>
<script type="text/javascript" src="/javascripts/socket.io.js"></script>
<script type="text/javascript" src="/javascripts/design.io.js"></script>
```

You can just [grab socket.io from here](https://raw.github.com/viatropos/design.io/master/spec/app/javascripts/socket.io.js) as well.

## Using Extensions

Design.io comes with two basic extensions:

1. Stylesheet watching/compressing/injecting
2. JavaScript watching/compressing/injecting

You can include them in your `Watchfile` like this:

``` coffeescript
require("design.io").extension("watchfile")
require("design.io").extension("stylesheets", compress: true)
require("design.io").extension("javascripts")

watch /\.md$/ # some custom one...
```

## Possibilities

- Incrementing values with keyboard and swipe pad in textmate.  http://old.nabble.com/Incremental-Sequences-for-Replacement-td27741019.html
- http://stackoverflow.com/questions/3459476/how-to-append-to-a-file-in-node
- http://francisshanahan.com/index.php/2011/stream-a-webcam-using-javascript-nodejs-android-opera-mobile-web-sockets-and-html5/
- The end solution would be something like this: a global database mapping a project name to directory to watch for changes, running one server, then you watch each project manually and kill each one manually.  Something about a central database, but then you'd need to deal with permissions and I'm not going there :).

## Resources

- https://github.com/joyent/node/issues/search?q=fs.watch

## License

(The MIT License)

Copyright &copy; 2011 - 2012 [Lance Pollard](http://twitter.com/viatropos) &lt;lancejpollard@gmail.com&gt;

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the 'Software'), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
