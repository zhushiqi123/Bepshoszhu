package com.s6.manager

import com.facebook.react.bridge.ReadableArray
import com.facebook.react.common.MapBuilder
import com.facebook.react.uimanager.SimpleViewManager
import com.facebook.react.uimanager.ThemedReactContext
import com.facebook.react.uimanager.annotations.ReactProp
import com.s6.view.AnimMeterView
import com.s6.view.SquareView

/**
 * Created by stw on 2017/11/24.
 */
class AnimMeterManager : MeterManger {

    constructor() : super()

    override fun createViewInstance(reactContext: ThemedReactContext?): SquareView {
        meter = AnimMeterView(reactContext)
        return meter as AnimMeterView
    }

    override fun getName(): String {
        return "AnimMeterView"
    }

    override fun getCommand(): Map<out String, Int> {
        return MapBuilder.of("startColorAnim", 3, "cleanColorAnim", 4)
    }

    override fun receiveCommand(root: SquareView, commandId: Int, args: ReadableArray?) {
        super.receiveCommand(root, commandId, args)
        when (commandId) {
            3 -> (root as AnimMeterView).startColorAnim()
            4 -> (root as AnimMeterView).cleanColorAnim()
        }
    }

    @ReactProp(name = "fillColor")
    public fun colorAnim(view: SquareView, b: Boolean) {
        if (b) {
            (view as AnimMeterView).fillColorAnim()
        } else {
            (view as AnimMeterView).cleanColorAnim()
        }
        view.invalidate()
    }
}