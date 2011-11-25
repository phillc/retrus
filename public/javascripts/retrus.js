var Retrus = {}

Retrus.Group = Backbone.Model.extend({

});

Retrus.GroupList = Backbone.Collection.extend({
  model: Retrus.Group
})

Retrus.Note = Backbone.Model.extend({
  defaults: {
    text: "",
    ups: 0,
    downs: 0,
  },
  urlRoot: "notes"
})

Retrus.NoteList = Backbone.Collection.extend({
  model: Retrus.Note
});

Retrus.NoteView = Backbone.View.extend({
  tagName: 'li',
  initialize: function(options) {
    this.model.bind('change', this.render, this);
  },
  render: function() {
    $(this.el).html("<div><button class='btn success'>+1</button><button class='btn danger'>-1</button> " + this.model.get("text") + "</div>");
    return this;
  }
});

Retrus.NoteListView = Backbone.View.extend({
  tagName: 'ul',
  className: 'notes',
  initialize: function(options) {
    this.collection.each(this.addOne, this);
    this.collection.bind("add", this.addOne, this);
  },
  render: function() {
    return this;
  },
  addOne: function(note) {
    var view = new Retrus.NoteView({ model: note });
    $(this.el).append(view.render().el)
  },
  addAll: function() {
    this.collection.each(this.addOne, this)
  }
});

Retrus.AddNoteView = Backbone.View.extend({
  tagName: 'div',
  className: 'add-note modal hide fade',
  events: {
    "click .cancel": "close",
    "submit .add-note-form": "add"
  },
  add: function(event) {
    event.preventDefault();
    var el = $(this.el);
    new Retrus.Note({ body: $(event.target).find(".note-input").val()}).
      save({}, { error: function() {console.log("error")},
                 success: function() {console.log("success")}
                 });  
    el.modal('hide');
  },
  close: function(event) {
    event.preventDefault();
    $(this.el).modal('hide');
  },
  open: function() {
    var el = $(this.el);
    el.modal('show');
    el.find(".note-input").focus();
  },
  render: function() {
    var el = $(this.el);
    el.html('\
      <form class="add-note-form">\
        <div class="modal-header">\
          <a href="#" class="close">&times;</a>\
          <h3>Add Note to: ' + this.options.sectionName + '</h3>\
        </div>\
        <div class="modal-body">\
          <input class="note-input" type="text" />\
        </div>\
        <div class="modal-footer">\
          <input type="submit" class="btn primary add" value="Add" />\
          <button class="btn secondary cancel">Cancel</button>\
        </div>\
      </form>'
    );
    return this;
  }
});

Retrus.SectionView = Backbone.View.extend({
  tagName: 'div',
  className: 'section-row',
  events: {
    "click button": "addNote"
  },
  initialize: function() {
    this.noteListView = new Retrus.NoteListView({ collection: this.model.noteList });
    this.addNoteView = new Retrus.AddNoteView({ sectionName: this.model.get('name') });
  },
  addNote: function() {
    this.addNoteView.open();
  },
  render: function() {
    $(this.el).
      html("<button class='section' style='background-color: " + this.model.get("color") + "'>" + this.model.get("name") + "</button>").
      append(this.noteListView.render().el).
      append(this.addNoteView.render().el);
      
    return this;
  }
});

Retrus.SectionListView = Backbone.View.extend({
  initialize: function() {
    this.collection.bind("add",   this.addOne, this);
    // this.collection.bind("all",   this.render, this)
  },
  addOne: function(section) {
    var view = new Retrus.SectionView({ model: section });
    this.el.append(view.render().el)
  }
});

Retrus.Section = Backbone.Model.extend({
  defaults: {
    name: "",
    color: "#ffccaa"
  },
  initialize: function() {
    this.noteList = new Retrus.NoteList();
  }
});

Retrus.SectionList = Backbone.Collection.extend({
  model: Retrus.Section,
  initialize: function() {
    window.socket.on('addSection', _.bind(this.add, this));
  }
});

Retrus.App = Backbone.Router.extend({
  initialize: function() {
    this.sectionList = new Retrus.SectionList();
    this.sectionListView = new Retrus.SectionListView({ collection: this.sectionList, el: $("#sections-notes") });
  },
  routes: {
    "": "index",
    "/": "index"
  },
  index: function(actions){
    this.sectionListView.render();
  },
});

window.onload = function() {
  window.socket = new io.connect();
  window.app = new Retrus.App();
  Backbone.history.start();
}

