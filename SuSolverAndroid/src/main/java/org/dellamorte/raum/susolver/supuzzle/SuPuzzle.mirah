/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package org.dellamorte.raum.susolver.supuzzle

import java.util.ArrayList
import java.lang.String
#import java.io.Console
import java.util.regex.*
#import com.codename1.util.StringUtil

/**
 *
 * @author Raum
 */
class SuPuzzle
	def initialize(syze:int):void
		@size = syze
		@cells = SuCell[Ops.pow(@size, 4)]
		@sorted = int[Ops.pow(@size, 4)]
		Ops.pow(@size, 4).times {|n| 
			@cells[n] = SuCell.new(self)
			row = calcRow(n + 1)
			col = ((n + 1) % 9)
			col = 9 if col == 0
			@cells[n].box_id = calcBox(row, col)
			@cells[n].row_id = row
			@cells[n].col_id = col
		}
		@guiMode = false
		@guessMode = false
		@guessFail = false
		@verbose = true
		@step = 0
		@stepMax = 11
	end
	
	def isEmpty():boolean
		out = true
		@size.times do |i:int|
			next unless out
			out = false if @cells[i].isSet()
		end
		return out
	end
	
	def self.copyOfRange(original:SuCell[], from:int, to:int):SuCell[]
		newLength = (to - from)
		(return SuCell[0]) if (newLength < 0)
		copy = SuCell[newLength]
		System.arraycopy(Object[].cast(original), from, Object[].cast(copy), 0, Math.min((original.length - from), newLength))
		return SuCell[].cast(copy)
	end
	
	def calcBox(r:int, c:int):int
		r = r + 1 until ((r % @size) == 0)
		r = r / @size
		c = c + 1 until ((c % @size) == 0)
		c = c / @size
		c + (@size * (r - 1))
	end
	
	def calcRow(n:int):int
		n = n + 1 until ((n % Ops.pow(@size, 2)) == 0)
		n / Ops.pow(@size, 2)
	end
	
	def size():int
		@size
	end
	
	def cell(r:int, c:int):SuCell
		cel = 0
		cel = cel + 1 until (((SuCell(@cells[cel]).row_id == r) and (SuCell(@cells[cel]).col_id == c)) or (@cells.length <= cel))
		return @cells[cel] unless (@cells.length <= cel)
		return SuCell(SuCell.new(self))
	end
	
	def cells():SuCell[]
		@cells
	end
	
	def setCell(n:int, cel:SuCell):void
		@cells[n - 1] = cel
	end
	
	def setSuCells(cels:SuCell[]):void
		@cells = cels
	end
	
	def setCells(cstr:String):void
		sz = Ops.pow(@size, 4)
		tmp = Ops.strToIntArray(cstr)
		return unless (tmp.length == sz)
		test = true
		m = Ops.pow(@size, 2)
		tmp.each do |n:int|
			next unless test
			test = ((n >= 0) and (n <= m))
		end
		return unless test
		setCells(tmp)
	end
	
	def setCells(ns:int[]):void
		Ops.pow(@size, 4).times {|i| @cells[i].set(ns[i], true) } if ns.length == Ops.pow(@size, 4)
	end
	
	def setRow(n:int, ns:int[]):void
		Ops.pow(@size, 2).times {|i| @cells[i + (Ops.pow(@size, 2) * (n - 1))].set(ns[i]) } if ns.length == Ops.pow(@size, 2)
	end
	
	def print():void
		return if @guiMode
		puts pmarks_s() unless solvedBool()
		puts to_s()
	end
	
	def gprint():void
		return if @guiMode
		puts g_to_s()
	end
	
	def to_s():String
		s = ""
		s = s + "Fail\n" if brokenBool()
		Ops.pow(@size, 2).times do |i|
			rw = row(i + 1).cells()
			Ops.pow(@size, 2).times {|n| s = s + rw[n].val + " "; s = s + " " if (((n + 1) % @size) == 0)}
			s = s + "\n"
			s = s + "\n" if (((i + 1) % @size) == 0)
		end
		return s
	end
	
	def g_to_s():String
		s = ""
		s = s + "Fail\n" if brokenBool()
		Ops.pow(@size, 2).times do |i|
			rw = row(i + 1).cells()
			Ops.pow(@size, 2).times {|n| s = s + rw[n].gval + " "; s = s + " " if (((n + 1) % @size) == 0)}
			s = s + "\n"
			s = s + "\n" if (((i + 1) % @size) == 0)
		end
		return s
	end
	
	def pmarks_s():String
		s = ""
		Ops.pow(@size, 2).times {|b|
			blk = SuBlock(box(b + 1))
			blk.cells().length.times {|c| s = s +  blk.cells[c].to_s + "\n" if !blk.cells[c].setBool() }
		}
		return s
	end
	
	def gpmarks_s():String
		s = ""
		Ops.pow(@size, 2).times {|b|
			blk = box(b + 1)
			blk.cells.length.times {|c| s = s + blk.cells[c].to_s + "\n" if !blk.cells[c].setBool() }
		}
		return s
	end
	
	def block(g:String, n:int):SuBlock
		out = SuBlock.new(self, g)
		grp = SuCell[Ops.pow(@size, 2)]
		gn = 0
		Ops.pow(@size, 4).times {|c|
			if (g.equals(:row) and (@cells[c].row_id() == n))
				grp[gn] = @cells[c] 
				gn = gn + 1
			elsif (g.equals(:col) and (@cells[c].col_id() == n))
				grp[gn] = @cells[c] 
				gn = gn + 1
			elsif (g.equals(:box) and (@cells[c].box_id() == n))
				grp[gn] = @cells[c] 
				gn = gn + 1
			end
		}
		grp.length.times {|n| SuBlock(out).setCell(n + 1, grp[n])}
		out
	end
	
	def box(n:int):SuBlock
		block(:box, n)
	end
	
	def row(n:int):SuBlock
		block(:row, n)
	end
	
	def col(n:int):SuBlock
		block(:col, n)
	end
	
	def setGuiMode(tf:boolean):void
		@guiMode = tf
	end
	
	def guiModeBool():boolean
		@guiMode
	end
	
	def setGuessMode(tf:boolean):void
		@guessMode = tf
	end
	
	def guessModeBool():boolean
		@guessMode
	end
	
	def solve():void # note to self. don't try to solve if there are no clues.
		puts to_s() unless guiModeBool()
		basicCheck()
		unless solvedBool()
			print()
			autoCheck()
		end
		if (@guessMode and !(solvedBool() or brokenBool()))
			print()
			puts "Guessing..." unless guiModeBool()
			guessCheck()
		end
		print()
	end
	
	def autoCheck():void
		i = 0
		until (solvedBool() or brokenBool())
			if checkStep(i)
				i = i + 1 unless brokenBool()
			else
				i = 0 unless brokenBool()
			end
			break if ((i >= @stepMax) or brokenBool())
		end
		puts "Broken By: " + i if brokenBool()
	end
	
	def stepCheck():void
		return if (solvedBool() or brokenBool())
		s1 = pmarks_s + to_s
		unless (solvedBool() or brokenBool())
			if checkStep(@step)
				@step = @step + 1 unless brokenBool()
			else
				@step = 0 unless brokenBool()
			end
		end
		s2 = pmarks_s + to_s
		stepCheck() if ((@step < @stepMax) and (s2.equals(s1) and (!solvedBool() and !brokenBool())))
	end
	
	def checkStep(i:int):boolean
		s1 = pmarks_s + to_s
		basicCheck() if i == 0
		singleCandidate() if i == 1
		hiddenSingle() if i == 2
		nakedPairs() if i == 3
		nakedGroups() if i == 4
		singleRC() if i == 5
		xwings() if i == 6
		singlesChains() if i == 7
		ywing() if i == 8
		swordfish() if i == 9
		xCycles() if i == 10
