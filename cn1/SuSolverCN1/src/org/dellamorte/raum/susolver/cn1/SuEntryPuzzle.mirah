/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package org.dellamorte.raum.susolver.cn1

import SuEntryBlock
import SuEntryCell

import java.util.Arrays
import java.util.ArrayList
#import java.io.Console

/**
 *
 * @author Raum
 */
class SuEntryPuzzle 
	def initialize():void
		@blocks = SuEntryBlock[9]
	end
	
	def setBlock(blk:SuEntryBlock, num:int):void
		if ((num > 0) and (num <= 9))
			@blocks[num - 1] = blk
		end
	end
	
	def getBlock(n:int):SuEntryBlock
		if ((n > 0) and (n <= 9))
			return @blocks[n - 1]
		else
			return SuEntryBlock(nil)
		end
	end
end

