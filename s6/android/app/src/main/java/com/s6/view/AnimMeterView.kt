package com.s6.view;

import android.animation.Animator
import android.animation.AnimatorListenerAdapter
import android.animation.ValueAnimator
import android.content.Context
import android.graphics.*
import android.os.Handler
import android.os.Message
import android.util.AttributeSet
import android.util.Log
import android.view.MotionEvent

/**
 * Created by Administrator on 2017/11/14.
 */
class AnimMeterView : SquareView {


    private var cricelRect1 = RectF()
    private var cricelRect2 = RectF()
    private var cricelRect3 = RectF()
    private var cricelRect4 = RectF()
    private var sectionRect = RectF()
    private var sectionTextRect = RectF()
    private var colorRect = RectF()

    private var cricelPaint1 = Paint()
    private var cricelPaint2 = Paint()
    private var cricelPaint3 = Paint()
    private var sectionPaint = Paint()
    private var sectionTextPaint = Paint()
    private var colorPaint1 = Paint()
    private var colorPaint2 = Paint()
    private var colorPaint3 = Paint()

    private var sectionTextPath = Path()

    private var mRectText = Rect()

    private var animColorIndex = 0

    private var valueAnim1 = ValueAnimator.ofFloat(0f, 45f)
    private var valueAnim2 = ValueAnimator.ofFloat(0f, 45f)

    private var animRotate1 = 0f
    private var animRotate2 = 0f

    private var handler = object : Handler() {
        override fun handleMessage(msg: Message?) {
            super.handleMessage(msg)
            valueAnim2.start()
        }
    }

    constructor(context: Context?) : super(context) {
        initObject()
    }

    constructor(context: Context?, attrs: AttributeSet?) : super(context, attrs) {
        initObject()
    }

    constructor(context: Context?, attrs: AttributeSet?, defStyleAttr: Int) : super(context, attrs, defStyleAttr) {
        initObject()
    }

    fun initObject() {
        isDrawValue = false
        cricelPaint1.style = Paint.Style.STROKE
        cricelPaint1.color = Color.parseColor("#06D8F5")
        cricelPaint2.style = Paint.Style.STROKE
        cricelPaint2.color = Color.parseColor("#7F909C")
        cricelPaint3.style = Paint.Style.STROKE
        sectionPaint.color = Color.parseColor("#ffffff")
        sectionPaint.strokeCap = Paint.Cap.ROUND
        sectionPaint.style = Paint.Style.STROKE
        sectionTextPaint.color = Color.parseColor("#ffffff")

        colorPaint1.style = Paint.Style.STROKE
        colorPaint2.style = Paint.Style.STROKE
        colorPaint3.style = Paint.Style.STROKE
        colorPaint3.color = Color.parseColor("#000000")

        valueAnim1.duration = 800
        valueAnim1.addUpdateListener {
            animRotate1 = it.getAnimatedValue() as Float
            postInvalidate()
        }
        valueAnim1.addListener(object : AnimatorListenerAdapter() {
            override fun onAnimationEnd(animation: Animator?) {
                Thread({
                    while (animColorIndex < 15) {
                        Thread.sleep(60)
                        animColor()
                    }
                    var msg = handler.obtainMessage(1)
                    handler.sendMessage(msg)
                }).start()
            }
        })
        valueAnim2.duration = 500
        valueAnim2.addUpdateListener {
            animRotate2 = it.getAnimatedValue() as Float
            postInvalidate()
        }
        valueAnim2.addListener(object : AnimatorListenerAdapter() {
            override fun onAnimationEnd(animation: Animator?) {

            }
        })
    }

    override fun initValue() {
        super.initValue()
        cricelRect1.set(bodyRect)
        cricelRect1.inset(jb2px(5f), jb2px(5f))

        colorRect.set(bodyRect)
        colorRect.inset(jb2px(4f), jb2px(4f))

        sectionTextRect.set(cricelRect1)
        sectionTextRect.inset(jb2px(4f), jb2px(4f))

        cricelRect2.set(cricelRect1)
        cricelRect2.inset(jb2px(10f), jb2px(10f))

        cricelRect3.set(cricelRect2)
        cricelRect3.inset(jb2px(1.5f), jb2px(1.5f))

        sectionRect.set(cricelRect3)
        sectionRect.inset(jb2px(1f), jb2px(1f))

        cricelRect4.set(sectionRect)
        cricelRect4.inset(jb2px(2f), jb2px(2f))

        cricelPaint1.strokeWidth = jb2px(3f)

        cricelPaint2.strokeWidth = jb2px(1.5f)

        cricelPaint3.strokeWidth = jb2px(1f)
        cricelPaint3.shader = SweepGradient(viewCenterX, viewCenterY,
                intArrayOf(
                        Color.parseColor("#011317"),
                        Color.parseColor("#0CBDD1"),
                        Color.parseColor("#0CBDD1"),
                        Color.parseColor("#011317")
                ),
                floatArrayOf(
                        0f, (360 - mSweepAngle + 100) / 720, 1 - (360 - mSweepAngle + 100) / 720, 1f
                )
        )

        sectionPaint.strokeWidth = jb2px(0.4f)
        sectionTextPaint.textSize = jb2px(5f)

        colorPaint1.strokeWidth = jb2px(5f)
        colorPaint2.strokeWidth = jb2px(5f)
        colorPaint1.shader = SweepGradient(viewCenterX, viewCenterY,
                intArrayOf(
                        Color.parseColor("#FF1817"),
                        Color.parseColor("#FB9419"),
                        Color.parseColor("#F9FD25")
                ),
                floatArrayOf(
                        0f, 0.125f, 0.25f
                )
        )
        colorPaint2.style = Paint.Style.STROKE
        colorPaint2.shader = SweepGradient(viewCenterX, viewCenterY,
                intArrayOf(
                        Color.parseColor("#F9FD25"),
                        Color.parseColor("#FB9419"),
                        Color.parseColor("#FF1817")
                ),
                floatArrayOf(
                        0f, 0.125f, 0.25f
                )
        )
        colorPaint3.strokeWidth = jb2px(0.6f)
    }