#		 if i == 11
#		 if i == 12
		s2 = pmarks_s + to_s
		return s2.equals(s1)
	end
	
	def gcheck(start:int, srtd:boolean):void
		s1 = "1"
		s2 = "2"
		until s2.equals(s1)
			s1 = gpmarks_s + g_to_s
			@cells.length.times {|c| 
				if c >= start
					if srtd
						cel = @sorted[c]
					else
						cel = c
					end
					@cells[cel].gcheck() 
				end
			}
			s2 = gpmarks_s + g_to_s
		end
	end
	
	def basicCheck():void
		s1 = "1"
		s2 = "2"
		until s2.equals(s1)
			s1 = pmarks_s + to_s
			Ops.pow(@size, 2).times do |i|
				n = i + 1
				elimGrp = ArrayList.new()
				@cells.each do |oc:SuCell|
					next unless oc.val() == n
					@cells.each do |ic:SuCell|
						next if oc == ic
						next if ic.setBool()
						next unless ic.canbeBool(n)
						elimGrp.add(ic) if ic.canSeeBool(oc)
					end
				end
				na = int[1]
				na[0] = n
				cellElim(na, elimGrp.toArray(SuCell[0]), "Simple Elimination: " + n) if elimGrp.size > 0
			end
			s2 = pmarks_s + to_s
		end
	end
	
	def singleCandidate():void
		msg = "Single Candidates: "
		@cells.each do |c:SuCell|
			na = c.pmarks()
			next unless na.length == 1
			c.set(na[0])
			msg = msg + "\n " + na[0] + " at " + c.brc_s()
		end
		puts msg if !msg.equals("Single Candidates: ")
	end
	
	def hiddenSingle():void
		msg = "Hidden Singles: "
		@cells.each {|c:SuCell|
			next if c.setBool()
			9.times do |i|
				n = i + 1
				if (box(c.box_id()).onlyCellBool(c, n) or (row(c.row_id()).onlyCellBool(c, n) or col(c.col_id()).onlyCellBool(c, n)))
					c.set(n)
					msg = msg + "\n" + "Cell at " + c.brc_s + " is the only cell in it's row, col, or box that can be " + n + ". Set."
				end
			end
		}
	end
	
	def nakedPairs(gflag = false):void
		cln = @cells.length
		cln.times {|oci|
			c1 = @cells[oci]
			next unless c1.pmarks().length == 2
			cln.times {|ici|
				next unless ici > oci
				c2 = @cells[ici]
				next unless c1.canSeeBool(c2)
				next unless c2.pmarks().length == 2
				next unless Ops.union(c1.pmarks(), c2.pmarks()).length == 2
				elimGrp = ArrayList.new()
				@cells.each do |c:SuCell|
					next if c == c1
					next if c == c2
					next unless (c.canSeeBool(c1) and c.canSeeBool(c2))
					elimGrp.add(c)
				end
				na = c1.pmarks()
				cellElim(na, elimGrp.toArray(SuCell[0]), "Naked Pair: " + Ops.toString(na)) if elimGrp.size > 0
			}
		}
	end
	
	def nakedGroups(gflag = false):void
		Ops.pow(@size, 2).times {|brci|
			brc = SuBlock[3]
			brc[0] = box(brci + 1)
			brc[1] = row(brci + 1)
			brc[2] = col(brci + 1)
			brcs = String[3]
			brcs[0] = :box
			brcs[1] = :row
			brcs[2] = :col
			3.times {|ibrc|
				cels = SuCell[].cast(brc[ibrc].cells())
				cels.length.times {|oc|
					next if ((gflag and cels[oc].gsetBool()) or cels[oc].setBool())
					if gflag
						ocr = cels[oc].gpmarks()
					else
						ocr = cels[oc].pmarks()
					end
					next unless ((ocr.length <= (Ops.pow(@size, 2) - 2)) and (ocr.length > 1))
					exclude = int[1]
					exclude[0] = oc
					cels.length.times {|ic|
						next if ((oc == ic) or ((gflag and cels[ic].gsetBool()) or cels[ic].setBool()))
						if gflag
							icr = cels[ic].gpmarks()
						else
							icr = cels[ic].pmarks()
						end
						next unless ((icr.length > 1) and Ops.isSubsetBool(ocr, icr))
						exclude = Ops.appendUniq(exclude, ic)
					}
					next unless ((exclude.length > 1) and (ocr.length == exclude.length))
					ocr.length.times {|i|
						brcElim(brcs[ibrc], (brci + 1), ocr[i], exclude, "Naked Group: " + Ops.toString(ocr), gflag)
					}
				}
			}
		}
	end
	
	def singleRC(gflag = false):void
		Ops.pow(@size, 2).times {|bx|
			cels = SuCell[].cast(box(bx + 1).cells())
			Ops.pow(@size, 2).times {|n|
				num = n + 1
				rows = int[0]
				cols = int[0]
				rexclude = int[0]
				cexclude = int[0]
				cels.length.times {|c|
					next if ((gflag and cels[c].gsetBool()) or cels[c].setBool)
					next unless Ops.containsBool(cels[c].pmarks(), num)
					rows = Ops.appendUniq(rows, cels[c].row_id())
					cols = Ops.appendUniq(cols, cels[c].col_id())
					rexclude = Ops.appendUniq(rexclude, cels[c].col_id() - 1)
					cexclude = Ops.appendUniq(cexclude, cels[c].row_id() - 1)
				}
				brcElim(:row, rows[0], num, rexclude, "single row: " + num, gflag) if (rows.length == 1)
				brcElim(:col, cols[0], num, cexclude, "single col: " + num, gflag) if (cols.length == 1)
			}
		}
	end
	
	def xwings(gflag = false):void
		Ops.pow(@size, 2).times {|orci|
			orc = orci + 1
			rw1 = SuBlock(row(orc))
			cl1 = SuBlock(col(orc))
			Ops.pow(@size, 2).times {|irci|
				irc = irci + 1
				next unless irc > orc
				rw2 = SuBlock(row(irc))
				cl2 = SuBlock(col(irc))
				Ops.pow(@size, 2).times {|oc|
					Ops.pow(@size, 2).times {|ic|
						next unless ic > oc
						rowcol = String[2]
						rowcol[0] = :row
						rowcol[1] = :col
						2.times {|rci|
							rcs = rowcol[rci]
							num = 0
							if rcs.equals(:row)
								cels1 = SuCell[].cast(rw1.cells())
								cels2 = SuCell[].cast(rw2.cells())
							else
								cels1 = SuCell[].cast(cl1.cells())
								cels2 = SuCell[].cast(cl2.cells())
							end
							Ops.pow(@size, 2).times {|ni|
								num = ni + 1
								next unless (((!cels1[oc].setBool() and Ops.containsBool(cels1[oc].pmarks(), num)) and (!cels1[ic].setBool() and Ops.containsBool(cels1[ic].pmarks(), num))) and 
										((!cels2[oc].setBool() and Ops.containsBool(cels2[oc].pmarks(), num)) and (!cels2[ic].setBool() and Ops.containsBool(cels2[ic].pmarks(), num))))
								#puts "Found Square r" + orc + "" + irc + "c" + (oc + 1) + "" + (ic + 1) + " num " + num
								test = true
								Ops.pow(@size, 2).times {|icol|
									next unless test
									next unless ((icol != oc) and (icol != ic))
									next unless ((!cels1[icol].setBool() and Ops.containsBool(cels1[icol].pmarks(), num)) or (!cels2[icol].setBool() and Ops.containsBool(cels2[icol].pmarks(), num)))
									test = false
								}
								next unless test
								if rcs.equals(:row)
									rcs = :col
								else
									rcs = :row
								end
								excluded = int[2]
								excluded[0] = orci
								excluded[1] = irci
								brcElim(rcs, oc + 1, num, excluded, "X-Wing: " + num + " " + 
									cels1[oc].brc_s + " " + cels1[ic].brc_s + " " + cels2[oc].brc_s + " " + cels2[ic].brc_s, gflag)
								brcElim(rcs, ic + 1, num, excluded, "X-Wing: " + num + " " + 
									cels1[oc].brc_s + " " + cels1[ic].brc_s + " " + cels2[oc].brc_s + " " + cels2[ic].brc_s, gflag)
							}
						}
					}
				}
			}
		}
	end
	
	def singlesChains(gflag = false):void
		puts "Started singlesChains"
		kill = false
		Ops.pow(@size, 2).times {|i|
			break if kill
			n = i + 1
			Chain.init(@cells, n)
			while Chain.findNextChain()
				break if kill
				x = Chain.elimTwiceInUnit()
				if ((x != nil) and (x.cells().length > 0))
					cellElim(x.vals(), x.cells(), x.msg())
					kill = true
					break
				end
				x = Chain.elimTwoColorsInUnit()
				if ((x != nil) and (x.cells().length > 0))
					cellElim(x.vals(), x.cells(), x.msg())
					kill = true
					break
				end
				x = Chain.elimTwoColorsElsewhere()
				if ((x != nil) and (x.cells().length > 0))
					cellElim(x.vals(), x.cells(), x.msg())
					kill = true
					break
				end
			end
		}
	end
	
	def ywing(gflag = false):void
		cels = twoRemain()
		cels.length.times {|c1|
			cels.length.times {|c2|
				next unless (c2 > c1)
				cels.length.times {|c3|
					next unless (c3 > c2)
					tnums = Ops.joinUniq(Ops.joinUniq(cels[c1].pmarks(), cels[c2].pmarks()), cels[c3].pmarks())
					next unless (tnums.length == 3)
					next if (cels[c1].setBool() or (cels[c2].setBool() or cels[c3].setBool()))
					next if ((((cels[c1].row_id == cels[c2].row_id) and (cels[c2].row_id == cels[c3].row_id)) or 
								((cels[c1].col_id == cels[c2].col_id) and (cels[c2].col_id == cels[c3].col_id))) or 
								((cels[c1].box_id == cels[c2].box_id) and (cels[c2].box_id == cels[c3].box_id)))
					next if (Ops.aEqualsBool(cels[c1].pmarks(), cels[c2].pmarks()) or 
							(Ops.aEqualsBool(cels[c1].pmarks(), cels[c3].pmarks()) or 
							Ops.aEqualsBool(cels[c2].pmarks(), cels[c3].pmarks())))
					#puts "Made it this far"
					#puts "c1: " + cels[c1].to_s
					#puts "c2: " + cels[c2].to_s
					#puts "c3: " + cels[c3].to_s
					if (cels[c1].canSeeBool(cels[c2]) and (cels[c1].canSeeBool(cels[c3]) and !cels[c2].canSeeBool(cels[c3])))
						# Hinge at c1
						u = Ops.union(cels[c2].pmarks(), cels[c3].pmarks())
						next if u.length == 0
						num = u[0]
						hinge = c1
						wing1 = c2
						wing2 = c3
					elsif (cels[c2].canSeeBool(cels[c1]) and (cels[c2].canSeeBool(cels[c3]) and !cels[c1].canSeeBool(cels[c3])))
						# Hinge at c2
						u = Ops.union(cels[c1].pmarks(), cels[c3].pmarks())
						next if u.length == 0
						num = u[0]
						hinge = c2
						wing1 = c1
						wing2 = c3
					elsif (cels[c3].canSeeBool(cels[c1]) and (cels[c3].canSeeBool(cels[c2]) and !cels[c1].canSeeBool(cels[c2])))
						# Hinge at c3
						u = Ops.union(cels[c1].pmarks(), cels[c2].pmarks())
						next if u.length == 0
						num = u[0]
						hinge = c3
						wing1 = c1
						wing2 = c2
					else
						next
					end
					@cells.length.times {|ic| 
						next if @cells[ic].setBool()
						s = @cells[ic].to_s
						next if (((@cells[ic] == cels[hinge]) or (@cells[ic] == cels[wing1])) or (@cells[ic] == cels[wing2]))
						next unless (@cells[ic].canSeeBool(cels[wing1]) and @cells[ic].canSeeBool(cels[wing2]))
						next if @cells[ic].eliminatedBool(num)
						@cells[ic].eliminate(num)
						@cells[ic].check()
						next unless @verbose
						puts "YWing: " + num + " Hinge: " + cels[hinge].brc_s + " Wing1: " + cels[wing1].brc_s + " Wing2: " + cels[wing2].brc_s
						puts "elim " + num + " from " + @cells[ic].to_s()
					}
				}
			}
		}
	end
	
	def swordfish(gflag = false):void
		Ops.pow(@size, 2).times {|rci1|
			rc1 = rci1 + 1
			rw1 = SuBlock(row(rc1))
			cl1 = SuBlock(col(rc1))
			Ops.pow(@size, 2).times {|rci2|
				rc2 = rci2 + 1
				next unless rc2 > rc1
				rw2 = SuBlock(row(rc2))
				cl2 = SuBlock(col(rc2))
				Ops.pow(@size, 2).times {|rci3|
					rc3 = rci3 + 1
					next unless rc3 > rc2
					rw3 = SuBlock(row(rc3))
					cl3 = SuBlock(col(rc3))
					Ops.pow(@size, 2).times {|c1|
						Ops.pow(@size, 2).times {|c2|
							next unless c2 > c1
							Ops.pow(@size, 2).times {|c3|
								next unless c3 > c2
								crefs = int[3]
								crefs[0] = c1
								crefs[1] = c2
								crefs[2] = c3
								rowcol = String[2]
								rowcol[0] = :row
								rowcol[1] = :col
								2.times {|rci|
									rcs = rowcol[rci]
									num = 0
									if rcs.equals(:row)
										cels1 = SuCell[].cast(rw1.cells())
										cels2 = SuCell[].cast(rw2.cells())
										cels3 = SuCell[].cast(rw3.cells())
									else
										cels1 = SuCell[].cast(cl1.cells())
										cels2 = SuCell[].cast(cl2.cells())
										cels3 = SuCell[].cast(cl3.cells())
									end
									Ops.pow(@size, 2).times {|ni|
										num = ni + 1
										cnt = 0
										crefs.each {|cn| cnt = cnt + 1 if (!cels1[cn].setBool() and Ops.containsBool(cels1[cn].pmarks(), num)) }
										next unless cnt >= 2
										cnt = 0
										crefs.each {|cn| cnt = cnt + 1 if (!cels2[cn].setBool() and Ops.containsBool(cels2[cn].pmarks(), num)) }
										next unless cnt >= 2
										cnt = 0
										crefs.each {|cn| cnt = cnt + 1 if (!cels3[cn].setBool() and Ops.containsBool(cels3[cn].pmarks(), num)) }
										next unless cnt >= 2
										#puts "Found Square r" + rc1 + "" + rc2 + "c" + (oc + 1) + "" + (ic + 1) + " num " + num
										cnt = 0
										crefs.each {|cn|
											icnt = 0
											icnt = icnt + 1 if (!cels1[cn].setBool() and Ops.containsBool(cels1[cn].pmarks(), num))
											icnt = icnt + 1 if (!cels2[cn].setBool() and Ops.containsBool(cels2[cn].pmarks(), num))
											icnt = icnt + 1 if (!cels3[cn].setBool() and Ops.containsBool(cels3[cn].pmarks(), num))
											cnt = cnt + 1 if (icnt >= 2)
										}
										next unless cnt == 3
										cnt = 0
										Ops.pow(@size, 2).times {|cn|
											next if cnt > 0
											next if Ops.containsBool(crefs, cn)
											cnt = cnt + 1 if (!cels1[cn].setBool() and Ops.containsBool(cels1[cn].pmarks(), num))
											cnt = cnt + 1 if (!cels2[cn].setBool() and Ops.containsBool(cels2[cn].pmarks(), num))
											cnt = cnt + 1 if (!cels3[cn].setBool() and Ops.containsBool(cels3[cn].pmarks(), num))
										}
										next unless (cnt == 0)
										if rcs.equals(:row)
											rcs = :col
										else
											rcs = :row
										end
										excluded = int[3]
										excluded[0] = rci1
										excluded[1] = rci2
										excluded[2] = rci3
										sfrows = int[0]
										sfcols = int[0]
										crefs.each {|cn|
											sfrows = Ops.appendUniq(sfrows, cels1[cn].row_id)
											sfrows = Ops.appendUniq(sfrows, cels2[cn].row_id)
											sfrows = Ops.appendUniq(sfrows, cels3[cn].row_id)
											sfcols = Ops.appendUniq(sfcols, cels1[cn].col_id)
											sfcols = Ops.appendUniq(sfcols, cels2[cn].col_id)
											sfcols = Ops.appendUniq(sfcols, cels3[cn].col_id)
										}
										brcElim(rcs, c1 + 1, num, excluded, "Swordfish: " + num + " r" + Ops.toString(sfrows) + "c" + Ops.toString(sfcols), gflag)
										brcElim(rcs, c2 + 1, num, excluded, "Swordfish: " + num + " r" + Ops.toString(sfrows) + "c" + Ops.toString(sfcols), gflag)
										brcElim(rcs, c3 + 1, num, excluded, "Swordfish: " + num + " r" + Ops.toString(sfrows) + "c" + Ops.toString(sfcols), gflag)
									}
								}
							}
						}
					}
				}
			}
		}
		#basicCheck()
	end
	
	def xCycles(gflag = false):void
		puts "Started X-Cycles"
		Ops.pow(@size, 2).times {|i|
			n = i + 1
			XCycle.init(@cells, n)
			#puts XCycle.reg_s()
			#puts XCycle.loop_s()
			if XCycle.loopCompleteBool()
				x = XCycle.elimTwoStrongLinks()
				if ((x != nil) and (x.cells().length > 0))
					cellElim(x.vals(), x.cells(), x.msg())
					break
				end
				x = XCycle.elimTwoWeakLinks()
				if ((x != nil) and (x.cells().length > 0))
					cellElim(x.vals(), x.cells(), x.msg())
					break
				end
				x = XCycle.elimWeakLink()
				if ((x != nil) and (x.cells().length > 0))
					cellElim(x.vals(), x.cells(), x.msg())
					break
				end
			end
		}
	end
	
	def guessCheck():void
		return if gbrokenBool()
		#gcheck()
		#remainSort()
		#puts "Fail" unless guesser(0)
	end
	
	def guesser(c:int):boolean
		return guesser(c + 1) if @cells[@sorted[c]].setBool()
		#gcheck(c, true)
		if @cells[@sorted[c]].gsetBool() # @sorted[c]
			if (gsolvedBool() or (((c + 1) < @cells.length) and guesser(c + 1)))
				@cells.length.times {|ic| @cells[@sorted[ic]].setToGuess() if (ic >= c) } unless @guessFail
				return true
			end
			@cells.length.times {|ic| @cells[@sorted[ic]].greset() if (ic >= c) }
			return false
		end
		while @cells[@sorted[c]].canGuessBool()
			@cells.length.times {|ic| @cells[@sorted[ic]].greset() if (ic > c) }
			@cells[@sorted[c]].nextGuess()
			gcheck(c + 1, true)
			#gcheck2(c + 1, true)
			if gsolvedBool()
				@cells.length.times {|ic| @cells[@sorted[ic]].setToGuess() if (ic >= c) }
				return true
			end
			#(puts c; @guessFail = !continueBool()) if c < 9 # if ((c >= (Ops.pow(@size, 2) * (Ops.pow(@size, 2) - 1))) and ((c % Ops.pow(@size, 2)) == 0))
			#return true if @guessFail
			if !gbrokenBool()
				if (((c + 1) < @cells.length) and guesser(c + 1))
					@cells[@sorted[c]].setToGuess() unless @guessFail
					return true
				end
			else
				@cells.length.times {|ic| @cells[@sorted[ic]].greset() if (ic > c) }
			end
		end
	#		puts gpmarks_s()
	#		gprint()
		@cells.length.times {|ic| @cells[@sorted[ic]].greset() if (ic >= c) }
		#@cells[@sorted[c]].gcheck()
		return false
	end
	
	def continueBool():boolean
		#puts gpmarks_s()
		#gprint()
		#console = System.console()
		#rl = console.readLine("Continue? ")
		#return false if rl.equals("q")
		return true
	end
	
	def remainSort():void
		used = boolean[Ops.pow(@size, 4)]
		used.length.times {|i| used[i] = false}
		@sorted = int[Ops.pow(@size, 4)]
		i = 0
		Ops.pow(@size, 2).times {|ll|
			l = ll + 1
			if i < @sorted.length
				@cells.length.times {|c|
					if i < @sorted.length
						if ((!used[c]) and (((l == 1) and @cells[c].setBool()) or ((l > 1) and (@cells[c].pmarks().length == l))))
							@sorted[i] = c
							used[c] = true
							i = i + 1
						end
					end
				}
			end
		}
		#puts Ops.toString(@sorted)
	end
	
	def twoRemain():SuCell[]
		out = SuCell[@cells.length]
		n = 0
		@cells.length.times {|c|
			next unless (!@cells[c].setBool() and (@cells[c].pmarks().length == 2))
			out[n] = @cells[c]
			n = n + 1
		}
		return SuCell[0] if n == 0
		return SuPuzzle.copyOfRange(out, 0, n)
		#return out.range(:SuCell, 0, n)
	end
	
	def brcElim(rowcol:String, rc:int, num:int, exclude:int[], message:String, gflag = false):void
		if rowcol.equals(:row)
			cels = SuCell[].cast(row(rc).cells())
		elsif rowcol.equals(:col)
			cels = SuCell[].cast(col(rc).cells())
		else
			cels = SuCell[].cast(box(rc).cells())
		end
		cnt = 0
		cels.length.times {|c|
			next unless (!Ops.containsBool(exclude, c) and !cels[c].setBool())
			next if cels[c].eliminatedBool(num)
			cnt = cnt + 1
		}
		puts message if (@verbose and (cnt > 0))
		cels.length.times {|c|
			next unless (!Ops.containsBool(exclude, c) and !cels[c].setBool())
			next if cels[c].eliminatedBool(num)
			cels[c].eliminate(num)
			cels[c].check()
			next unless @verbose
			puts "elim " + num + " from " + cels[c].to_s()
		}
		#print()
	end
	
	def cellElim(na:int[], cels:SuCell[], msg = "", gflag = false):void
		cnt = 0
		na.each do |n:int|
			msg = msg + "\n" + "elim " + n + " from:\n"
			cels.each {|c:SuCell|
				next if c.setBool()
				next if c.eliminatedBool(n)
				c.eliminate(n)
				next unless @verbose
				cnt = cnt + 1
				msg = msg + " " + c.brc_s()
				msg = msg + "\n" if ((cnt % 9) == 0)
			}
		end
