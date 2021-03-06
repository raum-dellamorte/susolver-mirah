/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package org.dellamorte.raum.susolver.supuzzle
import java.util.Arrays
import java.util.ArrayList

import Ops
import SuClass
import SuCell

/**
 *
 * @author Raum
 */
class SuBlock < SuClass
	def initialize(parent:SuClass, whatkind:String):void
		@parent = parent
		@blockType = whatkind
		@size = @parent.size()
		@cells = SuCell[Ops.pow(@size, 2)]
	end
	
	def blockType
		@blockType
	end
	
	def cells():SuClass[]
		SuClass[].cast(@cells)
	end
	
	def setCell(n:int, cel:SuClass):void
		@cells[n - 1] = SuCell(cel)
	end
	
	def sameCell?(a:SuCell, b:SuCell):boolean
		return true if ((a.box_id() == b.box_id()) and ((a.row_id() == b.row_id()) and (a.col_id() == b.col_id())))
		return false
	end
	
	def boxes():int[]
		if @blockType.equals(:box)
			out = int[1]
			out[0] = @cells[0].box_id()
			return out
		end
		out = int[@size]
		n = 0
		@cells.length.times {|c|
			bx = @cells[c].box_id()
			next unless ((((n > 0) and (n < @size)) and (out[n - 1] != bx)) or (n == 0))
			out[n] = bx
			n = n + 1
		}
		#puts "boxes fail" if Ops.contains?(out, 0)
		return out
	end
	
	def row_a(n:int):SuCell[]
		return SuCell[0] if ((n < 1) or (n > @size))
		return SuCell[].cast(Arrays.copyOfRange(Object[].cast(@cells), (@size * (n - 1)), (@size * n)))
	end
	
	def col_a(n:int):SuCell[]
		return SuCell[0] if ((n < 1) or (n > @size))
		out = SuCell[@size]
		@size.times {|i| out[i] = row_a(i + 1)[n - 1]}
		return out
	end
	
	def getChunk(rowcol:String, cel:SuCell):int
		return 0 if rowcol.equals(:box)
		@size.times {|i|
			num = i + 1
			if rowcol.equals(:row)
				cels = row_a(num)
			else
				cels = col_a(num)
			end
			cels.length.times {|c|
				return (num) if sameCell?(cel, cels[c])
			}
		}
		return 0
	end
	
	def getRow(cel:SuCell):int
		getChunk(:row, cel)
	end
	
	def getCol(cel:SuCell):int
		getChunk(:col, cel)
	end
	
	def chunkNotSet(gflag:boolean, rowcol:String, num:int):int
		if rowcol.equals(:row)
			cels = row_a(num)
		elsif rowcol.equals(:col)
			cels = col_a(num)
		else
			cels = @cells
		end
		out = 0
		cels.length.times {|c| out = out + 1 if ((gflag and !cels[c].gset?()) or !cels[c].set?())}
		out
	end
	
	def notSet(num:int):int
		chunkNotSet(false, :box, num)
	end
	
	def rowNotSet(num:int):int
		chunkNotSet(false, :row, num)
	end
	
	def colNotSet(num:int):int
		chunkNotSet(false, :col, num)
	end
	
	def chunkSet(gflag:boolean, rowcol:String, num:int):int[]
		if rowcol.equals(:row)
			cels = row_a(num)
		elsif rowcol.equals(:col)
			cels = col_a(num)
		else
			cels = @cells
		end
		out = int[0]
		cels.length.times {|c| 
			if (gflag and cels[c].gset?())
				out = Ops.appendUniq(out, cels[c].gval)
			elsif cels[c].set?()
				out = Ops.appendUniq(out, cels[c].val)
			end
		}
		return out
	end
	
	def boxSet():int[]
		chunkSet(false, :box, 0)
	end
	
	def rowSet(rc:int):int[]
		chunkSet(false, :row, rc)
	end
	
	def colSet(rc:int):int[]
		chunkSet(false, :col, rc)
	end
	
	def gboxSet():int[]
		chunkSet(true, :box, 0)
	end
	
	def growSet(rc:int):int[]
		chunkSet(true, :row, rc)
	end
	
	def gcolSet(rc:int):int[]
		chunkSet(true, :col, rc)
	end
	
	def chunkPMarks(gflag:boolean, rowcol:String, rc:int):int[]
		if rowcol.equals(:row)
			cels = row_a(rc)
		elsif rowcol.equals(:col)
			cels = col_a(rc)
		else
			cels = @cells
		end
		out = int[0]
		cels.length.times {|c| 
			if ((gflag and !cels[c].gset?) or !cels[c].set?)
				if gflag
					ir = cels[c].gpmarks()
					puts "gpmarks Fail" if Ops.contains?(ir, 0)
				else
					ir = cels[c].pmarks()
					puts "pmarks Fail" if Ops.contains?(ir, 0)
				end
				ir.length.times {|n| out = Ops.appendUniq(out, ir[n])}
			end
		}
		return out
	end
	
	def pmarks():int[]
		chunkPMarks(false, :box, 0)
	end
	
	def gpmarks():int[]
		chunkPMarks(true, :box, 0)
	end
	
	def rowPMarks(n:int):int[]
		chunkPMarks(false, :row, n)
	end
	
	def colPMarks(n:int):int[]
		chunkPMarks(false, :col, n)
	end
	
	def growPMarks(n:int):int[]
		chunkPMarks(true, :row, n)
	end
	
	def gcolPMarks(n:int):int[]
		chunkPMarks(true, :col, n)
	end
	
	def canbeChunk?(gflag:boolean, rowcol:String, rc:int, n:int):boolean
		if rowcol.equals(:row)
			return Ops.contains?(growPMarks(rc), n) if gflag
			return Ops.contains?(rowPMarks(rc), n)
		elsif rowcol.equals(:col)
			return Ops.contains?(gcolPMarks(rc), n) if gflag
			return Ops.contains?(colPMarks(rc), n)
		else
			return Ops.contains?(gpmarks(), n) if gflag
			return Ops.contains?(pmarks(), n)
		end
	end
	
	def valInChunk?(gflag:boolean, rowcol:String, rc:int, n:int):boolean
		return true if canbeChunk?(gflag, rowcol, rc, n)
		return Ops.contains?(chunkSet(gflag, rowcol, rc), n)
	end
	
	def canbeRow?(rc:int, n:int):boolean
		canbeChunk?(false, :row, rc, n)
	end
	
	def canbeCol?(rc:int, n:int):boolean
		canbeChunk?(false, :col, rc, n)
	end
	
	def gcanbeRow?(rc:int, n:int):boolean
		canbeChunk?(true, :row, rc, n)
	end
	
	def gcanbeCol?(rc:int, n:int):boolean
		canbeChunk?(true, :col, rc, n)
	end
	
	def inChunks(gflag:boolean, rowcol:String, num:int):int[]
		out = int[0]
		@size.times {|i|
			out = Ops.appendUniq(out, i + 1) if valInChunk?(gflag, rowcol, i + 1, num)
		}
		return out
	end
	
	def inChunkBoxes(gflag:boolean, rowcol:String, rc:int, num:int):int[]
		if !@blockType.equals(:box)
			out = int[@size - 1]
			n = 0
			bxs = boxes()
			bxs.length.times {|bxn|
				rcs = SuBlock(@parent.box(bxn + 1)).inChunks(gflag, rowcol, num)
				if ((rcs.length > 0) and Ops.contains?(rcs, rc))
					out[n] = bxn + 1 
					n = n + 1
				end
			}
			return int[0] if n == 0
			return Arrays.copyOfRange(out, 0, n)
		else
			return int[0]
		end
	end
	
	def onlyChunkBox(gflag:boolean, rowcol:String, rc:int, num:int):int
		tmp = inChunkBoxes(gflag, rowcol, rc, num)
		if tmp.length == 1
			return tmp[0]
		else
			return 0
		end
	end
	
	def onlyChunk(gflag:boolean, rowcol:String, num:int):int
		tmp = inChunks(gflag, rowcol, num)
		if tmp.length == 1
			return tmp[0]
		else
			return 0
		end
	end
	
	def onlyRow(num:int):int
		onlyChunk(false, :row, num)
	end
	
	def onlyCol(num:int):int
		onlyChunk(false, :col, num)
	end
	
	def gonlyRow(num:int):int
		onlyChunk(true, :row, num)
	end
	
	def gonlyCol(num:int):int
		onlyChunk(true, :col, num)
	end
	
	def onlyChunk?(rowcol:String, rc:int, num:int):boolean
		onlyChunk(false, rowcol, num) == rc
	end
	
	def gonlyChunk?(rowcol:String, rc:int, num:int):boolean
		onlyChunk(true, rowcol, num) == rc
	end
	
	def onlyRow?(i:int, num:int):boolean
		onlyChunk?(:row, i, num)
	end
	
	def onlyCol?(i:int, num:int):boolean
		onlyChunk?(:col, i, num)
	end
	
	def gonlyRow?(i:int, num:int):boolean
		gonlyChunk?(:row, i, num)
	end
	
	def gonlyCol?(i:int, num:int):boolean
		gonlyChunk?(:col, i, num)
	end
	
	def conflict?(n:int):boolean
		return Ops.contains?(boxSet(), n) unless n == 0
		return false
	end
	
	def gconflict?(n:int):boolean
		return Ops.contains?(gboxSet(), n) unless n == 0
		return false
	end
	
	def onlyCell?(cel:SuClass, num:int):boolean
		cnt = 0
		@cells.length.times {|c|
			next if sameCell?(@cells[c], SuCell(cel))
			cnt = cnt + 1
			return false if ((@cells[c].set?() and (@cells[c].val() == num)) or (!@cells[c].set?() and Ops.contains?(@cells[c].pmarks(), num)))
			#puts "onlyCell? " + num + " " + @cells[c].to_s() if (cnt == (@cells.length - 1))
		}
		puts "onlyCell? error: counted all cells" if cnt == @cells.length
		return true
	end
	
	def complete?():boolean
		Ops.pow(@size, 2).times {|n| return false if !@cells[n].set?() }
		return true
	end
	
	def gcomplete?():boolean
		Ops.pow(@size, 2).times {|n| return false if !@cells[n].gset?() }
		return true
	end
	
	def solved?():boolean
		return false unless complete?()
		tmp = int[Ops.pow(@size, 2)]
		Ops.pow(@size, 2).times {|n| val = @cells[n].val - 1; tmp[val] = tmp[val] + 1 if (val >= 0) }
		Ops.pow(@size, 2).times {|n| return false if (tmp[n] != 1) }
		return true
	end
	
	def gsolved?():boolean
		return false unless gcomplete?()
		tmp = int[Ops.pow(@size, 2)]
		Ops.pow(@size, 2).times {|n| val = @cells[n].gval - 1; tmp[val] = tmp[val] + 1 if (val >= 0) }
		Ops.pow(@size, 2).times {|n| return false if (tmp[n] != 1) }
		return true
	end
	
	def broken?():boolean
		@cells.length.times {|c| return true if @cells[c].broken?() }
		tmp = int[Ops.pow(@size, 2)]
		Ops.pow(@size, 2).times {|n| val = @cells[n].val - 1; tmp[val] = tmp[val] + 1 if (val >= 0) }
		Ops.pow(@size, 2).times {|n| return true unless (tmp[n] < 2) }
		return false
	end
	
	def gbroken?():boolean
		@cells.length.times {|c| return true if @cells[c].gbroken?() }
		tmp = int[Ops.pow(@size, 2)]
		Ops.pow(@size, 2).times {|n| val = @cells[n].gval - 1; tmp[val] = tmp[val] + 1 if (val >= 0) }
		Ops.pow(@size, 2).times {|n| return true unless (tmp[n] < 2) }
		return false
	end
end

