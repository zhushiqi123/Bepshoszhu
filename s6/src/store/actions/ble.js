export const START_SCAN = 'START_SCAN'
export const STOP_SCAN = 'STOP_SCAN'
export const DEVICE_CONNECTED = 'CONNECTED'
export const DEVICE_CONNECTING = 'CONNECTING'
export const DEVICE_DISCONNECT = 'DISCONNECTED'
export const DEVICE_FOUND = 'DEVICE_FOUND'
export const BLE_ON = 'BLE_ON'
export const BLE_OFF = 'BLE_OFF'

export var connected = mac => {
    return {
        type: DEVICE_CONNECTED,
        data: mac
    }
}
export var connecting = {
    type: DEVICE_CONNECTING
}
export var disconnect = {
    type: DEVICE_DISCONNECT
}
export var startScan = {
    type: START_SCAN
}
export var stopScan = {
    type: STOP_SCAN
}
export var bleOn = {
    type: BLE_ON
}
export var bleOff = {
    type: BLE_OFF
}