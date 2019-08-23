import React, { Component } from 'react';
import {
    View,
    Text,
    Image,
    TouchableWithoutFeedback,
    Platform,
    PermissionsAndroid
} from 'react-native';
import MeterView from '../componet/animmeter'
import { connect } from 'react-redux';
import LottieView from 'lottie-react-native';
import { Animated } from 'react-native';
import * as bleAction from '../store/actions/ble'
import BleManager from 'react-native-ble-manager';
import * as BleSDK from '../utils/bleSDK'
let w80, w310, w280;
@connect(state => ({
    scan: state.ble.scan,
    enable: state.ble.enable,
    connect: state.ble.connect,
    connectMac: state.ble.connectMac
}))
export default class extends Component {
    constructor(props) {
        super(props);
        this.state = {
            progress: new Animated.Value(0),
            locationPermission: false
        };
    }
    componentWillUpdate(nextProps, nextState) {
        if (nextProps.scan != this.props.scan) {
            if (nextProps.scan) {

            } else {
                this._stopScan()
            }
        }
        if (nextProps.connect != this.props.connect) {
            switch (nextProps.connect) {
                case 0:
                    this._disconnect()
                    break;
                case 1:
                    if (this.props.connect != 1)
                        this._connected();
                    break;
                case 2:
                    break;
            }
        }
        if (nextProps.enable != this.props.enable) {
            if (nextProps.enable) {
                this._startScan(true);
            } else {
                this._stopScan();
            }
        }
    }

    componentDidMount() {
        this.state.progress.addListener(v => {
            if (v.value == 1) {
                if (this.props.scan) {
                    this.state.progress.setValue(0)
                    Animated.timing(this.state.progress, {
                        toValue: 1,
                        duration: 2000,
                    }).start();
                } else {
                    this.state.progress.setValue(0)
                    Animated.timing(this.state.progress, {
                        toValue: 0.5,
                        duration: 1000,
                    }).start();
                }
            }
        })
        BleManager.checkState();
    }
    _click() {
        if (this.props.scan) {
            this.meter.stopAroundAnim()
            this.props.dispatch(bleAction.stopScan)
        } else {
            if (this.props.connect != 1) {
                this._startScan()
            }
        }
    }
    async _startScan(v = this.props.enable) {
        if (v) {
            if (await this._reuqestLocation()) {
                BleManager.scan([], 180, true)
                    .then(() => {
                        console.log('Scan started');
                    })
                this.meter.startAroundAnim()
                this.state.progress.setValue(0);
                Animated.timing(this.state.progress, {
                    toValue: 1,
                    duration: 2000,
                }).start();
                this.props.dispatch(bleAction.startScan)
            }
        } else {
            await this._enableBle()
        }
    }

    _stopScan() {
        BleManager.stopScan()
            .then(() => {
                // Success code
                console.log('Scan stopped');
            });
        this.meter.stopAroundAnim()
    }

    _connected() {
        this.meter.startColorAnim()
        this.state.progress.setValue(0);
        Animated.timing(this.state.progress, {
            toValue: 0.5,
            duration: 2000,
        }).start();
    }

    _disconnect() {
        this.meter.cleanColorAnim()
        this._startScan()
    }

    _enableBle() {
        return new Promise((resolve, reject) => {
            if (Platform.OS === 'android') {
                BleManager.enableBluetooth()
                    .then(() => {
                        resolve(true);
                    })
                    .catch((error) => {
                        resolve(false);
                    });
            } else {
                resolve(true);
            }
        })
    }

    _reuqestLocation() {
        return new Promise((resolve, reject) => {
            if (Platform.OS === 'android' && Platform.Version >= 23) {
                PermissionsAndroid.check(PermissionsAndroid.PERMISSIONS.ACCESS_COARSE_LOCATION).then((result) => {
                    if (result) {
                        resolve(true);
                    } else {
                        PermissionsAndroid.request(PermissionsAndroid.PERMISSIONS.ACCESS_COARSE_LOCATION).then((result) => {
                            switch (result) {
                                case "granted":
                                    resolve(true);
                                    break;
                                case "denied":
                                    resolve(false);
                                    break;
                                case "never_ask_again":
                                    Alert.alert(
                                        'Android 6 need location permission',
                                        'Please open the location permission in system management',
                                        [
                                            { text: 'OK', onPress: () => { } },
                                        ]
                                    )
                                    break;
                            }
                        });
                    }
                });
            } else
                resolve(true);
        });

    }

    componentWillMount() {
        let screenWidth = this.props.width;
        w280 = screenWidth * 0.68;//280
        w310 = screenWidth * 0.75;//310
        w80 = screenWidth * 0.19;//80
    }

    render() {

        return (
            <View
                style={{
                    alignItems: 'center',
                    justifyContent: 'center',
                    flex: 1
                }}
            >
                <View
                    style={{
                        height: w310,
                        width: w310,
                        alignItems: 'center',
                        justifyContent: 'center'
                    }}
                >
                    <Image
                        style={{
                            position: "absolute",
                            height: w310,
                            width: w310
                        }}
                        resizeMode="stretch"
                        source={require('../images/cricel.png')}
                    />
                    <MeterView
                        valueconfig={{
                            startAngle: 0,
                            sweepAngle: 360,
                        }}
                        point={this.props.connect == 0}
                        ref={r => this.meter = r}
                        changeValue={false}
                        style={{ height: w280, width: w280 }} />
                    <View
                        style={{
                            position: "absolute",
                            alignItems: 'center',
                            alignContent: 'center',
                            justifyContent: 'center',
                        }}
                    >
                        <View
                            style={{
                                height: w80,
                                width: w80,
                            }}
                        >
                            <LottieView
                                source={require('../images/connect.json')}
                                progress={this.state.progress}
                                style={{
                                    height: w80,
                                    width: w80,
                                }} />
                        </View>
                    </View>
                    <TouchableWithoutFeedback
                        onPress={() => this._click()}
                    >
                        <View
                            style={{
                                height: w310,
                                width: w310,
                                position: "absolute",
                            }}
                        />
                    </TouchableWithoutFeedback>
                </View>
            </View>

        );
    }
}