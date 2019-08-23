package com.s6.manager

import com.facebook.react.uimanager.SimpleViewManager
import com.facebook.react.uimanager.ThemedReactContext
import com.s6.view.AnimMeterView
import com.s6.view.ColorMeterView
import com.s6.view.SquareView

/**
 * Created by stw on 2017/11/24.
 */
class ColorMeterManager :MeterManger {

    constructor() : super()

    override fun createViewInstance(reactContext: ThemedReactContext?): SquareView {
        meter = ColorMeterView(reactContext)
        return meter as ColorMeterView
    }

    override fun getName(): String {
        return "ColorMeterView"
    }

}