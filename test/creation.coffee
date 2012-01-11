tobi = require 'tobi'
app = require '../app'

describe 'creation of a retro', ->

  before ->
    @browser = tobi.createBrowser(app)
    
  describe 'with no name', ->
  
    it 'should re-render the creation form', (done) ->
      @browser.get '/', (res, $) -> 
        $('form#retro-create')
          .submit (res, $) ->
            res.should.have.status 200
            $('form#retro-create').should.have.length(1)
            done()
            
    it 'should not create the retro', ->
      #$(that).should.have.length(0)

    it 'should render the error', ->
      
          
  it 'should redirect to the director\'s view'
  it 'should show on the index'
          
