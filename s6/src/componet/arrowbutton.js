import React, { Component } from 'react';
import {
    View,
    Image,
    TouchableWithoutFeedback
} from 'react-native';
const C1 = '#193755'
const C2 = '#1067C0'
export default class extends Component {
    static defaultProps = {
        onPress: () => { },
        left: false
    }
    constructor(props) {
        super(props);
        this.state = {
            backgroundColor: C1
        }
    }
    _clickIn() {
        this.setState({
            backgroundColor: C2
        });
        this.props.onPress()
    }
    _clickOut() {
        this.setState({
            backgroundColor: C1
        });
    }

    componentWillMount() {
        let screenWidth = this.props.width;
        this.w45 = screenWidth * 0.11;//45
        this.w70 = screenWidth * 0.17;//70
        this.w20 = screenWidth * 0.05;//20
        this.w32 = screenWidth * 0.08;//32
        this.w40 = screenWidth * 0.1;//40
    }

    render() {
        
        return (
            <TouchableWithoutFeedback
                onPressIn={() => this._clickIn()}
                onPressOut={() => this._clickOut()}
            >
                <View
                    style={{
                        height: this.w45,
                        width: this.w70,
                        backgroundColor: this.state.backgroundColor,
                        borderRadius: this.w20,
                        alignItems: 'center',
                        justifyContent: 'center'
                    }}
                >
                    <Image
                        resizeMode="stretch"
                        source={require('../images/arrow.png')}
                        style={{
                            height: this.w32,
                            width: this.w40,
                            transform: [
                                { rotate: this.props.left ? '180deg' : '0deg' }
                            ]
                        }}
                    />
                </View>
            </TouchableWithoutFeedback>
        );
    }
}