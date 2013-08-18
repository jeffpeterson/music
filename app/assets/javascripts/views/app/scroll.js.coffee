class App.Views.Scroll extends Backbone.View
  el: window
  events:
    scroll: (event) ->
      @total_height      = document.body.scrollHeight
      @y                 = window.scrollY + document.body.clientHeight
      @seconds           = new Date() / 1000
      if @previous_y? and @previous_seconds?
        @pixels_per_second = (@y - @previous_y) / (@seconds - @previous_seconds)

        if @pixels_per_second * 1 > @total_height - @y
          App.trigger 'infinite-scroll', @pixels_per_second

      @previous_y       = @y
      @previous_seconds = @seconds
