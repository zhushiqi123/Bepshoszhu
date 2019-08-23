/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 * @flow
 */

import React, { Component } from 'react';
import {
    View,
    NativeModules,
    NativeEventEmitter,
    Platform
} from 'react-native';
import BleManager from 'react-native-ble-manager';
const BleManagerModule = NativeModules.BleManager;
const bleManagerEmitter = new NativeEventEmitter(BleManagerModule);
import { connect } from 'react-redux';
import * as bleAction from '../store/actions/ble'
import * as BleSDK from '../utils/bleSDK'
import * as devicDataAction from '../store/actions/devicedata'
@connect(state => ({
    connect: state.ble.connect
}))
export default class extends Component {
    constructor(props) {
        super(props);
    }

    connectMac = ''
    _isStw(args) {
        if (Platform.OS == 'android') {
            return BleSDK.isDevice(args.advertising.bytes.slice(5))
        } else {
            if (args.advertising.kCBAdvDataManufacturerData)
                return BleSDK.isDevice(args.advertising.kCBAdvDataManufacturerData.bytes)
            return false;
        }
    }
    componentDidMount() {
        BleManager.start({ showAlert: true });
        this.scanDeviceListener = bleManagerEmitter.addListener(
            'BleManagerDiscoverPeripheral',
            (args) => {
                if (this._isStw(args)) {
                    this.props.dispatch(bleAction.stopScan)
                    BleManager.connect(args.id)
                        .then(() => {
                            this.connectMac = args.id
                            this.props.dispatch(bleAction.connected(args.id))
                            BleManager.retrieveServices(args.id)
                                .then(pergipheralInfo => {
                                    BleManager.startNotification(args.id, '7aac6ac0-afca-11e1-9feb-0002a5d5c51b', 'aed04e80-afc9-11e1-a484-0002a5d5c51b')
                                        .then(() => { console.log('success') })
                                        .catch(e => { console.log('error', e) })
                                    setTimeout(() => {
                                        BleSDK.findAll()
                                    }, 800)
                                })
                            BleSDK.setWrite(data => {
                                BleManager.write(args.id, '7aac6ac0-afca-11e1-9feb-0002a5d5c51b', '19575ba0-b20d-11e1-b0a5-0002a5d5c51b', Array.from(data)).then(() => { })
                            })
                        })
                }
            }
        );
        this.deviceDisconnectedListener = bleManagerEmitter.addListener(
            'BleManagerDisconnectPeripheral',
            (args) => {
                this.connectMac = ''
                this.props.dispatch(bleAction.disconnect)
            }
        );
        this.bleStopScanListener = bleManagerEmitter.addListener(
            'BleManagerStopScan',
            (args) => {
                this.props.dispatch(bleAction.stopScan)
            }
        );
        this.bleEnableListener = bleManagerEmitter.addListener(
            'BleManagerDidUpdateState',
            (args) => {
                switch (args.state) {
                    case 'on':
                        this.props.dispatch(bleAction.bleOn)
                        break;
                    case 'off':
                        this.props.dispatch(bleAction.bleOff)
                        this.props.dispatch(bleAction.stopScan)
                        break;
                }
            }
        );
        this.dataNotifyListener = bleManagerEmitter.addListener(
            'BleManagerDidUpdateValueForCharacteristic',
            args => {
                if (args.peripheral == this.connectMac) {
                    if (args.value.length > 1) {
                        console.log(args.value)
                        this.props.dispatch(devicDataAction.parse(args.value))
                    }
                }
            }
        )
    }
    componentWillUnmount() {
        if (this.props.connect == 1) {
            BleManager.disconnect(this.connectMac).then(() => console.log('disconnected'))
        }
        this.scanDeviceListener.remove()
        this.bleStopScanListener.remove()
        this.deviceDisconnectedListener.remove()
        this.bleEnableListener.remove()
    }

    render() {
        return null
    }

}