#		cels.each {|c:SuCell|
#			c.set(c.pmarks[0]) if c.pmarks.length == 1
#			9.times do |i|
#				n = i + 1
#				if (box(c.box_id()).onlyCellBool(c, n) or (row(c.row_id()).onlyCellBool(c, n) or col(c.col_id()).onlyCellBool(c, n)))
#					c.set(n)
#					msg = msg + "\n" + "Cell at " + c.brc_s + " is the only cell in it's row, col, or box that can be " + n + ". Set."
#				end
#			end
#		}
		puts msg if (@verbose and (cnt > 0))
		#print()
	end
	
	def solvedBool():boolean
		out = true
		Ops.pow(@size, 2).times {|n| 
			out = box(n + 1).solvedBool() if out
			out = row(n + 1).solvedBool() if out
			out = col(n + 1).solvedBool() if out
		}
		out
	end
	
	def gsolvedBool():boolean
		out = true
		Ops.pow(@size, 2).times {|n| 
			out = box(n + 1).gsolvedBool() if out
			out = row(n + 1).gsolvedBool() if out
			out = col(n + 1).gsolvedBool() if out
		}
		out
	end
	
	def completeBool():boolean
		out = true
		Ops.pow(@size, 2).times {|n| 
			out = box(n + 1).completeBool() if out
			out = row(n + 1).completeBool() if out
			out = col(n + 1).completeBool() if out
		}
		out
	end
	
	def gcompleteBool():boolean
		out = true
		Ops.pow(@size, 2).times {|n| 
			out = box(n + 1).gcompleteBool() if out
			out = row(n + 1).gcompleteBool() if out
			out = col(n + 1).gcompleteBool() if out
		}
		out
	end
	
	def brokenBool():boolean
		out = true
		Ops.pow(@size, 2).times {|n| 
			out = !box(n + 1).brokenBool() if out
			out = !row(n + 1).brokenBool() if out
			out = !col(n + 1).brokenBool() if out
		}
		!out
	end
	
	def gbrokenBool():boolean
		out = true
		Ops.pow(@size, 2).times {|n| 
			out = !box(n + 1).gbrokenBool() if out
			out = !row(n + 1).gbrokenBool() if out
			out = !col(n + 1).gbrokenBool() if out
		}
		!out
	end
	
	## Start Internal Classes
	
	class SuCell
		def initialize(parent:SuPuzzle):void
			@parent = parent
			@size = @parent.size()
			@is = 0
			@box = 0
			@row = 0
			@col = 0
			@elim = int[0]
			@clue = false
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
			@is = 0 unless @clue
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
		
		def isSet():boolean
			@is != 0
		end
		
		def isClue():boolean
			@clue
		end
		
		def set(num:int):void
			#@pmarks = int[0] unless (num == 0)
			@is = num
		end
		
		def set(num:int, clu:boolean):void
			#@pmarks = int[0] unless (num == 0)
			@clue = (clu and (num != 0))
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
		
		def canSeeBool(cel:SuCell):boolean
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
				x = @parent.box(@box).onlyCellBool(self, pmarks()[i])
				y = @parent.row(@row).onlyCellBool(self, pmarks()[i])
				z = @parent.col(@col).onlyCellBool(self, pmarks()[i])
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
	end # End SuCell
	
	class SuBlock
		def self.copyOfRange(original:SuCell[], from:int, to:int):SuCell[]
			newLength = (to - from)
			(return SuCell[0]) if (newLength < 0)
			copy = SuCell[newLength]
			System.arraycopy(Object[].cast(original), from, Object[].cast(copy), 0, Math.min((original.length - from), newLength))
			return SuCell[].cast(copy)
		end
		
		def initialize(parent:SuPuzzle, whatkind:String):void
			@parent = parent
			@blockType = whatkind
			@size = @parent.size()
			@cells = SuCell[Ops.pow(@size, 2)]
		end
		
		def blockType
			@blockType
		end
		
		def cells():SuCell[]
			@cells
		end
		
		def setCell(n:int, cel:SuCell):void
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
			return SuBlock.copyOfRange(@cells, (@size * (n - 1)), (@size * n))
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
		
		def onlyCellBool(cel:SuCell, num:int):boolean
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
	end # End SuBlock
	
	class ElimGroup
		def initialize():void; @msg = ""; @cels = SuCell[0]; @vals = int[0]; end
		def vals():int[]; @vals; end
		def addVal(n:int):void; @vals = Ops.appendUniq(@vals, n); end
		def msg():String; @msg; end
		def setMsg(s:String):void; @msg = s; end
		def msgAdd(s:String, newline = true):void; @msg = @msg + "\n" if newline; @msg = @msg + s; end
		def cells():SuCell[]; @cels; end
		def addCell(c:SuCell):void
			out = SuCell[@cels.length + 1]
			@cels.length.times {|i| out[i] = @cels[i]}
			out[@cels.length] = c
			@cels = out
		end
	end
	
	class XCycle
		def self.init(cels:SuCell[], n:int):void
			@@reg = XCycle[0]
			@@val = n
			#@@bookmark = 0 - 1
			out = ArrayList.new()
			cels.each do |c:SuCell|
				next if c.setBool()
				next if (c.pmarks().length < 2)
				out.add(c) if Ops.containsBool(c.pmarks(), n)
			end
			@@cels = out.toArray(SuCell[0])
			XCycle.findStrongLinks()
			XCycle.connectLoop()
		end
		
		def self.cells():SuCell[]
			@@cels
		end
		
		def self.value():int
			@@val
		end
		
		def self.clear():void
			@@reg = XCycle[0] # Look into changing this to a HashMap
		end
		
		def self.links():XCycle[]
			return @@reg
		end
		
		def self.emptyBool():boolean
			return (@@reg.length == 0)
		end
		
		def self.toString():String
			out = "XCycle: " + @@val + "\n"
			@@reg.each {|cyc:XCycle| out = out + cyc.to_s() + "\n"}
			return out
		end
		
		def self.regContainsBool(c1:SuCell, c2:SuCell):boolean
			out = false
			@@reg.each {|c:XCycle|
				next unless c.containsBool(c1, c2)
				out = true
				break
			}
			return out
		end
		
		def self.get(c1:SuCell, c2:SuCell):XCycle
			out = XCycle(nil)
			@@reg.each {|c:XCycle|
				next unless c.containsBool(c1, c2)
				out = c
				break
			}
			return out
		end
		
		def self.add(c1:SuCell, c2:SuCell, weak = false):XCycle
			unless XCycle.regContainsBool(c1, c2)
				reg = ArrayList.new()
				@@reg.each {|c:XCycle| reg.add(c) }
				nx = XCycle.new(c1,c2,weak)
				reg.add(nx)
				@@reg = reg.toArray(XCycle[0])
				return nx
			end
			return XCycle.get(c1, c2)
		end
		
		def self.findStrongLinks():void
			return if @@cels.length == 0
			@@cels.length.times {|oci:int|
				@@cels.length.times {|ici:int|
					next unless ici > oci
					c1 = SuCell(@@cels[oci])
					c2 = SuCell(@@cels[ici])
					next unless c1.canSeeBool(c2)
					test = false
					@@cels.length.times {|tci|
						next if tci == oci
						next if tci == ici
						tc = @@cels[tci]
						test = (tc.canSeeBool(c1) and tc.canSeeBool(c2))
						break if test
					}
					next if test
					XCycle.add(c1, c2)
				}
			}
		end
		
		def self.connectLoop():void
			return if @@reg.length == 0
			XCycle.connectWeakLinks()
			newreg = ArrayList.new()
			@@reg.each {|xc:XCycle|
				if xc.weakBool()
					newreg.add(xc)
					next
				end
				next if (!xc.hasLtxBool() and !xc.hasRtxBool())
				newreg.add(xc)
			}
			@@reg = newreg.toArray(XCycle[0])
