import * as ACT from '../actions/devicedata';
import { Map, List, OrderedMap } from 'immutable'
const defaultState = Map({
    connect: false,
    apptempU: 0,
    scanDevice: null,
    myDevices: Map(),
    temp: 400,
    nowTemp: 30,
    battery: 0,
    boot: false,
    tempMode: 0,
    gameMode: 0,
    hotMode: 0,
    lightMode: 0,
    light: 0,
    vibretion: 0,
    heattime: 0,
    batteryState: 0
});
export default function (state = defaultState, action) {
    switch (action.type) {
        case ACT.APP_TEMP_U:
            return state.set('apptempU', action.data);
        case ACT.APP_CONNECT:
            return state.set('connect', action.data);
        case 'bledata_find_device':
            return state.set('scanDevice', action.device);
        case ACT.CONNECT_STATE:
            return state.updateIn(['myDevices', action.mac], data => data.set('connect', action.state));
        case ACT.ADD_MYDEVICES:
            return state.updateIn(['myDevices'], data => data.set(action.device.get('mac'), action.device));
        case ACT.INIT_DEVICE:
            return state.set('myDevices', action.myDevices);
        case ACT.DELETE_MYDEVICES:
            return state.updateIn(['myDevices'], data => data.delete(action.mac));
        case ACT.CONNECT:
            break;
        case ACT.TEMP:
            return state.withMutations(state => {
                state.set('temp', action.data.temp)
                .set('tempMode', action.data.tempMode)
            })
        case ACT.NOW_TEMP:
            return state.withMutations(state => {
                state.set('nowTemp', action.data.nowTemp)
                    .set('tempMode', action.data.tempMode)
            })
        case ACT.BATTERY:
            return state.withMutations(state => {
                state.set('battery', action.data.battery)
                    .set('batteryState', action.data.batteryState)
            })
        case ACT.BOOT:
            return state.set('boot', action.data);
        case ACT.TEMP_MODE:
            return state.set('tempMode', action.data);
        case ACT.GAME_MODE:
            return state.set('gameMode', action.data);
        case ACT.HOT_MODE:
            return state.set('hotMode', action.data);
        case ACT.LIGHT_MODE:
            return state.set('lightMode', action.data);
        case ACT.LIGHT:
            return state.set('light', action.data);
        case ACT.VIBRETION:
            return state.set('vibretion', action.data);
        case ACT.BATTERY_STATE:
            return state.set('batteryState', action.data);
        case ACT.HEAT_TIME:
            return state.set('heattime', action.data);
        case ACT.ALL:
            return state.withMutations(state => {
                state.set('temp', action.data.temp)
                    .set('nowTemp', action.data.nowTemp)
                    .set('boot', action.data.boot)
                    .set('tempMode', action.data.tempMode)
                    .set('gameMode', action.data.gameMode)
                    .set('hotMode', action.data.hotMode)
                    .set('lightMode', action.data.lightMode)
                    .set('light', action.data.light)
                    .set('vibretion', action.data.vibretion)
                    .set('battery', action.data.battery)
                    .set('heattime', action.data.heattime)
            })
        default:
            return state;
    }
}