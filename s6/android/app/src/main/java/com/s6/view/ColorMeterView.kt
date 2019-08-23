package com.s6.view;
import android.content.Context
import android.graphics.*
import android.util.AttributeSet

/**
 * Created by Administrator on 2017/11/14.
 */
class ColorMeterView : SquareView {


    private var cricelRect1 = RectF()
    private var cricelRect2 = RectF()
    private var cricelRect3 = RectF()
    private var cricelRect4 = RectF()
    private var sectionRect = RectF()
    private var sectionTextRect = RectF()

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
        cricelPaint1.color = Color.parseColor("#06D8F5")
        cricelPaint2.style = Paint.Style.STROKE
        cricelPaint2.color = Color.parseColor("#0CBDD1")
        cricelPaint3.style = Paint.Style.STROKE
        sectionPaint.color = Color.parseColor("#ffffff")
        sectionPaint.strokeCap = Paint.Cap.ROUND
        sectionPaint.style = Paint.Style.STROKE
        sectionTextPaint.color = Color.parseColor("#ffffff")

        colorPaint1.style = Paint.Style.STROKE
        colorPaint2.style = Paint.Style.STROKE
        colorPaint3.style = Paint.Style.STROKE
        colorPaint3.color = Color.parseColor("#06D8F5")
    }

    override fun initValue() {
        super.initValue()
        cricelRect1.set(bodyRect)
        cricelRect1.inset(jb2px(3f), jb2px(3f))

        sectionTextRect.set(cricelRect1)
        sectionTextRect.inset(jb2px(4f), jb2px(4f))

        cricelRect2.set(cricelRect1)
        cricelRect2.inset(jb2px(7f), jb2px(7f))

        cricelRect3.set(cricelRect2)
        cricelRect3.inset(jb2px(1.5f), jb2px(1.5f))

        sectionRect.set(cricelRect3)
        sectionRect.inset(jb2px(1f), jb2px(1f))

        cricelRect4.set(sectionRect)
        cricelRect4.inset(jb2px(2f), jb2px(2f))

        cricelPaint1.strokeWidth = jb2px(3f)

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

        colorPaint1.strokeWidth=jb2px(3f)
        colorPaint2.strokeWidth=jb2px(3f)
        colorPaint1.shader = SweepGradient(viewCenterX, viewCenterY,
                intArrayOf(
                        Color.parseColor("#FF0825"),
                        Color.parseColor("#8233C8"),
                        Color.parseColor("#FEFC0C")
                ),
                floatArrayOf(
                        0f, 0.125f, 0.25f
                )
        )
        colorPaint2.style = Paint.Style.STROKE
        colorPaint2.shader = SweepGradient(viewCenterX, viewCenterY,
                intArrayOf(
                        Color.parseColor("#F4FC0C"),
                        Color.parseColor("#D6B64F")
                ),
                floatArrayOf(
                        0f, 0.25f
                )
        )
        colorPaint3.strokeWidth=jb2px(0.6f)
    }

    override fun draw2(canvas: Canvas) {
        drawCricle1(canvas)
        drawCricle2(canvas)
        drawCricle3(canvas)
        drawLongSection(canvas);
        drawShortSection(canvas);
        drawCricle4(canvas)
        drawSectionText(canvas)
        drawColor(canvas)
    }

    private fun drawColor(canvas: Canvas) {
        canvas.save()
        canvas.rotate(135f, viewCenterX, viewCenterY)
        canvas.drawArc(cricelRect1,0f,90f,false,colorPaint1)
        canvas.restore()

        canvas.save()
        canvas.rotate(315f, viewCenterX, viewCenterY)
        canvas.drawArc(cricelRect1,0f,90f,false,colorPaint2)
        canvas.restore()

        canvas.save()
        canvas.rotate(mStartAngle, viewCenterX, viewCenterY)
        for (i in 0..72) {
            canvas.drawLine(viewCenterX+cricelRect1.width()/2-cricelPaint1.strokeWidth/2,viewCenterY,viewCenterX+cricelRect1.width()/2+cricelPaint1.strokeWidth/2,viewCenterY, colorPaint3)
            canvas.rotate(5f, viewCenterX, viewCenterY)
        }
        canvas.restore()
    }

    override fun pointLeft(): Float {
        return viewCenterX + cricelRect2.width() / 2 - (pointBitmap?.width ?: 0) + jb2px(3f)
    }

    private fun drawSectionText(canvas: Canvas) {
        for (i in 0..mSection) {
            var s: String = (mMinValue + mSweepValue / mSection * i).toInt().toString()
            sectionTextPaint.getTextBounds(s, 0, s.length, mRectText)
            sectionTextPath.reset()
            var c = (360 * (mRectText.width() / 2 / (Math.PI * cricelRect1.height()))).toFloat()
            sectionTextPath.addArc(sectionTextRect, mStartAngle + i * (mSweepAngle / mSection) - c, mSweepAngle)
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
        for (i in 0.. mSection * 2) {
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