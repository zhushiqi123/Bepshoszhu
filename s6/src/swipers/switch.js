import React, { Component } from 'react';
import {
    View,
    Text,
    Image
} from 'react-native';
import MeterView from '../componet/colormeter'
import ArrowButton from '../componet/arrowbutton'
import { connect } from 'react-redux';
import * as dataAction from '../store/actions/devicedata'
import * as BleSDK from '../utils/bleSDK'
const mv1 = {
    minValue: 300,
    maxValue: 435,
    unit: "℉",
}
const mv2 = {
    minValue: 149,
    maxValue: 224,
    unit: "℃",
}
let w110, w100, w280, w310, w350, w80, w70, w25, w16;
@connect(state => ({
    temp: state.devicedata.get('temp'),
    tempMode: state.devicedata.get('tempMode'),
}))
export default class extends Component {
    _changeUnit() {
        if (this.props.tempMode == 1) {
            BleSDK.setTempMode(0)
            this.props.dispatch(dataAction.setTempMode(0))
        }
        else {
            BleSDK.setTempMode(1)
            this.props.dispatch(dataAction.setTempMode(1))
        }
    }
    _meterValueChange(v) {
        BleSDK.setTemp(this.props.tempMode, v)
        if (this.props.tempMode == 1) {
            this.props.dispatch(dataAction.setTemp(1, v))
        }
        else {
            this.props.dispatch(dataAction.setTemp(0, v * 1.8 + 32))
        }
    }
    _fineTune(value) {
        let s = 0;
        if (this.props.tempMode == 1) {
            s = this.props.temp + value;
            s = this._rangeValue(s);
            this.props.dispatch(dataAction.setTemp(1, s))
            BleSDK.setTemp(this.props.tempMode, s)

        } else {
            s = this.props.temp + value * 1.8;
            s = this._rangeValue(s);
            this.props.dispatch(dataAction.setTemp(0, s))
            BleSDK.setTemp(this.props.tempMode, parseInt((s - 32) / 1.8 + 0.5))
        }

    }
    _rangeValue(v) {
        if (v < mv1.minValue) return mv1.minValue;
        if (v > mv1.maxValue) return mv1.maxValue;
        return v;
    }

    componentWillMount() {
        let screenWidth = this.props.width;
        w110 = screenWidth * 0.27;//280
        w100 = screenWidth * 0.24;//280
        w280 = screenWidth * 0.68;//280
        w310 = screenWidth * 0.75;//300
        w350 = screenWidth * 0.85;//300
        w80 = screenWidth * 0.19;//80
        w70 = screenWidth * 0.17;//80
        w25 = screenWidth * 0.06;//80
        w16 = screenWidth * 0.04;//80
    }

    render() {
        return (
            <View
                style={{
                    alignItems: 'center',
                    justifyContent: 'center',
                    flex: 1,
                    flexDirection: this.props.portrait ? 'column' : 'row'
                }}
            >
                <View
                    style={{
                        height: w350,
                        width: w310,
                        position: "absolute",

                    }}
                >
                    <Image
                        style={{
                            height: w310,
                            width: w310,
                        }}
                        resizeMode="stretch"
                        source={require('../images/cricel.png')}
                    />
                </View>
                <View style={{ flex: 1 }} />
                <View
                    style={{
                        alignItems: 'center',
                        justifyContent: 'center',
                    }}
                >
                    <MeterView
                        onValueChange={v => this._meterValueChange(v)}
                        value={this.props.tempMode == 0 ? ((this.props.temp - 32) / 1.8) : this.props.temp}
                        ref={r => this.meter1 = r}
                        valueconfig={this.props.tempMode == 0 ? mv2 : mv1}
                        style={{ height: w280, width: w280 }} />
                    <MeterView
                        onPress={() => this._changeUnit()}
                        changeValue={false}
                        value={this.props.tempMode == 1 ? ((this.props.temp - 32) / 1.8) : this.props.temp}
                        valueconfig={this.props.tempMode == 0 ? mv1 : mv2}
                        style={{ height: w110, width: w110, marginTop: -w70 }} />
                </View>
                <View
                    style={{
                        flex: 1,
                        width: '60%',
                        height: '60%',
                        justifyContent: 'space-between',
                        flexDirection: this.props.portrait ? 'row' : 'column',
                        paddingLeft: this.props.portrait ? 0 : 0
                    }}
                >
                    <ArrowButton left onPress={() => this._fineTune(-1)} width={this.props.width} />
                    <ArrowButton onPress={() => this._fineTune(1)} width={this.props.width} />
                </View>
            </View >
        );
    }
}