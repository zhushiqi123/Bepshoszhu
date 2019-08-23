/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 * @flow
 */

import React, { Component } from 'react';
import {
  Platform,
  StyleSheet,
  Text,
  View,
  Image,
  Dimensions,
  LayoutAnimation,
  UIManager,
  TouchableWithoutFeedback
} from 'react-native';
import Orientation from 'react-native-orientation';
var ScrollableTabView = require('react-native-scrollable-tab-view');
import BatterySwiper from '../swipers/battery'
import MainSwiper from '../swipers/main'
import ConnectSwiper from '../swipers/connect'
import LockSwiper from '../swipers/lock'
import SwitchSwiper from '../swipers/switch'
import BleView from '../componet/ble'
if (Platform.OS == 'android')
  UIManager.setLayoutAnimationEnabledExperimental(true)
let mainBg = [
  require('../images/main_bg1.png'),
  require('../images/main_bg2.png')
]
let buttonBgs = [
  require('../images/connect_bt.png'),
  require('../images/battrey_bt.png'),
  require('../images/switch_bt.png'),
  require('../images/lock_bt.png'),
  require('../images/main_bt.png'),
]
let transparentBg = require('../images/transparent.png')
let w10, w15;
export default class App extends Component {
  constructor(props) {
    super(props);
    this.state = {
      portrait: true,
      pagerIndex: 0
    }
  }

  componentWillMount() {
    const initial = Orientation.getInitialOrientation();
    this.state.portrait = (initial === 'PORTRAIT')
  }

  componentDidMount() {
    Dimensions.addEventListener('change', ({ window: { width, height } }) => {
      // LayoutAnimation.linear()
      this.setState({
        portrait: height > width
      });
    })
  }

  componentWillUnmount() {
    Orientation.getOrientation((err, orientation) => {

    });
  }

  componentWillMount() {
    var { height, width } = Dimensions.get('window');
    w10 = Math.min(height, width) * 0.024
    w15 = Math.min(height, width) * 0.036
  }

  _button(i) {
    return (
      <TouchableWithoutFeedback
        key={'mainbt' + i}
        onPress={() => this._pagerSelect(i)}
      >
        <View
          style={{
            backgroundColor: this.state.pagerIndex == i ? '#087DCB' : '#1F4868',
            padding: w10,
            borderRadius: w15
          }}
        >
          <Image
            source={buttonBgs[i]}
            resizeMode="stretch"
            hintColor='#ff0000'
            style={{
              height: 30,
              width: 30,
              tintColor: this.state.pagerIndex == i ? '#FDE00C' : '#13EFFF'
            }} />
        </View>
      </TouchableWithoutFeedback>

    )
  }


  _pagerSelect(i) {
    this.setState({
      pagerIndex: i
    });
  }


