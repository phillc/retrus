li class: "retrospective", ->
  header class: "header", ->
    h3 @retrospective.toLabel()
  dl class: "content", ->
    dt "Name:"
    dd @retrospective.get("name")
  footer class: "footer", ->
    menu ->
      menuItem "Edit", urlFor(@retrospective, action: "edit")
