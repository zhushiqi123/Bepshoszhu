import React, { Component } from 'react';
var { requireNativeComponent, UIManager, findNodeHandle } = require('react-native');
let MeterView = requireNativeComponent('ColorMeterView', null);
export default class extends Component {

    static defaultProps = {
        onPress: () => { },
        onValueChange: value => { },
    }
    _onChange(e) {
        switch (e.event) {
            default:
                break;
            case 'click':
                this.props.onPress();
                break;
            case 'onValueChange':
                this.props.onValueChange(e.value);
                break;
        }
    }

    setValue(value) {
        // UIManager.dispatchViewManagerCommand(
        //     findNodeHandle(this),
        //     UIManager.ColorMeterView.Commands.setValue,
        //     [value]
        // )

    }
    render() {
        return (
            <MeterView{...this.props} onChange={e => this._onChange(e.nativeEvent)} />
        );
    }
}