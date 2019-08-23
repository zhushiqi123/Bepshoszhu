import React, { Component } from 'react';
import {
    View,
    Text,
    Image
} from 'react-native';
import MeterView from '../componet/colormeter'
import LinearGradient from 'react-native-linear-gradient';
import { connect } from 'react-redux';
let w110, w100, w280, w310, w350, w80, w70, w25, w16;
@connect(state => ({
    battery: state.devicedata.get('battery'),
    nowTemp: state.devicedata.get('nowTemp')
}))
export default class extends Component {

    _canWork() {
        return this.props.battery > 0 ? (this.props.battery / 100 * 180 / 60).toFixed(1) : 0
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
                    <MeterView
                        valueconfig={{
                            minValue: 0,
                            maxValue: 100,
                            unit: "",
                            format: "#'%'",
                            defaultValue: 0
                        }}
                        value={this.props.battery}
                        changeValue={false}
                        style={{ height: w280, width: w280 }} />
                    <View
                        style={{ height: w110, width: w110, marginTop: -w70, alignItems: 'center', justifyContent: 'center', }} >
                        <Image source={require('../images/cricel2.png')} style={{ height: w110, width: w110, position: "absolute", }} />
                        <View
                            style={{ height: '80%', alignItems: 'center', justifyContent: 'space-between', }}
                        >
                            <Text style={{ color: '#ffffff', fontSize: w16 }}>{this.props.nowTemp}℃</Text>
                            <LinearGradient start={{ x: 0.0, y: 0.5 }} end={{ x: 1, y: 0.5 }} colors={['#01191E', '#0A7883', '#01191E']} style={{ width: w80, height: 2 }} />
                            <Text style={{ color: '#ffffff', fontSize: w16 }}>Can work {this._canWork()}h</Text>
                            <LinearGradient start={{ x: 0.0, y: 0.5 }} end={{ x: 1, y: 0.5 }} colors={['#01191E', '#0A7883', '#01191E']} style={{ width: w100, height: 2 }} />
                            <View style={{ flexDirection: 'row' }}>
                                <Image source={require('../images/battrey_min.png')} style={{ height: w25, width: w25 }} />
                                <Text style={{ color: '#ffffff', fontSize: w16 }}>{this.props.battery}%</Text>
                            </View>
                        </View>
                    </View>
                </View>
            </View>

        );
    }
}