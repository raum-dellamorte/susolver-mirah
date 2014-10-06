package org.dellamorte.raum.susolver.cn1

import org.dellamorte.raum.susolver.cn1.*
import org.dellamorte.raum.susolver.supuzzle.*

import java.util.Arrays
import com.codename1.ui.Button
import com.codename1.ui.geom.Dimension
import com.codename1.ui.events.ActionEvent
import com.codename1.ui.Font
import com.codename1.ui.Display
import com.codename1.ui.Component
import com.codename1.ui.layouts.LayeredLayout
import com.codename1.ui.Container
import com.codename1.ui.layouts.GridLayout
import com.codename1.ui.layouts.FlowLayout
import com.codename1.ui.Label
import com.codename1.ui.layouts.BoxLayout
import com.codename1.ui.Graphics
import com.codename1.ui.Transform
import com.codename1.util.MathUtil
import com.codename1.ui.Image
import java.util.ArrayList

/**
 *
 * @author Raum
 */
class SuSolveCell < Component
	/*def self.setSuPuzzle():void
		
	end
	
	def self.suPuzzle():SuPuzzle
		
	end*/
	
	def self.build(loc:int, sz:int):SuSolveCell
		cel = SuSolveCell.new()
		cel.setLoc(loc)
		cel.setCellSize(sz)
		cel.setClue(false)
		cel
	end
	
	$Override
	def initialize():void
		super()
		@style = getStyle()
		@style.setMargin(0, 0, 0, 0)
		@style.setPadding(0, 0, 0, 0)
	end
	
	def setCellSize(syze:int):void
		@sz = syze
		setPreferredSize(Dimension.new(@sz,@sz))
		setSize(Dimension.new(@sz,@sz))
	end
	
	def setClue(isClue:boolean):void
		@clue = isClue
	end
	
	def setLoc(loc:int):void
		@loc = loc
		calcBRC()
	end
	
	def loc():int
		@loc
	end
	
	/*def setVal(n:int, doRepaint = true, isClue = false):void
		@val = n
		setClue(true) if isClue
		repaint() if doRepaint
	end*/
	
	def valS():String
		return ("" + val()) unless val() == 0
		return "_"
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
	
	def row():int
		@row
	end
	
	def col():int
		@col
	end
	
	def box():int
		@box
	end
	
	def set(cel:SuCell):void
		@suCell = cel
		repaint()
	end
	
	def reset():void
		@suCell = SuCell(nil)
		repaint()
	end
	
	def val():int
		if @suCell == nil
			return 0
		else
			return @suCell.val()
		end
	end
	
	def pMarks():int[]
		if @suCell == nil
			out = int[9]
			9.times do |i|
				out[i] = i + 1
			end
			return out
		else
			return @suCell.pmarks()
		end
	end
	
	def canBe(n:int):boolean
		return !@suCell.eliminated?(n) unless (@suCell == nil)
		return true
	end
	
	def pickFont():Font
		syze = SuSolverGui.calculateDPI
		if Font.isTrueTypeFileSupported()
			pmf = Font.createTrueTypeFont("Courier New Bold", "cnewbold.ttf")
			pmf.derive(@fontSz, Font.STYLE_BOLD) # @fontSz
		elsif (val() == 0)
			if syze == Display.DENSITY_HD
				Font.getBitmapFont("PMarksHD")
			elsif syze == Display.DENSITY_VERY_HIGH
				Font.getBitmapFont("PMarksVH")
			elsif syze == Display.DENSITY_HIGH
				Font.getBitmapFont("PMarksH")
			else
				Font.getBitmapFont("PMarks")
			end
		else
			if syze == Display.DENSITY_HD
				Font.getBitmapFont("SuEntryHD")
			elsif syze == Display.DENSITY_VERY_HIGH
				Font.getBitmapFont("SuEntryVH")
			elsif syze == Display.DENSITY_HIGH
				Font.getBitmapFont("SuEntryH")
			else
				Font.getBitmapFont("SuEntry")
			end
		end
	end
	
	def bgcolor():int
		return 15527148 if @clue # ECECEC
		return 14474460 # DCDCDC
	end
	
	def fgcolor():int
		return 3937300 if @clue # 3C1414
		return 1315860 # 141414
	end
	
	$Override
	def paint(g:Graphics):void
		super(g)
		x = getX(); y = getY() #; w = getWidth(); h = getHeight()
		g.setColor(0) # border
		g.drawRect(x + 1, y + 1, @sz, @sz)
		g.setColor(bgcolor())
		g.fillRect(x + 2, y + 2, @sz - 2, @sz - 2)
		g.setColor(fgcolor())
		if (val() == 0)
			inc = ((@sz / 3) - ((@sz * 5) / 100))
			brdr = ((@sz - (inc * 3)) / 2)
			@fontSz = ((inc * 90) / 100)
			g.setFont(pickFont())
			3.times do |r:int|
				3.times do |c:int|
					n = (((r * 3) + c) + 1)
					if canBe(n)
						s = ("" + n)
					else
						s = " "
					end
					ix = ((((c * inc) + (brdr + (@fontSz / 4))) + x) + 2)
					iy = ((((r * inc) + brdr) + y) + 2)
					g.drawString(s, ix, iy)
				end
			end
		else
			@fontSz = ((@sz * 90) / 100)
			brdr = ((@sz - @fontSz) / 4)
			g.setFont(pickFont())
			ix = ((brdr + x) + (@fontSz / 4))
			iy = (brdr + y)
			g.drawString(valS(), ix, iy)
		end
	end
end

