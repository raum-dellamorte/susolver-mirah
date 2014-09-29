package org.dellamorte.raum.susolver.cn1

import org.dellamorte.raum.susolver.cn1.*
#import org.dellamorte.raum.mirah.awtextra.AbsoluteConstraints
#import org.dellamorte.raum.mirah.awtextra.AbsoluteLayout

import java.util.Arrays
import com.codename1.ui.Button
import com.codename1.ui.geom.Dimension
import com.codename1.ui.events.ActionEvent
import com.codename1.ui.Font
import com.codename1.ui.Display
import java.util.ArrayList

/**
 *
 * @author Raum
 */
class SuEntryCell < Button
	def initialize():void
		super()
		setPreferredSize(Dimension.new(30,30))
		setGap(0)
		setVal(0)
		@style = getStyle()
		@style.setFont(pickFont())
		@style.setMargin(0, 0, 0, 0)
		@style.setPadding(0, 0, 0, 0)
	end
	
	def pickFont():Font
		sz = SuSolverGui.calculateDPI
		if sz == Display.DENSITY_HD
			Font.getBitmapFont("SuEntryHD")
		elsif sz == Display.DENSITY_VERY_HIGH
			Font.getBitmapFont("SuEntryVH")
		elsif sz == Display.DENSITY_HIGH
			Font.getBitmapFont("SuEntryH")
		else
			Font.getBitmapFont("SuEntry")
		end
	end
	
	def setLoc(loc:int):void
		@loc = loc
		calcBRC()
		c = self
		self.addActionListener do |e:ActionEvent|
			x = c.val() + 1
			until SuSolverGui.cellCanBe(c.loc(), x)
				x += 1
			end
			x = 0 if (x > 9)
			c.setVal(x)
		end
	end
	
	def loc():int
		@loc
	end
	
	def setVal(n:int):void
		@val = n
		setText(self.valS())
	end
	
	def val():int
		@val
	end
	
	def valS():String
		return ("" + @val) unless @val == 0
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
	/*
	def irow():int
		@irow
	end
	
	def icol():int
		@icol
	end
	
	def brow():int
		@brow
	end
	
	def bcol():int
		@bcol
	end
	*/
end

