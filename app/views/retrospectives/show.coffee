@title = "Retrospective #{@retrospective.toLabel()}"

dl class: "content", ->
  dt "Name:"
  dd @retrospective.get("name")
