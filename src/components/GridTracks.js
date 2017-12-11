import {css} from 'lib'
import Base from './Base'
import GridTrack from './GridTrack'
import Grid from './Grid'

export default ({tracks, tab, dispatch}) =>
    <Grid dispatch={dispatch} tab={tab}>
      {tracks.map(track =>
        <GridTrack track={track} dispatch={dispatch} key={track.id} />
      )}
    </Grid>

