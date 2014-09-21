describe 'InTheaters', ->
  before (done)->
    casper.start('http://localhost:3000/')

  it 'contains a header', ->
    casper.then ->
      'body > header'.should.be.inDOM

  it 'contains a title', ->
    casper.then ->
      'body > header h1'.should.be.inDOM

  it 'contains a search box', ->
    casper.then ->
      '#search'.should.be.inDOM

  it 'contains a movie list', ->
    casper.then ->
      '#list'.should.be.inDOM

  it 'contains 0 movies at first', ->
    casper.then ->
      num = @evaluate -> document.querySelectorAll('.movie_item').length
      expect(num).to.equal(0)

  it 'then loads 10 movies', ->
    casper.waitFor ->
      @evaluate( -> document.querySelectorAll('.movie_item').length ) >= 10

  describe 'Infinite Scrolling', ->
    before ->
      casper.start('http://localhost:3000/')
      casper.waitFor ->
        @evaluate(-> document.querySelectorAll('.movie_item').length is 10)

    context 'When you scroll to the bottom', ->
      before ->
        casper.then ->
          @scrollToBottom()

      it 'shows the "loading" div', ->
        casper.waitFor ->
          @evaluate -> $('footer').hasClass('show')

      it 'loads another 10 movies', ->
        casper.waitFor ->
          @evaluate(-> document.querySelectorAll('.movie_item').length is 20)

  describe 'Movie Info', ->
    before ->
      casper.start('http://localhost:3000/')
      casper.waitFor ->
        @evaluate(-> document.querySelectorAll('.movie_item').length is 10)
      casper.then ->
        @click('.movie_item:first-child')

    it 'shows a loading overlay', ->
      casper.waitFor ->
        @evaluate(-> $('.movie_item:first-child .overlay').length is 1)

    it 'shows extra details', ->
      casper.waitFor ->
        @evaluate(-> $('.movie_item:first-child').hasClass('details') )
      casper.then ->
        expect(@evaluate(-> $('.movie_item:first-child').children('.director') )).to.have.length(1)
        expect(@evaluate(-> $('.movie_item:first-child').children('.similar') )).to.have.length(1)
        expect(@evaluate(-> $('.movie_item:first-child').children('.reviews') )).to.have.length(1)