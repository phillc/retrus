nohm = require("nohm").Nohm
module.exports = nohm.model 'Retrospective',
    properties:
      name:
        type: 'string'
        validations: [ "notEmpty" ]
      private:
        type: 'bool'
        defaultValue: false