    override fun draw2(canvas: Canvas) {
        drawCricle1(canvas)
        drawCricle2(canvas)
//        drawCricle3(canvas)
//        drawLongSection(canvas);
//        drawShortSection(canvas);
//        drawCricle4(canvas)
//        drawSectionText(canvas)
        drawColor(canvas)
    }

    private fun animColor() {
        animColorIndex++
        postInvalidate()
    }

    public fun startColorAnim() {
        if (valueAnim1.isRunning || valueAnim2.isRunning)
            return
        valueAnim1.start()
        if (animColorIndex != 0 && animColorIndex < 15) {
            animColorIndex = 0
            valueAnim1.cancel()
            valueAnim2.cancel()
            valueAnim1.start()
            return
        }
        animColorIndex = 0
        animRotate1 = 0f
        animRotate2 = 0f
    }

    public fun fillColorAnim() {
        valueAnim1.cancel()
        valueAnim2.cancel()
        animColorIndex = 15
        animRotate1 = 45f
        animRotate2 = 45f
        invalidate()
    }

    public fun cleanColorAnim() {
        valueAnim1.cancel()
        valueAnim2.cancel()
        animColorIndex = 0
        animRotate1 = 0f
        animRotate2 = 0f
        invalidate()
    }

    private fun drawColor(canvas: Canvas) {
        canvas.save()
        canvas.rotate(135f, viewCenterX, viewCenterY)
        canvas.drawArc(cricelRect1, 0f, (6 * (animColorIndex % 16)).toFloat(), false, colorPaint1)
        canvas.restore()

        canvas.save()
        canvas.rotate(315f, viewCenterX, viewCenterY)
        canvas.drawArc(cricelRect1, (6 * (15 - animColorIndex % 16)).toFloat(), 6f * (animColorIndex % 16), false, colorPaint2)
        canvas.restore()

        canvas.save()
        canvas.rotate(135f + 6, viewCenterX, viewCenterY)
        for (i in 0..(animColorIndex % 16 - 2)) {
            canvas.drawLine(viewCenterX + cricelRect1.width() / 2 - colorPaint1.strokeWidth / 2, viewCenterY, viewCenterX + cricelRect1.width() / 2 + colorPaint1.strokeWidth / 2, viewCenterY, colorPaint3)
            canvas.rotate(6f, viewCenterX, viewCenterY)
        }
        canvas.restore()

        canvas.save()
        canvas.rotate(45f, viewCenterX, viewCenterY)
        for (i in 0..(animColorIndex % 16 - 2)) {
            canvas.rotate(-6f, viewCenterX, viewCenterY)
            canvas.drawLine(viewCenterX + cricelRect1.width() / 2 - colorPaint1.strokeWidth / 2, viewCenterY, viewCenterX + cricelRect1.width() / 2 + colorPaint1.strokeWidth / 2, viewCenterY, colorPaint3)
        }
        canvas.restore()
    }

    override fun pointLeft(): Float {
        return viewCenterX + cricelRect2.width() / 2 - (pointBitmap?.width ?: 0) + jb2px(5f)
    }


    private fun drawCricle4(canvas: Canvas) {
        canvas.drawArc(cricelRect4, mStartAngle, mSweepAngle, false, sectionPaint)
    }




    private fun drawCricle2(canvas: Canvas) {
        canvas.drawArc(cricelRect2, 0f, 360f, false, cricelPaint2)
    }

    private fun drawCricle1(canvas: Canvas) {
//        canvas.save()
//        canvas.rotate(mStartAngle - (360 - mSweepAngle) / 2, viewCenterX, viewCenterY)
//        canvas.drawArc(cricelRect1, 0f, 360f, false, cricelPaint1)
//        canvas.restore()

        canvas.save()
        canvas.rotate(90f, viewCenterX, viewCenterY)
        canvas.drawArc(cricelRect1, 0f, animRotate1, false, cricelPaint1)
        canvas.drawArc(cricelRect1, 0f, -animRotate1, false, cricelPaint1)
        canvas.restore()

        canvas.save()
        canvas.rotate(225f, viewCenterX, viewCenterY)
        canvas.drawArc(cricelRect1, 0f, animRotate2, false, cricelPaint1)
        canvas.restore()

        canvas.save()
        canvas.rotate(315f, viewCenterX, viewCenterY)
        canvas.drawArc(cricelRect1, 0f, -animRotate2, false, cricelPaint1)
        canvas.restore()
    }
}