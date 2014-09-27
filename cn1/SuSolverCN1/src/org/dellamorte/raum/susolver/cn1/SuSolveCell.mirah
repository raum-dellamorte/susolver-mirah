/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package org.dellamorte.raum.susolver.cn1

import org.dellamorte.raum.susolver.supuzzle.*
import org.dellamorte.raum.susolver.cn1.*

import com.codename1.ui.Graphics
#import com.codename1.ui.Button
import com.codename1.ui.Component
import com.codename1.ui.Container
#import com.codename1.ui.Dialog
import com.codename1.ui.Display
import com.codename1.ui.Form
#import com.codename1.ui.Image
import com.codename1.ui.Label
#import com.codename1.ui.TextArea
#import com.codename1.ui.animations.CommonTransitions
#import com.codename1.ui.events.ActionEvent
#import com.codename1.ui.events.ActionListener
import com.codename1.ui.geom.Dimension
#import com.codename1.ui.layouts.BorderLayout
#import com.codename1.ui.layouts.BoxLayout
#import com.codename1.ui.layouts.FlowLayout
#import com.codename1.ui.layouts.GridLayout
#import com.codename1.ui.layouts.LayeredLayout
#import com.codename1.ui.plaf.UIManager
#import com.codename1.ui.util.Resources
#import com.codename1.ui.util.UITimer
import java.io.IOException
import java.util.ArrayList
import java.util.Arrays
import java.util.Collections
import java.util.List

/**
 *
 * @author Raum
 */
class SuSolveCell < Component
	$Override
	def paint(g:Graphics):void
		
	end
	
	def initialize():void
		super
		@suCell = SuCell(nil)
		@cel = 0
		@box = 0
		@irow = 0
		@icol = 0
		@brow = 0
		@bcol = 0
		
		#setFocusable(false)
		#setMaximumSize(java::awt::Dimension.new(30, 30))
		#setMinimumSize(java::awt::Dimension.new(30, 30))
		#setLayout(javax::swing::OverlayLayout.new(self))
		
		@pMarksPanel = Container.new()
		@valPanel = Container.new()
		@valLbl = Container.new()
		
		@pMarkLbls = Label[9]
		9.times do |i|
			l = Label.new()
			#l.setFont() #(java::awt::Font.new("Courier New", 0, 8))
			#l.setHorizontalAlignment(javax::swing::SwingConstants.CENTER)
			#l.setText("" + (i + 1))
			#l.setAlignmentX(float(0.5))
			#l.setMaximumSize(java::awt::Dimension.new(10, 10))
			#l.setMinimumSize(java::awt::Dimension.new(10, 10))
			#l.setPreferredSize(java::awt::Dimension.new(10, 10))
			@pMarkLbls[i] = l
		end
		
		#@pMarksPanel.setLayout(AbsoluteLayout.new())
		
		#@pMarksPanel.add(@pMarkLbls[0], AbsoluteConstraints.new(0, 0, -1, -1))
		#@pMarksPanel.add(@pMarkLbls[1], AbsoluteConstraints.new(10, 0, -1, -1))
		#@pMarksPanel.add(@pMarkLbls[2], AbsoluteConstraints.new(20, 0, -1, -1))
		#@pMarksPanel.add(@pMarkLbls[3], AbsoluteConstraints.new(0, 10, -1, -1))
		#@pMarksPanel.add(@pMarkLbls[4], AbsoluteConstraints.new(10, 10, -1, -1))
		#@pMarksPanel.add(@pMarkLbls[5], AbsoluteConstraints.new(20, 10, -1, -1))
		#@pMarksPanel.add(@pMarkLbls[6], AbsoluteConstraints.new(0, 20, -1, -1))
		#@pMarksPanel.add(@pMarkLbls[7], AbsoluteConstraints.new(10, 20, -1, -1))
		#@pMarksPanel.add(@pMarkLbls[8], AbsoluteConstraints.new(20, 20, -1, -1))
		
		#add(@pMarksPanel)
		
		#@valPanel.setAlignmentX(float(0.0))
		#@valPanel.setAlignmentY(float(0.0))
		#@valPanel.setMaximumSize(java::awt::Dimension.new(30, 30))
		#@valPanel.setMinimumSize(java::awt::Dimension.new(30, 30))
		#@valPanel.setPreferredSize(java::awt::Dimension.new(30, 30))
		#@valPanel.setLayout(AbsoluteLayout.new())
		
		#@valLbl.setFont(java::awt::Font.new("Courier New", 1, 24))
		#@valLbl.setHorizontalAlignment(javax::swing::SwingConstants.CENTER)
		#@valLbl.setText("0")
		#@valLbl.setAlignmentY(float(0.0))
		#@valLbl.setFocusable(false)
		#@valLbl.setIconTextGap(0)
		#@valLbl.setMaximumSize(java::awt::Dimension.new(30, 30))
		#@valLbl.setMinimumSize(java::awt::Dimension.new(30, 30))
		#@valLbl.setPreferredSize(java::awt::Dimension.new(30, 30))
		#@valLbl.setRequestFocusEnabled(false)
		#@valLbl.setVerifyInputWhenFocusTarget(false)
		#@valPanel.add(@valLbl, AbsoluteConstraints.new(0, 0, -1, -1))
		
		#add(@valPanel)
		@counter = 0
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
	
	def set(cel:SuCell):void
		@suCell = cel
		updateLbls()
	end
	
	def reset():void
		@suCell = SuCell(nil)
		updateLbls()
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
	
	def updateLbls():void
		@counter = @counter + 1
		if @counter == 500
			@counter = 0
			puts "" + row() + "" + col() + " " + @suCell
			puts @suCell.to_s unless @suCell == nil
		end
		if val() == 0
			#@valLbl.setText("")
			@valLbl.setVisible(false)
			@pMarksPanel.setVisible(true)
			9.times do |i|
				@pMarkLbls[i].setVisible(Ops.contains?(pMarks(), i + 1))
			end
		else
			#@valLbl.setText("" + val())
			@pMarksPanel.setVisible(false)
			@valLbl.setVisible(true)
		end
		#revalidate()
		repaint()
	end
end