#			XCycle.connectWeakLinks()
			XCycle.connectStrongLinks()
			XCycle.connectDblWeak() unless XCycle.loopCompleteBool()
			newreg = ArrayList.new()
			@@reg.each {|xc:XCycle|
				next unless (xc.hasLtxBool() and xc.hasRtxBool())
				newreg.add(xc)
			}
			@@reg = newreg.toArray(XCycle[0])
		end
		
		def self.connectWeakLinks():void
			return if @@reg.length == 0
			creg = XCycle[@@reg.length]
			@@reg.length.times {|xci| creg[xci] = @@reg[xci]}
			creg.length.times {|oxi|
				ox = creg[oxi]
				next if (ox.hasLtxBool() and ox.hasRtxBool())
				creg.length.times {|ixi|
					next unless ixi > oxi
					ix = creg[ixi]
					next if ox == ix
					next if ix.containsBool(ox.ltc(), ox.rtc())
					if (!ox.hasLtxBool() and !ix.containsBool(ox.ltc()))
						ix.swap() if ((ox.ltc().canSeeBool(ix.ltc())) and (!ix.hasLtxBool() and !ix.hasRtxBool()))
						if ox.ltc().canSeeBool(ix.rtc())
							wk = XCycle.add(ix.rtc(), ox.ltc(), true)
							if wk.weakBool()
								ix.connectRt(wk)
								wk.connectLt(ix)
								wk.connectRt(ox)
								ox.connectLt(wk)
							end
						end
					end
					if (!ox.hasRtxBool() and !ix.containsBool(ox.rtc()))
						ix.swap() if ((ox.rtc().canSeeBool(ix.rtc())) and (!ix.hasLtxBool() and !ix.hasRtxBool()))
						if ox.rtc().canSeeBool(ix.ltc())
							wk = XCycle.add(ox.rtc(), ix.ltc(), true)
							if wk.weakBool()
								ox.connectRt(wk)
								wk.connectLt(ox)
								wk.connectRt(ix)
								ix.connectLt(wk)
							end
						end
					end
				}
			}
		end
		
		def self.connectStrongLinks():void
			return if @@reg.length == 0
			@@reg.length.times {|oxi|
				ox = @@reg[oxi]
				next if (ox.hasLtxBool() and ox.hasRtxBool())
				@@reg.length.times {|ixi|
					next unless ixi > oxi
					ix = @@reg[ixi]
					next if (ix.hasLtxBool() and ix.hasRtxBool())
					if (!ox.hasLtxBool() and ix.containsBool(ox.ltc()))
						if ox.ltc() == ix.rtc()
							ix.connectRt(ox)
							ox.connectLt(ix)
						end
					end
					if (!ox.hasRtxBool() and ix.containsBool(ox.rtc()))
						if ox.rtc() == ix.ltc()
							ox.connectRt(ix)
							ix.connectLt(ox)
						end
					end
				}
			}
		end
		
		def self.connectDblWeak():void
			return if @@reg.length == 0
			creg = XCycle[@@reg.length]
			@@reg.length.times {|xci| creg[xci] = @@reg[xci]}
			creg.length.times{|oxi| 
				ox = creg[oxi]
				next if (ox.hasLtxBool() and ox.hasRtxBool())
				next if (!ox.hasLtxBool() and !ox.hasRtxBool())
				creg.length.times{|ixi| 
					next unless ixi > oxi
					ix = creg[ixi]
					next if (ix.hasLtxBool() and ix.hasRtxBool())
					next if (!ix.hasLtxBool() and !ix.hasRtxBool())
					next unless ((!ix.hasLtxBool() and !ox.hasRtxBool()) or (!ox.hasLtxBool() and !ix.hasRtxBool()))
					if (!ix.hasLtxBool() and !ox.hasRtxBool())
						c1 = ix.ltc()
						c2 = ox.rtc()
						x1 = ox
						x2 = ix
					elsif (!ox.hasLtxBool() and !ix.hasRtxBool())
						c1 = ox.ltc()
						c2 = ix.rtc()
						x1 = ix
						x2 = ox
					end
					@@cels.each {|tc|
						next if tc == c1
						next if tc == c2
						next unless (tc.canSeeBool(c1) and tc.canSeeBool(c2))
						wk1 = XCycle.add(c2, tc, true)
						wk2 = XCycle.add(tc, c1, true)
						x1.connectRt(wk1)
						wk1.connectLt(x1)
						wk1.connectRt(wk2)
						wk2.connectLt(wk1)
						wk2.connectRt(x2)
						x2.connectLt(wk2)
						break
					}
				}
			}
		end
		
		def self.loopCompleteBool():boolean
			return false if @@reg.length < 3
			cnt = 0
			@@reg.each {|xc:XCycle| cnt = cnt + 1 if xc.strongBool() }
			return false if cnt < 2
			tmp = @@reg[0].cycle()
			test = false
			tmp.each {|xc:XCycle| 
				next if (xc.hasLtxBool() and xc.hasRtxBool())
				test = true
				break
			}
			return false if test
			return tmp[0].ltx() == tmp[tmp.length - 1]
		end
		
		def self.reg_s():String
			tmp = ""
			@@reg.each {|xc:XCycle| tmp = tmp + xc.to_s() + "\n"}
			return tmp
		end
		
		def self.loop_s():String
			tmp = ""
			return tmp if ((@@reg.length == 0) or !XCycle.loopCompleteBool())
			@@reg[0].cycle().each {|xc:XCycle| tmp = tmp + xc.to_s() + "\n"}
			return tmp
		end
		
		def self.elimTwoStrongLinks():ElimGroup
			unless XCycle.loopCompleteBool()
				puts "No Loop: " + XCycle.reg_s()
				return ElimGroup(nil)
			end
			strong = SuCell(nil)
			@@reg[0].cycle().each {|xc:XCycle| 
				next if xc.weakBool()
				next if (xc.ltStrongBool() and xc.rtStrongBool())
				strong = xc.ltc() if xc.ltStrongBool()
				strong = xc.rtc() if xc.rtStrongBool()
				break if strong != nil
			}
			return ElimGroup(nil) if strong == nil
			elim = ElimGroup.new()
			elim.addVal(@@val)
			@@cels.each {|c:SuCell|
				next if c == strong
				next unless strong.canSeeBool(c)
				elim.addCell(c)
			}
			return ElimGroup(nil) if elim.cells().length() == 0
			elim.setMsg("XCycle - Cell with 2 Strong Links: Value " + @@val + "\n" + XCycle.loop_s())
			return elim
		end
		
		def self.elimTwoWeakLinks():ElimGroup
			unless XCycle.loopCompleteBool()
				puts "No Loop: " + XCycle.reg_s()
				return ElimGroup(nil)
			end
			weak = SuCell(nil)
			@@reg[0].cycle().each {|xc:XCycle| 
				next if xc.strongBool()
				weak = xc.ltc() if xc.ltWeakBool()
				weak = xc.rtc() if xc.rtWeakBool()
				break if weak != nil
			}
			return ElimGroup(nil) if weak == nil
			elim = ElimGroup.new()
			elim.addVal(@@val)
			elim.addCell(weak)
			elim.setMsg("XCycle - Cell with 2 Weak Links: Value " + @@val + "\n" + XCycle.loop_s())
			return elim
		end
		
		def self.elimWeakLink():ElimGroup
			unless XCycle.loopCompleteBool()
				puts "No Loop: " + XCycle.reg_s()
				return ElimGroup(nil)
			end
			elim = ElimGroup.new()
			elim.addVal(@@val)
			@@reg[0].cycle().each {|xc:XCycle| 
				next unless xc.weakBool()
				@@cels.each {|tc| 
					next if tc == xc.ltc()
					next if tc == xc.rtc()
					next unless (tc.canSeeBool(xc.ltc()) and tc.canSeeBool(xc.rtc()))
					elim.addCell(tc)
				}
			}
			return ElimGroup(nil) if elim.cells().length() == 0
			elim.setMsg("XCycle - Cells Can See Both Ends of Weak Links: Value " + @@val + "\n" + XCycle.loop_s())
			return elim
		end
		
		def initialize(c1:SuCell, c2:SuCell, weak = false):void
			@ltc = c1
			@rtc = c2
			@ltx = XCycle(nil)
			@rtx = XCycle(nil)
			@weak = weak
		end
		
		def brc_s():String
			if @weak
				typ = "  Weak  "
			else
				typ = " Strong "
			end
			ltLnk = ""
			if hasLtxBool()
				tpl = "-S-"
				tpl = "-W-" if @ltx.weakBool() 
				ltLnk = "Lt: " + @ltx.ltc().brc_s() + tpl + @ltx.rtc().brc_s() + " "
			end
			rtLnk = ""
			if hasRtxBool()
				tpr = "-S-"
				tpr = "-W-" if @rtx.weakBool() 
				rtLnk = " Rt: " + @rtx.ltc().brc_s() + tpr + @rtx.rtc().brc_s()
			end
			return ltLnk + "Left: " + @ltc.brc_s() + typ  + "Right: " + @rtc.brc_s() + rtLnk
		end
		
		def to_s():String
			return ("Value: " + XCycle.value() + " " + brc_s())
		end
		
		def setWeak(weak:boolean):void
			@weak = weak
		end
		
		def weakBool():boolean
			return @weak
		end
		
		def strongBool():boolean
			return !@weak
		end
		
		def ltc():SuCell
			@ltc
		end
		
		def rtc():SuCell
			@rtc
		end
		
		def ltx():XCycle
			@ltx
		end
		
		def rtx():XCycle
			@rtx
		end
		
		def hasLtxBool():boolean
			@ltx != nil
		end
		
		def hasRtxBool():boolean
			@rtx != nil
		end
		
		def ltStrongBool():boolean
			return false unless hasLtxBool()
			return @ltx.strongBool()
		end
		
		def rtStrongBool():boolean
			return false unless hasRtxBool()
			return @rtx.strongBool()
		end
		
		def ltWeakBool():boolean
			return false unless hasLtxBool()
			return @ltx.weakBool()
		end
		
		def rtWeakBool():boolean
			return false unless hasRtxBool()
			return @rtx.weakBool()
		end
		
		def swap():void
			c1 = @rtc
			c2 = @ltc
			@ltc = c1
			@rtc = c2
		end
		
		def containsBool(c1:SuCell, c2 = SuCell(nil)):boolean
			if c2 == nil
				return ((c1 == @ltc) or (c1 == @rtc))
			else
				return (containsBool(c1) and containsBool(c2))
			end
		end
		
		def link():SuCell[]
			out = SuCell[2]; out[0] = @ltc; out[1] = @rtc
			return out
		end
		
		def val():int
			XCycle.value()
		end
		
		def connectLt(cyc:XCycle):void
			return if self == cyc
			return if cyc.containsBool(@ltc, @rtc)
			@ltx = cyc
		end
		
		def connectRt(cyc:XCycle):void
			return if self == cyc
			return if cyc.containsBool(@ltc, @rtc)
			@rtx = cyc
		end
		
		def cycle(first = XCycle(self)):XCycle[]
			out = ArrayList.new()
			out.add(self)
			return out.toArray(XCycle[0]) if (!hasRtxBool() or (@rtx == first))
			@rtx.cycle(first).each {|xc:XCycle| out.add(xc) }
			return out.toArray(XCycle[0])
		end
		
		def continueBool():boolean
			#console = Console(System.console())
			#rl = console.readLine("Continue? ")
			#return false if rl.equals("q")
			return true
		end
	end
	
	class Chain
		def self.init(cels:SuCell[], n:int):void
			@@reg = Chain[0]
			@@val = n
			@@bookmark = 0 - 1
			out = ArrayList.new()
			cels.each do |c:SuCell|
				next if c.setBool()
				next if (c.pmarks().length < 2)
				out.add(c) if Ops.containsBool(c.pmarks(), n)
			end
			@@cels = out.toArray(SuCell[0])
		end
		
		def self.cells():SuCell[]
			@@cels
		end
		
		def self.value():int
			@@val
		end
		
		def self.clear():void
			@@reg = Chain[0] # Look into changing this to a HashMap
		end
		
		def self.links():Chain[]
			return @@reg
		end
		
		def self.emptyBool():boolean
			return (@@reg.length == 0)
		end
		
		def self.toString():String
			out = "Chain: " + @@val + "\n"
			@@reg.each {|chn:Chain| out = out + chn.to_s() + "\n"}
			return out
		end
		
		def self.add(cel:SuCell):void
			out = Chain.get(cel)
			if out == nil
				chn = Chain.new(cel)
				reg = ArrayList.new()
				@@reg.each {|c:Chain| reg.add(c) }
				reg.add(chn)
				@@reg = reg.toArray(Chain[0])
				#puts "Chain Register Size: " + @@reg.length + " Val: " + @@val + " Cell At: " + cel if @@reg.length > 1
			end
		end
		
		def self.get(cel:String):Chain
			return Chain(nil) if Chain.emptyBool()
			out = Chain(nil)
			@@reg.each do |chn:Chain|
				break if out != nil
				next unless chn.brc_s().equals(cel)
				out = chn
			end
			return out
		end
		
		def self.get(cel:SuCell):Chain
			return Chain(nil) if Chain.emptyBool()
			out = Chain(nil)
			@@reg.each do |chn:Chain|
				break if out != nil
				next unless chn.cell() == cel
				out = chn
			end
			return out
		end
		
		def self.getCell(cel:String):SuCell
			return SuCell(nil) if (@@cels.length == 0)
			out = SuCell(nil)
			@@cels.each do |c:SuCell|
				break if out != nil
				next unless c.brc_s().equals(cel)
				out = c
			end
			return out
		end
		
		def self.findNextChain():boolean
			return false if @@bookmark >= @@cels.length
			Chain.clear()
			while (@@reg.length() < 3)
				@@bookmark = @@bookmark + 1
				Chain.clear()
				break if @@bookmark >= @@cels.length
				Chain.add(@@cels[@@bookmark])
				Chain.populate()
				Chain.colourChain(:red, :blue)
				#puts Chain.toString() if (@@reg.length() > 2)
			end
			return false if (@@reg.length() == 0)
			return true
		end
		
		def self.populate():void
			return if Chain.emptyBool()
			return if ((@@reg.length == 1) and (@@reg[0].nbrS().length == 0))
			while Chain.hasUnRegBool()
				@@reg.each do |chn:Chain|
					next unless chn.unRegNbrsBool()
					chn.nbrCells().each do |c:SuCell|
						Chain.add(c)
					end
				end
			end
		end
		
		def self.hasUnRegBool():boolean
			return false if Chain.emptyBool()
			out = false
			@@reg.each do |chn:Chain|
				next unless chn.unRegNbrsBool()
				out = true
				break
			end
			return out
		end
		
		def self.size():int
			return 0 if @@reg == nil
			return @@reg.length()
		end
		
		def self.inChainBool(cel:String):boolean
			return false if Chain.emptyBool()
			return true if (Chain.get(cel) != nil)
			return false
		end
		
		def self.inChainBool(cel:SuCell):boolean
			return false if Chain.emptyBool()
			return true if (Chain.get(cel) != nil)
			return false
		end
		
		def self.colouredBool(cel:String):boolean
			return false if Chain.emptyBool()
			x = Chain.get(cel)
			return x.colouredBool() unless x == nil
			return false
		end
		
		def self.colouredBool(cel:SuCell):boolean
			return false if Chain.emptyBool()
			x = Chain.get(cel)
			return x.colouredBool() unless x == nil
			return false
		end
		
		def self.conflictBool(cel:String):boolean
			return false if Chain.emptyBool()
			x = Chain.get(cel)
			return x.conflictBool() unless x == nil
			return false
		end
		
		def self.conflictBool(cel:SuCell):boolean
			return false if Chain.emptyBool()
			x = Chain.get(cel)
			return x.conflictBool() unless x == nil
			return false
		end
		
		def self.hasConflictsBool():boolean
			out = false
			@@reg.each {|chn:Chain| break if out; out = true if chn.conflictBool()}
			return out
		end
		
		def self.hasUncolouredBool():boolean
			out = false
			@@reg.each {|chn:Chain| break if out; out = true if !chn.colouredBool()}
			return out
		end
		
		def self.ends():Chain[]
			return Chain[0] if Chain.emptyBool()
			out = ArrayList.new()
			@@reg.each do |c:Chain|
				out.add(c) if c.chainEndBool()
			end
			return Chain[0] if out.size == 0
			return out.toArray(Chain[0])
		end
		
		def self.endsSeen(cel:SuCell):Chain[]
			return Chain[0] if (Chain.emptyBool() or (Chain.ends().length == 0))
			out = ArrayList.new()
			Chain.ends().each do |c:Chain|
				out.add(c) if cel.canSeeBool(c.cell())
			end
			return Chain[0] if out.size == 0
			return out.toArray(Chain[0])
		end
		
		def self.colourChain(clr1:String, clr2:String):void
			x = Chain.ends()
			x[0].followChain(clr1, clr2) if (x.length > 0)
		end
		
		def self.elimTwiceInUnit():ElimGroup
			if Chain.hasConflictsBool()
				puts "Colour Conflict in Chain"
				return ElimGroup(nil)
			end
			elim = ElimGroup.new()
			elim.addVal(@@val)
			elimColor = :none
			@@reg.each {|oc:Chain|
				break if !elimColor.equals(:none)
				@@reg.each {|ic:Chain|
					break if !elimColor.equals(:none)
					next unless ic != oc
					next unless oc.cell().canSeeBool(ic.cell())
					next unless oc.colour().equals(ic.colour())
					elimColor = oc.colour()
				}
			}
			unless elimColor.equals(:none)
				elim.msgAdd("Simple Coloring: " + Chain.value() + " Color Conflict: " + elimColor)
				@@reg.each {|chn:Chain|
					next unless chn.colouredBool()
					next unless chn.colour().equals(elimColor)
					next if chn.cell().eliminatedBool(Chain.value())
					elim.addCell(chn.cell())
					elim.msgAdd("elim by Color " + elimColor + " " + Chain.value() + " from " + chn.cell().to_s())
				}
			end
			return elim
		end
		
		def self.elimTwoColors(sameUnit = false):ElimGroup
			if Chain.hasConflictsBool()
				puts "Colour Conflict in Chain"
				return ElimGroup(nil)
			end
			elim = ElimGroup.new()
			elim.addVal(@@val)
			@@reg.length.times {|oci|
				break if elim.cells().length > 0
				oc = @@reg[oci]
				next unless oc.colouredBool()
				@@reg.length.times {|ici|
					break if elim.cells().length > 0
					next unless ici > oci
					ic = @@reg[ici]
					next unless ic.colouredBool()
					next if oc.colour().equals(ic.colour())
					@@cels.each {|c|
						next if Chain.inChainBool(c)
						next if c == oc.cell()
						next if c == ic.cell()
						if sameUnit
							next unless oc.cell().canSeeBool(ic.cell())
						end
						next unless c.canSeeBool(oc.cell())
						next unless c.canSeeBool(ic.cell())
						next if c.eliminatedBool(@@val)
						elim.addCell(c)
						su = ""
						su = " in the same unit" if sameUnit
						elim.msgAdd("Simple Coloring: Cell at: " + c.brc_s + " sees two different colors" + su + ".")
						elim.msgAdd(" Cell: " + oc.brc_s + " Color: " + oc.colour() + " and Cell: " + ic.brc_s + " Color: " + ic.colour())
					}
				}
			}
			return elim
		end
		
		def self.elimTwoColorsInUnit():ElimGroup
			return Chain.elimTwoColors(true)
		end
		
		def self.elimTwoColorsElsewhere():ElimGroup
			return Chain.elimTwoColors(false)
		end
		
		def initialize(cel:SuCell):void
			@cel = cel
			@colour = :none
			resetNeighbors()
			findNeighbors()
		end
		
		def validBool():boolean
			return Ops.containsBool(cell().pmarks(), val())
		end
		
		def brc():int[]
			@cel.brc()
		end
		
		def brc_s():String
			@cel.brc_s()
		end
		
		def to_s():String
			return ("Chain Value: " + Chain.value() + " Cell: " + @cel.to_s() + " Color: " + @colour + " End?: " + chainEndBool())
		end
		
		def cell():SuCell
