package org.dellamorte.raum.susolver.cn1

import org.dellamorte.raum.susolver.supuzzle.Ops
import SuEntryCell

import java.util.Arrays
import java.util.ArrayList

/**
 *
 * @author Raum
 */
class SuEntryBlock 
	def initialize(block:int):void
		@block = block
		@cells = SuEntryCell[9]
	end
end

