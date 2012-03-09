(function() {
  var Hook, command, hook;

  command = require(__dirname)(process.argv);

  Hook = require("hook.io").Hook;

  hook = new Hook({
    name: "design.io-stop",
    debug: false
  });

  hook.on("hook::ready", function(data) {
    return hook.emit("ready", data);
  });

  hook.start();

  /*
  forever.list false, (error, processes) ->
    for process, index in processes
      if process.file == file
        forever.stop(index)
        break
  */

}).call(this);
