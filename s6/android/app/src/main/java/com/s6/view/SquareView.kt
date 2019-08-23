package com.s6.view;

import android.animation.ValueAnimator
import android.content.Context
import android.graphics.*
import android.graphics.drawable.BitmapDrawable
import android.util.AttributeSet
import android.util.Log
import android.view.MotionEvent
import android.view.View
import android.view.animation.BounceInterpolator
import com.facebook.react.bridge.Arguments
import com.s6.R
import java.text.DecimalFormat
import com.facebook.react.uimanager.events.RCTEventEmitter
import com.facebook.react.bridge.ReactContext
import com.facebook.react.bridge.Arguments.createMap
import com.facebook.react.bridge.WritableMap


/**
 * Created by Administrator on 2017/11/10.
 */
abstract class SquareView : View {

    public var mStartAngle = 135f
    public var mSweepAngle = 270f
    public var mMinValue = 0f
    public var mMaxValue = 800f
    public var mSweepValue = mMaxValue - mMinValue
    public var value = 400f
        set(value) {
            if (value < mMinValue)
                field = mMinValue
            else if (value > mMaxValue)
                field = mMaxValue
            else
                field = value
            postInvalidate()
        }
    public var mSection = 10
    public var valueDf = "#"
    public var unit = "℉"
    public var unitDirection = "bottom"
    public var isDrawValue = true
    public var isDrawPoint = true
    public var isBianAnim = false
    public var isChangeValue = true


    private var viewWidth = 0
    private var viewHeight = 0
    protected var viewCenterX = 0f
    protected var viewCenterY = 0f

    private var viewRect = RectF()
    protected var bodyRect = RectF()
    protected var textRect = Rect()
    protected var textRect2 = Rect()

    private var circleRect1_1 = RectF()
    private var circleRect1_2 = RectF()
    private var circleRect1_3 = RectF()
    private var circleRect2 = RectF()

    private var circlePaint1_1 = Paint()
    private var circlePaint1_2 = Paint()
    private var circlePaint1_3 = Paint()
    private var circlePaint2 = Paint()
    private var backgroundPaint = Paint()
    private var valuePaint = Paint()
    private var unitPaint = Paint()

    protected var pointBitmap: Bitmap? = null
    private lateinit var mx: Matrix
    public lateinit var df: DecimalFormat

    private var aroundValue = 2 * mSweepValue / mSweepAngle
    private var tempAroundValue = 0f
    private var isAroundAnim = false
    var pfd = PaintFlagsDrawFilter(0, Paint.ANTI_ALIAS_FLAG or Paint.FILTER_BITMAP_FLAG)
    private var valueAnim1 = ValueAnimator.ofFloat(30f, 0f)
    private var valueAnim2 = ValueAnimator.ofFloat(0f, 30f)
    private var animCircle1 = 0f
    private var clickAngle = 0f


    constructor(context: Context?) : super(context) {
        initObject()
    }

    constructor(context: Context?, attrs: AttributeSet?) : super(context, attrs) {
        initObject()
    }

    constructor(context: Context?, attrs: AttributeSet?, defStyleAttr: Int) : super(context, attrs, defStyleAttr) {
        initObject()
    }

    private fun initObject() {
        circlePaint1_1.color = Color.parseColor("#BFD9E1")
        circlePaint1_2.color = Color.parseColor("#809DA6")
        circlePaint1_3.color = Color.parseColor("#086887")
        backgroundPaint.color = Color.parseColor("#000000")
        valuePaint.color = Color.parseColor("#ffffff")
        unitPaint.color = Color.parseColor("#ffffff")
        df = DecimalFormat(valueDf)
        valuePaint.typeface = Typeface.create("sans-serif-thin", Typeface.NORMAL)

        valueAnim1.duration = 500
        valueAnim1.interpolator = BounceInterpolator()
        valueAnim1.addUpdateListener {
            animCircle1 = it.animatedValue as Float
            invalidate()
        }

        valueAnim2.duration = 250
        valueAnim2.addUpdateListener {
            animCircle1 = it.animatedValue as Float
            invalidate()
        }
    }