#			out = SuCell(nil)
#			Chain.cells().each do |c:SuCell|
#				break unless out == nil
#				next unless c.brc_s().equals(@cel)
#				out = c
#			end
#			return out
			@cel
		end
		
		def val():int
			Chain.value()
		end
		
		$Override
		def equals(obj:Object):boolean
			begin
				chn = Chain(obj)
				#return (chn.brc_s().equals(@cel) and (chn.val() == val()))
				return ((chn.cell() == @cel) and (chn.val() == val()))
			rescue
				return false
			end
		end
		
		def colour():String
			@colour
		end
		
		def colouredBool():boolean
			!colour().equals(:none)
		end
		
		def conflictBool():boolean
			colour().equals(:conflict)
		end
		
		def thisColourBool(color:String):boolean
			colour().equals(color)
		end
		
		def setColour(color:String):void
			@colour = color
		end
		
		def resetColour():void
			@colour = :none
		end
		
		def resetNeighbors():void
			@boxNbr = SuCell(nil) # ""
			@rowNbr = SuCell(nil) # ""
			@colNbr = SuCell(nil) # ""
		end
		
		def nbrS():String[]
			out = ArrayList.new()
			out.add(@boxNbr.brc_s()) if boxNbrBool()
			out.add(@rowNbr.brc_s()) if rowNbrBool()
			out.add(@colNbr.brc_s()) if colNbrBool()
			return String[0] if out.size < 1
			return out.toArray(String[0])
		end
		
		def nbrCells():SuCell[]
			out = ArrayList.new()
			out.add(@boxNbr) if boxNbrBool()
			out.add(@rowNbr) if rowNbrBool()
			out.add(@colNbr) if colNbrBool()
			return SuCell[0] if out.size < 1
			return out.toArray(SuCell[0])
		end
		
		def boxNbr():Chain
			return Chain.get(@boxNbr) if boxNbrBool()
			return Chain(nil)
		end
		
		def rowNbr():Chain
			return Chain.get(@rowNbr) if rowNbrBool()
			return Chain(nil)
		end
		
		def colNbr():Chain
			return Chain.get(@colNbr) if colNbrBool()
			return Chain(nil)
		end
		
		def boxNbrBool():boolean
			return (@boxNbr != nil)
		end
		
		def rowNbrBool():boolean
			return (@rowNbr != nil)
		end
		
		def colNbrBool():boolean
			return (@colNbr != nil)
		end
		
		def boxNbrRegBool():boolean
			return (boxNbrBool() and Chain.inChainBool(@boxNbr))
		end
		
		def rowNbrRegBool():boolean
			return (rowNbrBool() and Chain.inChainBool(@rowNbr))
		end
		
		def colNbrRegBool():boolean
			return (colNbrBool() and Chain.inChainBool(@colNbr))
		end
		
		def boxNbrS():String
			@boxNbr.brc_s()
		end
		
		def rowNbrS():String
			@rowNbr.brc_s()
		end
		
		def colNbrS():String
			@colNbr.brc_s()
		end
		
		def countNeighbors():int
			return 0 unless validBool()
			cnt = 0
			cnt = cnt + 1 if boxNbrBool() # (@boxNbr.length != 0)
			cnt = cnt + 1 if rowNbrBool() # (@rowNbr.length != 0)
			cnt = cnt + 1 if colNbrBool() # (@colNbr.length != 0)
			return cnt
		end
		
		def countRegNeighbors():int
			return 0 unless validBool()
			cnt = 0
			cnt = cnt + 1 if boxNbrRegBool() # (@boxNbr.length != 0)
			cnt = cnt + 1 if rowNbrRegBool() # (@rowNbr.length != 0)
			cnt = cnt + 1 if colNbrRegBool() # (@colNbr.length != 0)
			return cnt
		end
		
		def unRegNbrsBool():boolean
			return false if (countNeighbors() == 0)
			return (countNeighbors() > countRegNeighbors())
		end
		
		def boxCells():String[]
			out = ArrayList.new()
			cels = Chain.cells()
			cels.length.times {|i|
				next if @cel == cels[i]
				next unless (cels[i].brc[0] == @cel.brc()[0])
				out.add(cels[i].brc_s())
			}
			return out.toArray(String[0])
		end
		
		def rowCells():String[]
			out = ArrayList.new()
			cels = Chain.cells()
			cels.length.times {|i|
				next if @cel == cels[i]
				next unless (cels[i].brc[1] == @cel.brc()[1])
				out.add(cels[i].brc_s())
			}
			return out.toArray(String[0])
		end
		
		def colCells():String[]
			out = ArrayList.new()
			cels = Chain.cells()
			cels.length.times {|i|
				next if @cel == cels[i]
				next unless (cels[i].brc[2] == @cel.brc()[2])
				out.add(cels[i].brc_s())
			}
			return out.toArray(String[0])
		end
		
		def findNeighbors():void
			ba = boxCells()
			ra = rowCells()
			ca = colCells()
