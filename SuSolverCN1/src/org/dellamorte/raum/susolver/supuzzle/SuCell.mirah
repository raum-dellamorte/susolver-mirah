/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package org.dellamorte.raum.susolver.supuzzle

import java.util.ArrayList
	
#import Ops
#import SuClass

/**
 *
 * @author Raum
 */
class SuCell < SuClass
	def initialize(parent:SuClass):void
		@parent = parent
		@size = @parent.size()
		@is = 0
		@box = 0
		@row = 0
		@col = 0
		@elim = int[0]
		@guessing = false
		@glim = int[0]
		@gpmarks = int[Ops.pow(@size, 2)]
		Ops.pow(@size, 2).times {|i| @gpmarks[i] = i + 1}
		greset()
	end
	
	def brc():int[]
		out = int[3]
		out[0] = @box
		out[1] = @row
		out[2] = @col
		return out
	end
	
	def brc_s():String
		#"b" + @box + 
		return 	"r" + @row + 
				"c" + @col
	end
	
	def to_s():String
		if setBool() and @elim.length < 9
			9.times {|i|
				n = i + 1
				@elim = Ops.appendUniq(@elim, n) # unless n == @is
			}
		end
		return 	"" + brc_s() + 
				" val: " + @is + " " + 
				Ops.toString(pmarks()) + 
				" elim: " + Ops.toString(@elim) + 
				" guess: " + @guess + " " + Ops.toString(@gpmarks) + 
				" used: " + Ops.toString(@gused)
	end
	
	def guessingBool():boolean
		@guessing
	end
	
	def guessMode(mode:boolean):void
		@guessing = mode
	end
	
	def reset():void
		@is = 0
		@elim = int[0]
		# and other stuff
	end
	
	def eliminate(num:int):void
		if (@guessing and (@glim.length == 0))
			@glim = Ops.appendUniq(@elim, num)
		else
			if @guessing
				@glim = Ops.appendUniq(@glim, num)
			else
				@elim = Ops.appendUniq(@elim, num)
			end
		end
		#puts "Eliminated " + num + " from " + to_s()
	end
	
	def eliminatedBool(num:int):boolean
		return true if (setBool() and (num != @is))
		return false if ((@guessing and (@glim.length == 0)) or (!@guessing and (@elim.length == 0)))
		return ((@guessing and Ops.containsBool(@glim, num)) or (!@guessing and Ops.containsBool(@elim, num)))
	end
	
	def box_id():int
		@box
	end
	
	def box_id=(v:int):void
		@box = v
	end
	
	def row_id():int
		@row
	end
	
	def row_id=(v:int):void
		@row = v
	end
	
	def col_id():int
		@col
	end
	
	def col_id=(v:int):void
		@col = v
	end
	
	def brow_id():int
		out = @row
		out = out - @size until out <= @size
		out
	end
	
	def bcol_id():int
		out = @col
		out = out - @size until out <= @size
		out
	end
	
	def val():int
		@is
	end
	
	def gval():int
		return val() if setBool()
		return @guess
	end
	
	def set(num:int):void
		#@pmarks = int[0] unless (num == 0)
		@is = num
	end
	
	def gset(num:int):void
		@guess = num
	end
	
	def setToGuess():void
		set(@guess) if (!setBool() and gsetBool())
	end
	
	def setBool():boolean
		@is != 0
	end
	
	def gsetBool():boolean
		setBool() or (@guess != 0)
	end
	
	def canSeeBool(cel:SuClass):boolean
		return false if ((@box == SuCell(cel).box_id) and ((@row == SuCell(cel).row_id) and (@col == SuCell(cel).col_id)))
		return true if ((@box == SuCell(cel).box_id) or ((@row == SuCell(cel).row_id) or (@col == SuCell(cel).col_id)))
	end
	
	def check():void; end # deprecated
	
	def gcheck():void
		return if gsetBool()
		s1 = "1"
		s2 = "2"
		until s2.equals(s1)
			s1 = to_s()
			gcalcPMarks()
			nextGuess() if @gpmarks.length == 1
			return if (gsetBool() or gbrokenBool())
			s2 = to_s()
		end
	end
	
	def pmarks():int[]
		#@pmarks
		return int[0] if setBool
		npm = int[0]
		9.times do |i|
			n = i + 1
			npm = Ops.appendUniq(npm, n) unless Ops.containsBool(@elim, n)
		end
		return npm
	end
	
	def gpmarks():int[]
		@gpmarks
	end
	
	def calcPMarks():void; end # deprecated
	
	def gcalcPMarks():void
		return if gsetBool()
		out = int[Ops.pow(@size, 2)]
		n = 0
		Ops.pow(@size, 2).times do |i| 
			if Ops.containsBool(pmarks(), i + 1)
				if gcanbeBool(i + 1)
					out[n] = i + 1
					n = n + 1
				end
			end
		end
		if ((n == 0) or setBool())
			@gpmarks = int[0]
		else
			@gpmarks = Ops.copyOfRange(out, 0, n)
		end
	end
	
	def canbeBool(n:int):boolean
		return false if (n == 0)
		return !eliminatedBool(n)
	end
	
	def gcanbeBool(n:int):boolean
		return false if (n == 0)
		if @gused.length == 0
			g = false
		else
			g = Ops.containsBool(@gused, n)
		end
		return !(g or eliminatedBool(n))
	end
	
	def setIfOnlyCell():void
		return if (setBool() or (pmarks().length == 0))
		pmarks().length.times {|i|
			#puts "" + pmarks().length + " " + i
			x = @parent.box(@box).onlyCellBool(SuClass(self), pmarks()[i])
			y = @parent.row(@row).onlyCellBool(SuClass(self), pmarks()[i])
			z = @parent.col(@col).onlyCellBool(SuClass(self), pmarks()[i])
			all = (x or (y or z))
			#puts "" + x + " " + y + " " + z + " " + all
			if all
				#puts "onlyCell " + to_s() + " " + pmarks()[i]
				set(pmarks()[i])
				return
			end
		}
	end
	
	def brokenBool():boolean
		return false if setBool()
		pmarks().length == 0
	end
	
	def gbrokenBool():boolean
		return false if gsetBool()
		@gpmarks.length == 0
	end
	
	def greset():void
		@guess = 0
		@gused = int[0]
		@gpmarks = Ops.copyOf(pmarks(), pmarks().length)
	end
	
	def canGuessBool():boolean
		return false if setBool()
		#gcheck()
		return @gpmarks.length > 0
	end
	
	def nextGuess():void
		return if setBool()
		x = Ops.copyOf(@gpmarks, @gpmarks.length)
		if x.length > 0
			@guess = x[0]
			sz = @gused.length
			tmp = int[sz + 1]
			sz.times {|i| tmp[i] = @gused[i]} if (sz > 0)
			tmp[sz] = x[0]
			@gused = tmp
			if x.length > 1
				@gpmarks = Ops.copyOfRange(x, 1, x.length)
			else
				@gpmarks = int[0]
			end
		end
	end
end

