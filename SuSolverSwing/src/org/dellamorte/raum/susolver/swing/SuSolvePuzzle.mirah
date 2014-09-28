package org.dellamorte.raum.susolver.swing

import org.dellamorte.raum.susolver.supuzzle.*
#import org.dellamorte.raum.susolver.swing.*

import java.util.Arrays
import java.util.ArrayList
import java.io.Console

import java.awt.*
import javax.swing.*

class SuSolvePuzzle < JPanel
	def initialize()
		super
		setBackground(java::awt::Color.new(0, 0, 0))
		setPreferredSize(java::awt::Dimension.new(338, 338))
		
		@imported = false
		@guessMode = false
		@puzzle = SuPuzzle(nil)
		@bloks = SuSolveBlock[9]
		@cels = SuSolveCell[81]
		9.times do |i|
			@bloks[i] = SuSolveBlock.new()
			@bloks[i].setBoxNum(i + 1)
			9.times do |ii|
				cel = @bloks[i].cells()[ii]
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
	
	def cells():SuSolveCell[]
		@cels
	end
	
	def boxes():SuSolveBlock[]
		@bloks
	end
	
	def getRowCol(rw:int, cl:int):SuSolveCell
		@cels[(9 * (rw - 1)) + (cl - 1)]
	end
	
	def reset():void
		@puzzle = SuPuzzle.new(3)
		@cels.length.times do |i|
			@cels[i].reset()
		end
		@imported = false
		@bloks.each {|b:SuSolveBlock| b.revalidate(); b.repaint() }
		revalidate()
		repaint()
	end
	
	def import(na:int[]):void
		return unless na.length == 81
		reset() if (@puzzle == nil)
		#@puzzle.setGuiMode(true) # Uncomment when finished debugging
		@puzzle.setGuessMode(@guessMode)
		@puzzle.setCells(na)
		#@puzzle.basicCheck()
		@cels.length.times do |i|
			@cels[i].set(@puzzle.cells[i])
		end
		@imported = true
	end
	
	def setImported(tf:boolean):void
		@imported = tf
	end
	
	def imported?():boolean
		@imported
	end
	
	def setGuessMode(tf:boolean):void
		@guessMode = tf
	end
	
	def nextStep():void
		@puzzle.setGuessMode(@guessMode)
		@puzzle.stepCheck()
		@bloks.each {|b:SuSolveBlock| b.revalidate(); b.repaint() }
		revalidate()
		repaint()
	end
	
	def solve():void
		@puzzle.setGuessMode(@guessMode)
		@puzzle.solve()
		updateCells()
	end
	
	def updateCells():void
		@cels.each do |c:SuSolveCell|
			c.updateLbls()
		end
		@bloks.each {|b:SuSolveBlock| b.revalidate(); b.repaint() }
		revalidate()
		repaint()
	end
end