#			puts to_s()
#			puts Ops.toString(ba) + " Length: " + ba.length
#			puts Ops.toString(ra) + " Length: " + ra.length
#			puts Ops.toString(ca) + " Length: " + ca.length
#			return unless continueBool()
			if ba.length == 1
				@boxNbr = Chain.getCell(ba[0])
			else
				@boxNbr = SuCell(nil)
			end
			if ra.length == 1
				@rowNbr = Chain.getCell(ra[0])
			else
				@rowNbr = SuCell(nil)
			end
			if ca.length == 1
				@colNbr = Chain.getCell(ca[0])
			else
				@colNbr = SuCell(nil)
			end
			if @boxNbr != nil
				(@rowNbr = SuCell(nil)) if @rowNbr == @boxNbr
				(@colNbr = SuCell(nil)) if @colNbr == @boxNbr
			end
		end
		
		def nbrColour():String
			test = String[3]
			if boxNbrBool()
				test[0] = boxNbr().colour()
			else
				test[0] = :none
			end
			if rowNbrBool()
				test[1] = rowNbr().colour()
			else
				test[1] = :none
			end
			if colNbrBool()
				test[2] = colNbr().colour()
			else
				test[2] = :none
			end
			out = :none
			test.each {|clr|
				if (out.equals(:none) and !clr.equals(:none))
					out = clr
				elsif (!out.equals(:none) and (!clr.equals(:none) and !out.equals(clr)))
					out = :conflict
				end
			}
			return out
		end
		
		def noChainBool():boolean
			return false unless validBool()
			return (countNeighbors() == 0)
		end
		
		def chainEndBool():boolean
			return false unless validBool()
			return (countNeighbors() == 1)
		end
		
		def followChain(clr1:String, clr2:String):void
			return if (colouredBool() or conflictBool())
			noFollow = false
			if chainEndBool()
				if nbrColour().equals(:none)
					@colour = clr1
					#puts "1st Chain End: " + val() + " " + @cel.brc_s() + " colored: " + clr1
				elsif nbrColour().equals(:conflict)
					puts "Chain End - Colour Conflict: " + val() + " Color: " + clr1 + " " + @cel.brc_s()
					noFollow = true
				elsif nbrColour().equals(clr1)
					@colour = clr2
					#puts "Chain End: " + val() + " " + @cel.brc_s() + " colored: " + clr2
				elsif nbrColour().equals(clr2)
					@colour = clr1
					#puts "Chain End: " + val() + " " + @cel.brc_s() + " colored: " + clr1
				else
					#puts "Chain End - Unknown Colour: " + val() + " Color: " + clr1 + " " + @cel.brc_s()
					noFollow = true
				end
			else
				if nbrColour().equals(:none)
					puts "Not Chain End - No Coloured Neighbors: " + val() + " " + cell().to_s()
					puts Chain.toString()
					noFollow = true
				elsif nbrColour().equals(:conflict)
					puts "Colour Conflict: " + val() + " Color: " + clr1 + " " + @cel.brc_s()
					noFollow = true
				elsif nbrColour().equals(clr1)
					@colour = clr2
					#puts "" + val() + " " + @cel.brc_s() + " colored: " + clr2
				elsif nbrColour().equals(clr2)
					@colour = clr1
					#puts "" + val() + " " + @cel.brc_s() + " colored: " + clr1
				else
					puts "Colour Conflict: " + val() + " Color: " + clr1 + " " + @cel.brc_s()
					noFollow = true
				end
			end
			followNbrs(clr2, clr1) unless noFollow
		end
		
		def followNbrs(clr1:String, clr2:String):void
			boxNbr().followChain(clr1, clr2) if boxNbrBool()
			rowNbr().followChain(clr1, clr2) if rowNbrBool()
			colNbr().followChain(clr1, clr2) if colNbrBool()
		end
		
		def continueBool():boolean
			#console = System.console()
			#rl = console.readLine("Continue? ")
			#return false if rl.equals("q")
			return true
		end
	end
	
	
end