    override fun onMeasure(widthMeasureSpec: Int, heightMeasureSpec: Int) {
        super.onMeasure(widthMeasureSpec, heightMeasureSpec)
        var width = resolveSize(0, widthMeasureSpec)
        var height = resolveSize(0, heightMeasureSpec)
        viewHeight = height
        viewWidth = width
        if (width > height)
            viewWidth = height
        else
            viewHeight = width
        viewRect.set(0f, 0f, viewWidth.toFloat(), viewHeight.toFloat())
        viewCenterX = viewWidth / 2.toFloat()
        viewCenterY = viewHeight / 2.toFloat()
        setMeasuredDimension(width, height)
    }

    override fun onLayout(changed: Boolean, left: Int, top: Int, right: Int, bottom: Int) {
        super.onLayout(changed, left, top, right, bottom)
        initValue()
        invalidate()
    }

    open fun initValue() {

        circlePaint1_1.strokeWidth = jb2px(2f)
        circlePaint1_1.style = Paint.Style.STROKE

        circlePaint1_2.strokeWidth = jb2px(1f)
        circlePaint1_2.style = Paint.Style.STROKE

        circlePaint1_3.strokeWidth = jb2px(1f)
        circlePaint1_3.style = Paint.Style.STROKE

        circleRect1_1.set(viewRect)
        circleRect1_1.inset(circlePaint1_1.strokeWidth / 2, circlePaint1_1.strokeWidth / 2)

        circleRect1_2.set(circleRect1_1)
        circleRect1_2.inset(circlePaint1_2.strokeWidth, circlePaint1_2.strokeWidth)

        circleRect1_3.set(circleRect1_2)
        circleRect1_3.inset(circlePaint1_3.strokeWidth, circlePaint1_3.strokeWidth)

        circleRect2.set(circleRect1_3)
        circlePaint2.shader = RadialGradient(viewWidth / 2.toFloat(),
                viewHeight / 2.toFloat(),
                jb2px(35f),
                Color.parseColor("#084851"),
                Color.parseColor("#000000"),
                Shader.TileMode.CLAMP)
        bodyRect.set(circleRect2)

        var p = (resources.getDrawable(R.drawable.point) as BitmapDrawable).bitmap
        mx = Matrix()
        mx.setRotate(180f)
        mx.postScale(viewWidth / 3.5f / p.width, viewWidth / 3.5f / p.width)
        pointBitmap = Bitmap.createBitmap(p, 0, 0, p.width, p.height, mx, false)
        valuePaint.textSize = jb2px(20f)

        unitPaint.textSize = jb2px(10f)
    }

    override fun draw(canvas: Canvas) {
        super.draw(canvas)
        canvas.setDrawFilter(pfd)
//        canvas.drawArc(circleRect1_1, 0f, 360f, false, backgroundPaint)
        canvas.drawArc(circleRect2, 0f, 360f, false, circlePaint2)
        drawCircle1(canvas)
        draw2(canvas)
        if (isDrawPoint)
            drawPoint(canvas)
        if (isDrawValue) {
            drawValue(canvas)
            drawUnit(canvas)
        }
    }

    private fun drawCircle1(canvas: Canvas) {
        canvas.save()
        if (isBianAnim) {
            canvas.rotate(clickAngle, viewCenterX, viewCenterY)
            canvas.translate(animCircle1, 0f)
        }
        canvas.drawArc(circleRect1_1, 0f, 360f, false, circlePaint1_1)
        canvas.drawArc(circleRect1_2, 0f, 360f, false, circlePaint1_2)
        canvas.drawArc(circleRect1_3, 0f, 360f, false, circlePaint1_3)
        canvas.restore()
    }

    private fun drawUnit(canvas: Canvas) {
        when (unitDirection) {
            "bottom" -> {
                valuePaint.getTextBounds("1", 0, 1, textRect)
                unitPaint.getTextBounds(unit, 0, unit.length, textRect2)
                canvas.drawText(unit, viewCenterX - textRect2.width() / 2, viewCenterY + textRect.height() / 2 + textRect2.height() + jb2px(5f), unitPaint);
            }
        }
    }

