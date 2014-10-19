package org.dellamorte.raum.susolver.swing

import org.dellamorte.raum.susolver.supuzzle.Ops
import org.dellamorte.raum.susolver.swing.SuEntryCell

import java.util.Arrays
import java.util.ArrayList
#import java.io.Console

import java.awt.*
import javax.swing.*

class SuEntryBlock < JPanel
	def initialize()
		super
		@box = 0
		@cels = SuEntryCell[9]
		9.times do |i|
			@cels[i] = SuEntryCell.new()
			@cels[i].setCellNum(i + 1)
		end
		
		setBackground(java::awt::Color.new(153, 153, 153))
		setMaximumSize(java::awt::Dimension.new(102, 102))
		setMinimumSize(java::awt::Dimension.new(102, 102))
		setPreferredSize(java::awt::Dimension.new(102, 102))
		layout = GroupLayout.new(self)
		setLayout(layout)
		layout.setHorizontalGroup(
			layout.createParallelGroup(javax::swing::GroupLayout::Alignment.LEADING)
			.addGroup(layout.createSequentialGroup()
				.addGroup(layout.createParallelGroup(javax::swing::GroupLayout::Alignment.LEADING)
					.addGroup(layout.createSequentialGroup()
						.addComponent(@cels[0], javax::swing::GroupLayout.PREFERRED_SIZE, javax::swing::GroupLayout.DEFAULT_SIZE, javax::swing::GroupLayout.PREFERRED_SIZE)
						.addPreferredGap(javax::swing::LayoutStyle::ComponentPlacement.RELATED)
						.addComponent(@cels[1], javax::swing::GroupLayout.PREFERRED_SIZE, javax::swing::GroupLayout.DEFAULT_SIZE, javax::swing::GroupLayout.PREFERRED_SIZE)
						.addPreferredGap(javax::swing::LayoutStyle::ComponentPlacement.RELATED)
						.addComponent(@cels[2], javax::swing::GroupLayout.PREFERRED_SIZE, javax::swing::GroupLayout.DEFAULT_SIZE, javax::swing::GroupLayout.PREFERRED_SIZE))
					.addGroup(layout.createSequentialGroup()
						.addComponent(@cels[3], javax::swing::GroupLayout.PREFERRED_SIZE, javax::swing::GroupLayout.DEFAULT_SIZE, javax::swing::GroupLayout.PREFERRED_SIZE)
						.addPreferredGap(javax::swing::LayoutStyle::ComponentPlacement.RELATED)
						.addComponent(@cels[4], javax::swing::GroupLayout.PREFERRED_SIZE, javax::swing::GroupLayout.DEFAULT_SIZE, javax::swing::GroupLayout.PREFERRED_SIZE)
						.addPreferredGap(javax::swing::LayoutStyle::ComponentPlacement.RELATED)
						.addComponent(@cels[5], javax::swing::GroupLayout.PREFERRED_SIZE, javax::swing::GroupLayout.DEFAULT_SIZE, javax::swing::GroupLayout.PREFERRED_SIZE))
					.addGroup(layout.createSequentialGroup()
						.addComponent(@cels[6], javax::swing::GroupLayout.PREFERRED_SIZE, javax::swing::GroupLayout.DEFAULT_SIZE, javax::swing::GroupLayout.PREFERRED_SIZE)
						.addPreferredGap(javax::swing::LayoutStyle::ComponentPlacement.RELATED)
						.addComponent(@cels[7], javax::swing::GroupLayout.PREFERRED_SIZE, javax::swing::GroupLayout.DEFAULT_SIZE, javax::swing::GroupLayout.PREFERRED_SIZE)
						.addPreferredGap(javax::swing::LayoutStyle::ComponentPlacement.RELATED)
						.addComponent(@cels[8], javax::swing::GroupLayout.PREFERRED_SIZE, javax::swing::GroupLayout.DEFAULT_SIZE, javax::swing::GroupLayout.PREFERRED_SIZE)))
				.addContainerGap())
		)
		layout.setVerticalGroup(
			layout.createParallelGroup(javax::swing::GroupLayout::Alignment.LEADING)
			.addGroup(layout.createSequentialGroup()
				.addGroup(layout.createParallelGroup(javax::swing::GroupLayout::Alignment.BASELINE)
					.addComponent(@cels[0], javax::swing::GroupLayout.PREFERRED_SIZE, javax::swing::GroupLayout.DEFAULT_SIZE, javax::swing::GroupLayout.PREFERRED_SIZE)
					.addComponent(@cels[1], javax::swing::GroupLayout.PREFERRED_SIZE, javax::swing::GroupLayout.DEFAULT_SIZE, javax::swing::GroupLayout.PREFERRED_SIZE)
					.addComponent(@cels[2], javax::swing::GroupLayout.PREFERRED_SIZE, javax::swing::GroupLayout.DEFAULT_SIZE, javax::swing::GroupLayout.PREFERRED_SIZE))
				.addPreferredGap(javax::swing::LayoutStyle::ComponentPlacement.RELATED)
				.addGroup(layout.createParallelGroup(javax::swing::GroupLayout::Alignment.BASELINE)
					.addComponent(@cels[3], javax::swing::GroupLayout.PREFERRED_SIZE, javax::swing::GroupLayout.DEFAULT_SIZE, javax::swing::GroupLayout.PREFERRED_SIZE)
					.addComponent(@cels[4], javax::swing::GroupLayout.PREFERRED_SIZE, javax::swing::GroupLayout.DEFAULT_SIZE, javax::swing::GroupLayout.PREFERRED_SIZE)
					.addComponent(@cels[5], javax::swing::GroupLayout.PREFERRED_SIZE, javax::swing::GroupLayout.DEFAULT_SIZE, javax::swing::GroupLayout.PREFERRED_SIZE))
				.addPreferredGap(javax::swing::LayoutStyle::ComponentPlacement.RELATED)
				.addGroup(layout.createParallelGroup(javax::swing::GroupLayout::Alignment.BASELINE)
					.addComponent(@cels[6], javax::swing::GroupLayout.PREFERRED_SIZE, javax::swing::GroupLayout.DEFAULT_SIZE, javax::swing::GroupLayout.PREFERRED_SIZE)
					.addComponent(@cels[7], javax::swing::GroupLayout.PREFERRED_SIZE, javax::swing::GroupLayout.DEFAULT_SIZE, javax::swing::GroupLayout.PREFERRED_SIZE)
					.addComponent(@cels[8], javax::swing::GroupLayout.PREFERRED_SIZE, javax::swing::GroupLayout.DEFAULT_SIZE, javax::swing::GroupLayout.PREFERRED_SIZE))
				.addContainerGap())
		)
	end
	
	def setBoxNum(num:int):void
		@box = num
		9.times do |i|
			@cels[i].setBoxNum(@box)
		end
	end
	
	def box():int
		@box
	end
	
	def cells():SuEntryCell[]
		@cels
	end
	
	def rows():int[]
		out = int[0]
		9.times do |i|
			out = Ops.appendUniq(out, @cels[i].row())
		end
		out
	end
	
	def cols():int[]
		out = int[0]
		9.times do |i|
			out = Ops.appendUniq(out, @cels[i].col())
		end
		out
	end
	
	def hasRow(n:int):boolean
		Ops.containsBool(rows(), n)
	end
	
	def hasCol(n:int):boolean
		Ops.containsBool(cols(), n)
	end
	
	
end