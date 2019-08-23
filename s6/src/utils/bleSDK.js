
var Buffer = require('buffer').Buffer;
const hex = ['0', '1', '2', '3', '4', '5', '6', '7',
    '8', '9', 'A', 'B', 'C', 'D', 'E', 'F'];
const CHECK_SUM = 0xa6;
const HEAD = 0xa8;
const KEY = [0x0d, 0x8c, 0xc8, 0xa2, 0x2c, 0xf8, 0x5e, 0x8e, 0xaf, 0xd6, 0x82, 0xcd, 0x6, 0x5b, 0xe4, 0xb8, 0xa6, 0xd0, 0x30, 0xba];

let write;
import utf2byte from './utf2byte.js';
/**
 * 加密
 * @param {Uint8Array} data 
 */
let encrypt = (data) => {
    for (let i = 0; i < data.byteLength; i++) {
        if (data[i] != 0 &&
            data[i] != 0xff &&
            (data[i] ^ KEY[i]) != 0xff &&
            data[i] != KEY[i]) {
            data[i] ^= KEY[i];
        }
        var temp = data[i];

        if (temp == 0x00 || temp == 0x40 || temp == 0x80 || temp == 0xc0) {
            /* 0x80 0x00不需要操作 */
        } else if (temp > 0x00 && temp < 0x40) {
            data[i] = temp + 0x80;
        } else if (temp > 0x40 && temp < 0x80) {
            data[i] = temp + 0x80;
        } else if (temp > 0x80 && temp < 0xc0) {
            data[i] = temp - 0x40;
        } else {
            /* temp > 0xc0 */
            data[i] = temp - 0xc0;
        }
    }
}

/**
 * 校验
 * @param {ArrayBuffer} data 
 */
let checkData = data => {
    let b = CHECK_SUM;
    let s = new Uint8Array(data);
    for (let i = 0; i < s.length; i++) {
        b ^= s[i];
    }
    return b;
}

/**
 * 
 * @param {number} command 指令 
 * @param {ArrayBuffer} data 数据
 */
let sendData = (command, data) => {
    let arr = new Uint8Array(data.byteLength + 4);
    arr.set(new Uint8Array(data), 3);
    let dataView = new DataView(arr.buffer);
    dataView.setUint8(0, HEAD);
    dataView.setUint8(1, command);
    dataView.setUint8(2, data.byteLength + 4);
    dataView.setUint8(data.byteLength + 3, checkData(data));//校验
    // encrypt(arr);//加密
    console.log('write', ab2Str(arr));
    if (write)
        // write(new Buffer(ab2Str(arr), 'hex').toString('base64'))
        write(arr)
}



/**
 * ArrayBuffer=>String
 * @param {ArrayBuffer} buf 
 */
let ab2Str = buf => {
    let str = '';
    let data = new Uint8Array(buf);
    for (let i = 0; i < buf.byteLength; i++) {

        str += hex[data[i] >> 4];
        str += hex[data[i] & 0xf];
    }
    return str;
}

/**
 * String=>ArrayBuffer
 * @param {string} str 
 */
let str2ab = str => {
    let buf = new ArrayBuffer(str.length * 2); // 每个字符占用2个字节
    let bufView = new Uint16Array(buf);
    for (let i = 0, strLen = str.length; i < strLen; i++) {
        bufView[i] = str.charCodeAt(i);
    }
    return buf;
}

/**
 * @param {string} str
 */
let str2byte = str => {
    let data = [];
    for (let i = 0; i < str.length / 2; i++) {
        data[i] = parseInt(str.charAt(i * 2), 16) * 16 + parseInt(str.charAt(i * 2 + 1), 16);
    }
    return data;
}
export let setWrite = w => {
    write = w;
};

export let isDevice = data => {
    // let s = str2byte(new Buffer(data, "base64").toString('hex'));
    let s = data
    if (s != undefined && s.length > 3)
        if (s[0] == 0x53 && s[1] == 0x36 && s[2] == 0x36)
            return true;
    return false;
}

