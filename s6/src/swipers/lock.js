import React, { Component } from 'react';
import {
    View,
    Text,
    Image,
    TouchableWithoutFeedback
} from 'react-native';
import MeterView from '../componet/animmeter'
import { connect } from 'react-redux';
import LottieView from 'lottie-react-native';
import { Animated } from 'react-native';
import * as dataAction from '../store/actions/devicedata'
import * as BleSDK from '../utils/bleSDK'
let w280, w310, w60, w90, w80;
@connect(state => ({
    lock: state.devicedata.get('boot'),
}))
export default class extends Component {
    nowLock = false
    constructor(props) {
        super(props);
        this.state = {
            progress: new Animated.Value(0),
        };
    }
    componentWillUpdate(nextProps, nextState) {
        if (nextProps.lock != this.nowLock) {
            // if (nextProps.lock) {
            //     this._lock()
            // } else {
            //     this._unlock()
            // }
            this.state.progress.setValue(0.5)
        }
    }


    _click() {
        if (this.props.lock) {
            this.nowLock = false
            this._unlock()
            BleSDK.setBoot(false)
        } else {
            this.nowLock = true
            this._lock()
            BleSDK.setBoot(true)
        }
    }

    _lock() {
        this.state.progress.setValue(0)
        Animated.timing(this.state.progress, {
            toValue: 0.5,
            duration: 1000,
        }).start();
    }

    _unlock() {
        this.state.progress.setValue(0.5)
        Animated.timing(this.state.progress, {
            toValue: 1,
            duration: 1000,
        }).start();
    }

    componentWillMount() {
        let screenWidth = this.props.width;
        w280 = screenWidth * 0.68;//280
        w310 = screenWidth * 0.75;//300
        w60 = screenWidth * 0.15;//90
        w90 = screenWidth * 0.22;//90
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
                        point={false}
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
                                height: w90,
                                width: w60,
                            }}
                        >
                            <LottieView
                                progress={this.state.progress}
                                source={require('../images/lock.json')}
                                style={{
                                    height: w90,
                                    width: w60,
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