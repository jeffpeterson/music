#= require track/show.js
#= require ./show.jst

class App.QueueTrackShow extends App.TrackView
  template: JST['queue/track/show']
  events:
    'click .album-art': 'play'
    'dragstart': 'drag'
    'drop': 'drop'
    'click .remove': 'remove'

  render: ->
    @$el.html @template(track: @model)
    @model.set icon: @model.get('icon').replace("square-200", "square-500")

    if @model is App.queue.current_track()
      @$el.attr id: "current-track"

      ImageAnalyzer @model.get('icon'), (bgColor, primaryColor, secondaryColor, detailColor) =>
        window.extraStyle?.remove()
        window.extraStyle = $style = $("<style>")
        $style.html """
            #current-track .text {
              background-image: -webkit-linear-gradient(bottom, rgba(#{bgColor}, 0), rgba(#{bgColor}, 1));
              background-image: linear-gradient(to top, rgba(#{bgColor}, 0), rgba(#{bgColor}, 1));
              text-shadow: 0 0 1px rgb(#{bgColor}), 0 0 3px rgb(#{bgColor});
            }
            #queue .track {
              background-color: rgb(#{bgColor});
            }
            #queue .text {
              color: rgb(#{primaryColor});
            }
            #queue .artist-name {
              color: rgb(#{secondaryColor});
            }
        """
        $(document.body).append $style
    this

  play: (event) ->
    event.preventDefault()
    App.queue.play(@model)

  drop: (event) =>
    event.preventDefault()

    data = event.originalEvent.dataTransfer.getData("text/json")
    @model.collection.add JSON.parse(data),
      at: @model.collection.indexOf(@model)

  remove: (event) =>
    event.preventDefault()
    @model.collection.remove @model
