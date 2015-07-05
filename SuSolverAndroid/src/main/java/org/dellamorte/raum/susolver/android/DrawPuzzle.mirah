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
		Btns.init(context)
		gp = @guiPuz
		@solverBtn = Btns.create("Solve Mode", :entry) {
			#Toast.makeText(context, "Clicked Solve Mode", Toast.LENGTH_SHORT).show()
			gp.commit()
		}
		@saveBtn = Btns.create("Save", :entry) {
			#Toast.makeText(context, "Clicked Save", Toast.LENGTH_SHORT).show()
			gp.save()
		}
		@loadBtn = Btns.create("Load", :entry) {
			#Toast.makeText(context, "Clicked Load", Toast.LENGTH_SHORT).show()
			gp.load()
		}
		@returnBtn = Btns.create("Entry Mode", :solver) {
			#Toast.makeText(context, "Clicked Entry Mode", Toast.LENGTH_SHORT).show()
			gp.commit(false)
		}
		@solveBtn = Btns.create("Solve", :solver) {
			#Toast.makeText(context, "Clicked Solve", Toast.LENGTH_SHORT).show()
			gp.solve()
		}
		@nextBtn = Btns.create("Next", :solver) {
			#Toast.makeText(context, "Clicked Next", Toast.LENGTH_SHORT).show()
			gp.nextStep()
		}
	end
	
	$Override
	def onDraw(canvas:Canvas):void
		super
		updateSizeAndOffset()
		xT = float(0 + ((!@wide) ? 0 : @offset))
		yT = float(0 + ((@wide) ? 0 : @offset))
		@guiPuz.drawPuz(canvas, xT, yT, @size)
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
		#xS = ((@wide) ? btnMW - 5 : int(btnMW / 2) - 2)
		#yS = ((@wide) ? int(btnMH / 2) - 2 : btnMH - 5)
		xT = ((@wide) ? @size + @offset + 5 : 0)
		yT = ((@wide) ? 0 : @size + @offset + 5)
		top = BtnArea.new(0,0,btnMW,btnMH - 5)
		btm = BtnArea.new(xT,yT,btnMW,btnMH - 5,1)
		if @guiPuz.solveMode()
			Btns.visScreen(:solver)
			Btn(Btns.get(@returnBtn)).drawBtn(canvas, top)
			Btn(Btns.get(@solveBtn)).drawBtn(canvas, btm.areas()[0])
			Btn(Btns.get(@nextBtn)).drawBtn(canvas, btm.areas()[1])
		else
			Btns.visScreen(:entry)
			Btn(Btns.get(@solverBtn)).drawBtn(canvas, top)
			Btn(Btns.get(@saveBtn)).drawBtn(canvas, btm.areas()[0])
			Btn(Btns.get(@loadBtn)).drawBtn(canvas, btm.areas()[1])
		end
	end
	
	$Override
	def onTouchEvent(e:MotionEvent):boolean
		return super(e) if (e.getAction() != MotionEvent.ACTION_DOWN)
		x = e.getX()
		y = e.getY()
		a = ((@wide) ? x : y)
		if ((a > @offset) and (a < (@size + @offset)))
			@guiPuz.cellBtn(x,y)
		else
			Btns.buttons().each {|btn:Btn| btn.click(x,y) if btn.vis() }
		end
		invalidate()
		return true
	end
	
	def toast(str:String):void
		Toast.makeText(@cntxt, str, Toast.LENGTH_SHORT).show()
	end
	
	class Btns
		def self.init(context:Context):void
			@@cntxt = context
			@@btns = Btn[0]
			@@lbls = String[0]
		end
		
		def self.create(txt:String, scrn:String, act:Click):int
			tmp = Btn.new(txt)
			tmp.setAction(act)
			tmp.setScreen(scrn)
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
		
		def self.visScreen(scrn:String):void
			@@btns.each do |btn:Btn|
				btn.setVis(btn.scrTest(scrn))
			end
		end
	end
	
	class BtnArea
		def initialize(xTran:int, yTran:int, width:int, height:int, divide = 0, vertical = false):void
			@xT = xTran
			@yT = yTran
			@w = width
			@h = height
			@vert = vertical
			setDiv(divide)
		end
		
		def xTran():int
			@xT
		end
		
		def yTran():int
			@yT
		end
		
		def width():int
			@w
		end
		
		def height():int
			@h
		end
		
		def isVertical():boolean
			@vert
		end
		
		def isHorizontal():boolean
			!@vert
		end
		
		def setDiv(divide:int):void
			@div = ((divide < 0) ? 0 : divide)
			genChilds()
		end
		
		def div():int
			@div
		end
		
		def genChilds():void
			return if (@div < 1)
			d = @div + 1
			@childs = BtnArea[d]
			nW = ( (@vert) ? @w : int(float(@w) / d) )
			nH = ( (!@vert) ? @h : int(float(@h) / d) )
			d.times do |i:int|
				xTr = @xT + ( (@vert) ? (-2) : (i * (nW)) )
				yTr = @yT + ( (!@vert) ? (-2) : (i * (nH)) )
				@childs[i] = BtnArea.new(xTr + 2, yTr + 2, nW - 4, nH - 4)
			end
		end
		
		def areas():BtnArea[]
			return @childs if (@div > 0)
			out = BtnArea[1]
			out[0] = self
			return out
		end
		
	end
	
	class Btn
		def initialize(string = ""):void
			@screen = ""
			@visibal = false
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
		
		def setVis(visible = true)
			@visibal = visible
		end
		
		def vis():boolean
			@visibal
		end
		
		def setScreen(scrn:String):void
			@screen = scrn
		end
		
		def scrTest(scrn:String):boolean
			@screen.equals(scrn)
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
		
		def tmpStr(str:String)
			ts = StringBuilder.new()
			int(str.length()).times do |i:int|
				ts.append("A")
			end
			ts.toString()
		end
		
		def textBounds():Rect
			out = Rect.new()
			@pnt.getTextBounds(tmpStr(@str), 0, @str.length(), out)
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
		
		def drawBtn(canvas:Canvas, area:BtnArea):void
			drawBtn(canvas, area.xTran(), area.yTran(), area.width(), area.height())
		end
		
		def setAction(act:Click):void
			# store lamda
			@action = act
		end
		
		def click(xC:float, yC:float):void
			return unless @visibal
			return if (int(@w * @h) == 0)
			return unless (((xC > @xT) and (xC < (@xT + @bw))) and ((yC > @yT) and (yC < (@yT + @bh))))
			# run lamda
			@action.onClick()
		end
	end
	
	class SuGuiCell
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
		
		def drawCell(c:Canvas, xTran:float, yTran:float, scl:float):void
			sclFrom = 104 # 108
			c.translate(xTran,yTran)
			@@r.set(0 + int(8 * scl),0 + int(8 * scl),int(sclFrom * scl),int(sclFrom * scl))
			@@pPncl.setTextSize(int(33 * scl))
			@@pClue.setTextSize(int(98 * scl))
			@@pSlvd.setTextSize(int(98 * scl))
			c.drawRect(@@r, ((@hl) ? @@pBGH : @@pBG))
			#c.drawRect(@@r, @@pBrdr)
			@hl = false
			c.translate(10 * scl,33 * scl)
			if (isClue() or suCell().isSet())
				p = ((isClue()) ? @@pClue : @@pSlvd)
				c.drawText(valS(), int(18 * scl), int(58 * scl), p)
			else
				3.times do |rw|
					3.times do |cl|
						x = int((cl * 33) * scl)
						y = int((rw * 33) * scl)
						num = 1 + ((rw * 3) + cl)
						if suCell().canbeBool(num)
							# draw num
							c.drawText("" + num, x + 1, y + 1, @@pPncl)
						end
					end
				end
			end
			c.translate(-(xTran + (10 * scl)),-(yTran + (33 * scl)))
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
		
		def entryVal():int
			@val
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
		
		def setHighlight(highlight:boolean):void
			@hl = highlight
		end
	end
	
	class SuGuiBlock
		@@r = Rect.new()
		@@pBG = Paint.new()   # Background
		
		def self.init():void
			return unless @@r.isEmpty()
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
		
		def drawBlock(c:Canvas, xTran:float, yTran:float, scl:float):void
			c.translate(xTran,yTran)
			@@r.set(0,0,int(324 * scl),int(324 * scl))
			c.drawRect(@@r, @@pBG)
			brdrsz = int(3 * scl)
			clsz = int(99 * scl)
			clspace = int((108 * scl) - clsz)
			c.translate(brdrsz,brdrsz)
			Ops.sort(@cels)
			3.times do |rw|
				3.times do |cl|
					x = (cl * clsz) + (cl * clspace)
					y = (rw * clsz) + (rw * clspace)
					icel = @cels[((rw * 3) + cl)]
					cel = @parent.cells()[icel]
					cel.drawCell(c, float(x), float(y), float(scl))
				end
			end
			c.translate(-(xTran + brdrsz),-(yTran + brdrsz))
		end
		
		def setParent(prnt:SuGuiPuzzle):void
			@parent = prnt
		end
		
		def addLoc(rw:int, cl:int, loc:int):void
			return unless (((rw >= 0) and (rw < 3)) and ((cl >= 0) and (cl < 3)))
			iloc = ((rw * 3) + cl)
			@cels[iloc] = loc
		end
		
	end
	
	class SuGuiPuzzle
		def self.init():void
			# Class setup here
		end
		
		def self.newPuzzle():SuGuiPuzzle
			SuGuiPuzzle.init()
			out = SuGuiPuzzle.new()
			# Object setup here
			return out
		end
		
		def initialize():void
			super
			@bg = Rect.new()
			@bgC = Paint.new()
			@bgC.setColor(Color.rgb(200, 200, 200))
			@bgC.setStyle(Paint.Style.FILL)
			@bgC.setAlpha(255)
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
		
		def drawPuz(c:Canvas, xTran:float, yTran:float, syze:int):void
			@xT = xTran
			@yT = yTran
			@sz = syze
			c.translate(@xT,@yT)
			# left, top, right, bottom
			@bg.set(0, 0, @sz, @sz)
			c.drawRect(@bg, @bgC)
			c.translate(5,5)
			scl = float(float(@sz) / float(1010))
			rscl = float(float(1) / scl)  # float(1010) / float(@sz)
			#c.scale(scl, scl)
			bxsz = int(330 * scl)
			3.times do |rw|
				3.times do |cl|
					x = (cl * bxsz)
					y = (rw * bxsz)
					bx = @boxS[((rw * 3) + cl)]
					bx.drawBlock(c, float(x), float(y), scl)
				end
			end
			#c.scale(rscl, rscl)
			c.translate(-(@xT + 5),-(@yT + 5))
		end
		
		def solveMode():boolean
			@solveMode
		end
		
		def puzzle():SuPuzzle
			@puz
		end
		
		def suCell(i:int):SuCell
			return @puz.cells()[i] if Ops.inArray(i, 81)
			return SuCell(nil)
		end
		
		def commit(sm = true):void
			@puz = SuPuzzle.new(3) unless sm
			@puz.setCells(entryArray()) if sm
			@solveMode = sm
		end
		
		def entryArray():int[]
			out = int[81]
			81.times do |i:int|
				out[i] = @gCells[i].entryVal()
			end
			return out
		end
		
		def nextStep():void
			return unless @solveMode
			@puz.stepCheck()
		end
		
		def solve():void
			return unless @solveMode
			@puz.solve()
		end
		
		def save():void
			return if @solveMode
			
		end
		
		def load():void
			return if @solveMode
			
		end
		
		def cells():SuGuiCell[]
			@gCells
		end
		
		def validCell(n:int):boolean
			return Ops.inArray(n, 81)
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
		
		def cellBtn(x:float, y:float):void
			cx = int(x - (@xT + float(5)))
			cy = int(y - (@yT + float(5)))
			n = getGCellAt(cx, cy)
			@gCells[n].nextVal() if validCell(n)
		end
		
		def getGCellAt(x:int, y:int):int
			return -1 if (((x < 0) or (x > (@sz - 10))) or ((y < 0) or (y > (@sz - 10))))
			cl = int((float(x) * float(9)) / float(@sz - 10))
			rw = int((float(y) * float(9)) / float(@sz - 10))
			return -1 if (((cl < 0) or (rw < 0)) or ((cl > 8) or (rw > 8)))
			return ((rw * 9) + cl)
		end
		
		
	end
	
end

interface Click do
	def onClick():void;end
end

