package com.s6.manager

import android.util.Log
import com.facebook.react.bridge.ReadableArray
import com.facebook.react.bridge.ReadableMap
import com.facebook.react.common.MapBuilder
import com.facebook.react.uimanager.SimpleViewManager
import com.facebook.react.uimanager.ThemedReactContext
import com.facebook.react.uimanager.annotations.ReactProp
import com.s6.view.ColorMeterView
import com.s6.view.SquareView
import java.text.DecimalFormat

/**
 * Created by stw on 2017/11/24.
 */
abstract class MeterManger : SimpleViewManager<SquareView> {
    lateinit protected var meter: SquareView

    constructor() : super()

    abstract override fun createViewInstance(reactContext: ThemedReactContext?): SquareView

    abstract override fun getName(): String

    @ReactProp(name = "valueconfig")
    public fun valueconfig(view: SquareView, map: ReadableMap) {
        var minValue = 0f
        var maxValue = 800f
        var startAngle = 135f
        var sweepAngle = 270f
        var unit = ""
        var mSection = 10
        var format = "#"
        var defaultValue = -1f
        if (map.hasKey("minValue"))
            minValue = map.getDouble("minValue").toFloat()
        if (map.hasKey("maxValue"))
            maxValue = map.getDouble("maxValue").toFloat()
        if (map.hasKey("startAngle"))
            startAngle = map.getDouble("startAngle").toFloat()
        if (map.hasKey("sweepAngle"))
            sweepAngle = map.getDouble("sweepAngle").toFloat()
        if (map.hasKey("unit"))
            unit = map.getString("unit")
        if (map.hasKey("mSection"))
            mSection = map.getInt("mSection")
        if (map.hasKey("format"))
            format = map.getString("format")
        if (map.hasKey("defaultValue"))
            defaultValue = map.getDouble("defaultValue").toFloat()

        view.mMinValue = minValue
        view.mMaxValue = maxValue
        view.mSweepValue = view.mMaxValue - view.mMinValue
        view.mStartAngle = startAngle
        view.mSweepAngle = sweepAngle
        view.unit = unit
        view.mSection = mSection
        view.df = DecimalFormat(format)
        if (defaultValue > 0)
            view.value = defaultValue
        view.invalidate()
    }

    @ReactProp(name = "bianAnim")
    public fun bianAnim(view: SquareView, b: Boolean) {
        view.isBianAnim = b
    }

    @ReactProp(name = "changeValue")
    public fun changeValue(view: SquareView, b: Boolean) {
        view.isChangeValue = b
    }

    @ReactProp(name = "point")
    public fun point(view: SquareView, b: Boolean) {
        view.isDrawPoint = b
        view.invalidate()
    }

    @ReactProp(name = "unitDirection")
    public fun unitDirection(view: SquareView, s: String) {
        view.unitDirection = s
        view.invalidate()
    }

    @ReactProp(name = "value")
    public fun value(view: SquareView, s: Double) {
        view.value = s.toFloat()
    }

    override fun getCommandsMap(): MutableMap<String, Int> {
        var maps = MapBuilder.of("setValue", 0, "startAroundAnim", 1, "stopAroundAnim", 2)
        maps.putAll(getCommand())
        return maps
    }

    open fun getCommand(): Map<out String, Int> {
        return MapBuilder.newHashMap()
    }

    override fun receiveCommand(root: SquareView, commandId: Int, args: ReadableArray?) {
        super.receiveCommand(root, commandId, args)
        when (commandId) {
            0 -> root.value = args!!.getDouble(0).toFloat()
            1 -> root.startAroundAnim()
            2 -> root.stopAroundAnim()
        }
    }
}