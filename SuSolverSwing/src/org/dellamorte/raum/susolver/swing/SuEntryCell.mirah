package org.dellamorte.raum.susolver.swing

import org.dellamorte.raum.susolver.swing.*
import org.dellamorte.raum.mirah.awtextra.AbsoluteConstraints
import org.dellamorte.raum.mirah.awtextra.AbsoluteLayout

import java.util.Arrays
import java.util.ArrayList

import java.awt.*
import javax.swing.*

import java.awt.*
import java.awt.event.*

import javax.swing.*

import org.netbeans.lib.awtextra.*

class SuEntryCell < JPanel
	def initialize()
		super
		@valLbl = JLabel.new()
		@cel = 0
		@box = 0
		@irow = 0
		@icol = 0
		@brow = 0
		@bcol = 0
		
		#setAlignmentX(float(0.0))
		#setAlignmentY(float(0.0))
		setMaximumSize(java::awt::Dimension.new(30, 30))
		setMinimumSize(java::awt::Dimension.new(30, 30))
		setPreferredSize(java::awt::Dimension.new(30, 30))
		setLayout(AbsoluteLayout.new())
		setBackground(java::awt::Color.new(245, 245, 245))
		
		@valLbl.setFont(java::awt::Font.new("Courier New", 1, 24))
		@valLbl.setHorizontalAlignment(javax::swing::SwingConstants.CENTER)
		@valLbl.setText("")
		@valLbl.setAlignmentY(float(0.0))
		@valLbl.setFocusable(true)
		@valLbl.setIconTextGap(0)
		@valLbl.setMaximumSize(java::awt::Dimension.new(30, 30))
		@valLbl.setMinimumSize(java::awt::Dimension.new(30, 30))
		@valLbl.setPreferredSize(java::awt::Dimension.new(30, 30))
		@valLbl.setRequestFocusEnabled(true)
		add(@valLbl, AbsoluteConstraints.new(0, 0, -1, -1))
	end
	
	def lbl():JLabel
		@valLbl
	end
	
	def setText(txt:String):void
		@valLbl.setText(txt)
		revalidate()
		repaint()
	end
	
	def getText():String
		@valLbl.getText()
	end
	
	def setCellNum(v:int):void
		@cel = v
		v = v + 1 until ((v % 3) == 0)
		@irow = v / 3
		@icol = @cel - (3 * (@irow - 1))
	end
	
	def setBoxNum(v:int):void
		return if ((v < 1) or (v > 9))
		@box = v
		v = v + 1 until ((v % 3) == 0)
		@brow = v / 3
		@bcol = @box - (3 * (@brow - 1))
	end
	
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
	
	def row():int
		return 0 if (((@cel == 0) or (@box == 0)) or (@brow <= 0))
		(3 * (@brow - 1)) + irow()
	end
	
	def col():int
		return 0 if (((@cel == 0) or (@box == 0)) or (@bcol <= 0))
		(3 * (@bcol - 1)) + icol()
	end
	
	def val():int
		n = @valLbl.getText()
		return int(0) unless n =~ /[1-9]/
		return int(Integer.parseInt(n))
	end
	
	def reset():void
		setText("")
	end
end