class window.BetterRouter extends Backbone.Router
  swap: (new_view) ->
    return if new_view is @view

    old_view = @view
    @view    = new_view
    $el      = $(@el)

    if old_view
      old_view.out?()
      old_view.$el.queue (next) ->
        old_view.leave?()
        new_view.render()
        $el.html new_view.el
        new_view.in?()
        next()
    else
      new_view.render().in?()
      $el.html new_view.el
