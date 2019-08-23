import { combineReducers } from 'redux';
import test from './test';
import ble from './ble';
import devicedata from './devicedata';
export default combineReducers({
    test, ble, devicedata
});
