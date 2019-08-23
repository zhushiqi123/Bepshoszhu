package com.s6.manager

import android.util.Log
import com.facebook.react.bridge.ReadableArray
import com.facebook.react.uimanager.SimpleViewManager
import com.facebook.react.uimanager.ThemedReactContext
import com.s6.view.AnimMeterView
import com.s6.view.BlueMeterView
import com.s6.view.SquareView

/**
 * Created by stw on 2017/11/24.
 */
class BlueMeterManager : MeterManger {

    constructor() : super()

    override fun createViewInstance(reactContext: ThemedReactContext?): SquareView {
        meter = BlueMeterView(reactContext)
        return meter as BlueMeterView
    }

    override fun getName(): String {
        return "BlueMeterView"
    }
}