tableFor "retrospectives", (t) ->
  t.head ->
    t.row ->
      t.header "name", sort: true
  t.body ->
    for retrospective in @retrospectives
      t.row ->
        t.cell -> retrospective.get("name")
        t.cell -> 
          linkTo 'Show', urlFor(retrospective)
          span "|"
          linkTo 'Edit', urlFor(retrospective, action: "edit")
          span "|"
          linkTo 'Destroy', urlFor(retrospective), "data-method": "delete"
  t.foot ->
    t.row ->
      t.cell colspan: 4, ->
        linkTo 'New Retrospective', urlFor(App.Retrospective, action: "new")