export let getColor = data => {
    let s = str2byte(new Buffer(data, "base64").toString('hex'));
    if (s[10])
        return s[10];
    return 1;
}

/*********************************************设置**********************************************/


export let setTemp = (u, value) => {
    let buf = new ArrayBuffer(3);
    let dataView = new DataView(buf);
    dataView.setUint8(0, u);
    dataView.setUint16(1, value);
    sendData(0x02, buf);
}
export let findTemp = () => {
    let buf = new ArrayBuffer(3);
    let dataView = new DataView(buf);
    dataView.setUint16(1, 0xfd);
    sendData(0x02, buf);
}
export let findBattery = () => {
    let buf = new ArrayBuffer(1);
    dataView.setUint16(0, 0xfd);
    sendData(0x03, buf);
}
export let setBoot = value => {
    let buf = new ArrayBuffer(1);
    let dataView = new DataView(buf);
    dataView.setUint8(0, value ? 0 : 1);
    sendData(0x04, buf);
}
export let findBoot = () => {
    let buf = new ArrayBuffer(1);
    dataView.setUint16(0, 0xfd);
    sendData(0x04, buf);
}

export let setTempMode = value => {
    let buf = new ArrayBuffer(1);
    let dataView = new DataView(buf);
    dataView.setUint8(0, value);
    sendData(0x05, buf);
}
export let findTempMode = () => {
    let buf = new ArrayBuffer(1);
    dataView.setUint16(0, 0xfd);
    sendData(0x05, buf);
}
export let setName = name => {
    sendData(0x07, utf2byte(name).buffer);
}
export let setGameMode = value => {
    let buf = new ArrayBuffer(1);
    let dataView = new DataView(buf);
    dataView.setUint8(0, value);
    sendData(0x08, buf);
}
export let findGameMode = () => {
    let buf = new ArrayBuffer(1);
    dataView.setUint16(0, 0xfd);
    sendData(0x08, buf);
}
export let setHotMode = value => {
    let buf = new ArrayBuffer(1);
    let dataView = new DataView(buf);
    dataView.setUint8(0, value);
    sendData(0x09, buf);
}
export let findHotMode = () => {
    let buf = new ArrayBuffer(1);
    dataView.setUint16(0, 0xfd);
    sendData(0x09, buf);
}
export let setLightMode = value => {
    let buf = new ArrayBuffer(1);
    let dataView = new DataView(buf);
    dataView.setUint8(0, value);
    sendData(0x0a, buf);
}
export let findLightMode = () => {
    let buf = new ArrayBuffer(1);
    dataView.setUint16(0, 0xfd);
    sendData(0x0a, buf);
}
export let setLight = value => {
    let buf = new ArrayBuffer(1);
    let dataView = new DataView(buf);
    dataView.setUint8(0, value);
    sendData(0x0b, buf);
}
export let findLight = () => {
    let buf = new ArrayBuffer(1);
    dataView.setUint16(0, 0xfd);
    sendData(0x0b, buf);
}
export let setVibration = value => {
    let buf = new ArrayBuffer(1);
    let dataView = new DataView(buf);
    dataView.setUint8(0, value);
    sendData(0x0c, buf);
}
export let findVibration = () => {
    let buf = new ArrayBuffer(1);
    dataView.setUint16(0, 0xfd);
    sendData(0x0c, buf);
}
export let findAll = () => {
    let buf = new ArrayBuffer(1);
    let dataView = new DataView(buf);
    dataView.setUint8(0, 0xfd);
    sendData(0x0f, buf);
}
/**
 * 设置时间
 */
export let setTime = () => {
    let buf = new ArrayBuffer(7);
    let dataView = new DataView(buf);
    let date = new Date();
    dataView.setUint16(0, date.getFullYear());
    dataView.setUint8(2, date.getMonth() + 1);
    dataView.setUint8(3, date.getDate());
    dataView.setUint8(4, date.getHours());
    dataView.setUint8(5, date.getMinutes());
    dataView.setUint8(6, date.getSeconds());
    sendData(0x06, buf);
}