Component.new 'WindowTitle', 
  initialize: ->
    @listenTo App.queue, 'change:current_track', @render

  render: ->
    ct = App.queue.get('current_track')
    document.title = "#{ct.get('name')} by #{ct.get('artist')}"
    this
