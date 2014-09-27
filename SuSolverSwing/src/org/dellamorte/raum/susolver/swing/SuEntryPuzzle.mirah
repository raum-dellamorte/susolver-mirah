package org.dellamorte.raum.susolver.swing

import org.dellamorte.raum.susolver.swing.*

import java.util.Arrays
import java.util.ArrayList
import java.io.Console

import java.awt.*
import java.awt.event.*
import javax.swing.*

class SuEntryPuzzle < JPanel
	class MListen implements MouseListener
		def initialize(cel:SuEntryCell):void
			@cel = cel
		end
		
		$Override
		def mouseClicked(e:MouseEvent)
			@cel.lbl.grabFocus()
		end
		
		$Override
		def mousePressed(e:MouseEvent):void; end
		$Override
		def mouseReleased(e:MouseEvent):void; end
		$Override
		def mouseEntered(e:MouseEvent):void; end
		$Override
		def mouseExited(e:MouseEvent):void; end
	end
	
	class KListen implements KeyListener
		def initialize(puz:SuEntryPuzzle, cel:SuEntryCell):void
			@puz = puz
			@cel = cel
		end
		
		$Override
		def keyTyped(e:KeyEvent):void
			id = int(e.getID())
			if (id == KeyEvent.KEY_TYPED)
				c = char(e.getKeyChar())
				@cel.setText("" + c) if (("" + c) =~ /[1-9]/)
				@cel.setText("") if (("" + c) =~ /0/)
			end
		end
		
		$Override
		def keyPressed(e:KeyEvent):void
			k = int(e.getKeyCode())
			#puts "" + k
			@cel.setText("") if ((k == 8) or (k == 127))
			if k == 38
				n = @cel.row() - 1
				n = 9 if n < 1
				@puz.getRowCol(n, @cel.col()).lbl.grabFocus() #requestFocusInWindow()
			end
			if k == 40
				n = @cel.row() + 1
				n = 1 if n > 9
				@puz.getRowCol(n, @cel.col()).lbl.grabFocus() #requestFocusInWindow()
			end
			if k == 37
				n = @cel.col() - 1
				n = 9 if n < 1
				@puz.getRowCol(@cel.row(), n).lbl.grabFocus() #requestFocusInWindow()
			end
			if k == 39
				n = @cel.col() + 1
				n = 1 if n > 9
				@puz.getRowCol(@cel.row(), n).lbl.grabFocus() #requestFocusInWindow()
			end
		end
		$Override
		def keyReleased(e:KeyEvent):void; end
	end
	
	class FListen implements FocusListener
		def initialize(cel:SuEntryCell):void
			@cel = cel
		end
		
		def focusGained(e:FocusEvent):void
			#puts "fG"
			@cel.setBackground(java::awt::Color.new(200, 50, 50))
		end
		
		def focusLost(e:FocusEvent):void
			#puts "fL"
			@cel.setBackground(java::awt::Color.new(245, 245, 245))
		end
	end
	
	def initialize()
		super
		setBackground(java::awt::Color.new(0, 0, 0))
		setPreferredSize(java::awt::Dimension.new(338, 338))
		
		@bloks = SuEntryBlock[9]
		@cels = SuEntryCell[81]
		9.times do |i|
			@bloks[i] = SuEntryBlock.new()
			@bloks[i].setBoxNum(i + 1)
			9.times do |ii|
				cel = @bloks[i].cells()[ii]
				cel.lbl.addKeyListener(KListen.new(self, cel))
				cel.lbl.addFocusListener(FListen.new(cel))
				cel.lbl.addMouseListener(MListen.new(cel))
				@cels[((9 * (cel.row() - 1)) + (cel.col() - 1))] = cel
			end
		end
		
		layout = GroupLayout.new(self)
		setLayout(layout)
		layout.setHorizontalGroup(
			layout.createParallelGroup(javax::swing::GroupLayout.Alignment.LEADING)
			.addGroup(layout.createSequentialGroup()
				.addContainerGap()
				.addGroup(layout.createParallelGroup(javax::swing::GroupLayout.Alignment.LEADING)
					.addGroup(layout.createSequentialGroup()
						.addComponent(@bloks[0], javax::swing::GroupLayout.PREFERRED_SIZE, javax::swing::GroupLayout.DEFAULT_SIZE, javax::swing::GroupLayout.PREFERRED_SIZE)
						.addPreferredGap(javax::swing::LayoutStyle.ComponentPlacement.RELATED)
						.addComponent(@bloks[1], javax::swing::GroupLayout.PREFERRED_SIZE, javax::swing::GroupLayout.DEFAULT_SIZE, javax::swing::GroupLayout.PREFERRED_SIZE)
						.addPreferredGap(javax::swing::LayoutStyle.ComponentPlacement.RELATED)
						.addComponent(@bloks[2], javax::swing::GroupLayout.PREFERRED_SIZE, javax::swing::GroupLayout.DEFAULT_SIZE, javax::swing::GroupLayout.PREFERRED_SIZE))
					.addGroup(layout.createSequentialGroup()
						.addComponent(@bloks[3], javax::swing::GroupLayout.PREFERRED_SIZE, javax::swing::GroupLayout.DEFAULT_SIZE, javax::swing::GroupLayout.PREFERRED_SIZE)
						.addPreferredGap(javax::swing::LayoutStyle.ComponentPlacement.RELATED)
						.addComponent(@bloks[4], javax::swing::GroupLayout.PREFERRED_SIZE, javax::swing::GroupLayout.DEFAULT_SIZE, javax::swing::GroupLayout.PREFERRED_SIZE)
						.addPreferredGap(javax::swing::LayoutStyle.ComponentPlacement.RELATED)
						.addComponent(@bloks[5], javax::swing::GroupLayout.PREFERRED_SIZE, javax::swing::GroupLayout.DEFAULT_SIZE, javax::swing::GroupLayout.PREFERRED_SIZE))
					.addGroup(layout.createSequentialGroup()
						.addComponent(@bloks[6], javax::swing::GroupLayout.PREFERRED_SIZE, javax::swing::GroupLayout.DEFAULT_SIZE, javax::swing::GroupLayout.PREFERRED_SIZE)
						.addPreferredGap(javax::swing::LayoutStyle.ComponentPlacement.RELATED)
						.addComponent(@bloks[7], javax::swing::GroupLayout.PREFERRED_SIZE, javax::swing::GroupLayout.DEFAULT_SIZE, javax::swing::GroupLayout.PREFERRED_SIZE)
						.addPreferredGap(javax::swing::LayoutStyle.ComponentPlacement.RELATED)
						.addComponent(@bloks[8], javax::swing::GroupLayout.PREFERRED_SIZE, javax::swing::GroupLayout.DEFAULT_SIZE, javax::swing::GroupLayout.PREFERRED_SIZE)))
				.addContainerGap(javax::swing::GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
		)
		layout.setVerticalGroup(
			layout.createParallelGroup(javax::swing::GroupLayout.Alignment.LEADING)
			.addGroup(layout.createSequentialGroup()
				.addContainerGap()
				.addGroup(layout.createParallelGroup(javax::swing::GroupLayout.Alignment.LEADING)
					.addComponent(@bloks[0], javax::swing::GroupLayout.PREFERRED_SIZE, javax::swing::GroupLayout.DEFAULT_SIZE, javax::swing::GroupLayout.PREFERRED_SIZE)
					.addComponent(@bloks[1], javax::swing::GroupLayout.PREFERRED_SIZE, javax::swing::GroupLayout.DEFAULT_SIZE, javax::swing::GroupLayout.PREFERRED_SIZE)
					.addComponent(@bloks[2], javax::swing::GroupLayout.PREFERRED_SIZE, javax::swing::GroupLayout.DEFAULT_SIZE, javax::swing::GroupLayout.PREFERRED_SIZE))
				.addPreferredGap(javax::swing::LayoutStyle.ComponentPlacement.RELATED)
				.addGroup(layout.createParallelGroup(javax::swing::GroupLayout.Alignment.LEADING)
					.addComponent(@bloks[3], javax::swing::GroupLayout.PREFERRED_SIZE, javax::swing::GroupLayout.DEFAULT_SIZE, javax::swing::GroupLayout.PREFERRED_SIZE)
					.addComponent(@bloks[4], javax::swing::GroupLayout.PREFERRED_SIZE, javax::swing::GroupLayout.DEFAULT_SIZE, javax::swing::GroupLayout.PREFERRED_SIZE)
					.addComponent(@bloks[5], javax::swing::GroupLayout.PREFERRED_SIZE, javax::swing::GroupLayout.DEFAULT_SIZE, javax::swing::GroupLayout.PREFERRED_SIZE))
				.addPreferredGap(javax::swing::LayoutStyle.ComponentPlacement.RELATED)
				.addGroup(layout.createParallelGroup(javax::swing::GroupLayout.Alignment.LEADING)
					.addComponent(@bloks[6], javax::swing::GroupLayout.PREFERRED_SIZE, javax::swing::GroupLayout.DEFAULT_SIZE, javax::swing::GroupLayout.PREFERRED_SIZE)
					.addComponent(@bloks[7], javax::swing::GroupLayout.PREFERRED_SIZE, javax::swing::GroupLayout.DEFAULT_SIZE, javax::swing::GroupLayout.PREFERRED_SIZE)
					.addComponent(@bloks[8], javax::swing::GroupLayout.PREFERRED_SIZE, javax::swing::GroupLayout.DEFAULT_SIZE, javax::swing::GroupLayout.PREFERRED_SIZE))
				.addContainerGap(javax::swing::GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
		)
	end
	
	def cells():SuEntryCell[]
		@cels
	end
	
	def boxes():SuEntryBlock[]
		@bloks
	end
	
	def getRowCol(rw:int, cl:int):SuEntryCell
		@cels[(9 * (rw - 1)) + (cl - 1)]
	end
	
	def export():int[]
		out = int[81]
		81.times do |i|
			out[i] = int(@cels[i].val())
		end
		return int[].cast(out)
	end
	
	def import(na:int[]):void
		na.length.times {|i:int| @cels[i].setText("" + na[i]) unless na[i] == 0 }
	end
	
#	def updateCells():void
#		@cels.each do |c:SuEntryCell|
#			c.updateLbls()
#		end
#		revalidate()
#	end
	
	def reset():void
		@cels.length.times do |i|
			@cels[i].reset()
		end
		@bloks.each {|b:SuEntryBlock| b.revalidate(); b.repaint() }
		revalidate()
		repaint()
	end
	
end