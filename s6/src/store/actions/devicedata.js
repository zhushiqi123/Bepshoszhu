let Buffer = require('buffer/').Buffer;
export const INIT_DEVICE = 'bledata_init_device';
export const ADD_MYDEVICES = 'bledata_add_my_devices';
export const DELETE_MYDEVICES = 'bledata_delete_my_devices';
export const APP_CONNECT = 'bledata_app_connect';
export const CONNECT_STATE = 'bledata_connect_state';
export const APP_TEMP_U = 'bledata_app_temp_u';

export const TEMP = 'bledata_temp';
export const NOW_TEMP = 'bledata_now_temp';
export const BATTERY = 'bledata_battery';
export const BATTERY_STATE = 'bledata_battery_state';
export const BOOT = 'bledata_boot';
export const TEMP_MODE = 'bledata_temp_mode';
export const GAME_MODE = 'bledata_game_mode';
export const HOT_MODE = 'bledata_hot_mode';
export const LIGHT_MODE = 'bledata_light_mode';
export const LIGHT = 'bledata_light';
export const VIBRETION = 'bledata_vibretion';
export const HEAT_TIME = 'bledata_heat_time';
export const ALL = 'bledata_all';

export const setAppTempU = d => {
    return {
        type: APP_TEMP_U,
        data: d
    }
}

export const setConnectState = (mac, state) => {
    return {
        type: CONNECT_STATE,
        mac: mac,
        state: state
    }
}


export let deleteMyDevices = mac => {
    global.storage.remove({
        key: 'mydevices',
        id: mac
    })
    return {
        type: DELETE_MYDEVICES,
        mac: mac
    }
}
export let setTemp = (u, v) => {
    return {
        type: TEMP,
        data: {
            tempMode: u,
            temp: v
        }
    }
}
export let setNowTemp = (u, v) => {
    return {
        type: NOW_TEMP,
        data: {
            tempMode: u,
            nowTemp: v
        }
    }
}
export let setBattery = (battery, state) => {
    return {
        type: BATTERY,
        data: {
            battery: battery,
            state: state
        }
    }
}
export let setBatteryState = data => {
    return {
        type: BATTERY_STATE,
        data: data
    }
}
export let setBoot = data => {
    return {
        type: BOOT,
        data: data
    }
}
export let setTempMode = data => {
    return {
        type: TEMP_MODE,
        data: data
    }
}
export let setGameMode = data => {
    return {
        type: GAME_MODE,
        data: data
    }
}
export let setHotMode = data => {
    return {
        type: HOT_MODE,
        data: data
    }
}
export let setLightMode = data => {
    return {
        type: LIGHT_MODE,
        data: data
    }
}
export let setLight = data => {
    return {
        type: LIGHT,
        data: data
    }
}
export let setVibretion = data => {
    return {
        type: VIBRETION,
        data: data
    }
}

let setHeatTime = data => {
    return {
        type: HEAT_TIME,
        data: data
    }
}

let setAll = data => {
    return {
        type: ALL,
        data: data
    }
}
export let parse = data => {
    // let s = new Buffer(data, "base64").toString('hex');
    // let bb = str2bytes(s);
    let bb = data;
    // if (bb[1] != 1)
    switch (bb[1]) {
        case 0x01:
            return setNowTemp(bb[3], bb[4] * 256 + bb[5]);
        case 0x02:
            if (bb[3] != 0xff && bb[3] != 0xee)
                return setTemp(bb[3], _switchTemp(bb[3], bb[4] * 256 + bb[5]));
            return {
                type: 0
            }
        case 0x03:
            return setBattery(bb[4], bb[3]);
        case 0x04:
            switch (bb[3]) {
                case 0:
                    return setBoot(true);
                case 1:
                    return setBoot(false);
            }
        case 0x08:
            return setHeatTime((bb[3] * 256 + bb[4]) / 60);
        case 0x0b:
            return setLight(bb[3]);
        case 0x0f:
            if (bb[3] == 0)
                return setAll({
                    tempMode: bb[4],
                    temp: _switchTemp(bb[4], bb[5] * 256 + bb[6]),
                    nowTemp: bb[7] * 256 + bb[8],
                    boot: bb[9] == 0 ? true : false,
                    battery: bb[10],
                    heattime: (bb[11] * 256 + bb[12]) / 60
                })
            else
                return {
                    type: 'null'
                }
    }
    return {
        type: 0
    }
}
function _switchTemp(u, v) {
    if (u == 0)
        return v * 1.8 + 32 - 0.5
    else
        return v
}

/**
 * @param {string} str 
 */
let str2bytes = str => {
    let bb = [];
    for (let i = 0; i < str.length / 2; i++) {
        bb[i] = digit(str.charCodeAt(2 * i)) * 16 + digit(str.charCodeAt(i * 2 + 1));
    }
    return bb;
}

let digit = codePoint => {
    let result = -1;
    if (48 <= codePoint && codePoint <= 57) {
        result = codePoint - 48;
    } else if (65 <= codePoint && codePoint <= 90) {
        result = 10 + (codePoint - 65);
    } else if (97 <= codePoint && codePoint <= 122) {
        result = 10 + (codePoint - 97);
    }
    return result;
}