  render() {
    var { height, width } = Dimensions.get('window');
    return (
      <View
        style={{
          flex: 1,
          backgroundColor:'#000000'
        }}
      >
        <BleView />

        <View style={{ height: '100%' }} >
          <Image style={{ width: width, height: '100%', }} source={this.state.portrait ? mainBg[0] : mainBg[1]} resizeMode="stretch" />
          {
            this.state.portrait ?
              <View style={{
                height: '100%',
                width: '100%',
                position: "absolute",
                alignItems: 'center'
              }}>
                <View style={{ flex: 1, width: '100%' }} />
                <View style={{ flexDirection: 'row', justifyContent: 'space-between', width: '80%', marginBottom: height / 20 }}>
                  {
                    buttonBgs.map((v, i) => {
                      return this._button(i)
                    })
                  }
                </View>
              </View>
              :
              <View style={{ height: height, position: "absolute" }}>
                <Image style={{ marginTop: height / 22, position: "absolute", width: width / 3.55, height: height / 6.8, display: this.state.pagerIndex == 0 ? 'flex' : 'none' }} source={require('../images/connect_bg.png')} resizeMode="stretch" />
                <Image style={{ marginTop: height / 4.8, position: "absolute", width: width / 4.3, height: height / 6.8, display: this.state.pagerIndex == 1 ? 'flex' : 'none' }} source={require('../images/battrey_bg.png')} resizeMode="stretch" />
                <Image style={{ marginTop: height / 2.65, position: "absolute", width: width / 4.78, height: height / 6.8, display: this.state.pagerIndex == 2 ? 'flex' : 'none' }} source={require('../images/switch_bg.png')} resizeMode="stretch" />
                <Image style={{ marginTop: height / 1.84, position: "absolute", width: width / 4.59, height: height / 6.8, display: this.state.pagerIndex == 3 ? 'flex' : 'none' }} source={require('../images/lock_bg.png')} resizeMode="stretch" />
                <Image style={{ marginTop: height / 1.43, position: "absolute", width: width / 4.04, height: height / 6.8, display: this.state.pagerIndex == 4 ? 'flex' : 'none' }} source={require('../images/main_bg.png')} resizeMode="stretch" />

                <TouchableWithoutFeedback
                  onPress={() => this._pagerSelect(0)}
                >
                  <View style={{ marginTop: height / 22, position: "absolute", width: width / 4.3, height: height / 6.8, alignItems: 'center', justifyContent: 'center', flexDirection: 'row' }} >
                    <Image source={buttonBgs[0]} style={{ height: 30, width: 30, marginLeft: 15 }} />
                    <Text style={{ color: '#ffffff', flex: 1, textAlign: 'center', backgroundColor: 'rgba(0,0,0,0)' }}>Connect</Text>
                  </View>
                </TouchableWithoutFeedback>

                <TouchableWithoutFeedback
                  onPress={() => this._pagerSelect(1)}
                >
                  <View style={{ marginTop: height / 4.8, position: "absolute", width: width / 4.3, height: height / 6.8, alignItems: 'center', justifyContent: 'center', flexDirection: 'row' }} >
                    <Image source={buttonBgs[1]} style={{ height: 30, width: 30, marginLeft: 15 }} />
                    <Text style={{ color: '#ffffff', flex: 1, textAlign: 'center', backgroundColor: 'rgba(0,0,0,0)' }}>Battery</Text>
                  </View>
                </TouchableWithoutFeedback>

                <TouchableWithoutFeedback
                  onPress={() => this._pagerSelect(2)}
                >
                  <View style={{ marginTop: height / 2.65, position: "absolute", width: width / 4.78, height: height / 6.8, alignItems: 'center', justifyContent: 'center', flexDirection: 'row' }} >
                    <Image source={buttonBgs[2]} style={{ height: 30, width: 30, marginLeft: 15 }} />
                    <Text style={{ color: '#ffffff', flex: 1, textAlign: 'center', backgroundColor: 'rgba(0,0,0,0)' }}>℃/℉</Text>
                  </View>
                </TouchableWithoutFeedback>

                <TouchableWithoutFeedback
                  onPress={() => this._pagerSelect(3)}
                >
                  <View style={{ marginTop: height / 1.84, position: "absolute", width: width / 4.59, height: height / 6.8, alignItems: 'center', justifyContent: 'center', flexDirection: 'row' }} >
                    <Image source={buttonBgs[3]} style={{ height: 30, width: 30, marginLeft: 15 }} />
                    <Text style={{ color: '#ffffff', flex: 1, textAlign: 'center', backgroundColor: 'rgba(0,0,0,0)' }}>Lock</Text>
                  </View>
                </TouchableWithoutFeedback>

                <TouchableWithoutFeedback
                  onPress={() => this._pagerSelect(4)}
                >
                  <View style={{ marginTop: height / 1.43, position: "absolute", width: width / 4.04, height: height / 6.8, alignItems: 'center', justifyContent: 'center', flexDirection: 'row' }} >
                    <Image source={buttonBgs[4]} style={{ height: 30, width: 30, marginLeft: 15 }} />
                    <Text style={{ color: '#ffffff', flex: 1, textAlign: 'center', backgroundColor: 'rgba(0,0,0,0)' }}>Temperature    </Text>
                  </View>
                </TouchableWithoutFeedback>
              </View>
          }

        </View>
        <View
          style={{
            height: this.state.portrait ? '69%' : '100%',
            position: "absolute",
            width: this.state.portrait ? '100%' : (width - width / 4.5),
            marginLeft: this.state.portrait ? 0 : (width / 4.5),
            alignItems: 'center',
            justifyContent: 'center',
            backgroundColor: 'rgba(0,0,0,0)'
          }}
        >
          <ScrollableTabView
            page={this.state.pagerIndex}
            renderTabBar={() => <View />}
            locked
            scrollWithoutAnimation
            prerenderingSiblingsNumber={0}
            style={{
              width: '100%',
              height: '100%',
            }}
          >
            <ConnectSwiper width={Math.min(width, height)} />
            <BatterySwiper width={Math.min(width, height)} />
            <SwitchSwiper portrait={this.state.portrait} width={Math.min(width, height)} />
            <LockSwiper width={Math.min(width, height)} />
            <MainSwiper portrait={this.state.portrait} width={Math.min(width, height)} />
          </ScrollableTabView>
        </View>
      </View>
    );
  }
}