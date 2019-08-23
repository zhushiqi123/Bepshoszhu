import { createStore } from 'redux'
import rootReducer from './reducers'
export default function () {
  const store = createStore(rootReducer)
  return store;
}
