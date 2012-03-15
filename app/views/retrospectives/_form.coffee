formFor @retrospective, (f) ->
  f.fieldset (fields) ->
    fields.field "name", as: "string"
  f.fieldset (fields) ->
    fields.submit "Submit"
