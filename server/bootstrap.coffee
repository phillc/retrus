Meteor.startup ->
  if Retrospectives.find().count() == 0
    Retrospectives.insert
      name: "Brainstorming current issues"
    Retrospectives.insert
      name: "Iteration 32 retrospective"
    Retrospectives.insert
      name: "Company outing ideas"
    Retrospectives.insert
      name: "Improvement roadmap"
