package org.dellamorte.raum.susolver.android

import org.dellamorte.raum.susolver.supuzzle.*

import android.content.Context
import android.graphics.Canvas
import android.graphics.Rect
import android.graphics.Paint
import android.graphics.Color
import android.view.Display
import android.view.WindowManager
import android.graphics.Point
import android.util.TypedValue
import android.graphics.Bitmap
import android.graphics.Typeface
import android.view.MotionEvent
import android.widget.Toast
import android.view.View

/**
 *
 * @author Raum
 */
class DrawPuzzle < View
	def initialize(context:Context):void
		super
		@cntxt = context
		@wm = WindowManager(context.getSystemService(Context.WINDOW_SERVICE))
		@display = Display(wm.getDefaultDisplay())
		tv = TypedValue.new()
		context.getTheme().resolveAttribute(android::R::attr.actionBarSize, tv, true)
		@abh = getResources().getDimensionPixelSize(tv.resourceId)
		@guiPuz = SuGuiPuzzle.newPuzzle()
		@bg = Rect.new()
		@bgC = Paint.new()
		@bgC.setColor(Color.rgb(200, 200, 200))
		@bgC.setStyle(Paint.Style.FILL)
		@bgC.setAlpha(255)
		Btns.init()
		gp = @guiPuz
		@returnBtn = Btns.create("Entry Mode") {
			gp.commit(false)
		}
		@solverBtn = Btns.create("Solve Mode") {
			gp.commit()
		}
		@saveBtn = Btns.create("Save") {
			
		}
		@loadBtn = Btns.create("Load") {
			
		}
		@solveBtn = Btns.create("Solve") {
			
		}
		@nextBtn = Btns.create("Next") {
			
		}
	end
	
	$Override
	def onDraw(canvas:Canvas):void
		super
		updateSizeAndOffset()
		# left, top, right, bottom
		@bg.set(0, 0, @size, @size)
		xT = float(0.0 + ((!@wide) ? 0 : @offset))
		yT = float(0.0 + ((@wide) ? 0 : @offset))
		canvas.translate(xT,yT)
		canvas.drawRect(@bg, @bgC)
		@guiPuz.gen()
		scl = float(@size) / float(1010)
		rscl = float(1010) / float(@size)
		canvas.scale(scl, scl)
		canvas.drawBitmap(Bitmap(@guiPuz.bitmap()), 5, 5, Paint(nil))
		canvas.scale(rscl, rscl)
		canvas.translate(-xT,-yT)
		drawButtons(canvas)
	end
	
	def updateSizeAndOffset():void
		sizeP = Point.new()
		@display.getSize(sizeP)
		@w = sizeP.x
		@h = sizeP.y
		@wide = (@w > (@h - @abh))
		@size = ((!wide) ? @w : (@h - @abh))
		@offset = 0 + (((wide ? @w : (@h - @abh)) - @size) / 2)
	end
	
	def drawButtons(canvas:Canvas):void
		btnMW = ((@wide) ? @offset : @size)
		btnMH = ((@wide) ? @size : @offset)
		xS = ((@wide) ? btnMW - 5 : int(btnMW / 2) - 2)
		yS = ((@wide) ? int(btnMH / 2) - 2 : btnMH - 5)
		if @guiPuz.solveMode()
			Btn(Btns.get(@returnBtn)).drawBtn(canvas, 0, 0, btnMW, btnMH - 5)
			xT = ((@wide) ? @size + @offset + 5 : 0)
			yT = ((@wide) ? 0 : @size + @offset + 5)
			Btn(Btns.get(@solveBtn)).drawBtn(canvas, 0, 0, xS, yS)
			xT = ((@wide) ? 0 : int(btnMW / 2) + 2)
			yT = ((@wide) ? int(btnMH / 2) + 2 : 0)
			Btn(Btns.get(@nextBtn)).drawBtn(canvas, xT, yT, xS, yS)
		else
			Btn(Btns.get(@solverBtn)).drawBtn(canvas, 0, 0, btnMW, btnMH - 5)
			xT = ((@wide) ? @size + @offset + 5 : 0)
			yT = ((@wide) ? 0 : @size + @offset + 5)
			Btn(Btns.get(@saveBtn)).drawBtn(canvas, xT, yT, xS, yS)
			xT = xT + ((@wide) ? 0 : int(btnMW / 2) + 2)
			yT = yT + ((@wide) ? int(btnMH / 2) + 2 : 0)
			Btn(Btns.get(@loadBtn)).drawBtn(canvas, xT, yT, xS, yS)
		end
	end
	
	$Override
	def onTouchEvent(e:MotionEvent):boolean
		return super(e) if (e.getAction() != MotionEvent.ACTION_DOWN)
		x = e.getX()
		y = e.getY()
		a = ((@wide) ? x : y)
		if ((a > @offset) and (a < (@size + @offset)))
			cellBtn(x,y)
		else
			Btns.buttons().each {|btn:Btn| btn.click(x,y) }
		end
		invalidate()
		return true
	end
	
	def cellBtn(x:float, y:float):void
		cx = int(x - (5 + ((@wide) ? @offset : 0)))
		cy = int(y - (5 + ((@wide) ? 0 : @offset)))
		n = getGCellAt(cx, cy)
		@guiPuz.cells()[n].nextVal()
	end
	
	def getGCellAt(x:int, y:int):int
		return -1 if (((x < 0) or (x > (@size - 10))) or ((y < 0) or (y > (@size - 10))))
		cl = int((float(x) * float(9)) / float(@size - 10))
		rw = int((float(y) * float(9)) / float(@size - 10))
		return -1 if (((cl < 0) or (rw < 0)) or ((cl > 8) or (rw > 8)))
		return ((rw * 9) + cl)
	end
	
	class Btns
		def self.init():void
			@@btns = Btn[0]
			@@lbls = String[0]
		end
		
		def self.create(txt:String, act:Click):int
			tmp = Btn.new(txt)
			tmp.setAction(act)
			pos = @@btns.length
			Btns.add(tmp)
			return pos
		end
		
		def self.add(btn:Btn):void
			tmp = Btn[@@btns.length + 1]
			@@btns.length.times do |i:int|
				tmp[i] = @@btns[i]
			end
			tmp[@@btns.length] = btn
			@@btns = tmp
		end
		
		def self.buttons():Btn[]
			@@btns
		end
		
		def self.get(i:int):Btn
			return @@btns[i] unless ((i < 0) or (i >= @@btns.length))
			return Btn.new("")
		end
		
		def self.get(str:String):Btn
			out = Btn.new("")
			@@btns.each do |btn:Btn|
				next unless Btn(btn).getText().equals(str)
				out = Btn(btn)
			end
			return Btn(out)
		end
	end
	
	class Btn
		def initialize(string = ""):void
			@pnt = Paint.new()
			@tf = Typeface(Typeface.create("Courier New",Typeface.BOLD))
			@pnt.setColor(Color.rgb(5, 5, 5))
			@pnt.setStyle(Paint.Style.FILL)
			@pnt.setTypeface(@tf)
			@brdP = Paint.new()
			@brdP.setColor(Color.rgb(200, 200, 200))
			@brdP.setStyle(Paint.Style.FILL)
			@brdP.setAlpha(255)
			@brdr = Rect.new()
			@bg = Rect.new()
			@bgP = Paint.new()
			@bgP.setColor(Color.rgb(50, 30, 50))
			@bgP.setStyle(Paint.Style.FILL)
			@bgP.setAlpha(255)
			setText(string)
		end
		
		def setText(string:String):void
			@str = string
		end
		
		def setBrdrClr(r:int,g:int,b:int):void
			@brdP.setColor(Color.rgb(r, g, b))
		end
		
		def setBtnClr(r:int,g:int,b:int):void
			@bgP.setColor(Color.rgb(r, g, b))
		end
		
		def getText():String
			@str
		end
		
		def paint():Paint
			@pnt
		end
		
		def w():int
			@w
		end
		
		def h():int
			@h
		end
		
		def xT():int
			@xT
		end
		
		def yT():int
			@yT
		end
		
		def x():int
			int((float(@bw) / float(2)) - (float(@w) / float(2)))
		end
		
		def y():int
			int((float(@bh) / float(2)) + (float(@h) / float(2)))
		end
		
		def textBounds():Rect
			out = Rect.new()
			@pnt.getTextBounds(@str, 0, @str.length(), out)
			out
		end
		
		def calcWH():void
			@pnt.setTextSize(@sz)
			@pnt.setFlags(Paint.ANTI_ALIAS_FLAG)
			bounds = textBounds()
			@h = bounds.height()
			@w = bounds.width()
		end
		
		def recalcSize():void
			return if (((@h > 0) and (@w > 0)) and (@w < (@bw - 19)))
			calcWH() if (@h == 0)
			unless (@w < (@bw - 19))
				@sz = int(float(@sz * (@bw - 20)) / float(@w))
				@h = 0
				@w = 0
				recalcSize()
			end
		end
		
		def drawBtn(canvas:Canvas, xTran:int, yTran:int, btnMW:int, btnMH:int):void
			@xT = xTran
			@yT = yTran
			@bw = btnMW
			@bh = btnMH
			@wide = (@bw > @bh)
			@sz = int((@bh - int(@bh / 32)) / 2)
			recalcSize()
			@brdr.set(0,0,@bw, @bh)
			@bg.set(5,5,@bw - 5, @bh - 5)
			canvas.translate(@xT,@yT)
			canvas.drawRect(@brdr, @brdP)
			canvas.drawRect(@bg, @bgP)
			# Todo: If button is not wide we should split at spaces and draw words top to bottom
			canvas.drawText(@str, x(), y(), @pnt)
			canvas.translate(-@xT,-@yT)
		end
		
		def setAction(act:Click):void
			# store lamda
			@action = act
		end
		
		def click(xC:float, yC:float):void
			return if (int(@w * @h) == 0)
			return unless (((xC > @xT) and (xC < (@xT + @w))) and ((yC > @yT) and (yC < (@yT + @h))))
			# run lamda
			@action.onClick()
		end
	end
	
	class SuGuiPuzzle < Canvas
		@@r = Rect.new()
		@@pBG = Paint.new()   # Background
		
		def self.init():void
			return unless @@r.isEmpty()
			@@r.set(0,0,1000,1000)
			@@pBG.setColor(Color.rgb(0, 0, 0))
			@@pBG.setStyle(Paint.Style.FILL)
			@@pBG.setAlpha(255)
		end
		
		def self.newPuzzle():SuGuiPuzzle
			SuGuiPuzzle.init()
			out = SuGuiPuzzle.new()
			return out
		end
		
		def initialize():void
			super
			@puz = SuPuzzle.new(3)
			@solveMode = false
			@gCells = SuGuiCell[81]
			@boxS = SuGuiBlock[9]
			3.times do |brw:int|
				3.times do |bcl:int|
					#bsz = int(@size / 3) - 12
					bx = SuGuiBlock.newBlock(self)
					@boxS[((brw * 3) + bcl)] = bx
					3.times do |crw:int|
						3.times do |ccl:int|
							loc = ((((brw * 27) + (crw * 9)) + (bcl * 3)) + ccl)
							#csz = (bsz / 3)
							##(csz -= 6) if (csz > 15)
							cel = SuGuiCell.newCell(self, loc)
							@gCells[loc] = cel
							bx.addLoc(crw,ccl,loc)
						end
					end
				end
			end
			
		end
		
		def solveMode():boolean
			@solveMode
		end
		
		def puzzle():SuPuzzle
			@puz
		end
		
		def suCell(i:int):SuCell
			return @puz.cells()[i] if ((i >= 0) and (i < 81))
			return SuCell(nil)
		end
		
		def commit(sm = true):void
			if sm
				
			end
			@solveMode = sm
		end
		
		def refresh():void
			@bitmap = Bitmap.createBitmap(1000, 1000, Bitmap.Config.ARGB_8888)
			#@bitmap.setHasAlpha(false)
			setBitmap(@bitmap)
			drawRect(@@r, @@pBG)
		end
		
		def bitmap():Bitmap
			@bitmap
		end
		
		def cells():SuGuiCell[]
			@gCells
		end
		
		def gen():void
			refresh()
			translate(5,5)
			3.times do |rw|
				3.times do |cl|
					x = cl * 330
					y = rw * 330
					bx = @boxS[((rw * 3) + cl)]
					bx.gen()
					drawBitmap(Bitmap(bx.bitmap()), x, y, Paint.new().setAlpha(255))
				end
			end
			translate(-5,-5)
		end
		
		def cellCanBe(cel:int, n:int):boolean
			return true if n == 0
			out = true
			tc = @gCells[cel]
			81.times do |i:int|
				next unless out
				next if cel == i
				c = @gCells[i]
				next unless (((c.box() == tc.box()) or (c.row() == tc.row())) or (c.col() == tc.col()))
				next if c.val() == 0
				next if c.val() != n
				out = false
			end
			out
		end
		
		
	end
	
	class SuGuiBlock < Canvas
		@@r = Rect.new()
		@@pBG = Paint.new()   # Background
		
		def self.init():void
			return unless @@r.isEmpty()
			@@r.set(0,0,330,330)
			@@pBG.setColor(Color.rgb(0, 0, 0))
			@@pBG.setStyle(Paint.Style.FILL)
		end
		
		def self.newBlock(prnt:SuGuiPuzzle):SuGuiBlock
			SuGuiBlock.init()
			out = SuGuiBlock.new()
			out.setParent(prnt)
			return out
		end
		
		def initialize():void
			super
			@cels = int[9]
		end
		
		def setParent(prnt:SuGuiPuzzle):void
			@parent = prnt
		end
		
		def refresh():void
			@bitmap = Bitmap.createBitmap(330, 330, Bitmap.Config.ARGB_8888)
			#@bitmap.setHasAlpha(false)
			setBitmap(@bitmap)
			drawRect(@@r, @@pBG)
			save()
		end
		
		def bitmap():Bitmap
			@bitmap
		end
		
		def addLoc(rw:int, cl:int, loc:int):void
			return unless (((rw >= 0) and (rw < 3)) and ((cl >= 0) and (cl < 3)))
			iloc = ((rw * 3) + cl)
			@cels[iloc] = loc
		end
		
		def gen():void
			refresh()
			translate(3,3)
			Ops.sort(@cels)
			3.times do |rw|
				3.times do |cl|
					x = (cl * 108)
					y = (rw * 108)
					icel = @cels[((rw * 3) + cl)]
					cel = @parent.cells()[icel]
					cel.gen()
					drawBitmap(Bitmap(cel.bitmap()), x, y, Paint.new().setAlpha(255))
				end
			end
			translate(-3,-3)
		end
		
	end
	
	class SuGuiCell < Canvas
		@@r = Rect.new()
		@@pBrdr = Paint.new() # Border
		@@pBG = Paint.new()   # Background
		@@pBGH = Paint.new()   # Background Highlighted
		@@pPncl = Paint.new()  # Text
		@@pClue = Paint.new() # Clue
		@@pSlvd = Paint.new() # Solved
		
		def self.init():void
			return unless @@r.isEmpty()
			@@r.set(0,0,108,108)
			@@pBrdr.setColor(Color.rgb(0, 0, 0))
			@@pBrdr.setStyle(Paint.Style.STROKE)
			@@pBrdr.setStrokeWidth(5)
			@@pBG.setColor(Color.rgb(235, 235, 235))
			@@pBG.setStyle(Paint.Style.FILL)
			@@pBG.setAlpha(255)
			@@pBGH.setColor(Color.rgb(255, 215, 215))
			@@pBGH.setStyle(Paint.Style.FILL)
			@@pBGH.setAlpha(255)
			@@tf = Typeface.create("Courier New",Typeface.BOLD)
			@@pPncl.setColor(Color.rgb(0, 0, 0))
			@@pPncl.setStyle(Paint.Style.FILL)
			@@pPncl.setTypeface(@@tf)
			@@pPncl.setTextSize(35)
			@@pPncl.setFlags(Paint.ANTI_ALIAS_FLAG)
			@@pClue.setColor(Color.rgb(90, 5, 5))
			@@pClue.setStyle(Paint.Style.FILL)
			@@pClue.setTypeface(@@tf)
			@@pClue.setTextSize(98)
			@@pClue.setFlags(Paint.ANTI_ALIAS_FLAG)
			@@pSlvd.setColor(Color.rgb(5, 5, 5))
			@@pSlvd.setStyle(Paint.Style.FILL)
			@@pSlvd.setTypeface(@@tf)
			@@pSlvd.setTextSize(98)
			@@pSlvd.setFlags(Paint.ANTI_ALIAS_FLAG)
		end
		
		def self.newCell(prnt:SuGuiPuzzle, loc:int):SuGuiCell
			SuGuiCell.init()
			out = SuGuiCell.new()
			out.setParent(prnt)
			out.setLoc(loc)
			return out
		end
		
		def initialize():void
			super
			@hl = false
			@val = 0
			@box = 0
			@row = 0
			@col = 0
		end
		
		def setParent(prnt:SuGuiPuzzle):void
			@parent = prnt
		end
		
		def puz():SuPuzzle
			@parent.puzzle()
		end
		
		def setLoc(n:int):void
			@loc = n
			calcBRC()
		end
		
		def loc():int
			@loc
		end
		
		def row():int
			@row
		end
		
		def col():int
			@col
		end
		
		def box():int
			@box
		end
		
		def suCell():SuCell
			@parent.suCell(@loc)
		end
		
		def val():int
			return @val unless @parent.solveMode()
			suCell().val()
		end
		
		def valS():String
			v = val()
			return ("" + v) unless v == 0
			return " "
		end
		
		def nextVal():void
			@hl = true
			return if @parent.solveMode()
			x = @val + 1
			(x += 1) until @parent.cellCanBe(@loc, x)
			x = 0 if (x > 9)
			@val = x
		end
		
		def isClue():boolean
			return true unless @parent.solveMode()
			return suCell().isClue()
		end
		
		def calcBRC():void
			l = (@loc + 1)
			@col = l % 9
			@col = 9 if (@col == 0)
			@row = 0
			(@row += 1; l -= 9) until (l < 1)
			r = @row
			c = @col
			@brow = 0
			@bcol = 0
			(@brow += 1; c -= 3) until (c < 1)
			(@bcol += 1; r -= 3) until (r < 1)
			@box = (((@brow - 1) * 3) + @bcol)
		end
		
		def refresh():void
			@bitmap = Bitmap.createBitmap(108, 108, Bitmap.Config.ARGB_8888)
			#@bitmap.setHasAlpha(false)
			setBitmap(@bitmap)
			drawRect(@@r, ((@hl) ? @@pBGH : @@pBG))
			drawRect(@@r, @@pBrdr)
			@hl = false
		end
		
		def bitmap():Bitmap
			@bitmap
		end
		
		def gen():void
			refresh()
			translate(10,33)
			# define cel
			if (isClue() or suCell().isSet())
				p = ((isClue()) ? @@pClue : @@pSlvd)
				#num = val()
				#txt = ((num == 0) ? "" : "" + num)
				drawText(valS(), 18, 54, p)
			else
				3.times do |rw|
					3.times do |cl|
						x = cl * 33
						y = rw * 33
						num = 1 + ((rw * 3) + cl)
						if suCell().canbeBool(num)
							# draw num
							drawText("" + num, x, y, @@pPncl)
						end
					end
				end
			end
			translate(-10,-33)
		end
		
		def setHighlight(highlight:boolean):void
			@hl = highlight
		end
	end
	
end

interface Click do
	def onClick():void;end
end