    private fun drawValue(canvas: Canvas) {
        var s = df.format(value)
        valuePaint.getTextBounds(s, 0, s.length, textRect)
        when (unitDirection) {
            "bottom" -> {
                canvas.drawText(s, viewCenterX - textRect.width() / 2, viewCenterY + (valuePaint.descent() - valuePaint.ascent()) / 2 - valuePaint.descent(), valuePaint);
            }
            "right" -> {
                unitPaint.getTextBounds(unit, 0, unit.length, textRect2)
                canvas.drawText(s, viewCenterX - textRect.width() / 2 - textRect2.width() / 2 - jb2px(1f), viewCenterY + (valuePaint.descent() - valuePaint.ascent()) / 2 - valuePaint.descent() + 1, valuePaint);
                canvas.drawText(unit, viewCenterX + textRect.width() / 2 - textRect2.width() / 2 + jb2px(1f), viewCenterY + (unitPaint.descent() - unitPaint.ascent()) / 2 - unitPaint.descent() + (textRect.height() - textRect2.height()) / 2, unitPaint);
            }
        }

    }

    private fun drawPoint(canvas: Canvas) {
        if (pointBitmap != null) {
            canvas.save()
            canvas.rotate(mStartAngle + ((value - mMinValue) / mSweepValue) * mSweepAngle, viewCenterX, viewCenterY)
            canvas.drawBitmap(pointBitmap, pointLeft(), viewCenterY - pointBitmap!!.height / 2, backgroundPaint)
            canvas.restore()
        }
    }

    override fun onTouchEvent(event: MotionEvent): Boolean {
        when (event.action) {
            MotionEvent.ACTION_DOWN -> {
                if (isBianAnim)
                    valueAnim2.start()
                parsePoint(event.x, event.y)
                var event = Arguments.createMap()
                event.putString("event", "click")
                (context as ReactContext).getJSModule(RCTEventEmitter::class.java).receiveEvent(
                        id, "topChange", event)

            }
            MotionEvent.ACTION_MOVE -> {
                parsePoint(event.x, event.y)
                invalidate()
            }
            MotionEvent.ACTION_UP,
            MotionEvent.ACTION_CANCEL -> {
                parsePoint(event.x, event.y)
                invalidate()
                var event = Arguments.createMap()
                event.putString("event", "onValueChange")
                event.putInt("value", value.toInt())
                (context as ReactContext).getJSModule(RCTEventEmitter::class.java).receiveEvent(
                        id, "topChange", event)
                if (isBianAnim)
                    valueAnim1.start()
            }
        }
        return true
    }

    override fun dispatchTouchEvent(event: MotionEvent?): Boolean {
        getParent().requestDisallowInterceptTouchEvent(true);
        return super.dispatchTouchEvent(event)
    }

    private fun parsePoint(xPos: Float, yPos: Float) {
//        if (!isPoint(xPos, yPos))
//            return
        if (!isChangeValue)
            return
        val x = xPos - viewCenterX
        val y = yPos - viewCenterY
        var angle = Math.toDegrees(Math.atan2(y.toDouble(), x.toDouble()))
        clickAngle = angle.toFloat() + 180f
        if (angle < 0)
            angle = 360 + angle
        if (angle - mStartAngle >= 0)
            angle -= mStartAngle
        else
            angle = 360 - mStartAngle + angle

        if (angle > mSweepAngle && angle <= mSweepAngle + 10)
            angle = mSweepAngle.toDouble()
        else if (angle >= 360 - 10 && angle <= 360)
            angle = 0.0
        if (angle > mSweepAngle)
            return
        value = Math.round(mMinValue + mSweepValue * angle / mSweepAngle).toFloat()
    }

    public fun startAroundAnim() {
        if (!isAroundAnim) {
            isAroundAnim = true
            Thread({
                while (isAroundAnim) {
                    Thread.sleep(30)
                    tempAroundValue += aroundValue
                    value = tempAroundValue % (mMaxValue - mMinValue)
                }
            }).start()
        }

    }

    public fun stopAroundAnim() {
        isAroundAnim = false
    }

    override fun destroyDrawingCache() {
        super.destroyDrawingCache()
        isAroundAnim = false
    }

    abstract fun pointLeft(): Float

    abstract fun draw2(canvas: Canvas)

    /*
    独创jb单位
     */
    public fun jb2px(value: Float): Float {
        return viewHeight * value / 100
    }
}