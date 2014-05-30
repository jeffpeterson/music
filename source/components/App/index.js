import React         from '../../libs/react-0.10.0.min';
import Header        from '../Header';
import Collection    from '../Collection';
import HeavyRotation from '../HeavyRotation';

var routes = {
  'collection': Collection,
  'heavy-rotation': HeavyRotation,
  '': Collection
};

var Body = routes[window.location.hash]();

export default React.createComponent({
  render: function() {

    return D.div({className: 'App'},
      Body(),
      Queue(),
      Header()
    );
  }
});
