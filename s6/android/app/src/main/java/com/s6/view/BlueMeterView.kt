package com.s6.view;
import android.content.Context
import android.graphics.*
import android.util.AttributeSet
import android.util.Log


/**
 * Created by Administrator on 2017/11/10.
 */
class BlueMeterView : SquareView {

    private var cricelRect1 = RectF()
    private var cricelRect2 = RectF()
    private var cricelRect3 = RectF()
    private var cricelRect4 = RectF()
    private var sectionRect = RectF()

    private var cricelPaint1 = Paint()
    private var cricelPaint2 = Paint()
    private var cricelPaint3 = Paint()
    private var sectionPaint = Paint()
    private var sectionTextPaint = Paint()

    private var sectionTextPath = Path()

    private var mRectText = Rect()

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
        cricelPaint1.style = Paint.Style.STROKE
        cricelPaint2.style = Paint.Style.STROKE
        cricelPaint2.color = Color.parseColor("#0CBDD1")
        cricelPaint3.style = Paint.Style.STROKE
        sectionPaint.color = Color.parseColor("#ffffff")
        sectionPaint.strokeCap = Paint.Cap.ROUND
        sectionPaint.style = Paint.Style.STROKE
        sectionTextPaint.color = Color.parseColor("#ffffff")
    }

    override fun initValue() {
        super.initValue()
        cricelRect1.set(bodyRect)
        cricelRect1.inset(jb2px(5f), jb2px(5f))

        cricelRect2.set(cricelRect1)
        cricelRect2.inset(jb2px(5f), jb2px(5f))

        cricelRect3.set(cricelRect2)
        cricelRect3.inset(jb2px(1.5f), jb2px(1.5f))

        sectionRect.set(cricelRect3)
        sectionRect.inset(jb2px(1f), jb2px(1f))

        cricelRect4.set(sectionRect)
        cricelRect4.inset(jb2px(2f), jb2px(2f))

        cricelPaint1.strokeWidth = jb2px(3f)
        cricelPaint1.shader = SweepGradient(viewCenterX, viewCenterY,
                intArrayOf(
                        Color.parseColor("#0CBDD1"),
                        Color.parseColor("#011317"),
                        Color.parseColor("#011317"),
                        Color.parseColor("#0CBDD1")
                ),
                floatArrayOf(
                        0f, (360 - mSweepAngle) / 720, 1 - (360 - mSweepAngle) / 720, 1f
                )
        )

        cricelPaint2.strokeWidth = jb2px(0.3f)

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
    }

    override fun draw2(canvas: Canvas) {
        drawCricle1(canvas)
        drawCricle2(canvas)
        drawCricle3(canvas)
        drawLongSection(canvas);
        drawShortSection(canvas);
        drawCricle4(canvas)
        drawSectionText(canvas)
    }

    override fun pointLeft(): Float {
        return viewCenterX + cricelRect2.width() / 2 -(pointBitmap?.width ?: 0)+jb2px(3f)
    }

    private fun drawSectionText(canvas: Canvas) {
        for (i in 0..mSection) {
            var s: String = (mMinValue + mSweepValue / mSection * i).toInt().toString()
            sectionTextPaint.getTextBounds(s, 0, s.length, mRectText)
            sectionTextPath.reset()
            var c = (360 * (mRectText.width() / 2 / (Math.PI * cricelRect1.height()))).toFloat()
            sectionTextPath.addArc(cricelRect1, mStartAngle + i * (mSweepAngle / mSection) - c, mSweepAngle)
            canvas.drawTextOnPath(s, sectionTextPath, 0f, mRectText.height() / 2.toFloat(), sectionTextPaint)
        }
    }

    private fun drawCricle4(canvas: Canvas) {
        canvas.drawArc(cricelRect4, mStartAngle, mSweepAngle, false, sectionPaint)
    }

    private fun drawShortSection(canvas: Canvas) {
        canvas.save()
        canvas.rotate(mStartAngle, viewCenterX, viewCenterY)
        for (i in 0..mSection * 10) {
            canvas.drawLine(viewCenterX + sectionRect.width() / 2, viewCenterY, viewCenterX + sectionRect.width() / 2 - jb2px(0.7f), viewCenterY, sectionPaint)
            canvas.rotate(mSweepAngle / mSection / 10, viewCenterX, viewCenterY)
        }
        canvas.restore()
    }

    private fun drawLongSection(canvas: Canvas) {
        canvas.save()
        canvas.rotate(mStartAngle, viewCenterX, viewCenterY)
        for (i in 0..mSection * 2) {
            canvas.drawLine(viewCenterX + sectionRect.width() / 2, viewCenterY, viewCenterX + sectionRect.width() / 2 - jb2px(3f), viewCenterY, sectionPaint)
            canvas.rotate(mSweepAngle / mSection / 2, viewCenterX, viewCenterY)
        }
        canvas.restore()
    }

    private fun drawCricle3(canvas: Canvas) {
        canvas.save()
        canvas.rotate(mStartAngle - (360 - mSweepAngle) / 2, viewCenterX, viewCenterY)
        canvas.drawArc(cricelRect3, 0f, 360f, false, cricelPaint3)
        canvas.restore()
    }

    private fun drawCricle2(canvas: Canvas) {
        canvas.drawArc(cricelRect2, mStartAngle - 2f, mSweepAngle + 4f, false, cricelPaint2)
    }

    private fun drawCricle1(canvas: Canvas) {
        canvas.save()
        canvas.rotate(mStartAngle - (360 - mSweepAngle) / 2, viewCenterX, viewCenterY)
        canvas.drawArc(cricelRect1, 0f, 360f, false, cricelPaint1)
        canvas.restore()
    }
}
