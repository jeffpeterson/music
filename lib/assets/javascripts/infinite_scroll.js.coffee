InfiniteScroll =
  scroll: (event) ->
    time = event.timeStamp
    y = @el.scrollTop
    pixels_per_sec = 0

    if @previous_time and @previous_y
      pixels_per_sec = (y - @previous_y) / (time - @previous_time) * 500

      if y + pixels_per_sec >= (@el.scrollHeight - @el.offsetHeight)
        @collection.fetch()

    @previous_time = time
    @previous_y    = y


$(document).on 'scroll', '.infinite-scroll', (event) ->
  InfiniteScroll.scroll(event)

