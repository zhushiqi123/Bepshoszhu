/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 * @flow
 */

import React, { Component } from 'react';
import {
  View
} from 'react-native';
import { Provider, connect } from "react-redux";
import Main from './pager/main'
import getStore from './store'
export default class App extends Component {

  render() {
    return (
      <Provider store={getStore()}>
        <Main />
      </Provider>
    );
  }
}