Meteor.startup ->
  if Retrospectives.find().count() == 0
    retrospective1 = Retrospectives.insert
      name: "Try me!!"
    for name in ["Click Add!", "Other people see the same board", "Facilitators add sections", "Click above to see facilitation view", "How are you doing?"]
      section_id = Sections.insert
        retrospective_id: retrospective1
        name: name
      for body in ["Random", "More stuff", "Down with it!!"]
        Items.insert
          body: body
          section_id: section_id
          agree: 1
          disagree: 0

    retrospective2 = Retrospectives.insert
      name: "Retrus development feedback"
    for name in ["Feature requests", "Problems", "Bugs", "Ideas", "Say Hello"]
      Sections.insert
        retrospective_id: retrospective2
        name: name

