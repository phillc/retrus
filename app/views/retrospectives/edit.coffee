@title = "Editing Retrospective"

partial "form"

contentFor "sidebar", ->
  header class: "widget header", ->
    h2 @retrospective.toLabel()