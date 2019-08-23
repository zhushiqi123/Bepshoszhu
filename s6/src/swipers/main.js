import React, { Component } from 'react';
import {
    View,
    Text,
    Image
} from 'react-native';
import MeterView from '../componet/bluemeter'
import { connect } from 'react-redux';
const v1 = {
    minValue: 0,
    maxValue: 5,
    startAngle: 180,
    sweepAngle: 145,
    unit: "min",
    mSection: 5,
    format: "0.0"
}
const v2 = {
    minValue: 0,
    maxValue: 5,
    startAngle: 270,
    sweepAngle: 145,
    unit: "min",
    mSection: 5,
    format: "0.0"
}
const mv1 = {
    minValue: 0,
    maxValue: 450,
    unit: "℉",
}
const mv2 = {
    minValue: 0,
    maxValue: 224,
    unit: "°C",
}
let w230, w260, w250, w270, w280, w300, w110, w100, w60, w90, w80,w290,w130;
@connect(state => ({
    tempMode: state.devicedata.get('tempMode'),
    temp: state.devicedata.get('temp'),
    nowTemp: state.devicedata.get('nowTemp'),
    heattime: state.devicedata.get('heattime'),
}))
export default class extends Component {

    componentWillMount() {
        let screenWidth = this.props.width;
        w230 = screenWidth * 0.56;//230
        w260 = screenWidth * 0.63;//260
        w250 = screenWidth * 0.6;//250
        w270 = screenWidth * 0.66;//270
        w280 = screenWidth * 0.68;//280
        w290 = screenWidth * 0.7;//280
        w300 = screenWidth * 0.73;//300
        w130 = screenWidth * 0.31;//120
        w120 = screenWidth * 0.3;//120
        w110 = screenWidth * 0.27;//110
        w100 = screenWidth * 0.24;//100
        w60 = screenWidth * 0.15;//90
        w90 = screenWidth * 0.22;//90
        w80 = screenWidth * 0.19;//80
    }

    render() {
        return (
            <View
                style={{
                    flexDirection: this.props.portrait ? 'column' : 'row-reverse',
                    justifyContent: 'center',
                    alignItems: 'center',
                    flex: 1
                }}
            >
                <View
                    style={{
                        position: "absolute",
                        flexDirection: this.props.portrait ? 'column' : 'row-reverse',
                        justifyContent: 'center',
                        alignItems: 'center',
                    }}
                >
                    <Image
                        style={{
                            height: this.props.portrait ? w260 : w290,
                            width: this.props.portrait ? w260 : w290,
                            marginBottom: this.props.portrait ? -w130 : 0,
                            marginLeft: this.props.portrait ? 0 : -w120
                        }}
                        resizeMode="stretch"
                        source={require('../images/cricel.png')}
                    />
                    <Image
                        style={{
                            height: w290,
                            width: w290
                        }}
                        resizeMode="stretch"
                        source={require('../images/cricel.png')}
                    />
                </View>
                <MeterView
                    value={this.props.heattime}
                    unitDirection={this.props.portrait ? 'right' : 'bottom'}
                    changeValue={false}
                    valueconfig={this.props.portrait ? v1 : v2}
                    style={{
                        height: this.props.portrait ? w230 : w260,
                        width: this.props.portrait ? w230 : w260,
                        marginLeft: this.props.portrait ? 0 : -w100,
                        marginBottom: this.props.portrait ? -w100 : 0
                    }} />
                <MeterView
                    changeValue={false}
                    value={this.props.nowTemp}
                    valueconfig={this.props.tempMode == 1 ? mv1 : mv2}
                    style={{ height: w260, width: w260 }} />
            </View>
        );
    }
}