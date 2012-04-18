mongoose = require "mongoose"
mongoose.connect 'mongodb://localhost/retrus'

validatePresenceOf = (value) ->
  value && value.length > 0

Schema = mongoose.Schema

NoteSchema = new Schema({ text: String
                        , ups: Number
                        , downs: Number })

GroupSchema = new Schema({ name: String
                         , notes: [NoteSchema] })

SectionSchema = new Schema({ name: String
                           , color: String
                           , notes: [NoteSchema] })

RetrospectiveSchema = new Schema({ name: { type: String
                                         , validate: [validatePresenceOf, 'presence']
                                         , required: true
                                         }
                                 , private: { type: Boolean
                                            , default: false
                                            }
                                 , sections: [SectionSchema] })

# exports.Note = mongoose.model 'Note', NoteSchema
# exports.Group = mongoose.model 'Group', GroupSchema
# exports.Section = mongoose.model 'Section', SectionSchema
exports.Retrospective = mongoose.model 'Retrospective', RetrospectiveSchema

