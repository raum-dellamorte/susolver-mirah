/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package org.dellamorte.raum.susolver.supuzzle

import java.util.ArrayList

#import Ops
#import SuClass
#import SuCell

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
	
	def sameCellBool(a:SuCell, b:SuCell):boolean
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
		#puts "boxes fail" if Ops.containsBool(out, 0)
		return out
	end
	
	def row_a(n:int):SuCell[]
		return SuCell[0] if ((n < 1) or (n > @size))
		return SuPuzzle.copyOfRange(@cells, (@size * (n - 1)), (@size * n))
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
				return (num) if sameCellBool(cel, cels[c])
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
		cels.length.times {|c| out = out + 1 if ((gflag and !cels[c].gsetBool()) or !cels[c].setBool())}
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
			if (gflag and cels[c].gsetBool())
				out = Ops.appendUniq(out, cels[c].gval)
			elsif cels[c].setBool()
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
			if ((gflag and !cels[c].gsetBool) or !cels[c].setBool)
				if gflag
					ir = cels[c].gpmarks()
					puts "gpmarks Fail" if Ops.containsBool(ir, 0)
				else
					ir = cels[c].pmarks()
					puts "pmarks Fail" if Ops.containsBool(ir, 0)
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
	
	def canbeChunkBool(gflag:boolean, rowcol:String, rc:int, n:int):boolean
		if rowcol.equals(:row)
			return Ops.containsBool(growPMarks(rc), n) if gflag
			return Ops.containsBool(rowPMarks(rc), n)
		elsif rowcol.equals(:col)
			return Ops.containsBool(gcolPMarks(rc), n) if gflag
			return Ops.containsBool(colPMarks(rc), n)
		else
			return Ops.containsBool(gpmarks(), n) if gflag
			return Ops.containsBool(pmarks(), n)
		end
	end
	
	def valInChunkBool(gflag:boolean, rowcol:String, rc:int, n:int):boolean
		return true if canbeChunkBool(gflag, rowcol, rc, n)
		return Ops.containsBool(chunkSet(gflag, rowcol, rc), n)
	end
	
	def canbeRowBool(rc:int, n:int):boolean
		canbeChunkBool(false, :row, rc, n)
	end
	
	def canbeColBool(rc:int, n:int):boolean
		canbeChunkBool(false, :col, rc, n)
	end
	
	def gcanbeRowBool(rc:int, n:int):boolean
		canbeChunkBool(true, :row, rc, n)
	end
	
	def gcanbeColBool(rc:int, n:int):boolean
		canbeChunkBool(true, :col, rc, n)
	end
	
	def inChunks(gflag:boolean, rowcol:String, num:int):int[]
		out = int[0]
		@size.times {|i|
			out = Ops.appendUniq(out, i + 1) if valInChunkBool(gflag, rowcol, i + 1, num)
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
				if ((rcs.length > 0) and Ops.containsBool(rcs, rc))
					out[n] = bxn + 1 
					n = n + 1
				end
			}
			return int[0] if n == 0
			return Ops.copyOfRange(out, 0, n)
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
	
	def onlyChunkBool(rowcol:String, rc:int, num:int):boolean
		onlyChunk(false, rowcol, num) == rc
	end
	
	def gonlyChunkBool(rowcol:String, rc:int, num:int):boolean
		onlyChunk(true, rowcol, num) == rc
	end
	
	def onlyRowBool(i:int, num:int):boolean
		onlyChunkBool(:row, i, num)
	end
	
	def onlyColBool(i:int, num:int):boolean
		onlyChunkBool(:col, i, num)
	end
	
	def gonlyRowBool(i:int, num:int):boolean
		gonlyChunkBool(:row, i, num)
	end
	
	def gonlyColBool(i:int, num:int):boolean
		gonlyChunkBool(:col, i, num)
	end
	
	def conflictBool(n:int):boolean
		return Ops.containsBool(boxSet(), n) unless n == 0
		return false
	end
	
	def gconflictBool(n:int):boolean
		return Ops.containsBool(gboxSet(), n) unless n == 0
		return false
	end
	
	def onlyCellBool(cel:SuClass, num:int):boolean
		cnt = 0
		@cells.length.times {|c|
			next if sameCellBool(@cells[c], SuCell(cel))
			cnt = cnt + 1
			return false if ((@cells[c].setBool() and (@cells[c].val() == num)) or (!@cells[c].setBool() and Ops.containsBool(@cells[c].pmarks(), num)))
			#puts "onlyCell? " + num + " " + @cells[c].to_s() if (cnt == (@cells.length - 1))
		}
		puts "onlyCell? error: counted all cells" if cnt == @cells.length
		return true
	end
	
	def completeBool():boolean
		Ops.pow(@size, 2).times {|n| return false if !@cells[n].setBool() }
		return true
	end
	
	def gcompleteBool():boolean
		Ops.pow(@size, 2).times {|n| return false if !@cells[n].gsetBool() }
		return true
	end
	
	def solvedBool():boolean
		return false unless completeBool()
		tmp = int[Ops.pow(@size, 2)]
		Ops.pow(@size, 2).times {|n| val = @cells[n].val - 1; tmp[val] = tmp[val] + 1 if (val >= 0) }
		Ops.pow(@size, 2).times {|n| return false if (tmp[n] != 1) }
		return true
	end
	
	def gsolvedBool():boolean
		return false unless gcompleteBool()
		tmp = int[Ops.pow(@size, 2)]
		Ops.pow(@size, 2).times {|n| val = @cells[n].gval - 1; tmp[val] = tmp[val] + 1 if (val >= 0) }
		Ops.pow(@size, 2).times {|n| return false if (tmp[n] != 1) }
		return true
	end
	
	def brokenBool():boolean
		@cells.length.times {|c| return true if @cells[c].brokenBool() }
		tmp = int[Ops.pow(@size, 2)]
		Ops.pow(@size, 2).times {|n| val = @cells[n].val - 1; tmp[val] = tmp[val] + 1 if (val >= 0) }
		Ops.pow(@size, 2).times {|n| return true unless (tmp[n] < 2) }
		return false
	end
	
	def gbrokenBool():boolean
		@cells.length.times {|c| return true if @cells[c].gbrokenBool() }
		tmp = int[Ops.pow(@size, 2)]
		Ops.pow(@size, 2).times {|n| val = @cells[n].gval - 1; tmp[val] = tmp[val] + 1 if (val >= 0) }
		Ops.pow(@size, 2).times {|n| return true unless (tmp[n] < 2) }
		return false
	end
end

