describe 'Search', ->
  before (done)->
    casper.start('http://localhost:3000/')
    casper.waitFor ->
      @evaluate(-> document.querySelectorAll('.movie_item').length is 10)

  context 'When you search for something', ->
    before ->
      casper.then ->
        @fill 'form'
          'search': 'star wars'
        , false
        @mouseEvent('keyup', '#search');

    it 'loads new results', ->
      casper.waitFor ->
        @evaluate(-> $('.movie_item:first-child h1').text() is 'Star Wars: Episode III - Revenge of the Sith 3D')

  describe 'Infinite Scrolling', ->
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