import * as bleAction from '../actions/ble'
const defaultState = {
    scan: false,
    enable: false,
    connect: 0,
    connectMac: undefined
}
export default (state = defaultState, action) => {
    switch (action.type) {
        case bleAction.START_SCAN:
            return Object.assign({}, state, { scan: true })
        case bleAction.STOP_SCAN:
            return Object.assign({}, state, { scan: false })
        case bleAction.DEVICE_CONNECTED:
            return Object.assign({}, state, { connect: 1, connectMac: action.data })
        case bleAction.DEVICE_CONNECTING:
            return Object.assign({}, state, { connect: 2 })
        case bleAction.DEVICE_DISCONNECT:
            return Object.assign({}, state, { connect: 0, connectMac: undefined })
        case bleAction.BLE_ON:
            return Object.assign({}, state, { enable: true })
        case bleAction.BLE_OFF:
            return Object.assign({}, state, { enable: false })
        default:
            return state;
    }

}