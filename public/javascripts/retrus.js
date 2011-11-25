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
  urlRoot: "note"
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
  // addAll: function() {
  //   this.collection.each(this.addOne, this)
  // }
});

Retrus.AddNoteView = Backbone.View.extend({
  tagName: 'div',
  className: 'add-note modal hide fade',
  events: {
    "click .cancel": "close",
    "submit .add-note-form": "add"
  },
  initialize: function(options) {
    this.section = options.section;
  },
  add: function(event) {
    event.preventDefault();
    var el = $(this.el);
    new Retrus.Note({ text: $(event.target).find(".note-input").val(),
                      sectionId: this.section.get('id') }).
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
          <h3>Add Note to: ' + this.section.get('name') + '</h3>\
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
    this.addNoteView = new Retrus.AddNoteView({ section: this.model });
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
  tagName: 'div',
  id: 'section-notes',
  initialize: function(sectionList) {
    this.collection = sectionList;
    this.collection.bind("add", this.addOne, this);
    this.collection.bind("reset", this.reset, this)
  },
  addOne: function(section) {
    var sectionView = new Retrus.SectionView({ model: section });
    $(this.el).append(sectionView.render().el)
  },
  reset: function(sections) {
    sections.each(this.addOne, this)
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
  url: "sections",
  initialize: function() {
    this.ioBind('create', function(){console.log('hi')}, this);
  }
});

Retrus.App = Backbone.Router.extend({
  routes: {
    "": "index",
    "/": "index"
  },
  index: function(actions){
    var sectionList = new Retrus.SectionList();
    var sectionListView = new Retrus.SectionListView(sectionList);
    $('#retrus').append(sectionListView.el);
    
    // For debug:
    window.sectionList = sectionList;
    
    sectionList.fetch();
  },
});

window.onload = function() {
  window.socket = new io.connect();
  window.app = new Retrus.App();
  Backbone.history.start();
}

