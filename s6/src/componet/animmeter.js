import React, { Component } from 'react';
var { requireNativeComponent, UIManager, findNodeHandle } = require('react-native');
let MeterView = requireNativeComponent('AnimMeterView', null);
export default class extends Component {
    constructor(props) {
        super(props);
    }

    static defaultProps = {
        onPress: () => { }
    }
    _onChange(e) {
        switch (e.event) {
            default:
                break;
            case 'click':
                this.props.onPress();
                break;
        }
    }
    startAroundAnim() {
        UIManager.dispatchViewManagerCommand(
            findNodeHandle(this),
            UIManager.AnimMeterView.Commands.startAroundAnim,
            null
        )
    }
    stopAroundAnim() {
        UIManager.dispatchViewManagerCommand(
            findNodeHandle(this),
            UIManager.AnimMeterView.Commands.stopAroundAnim,
            null
        )
    }
    startColorAnim() {
        UIManager.dispatchViewManagerCommand(
            findNodeHandle(this),
            UIManager.AnimMeterView.Commands.startColorAnim,
            null
        )

    }
    cleanColorAnim() {
        UIManager.dispatchViewManagerCommand(
            findNodeHandle(this),
            UIManager.AnimMeterView.Commands.cleanColorAnim,
            null
        )

    }
    render() {
        return (
            <MeterView{...this.props} onChange={e => this._onChange(e.nativeEvent)} />
        );
    }
}