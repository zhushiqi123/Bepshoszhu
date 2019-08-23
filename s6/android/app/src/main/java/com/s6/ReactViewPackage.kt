package com.s6

import android.view.View
import com.facebook.react.ReactPackage
import com.facebook.react.bridge.NativeModule
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.uimanager.ReactShadowNode
import com.facebook.react.uimanager.SimpleViewManager
import com.facebook.react.uimanager.ViewManager
import com.s6.manager.AnimMeterManager
import com.s6.manager.BlueMeterManager
import com.s6.manager.ColorMeterManager
import com.s6.view.AnimMeterView
import com.s6.view.SquareView
import java.util.*
import java.util.Arrays.asList
import java.util.Arrays.asList
import java.util.Arrays.asList




/**
 * Created by stw on 2017/11/24.
 */
class ReactViewPackage : ReactPackage {
    override fun createNativeModules(reactContext: ReactApplicationContext?): MutableList<NativeModule> {
        return Collections.emptyList();
    }

    override fun createViewManagers(reactContext: ReactApplicationContext): List<ViewManager<*, *>> {
        return Arrays.asList(
                AnimMeterManager(),
                BlueMeterManager(),
                ColorMeterManager()
        )
    }

}