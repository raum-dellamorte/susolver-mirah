/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package org.dellamorte.raum.susolver.supuzzle

import java.util.Arrays
import java.util.ArrayList
import java.io.Console

import Ops
import SuClass
import SuCell
import SuBlock

/**
 *
 * @author Raum
 */
class SuPuzzle < SuClass
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
				next if c.set?()
				next if (c.pmarks().length < 2)
				out.add(c) if Ops.contains?(c.pmarks(), n)
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
		
		def self.empty?():boolean
			return (@@reg.length == 0)
		end
		
		def self.toString():String
			out = "XCycle: " + @@val + "\n"
			@@reg.each {|cyc:XCycle| out = out + cyc.to_s() + "\n"}
			return out
		end
		
		def self.regContains?(c1:SuCell, c2:SuCell):boolean
			out = false
			@@reg.each {|c:XCycle|
				next unless c.contains?(c1, c2)
				out = true
				break
			}
			return out
		end
		
		def self.get(c1:SuCell, c2:SuCell):XCycle
			out = XCycle(nil)
			@@reg.each {|c:XCycle|
				next unless c.contains?(c1, c2)
				out = c
				break
			}
			return out
		end
		
		def self.add(c1:SuCell, c2:SuCell, weak = false):XCycle
			unless XCycle.regContains?(c1, c2)
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
			@@cels.length.times {|oci|
				@@cels.length.times {|ici|
					next unless ici > oci
					c1 = @@cels[oci]
					c2 = @@cels[ici]
					next unless c1.canSee?(SuClass(c2))
					test = false
					@@cels.length.times {|tci|
						next if tci == oci
						next if tci == ici
						tc = @@cels[tci]
						test = (tc.canSee?(SuClass(c1)) and tc.canSee?(SuClass(c2)))
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
				if xc.weak?()
					newreg.add(xc)
					next
				end
				next if (!xc.hasLtx?() and !xc.hasRtx?())
				newreg.add(xc)
			}
			@@reg = newreg.toArray(XCycle[0])
#			XCycle.connectWeakLinks()
			XCycle.connectStrongLinks()
			XCycle.connectDblWeak() unless XCycle.loopComplete?()
			newreg = ArrayList.new()
			@@reg.each {|xc:XCycle|
				next unless (xc.hasLtx?() and xc.hasRtx?())
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
				next if (ox.hasLtx?() and ox.hasRtx?())
				creg.length.times {|ixi|
					next unless ixi > oxi
					ix = creg[ixi]
					next if ox == ix
					next if ix.contains?(ox.ltc(), ox.rtc())
					if (!ox.hasLtx?() and !ix.contains?(ox.ltc()))
						ix.swap() if ((ox.ltc().canSee?(SuClass(ix.ltc()))) and (!ix.hasLtx?() and !ix.hasRtx?()))
						if ox.ltc().canSee?(SuClass(ix.rtc()))
							wk = XCycle.add(ix.rtc(), ox.ltc(), true)
							if wk.weak?()
								ix.connectRt(wk)
								wk.connectLt(ix)
								wk.connectRt(ox)
								ox.connectLt(wk)
							end
						end
					end
					if (!ox.hasRtx?() and !ix.contains?(ox.rtc()))
						ix.swap() if ((ox.rtc().canSee?(SuClass(ix.rtc()))) and (!ix.hasLtx?() and !ix.hasRtx?()))
						if ox.rtc().canSee?(SuClass(ix.ltc()))
							wk = XCycle.add(ox.rtc(), ix.ltc(), true)
							if wk.weak?()
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
				next if (ox.hasLtx?() and ox.hasRtx?())
				@@reg.length.times {|ixi|
					next unless ixi > oxi
					ix = @@reg[ixi]
					next if (ix.hasLtx?() and ix.hasRtx?())
					if (!ox.hasLtx?() and ix.contains?(ox.ltc()))
						if ox.ltc() == ix.rtc()
							ix.connectRt(ox)
							ox.connectLt(ix)
						end
					end
					if (!ox.hasRtx?() and ix.contains?(ox.rtc()))
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
				next if (ox.hasLtx?() and ox.hasRtx?())
				next if (!ox.hasLtx?() and !ox.hasRtx?())
				creg.length.times{|ixi| 
					next unless ixi > oxi
					ix = creg[ixi]
					next if (ix.hasLtx?() and ix.hasRtx?())
					next if (!ix.hasLtx?() and !ix.hasRtx?())
					next unless ((!ix.hasLtx?() and !ox.hasRtx?()) or (!ox.hasLtx?() and !ix.hasRtx?()))
					if (!ix.hasLtx?() and !ox.hasRtx?())
						c1 = ix.ltc()
						c2 = ox.rtc()
						x1 = ox
						x2 = ix
					elsif (!ox.hasLtx?() and !ix.hasRtx?())
						c1 = ox.ltc()
						c2 = ix.rtc()
						x1 = ix
						x2 = ox
					end
					@@cels.each {|tc|
						next if tc == c1
						next if tc == c2
						next unless (tc.canSee?(SuClass(c1)) and tc.canSee?(SuClass(c2)))
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
		
		def self.loopComplete?():boolean
			return false if @@reg.length < 3
			cnt = 0
			@@reg.each {|xc:XCycle| cnt = cnt + 1 if xc.strong?() }
			return false if cnt < 2
			tmp = @@reg[0].cycle()
			test = false
			tmp.each {|xc:XCycle| 
				next if (xc.hasLtx?() and xc.hasRtx?())
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
			return tmp if ((@@reg.length == 0) or !XCycle.loopComplete?())
			@@reg[0].cycle().each {|xc:XCycle| tmp = tmp + xc.to_s() + "\n"}
			return tmp
		end
		
		def self.elimTwoStrongLinks():ElimGroup
			unless XCycle.loopComplete?()
				puts "No Loop: " + XCycle.reg_s()
				return ElimGroup(nil)
			end
			strong = SuCell(nil)
			@@reg[0].cycle().each {|xc:XCycle| 
				next if xc.weak?()
				next if (xc.ltStrong?() and xc.rtStrong?())
				strong = xc.ltc() if xc.ltStrong?()
				strong = xc.rtc() if xc.rtStrong?()
				break if strong != nil
			}
			return ElimGroup(nil) if strong == nil
			elim = ElimGroup.new()
			elim.addVal(@@val)
			@@cels.each {|c:SuCell|
				next if c == strong
				next unless strong.canSee?(SuClass(c))
				elim.addCell(c)
			}
			return ElimGroup(nil) if elim.cells().length() == 0
			elim.setMsg("XCycle - Cell with 2 Strong Links: Value " + @@val + "\n" + XCycle.loop_s())
			return elim
		end
		
		def self.elimTwoWeakLinks():ElimGroup
			unless XCycle.loopComplete?()
				puts "No Loop: " + XCycle.reg_s()
				return ElimGroup(nil)
			end
			weak = SuCell(nil)
			@@reg[0].cycle().each {|xc:XCycle| 
				next if xc.strong?()
				weak = xc.ltc() if xc.ltWeak?()
				weak = xc.rtc() if xc.rtWeak?()
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
			unless XCycle.loopComplete?()
				puts "No Loop: " + XCycle.reg_s()
				return ElimGroup(nil)
			end
			elim = ElimGroup.new()
			elim.addVal(@@val)
			@@reg[0].cycle().each {|xc:XCycle| 
				next unless xc.weak?()
				@@cels.each {|tc| 
					next if tc == xc.ltc()
					next if tc == xc.rtc()
					next unless (tc.canSee?(SuClass(xc.ltc())) and tc.canSee?(SuClass(xc.rtc())))
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
			if hasLtx?()
				tpl = "-S-"
				tpl = "-W-" if @ltx.weak?() 
				ltLnk = "Lt: " + @ltx.ltc().brc_s() + tpl + @ltx.rtc().brc_s() + " "
			end
			rtLnk = ""
			if hasRtx?()
				tpr = "-S-"
				tpr = "-W-" if @rtx.weak?() 
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
		
		def weak?():boolean
			return @weak
		end
		
		def strong?():boolean
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
		
		def hasLtx?():boolean
			@ltx != nil
		end
		
		def hasRtx?():boolean
			@rtx != nil
		end
		
		def ltStrong?():boolean
			return false unless hasLtx?()
			return @ltx.strong?()
		end
		
		def rtStrong?():boolean
			return false unless hasRtx?()
			return @rtx.strong?()
		end
		
		def ltWeak?():boolean
			return false unless hasLtx?()
			return @ltx.weak?()
		end
		
		def rtWeak?():boolean
			return false unless hasRtx?()
			return @rtx.weak?()
		end
		
		def swap():void
			c1 = @rtc
			c2 = @ltc
			@ltc = c1
			@rtc = c2
		end
		
		def contains?(c1:SuCell, c2 = SuCell(nil)):boolean
			if c2 == nil
				return ((c1 == @ltc) or (c1 == @rtc))
			else
				return (contains?(c1) and contains?(c2))
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
			return if cyc.contains?(@ltc, @rtc)
			@ltx = cyc
		end
		
		def connectRt(cyc:XCycle):void
			return if self == cyc
			return if cyc.contains?(@ltc, @rtc)
			@rtx = cyc
		end
		
		def cycle(first = XCycle(self)):XCycle[]
			out = ArrayList.new()
			out.add(self)
			return out.toArray(XCycle[0]) if (!hasRtx?() or (@rtx == first))
			@rtx.cycle(first).each {|xc:XCycle| out.add(xc) }
			return out.toArray(XCycle[0])
		end
		
		def continue?():boolean
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
				next if c.set?()
				next if (c.pmarks().length < 2)
				out.add(c) if Ops.contains?(c.pmarks(), n)
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
		
		def self.empty?():boolean
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
			return Chain(nil) if Chain.empty?()
			out = Chain(nil)
			@@reg.each do |chn:Chain|
				break if out != nil
				next unless chn.brc_s().equals(cel)
				out = chn
			end
			return out
		end
		
		def self.get(cel:SuCell):Chain
			return Chain(nil) if Chain.empty?()
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
			return if Chain.empty?()
			return if ((@@reg.length == 1) and (@@reg[0].nbrS().length == 0))
			while Chain.hasUnReg?()
				@@reg.each do |chn:Chain|
					next unless chn.unRegNbrs?()
					chn.nbrCells().each do |c:SuCell|
						Chain.add(c)
					end
				end
			end
		end
		
		def self.hasUnReg?():boolean
			return false if Chain.empty?()
			out = false
			@@reg.each do |chn:Chain|
				next unless chn.unRegNbrs?()
				out = true
				break
			end
			return out
		end
		
		def self.size():int
			return 0 if @@reg == nil
			return @@reg.length()
		end
		
		def self.inChain?(cel:String):boolean
			return false if Chain.empty?()
			return true if (Chain.get(cel) != nil)
			return false
		end
		
		def self.inChain?(cel:SuCell):boolean
			return false if Chain.empty?()
			return true if (Chain.get(cel) != nil)
			return false
		end
		
		def self.coloured?(cel:String):boolean
			return false if Chain.empty?()
			x = Chain.get(cel)
			return x.coloured?() unless x == nil
			return false
		end
		
		def self.coloured?(cel:SuCell):boolean
			return false if Chain.empty?()
			x = Chain.get(cel)
			return x.coloured?() unless x == nil
			return false
		end
		
		def self.conflict?(cel:String):boolean
			return false if Chain.empty?()
			x = Chain.get(cel)
			return x.conflict?() unless x == nil
			return false
		end
		
		def self.conflict?(cel:SuCell):boolean
			return false if Chain.empty?()
			x = Chain.get(cel)
			return x.conflict?() unless x == nil
			return false
		end
		
		def self.hasConflicts?():boolean
			out = false
			@@reg.each {|chn:Chain| break if out; out = true if chn.conflict?()}
			return out
		end
		
		def self.hasUncoloured?():boolean
			out = false
			@@reg.each {|chn:Chain| break if out; out = true if !chn.coloured?()}
			return out
		end
		
		def self.ends():Chain[]
			return Chain[0] if Chain.empty?()
			out = ArrayList.new()
			@@reg.each do |c:Chain|
				out.add(c) if c.chainEnd?()
			end
			return Chain[0] if out.size == 0
			return out.toArray(Chain[0])
		end
		
		def self.endsSeen(cel:SuCell):Chain[]
			return Chain[0] if (Chain.empty?() or (Chain.ends().length == 0))
			out = ArrayList.new()
			Chain.ends().each do |c:Chain|
				out.add(c) if cel.canSee?(SuClass(c.cell()))
			end
			return Chain[0] if out.size == 0
			return out.toArray(Chain[0])
		end
		
		def self.colourChain(clr1:String, clr2:String):void
			x = Chain.ends()
			x[0].followChain(clr1, clr2) if (x.length > 0)
		end
		
		def self.elimTwiceInUnit():ElimGroup
			if Chain.hasConflicts?()
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
					next unless oc.cell().canSee?(SuClass(ic.cell()))
					next unless oc.colour().equals(ic.colour())
					elimColor = oc.colour()
				}
			}
			unless elimColor.equals(:none)
				elim.msgAdd("Simple Coloring: " + Chain.value() + " Color Conflict: " + elimColor)
				@@reg.each {|chn:Chain|
					next unless chn.coloured?()
					next unless chn.colour().equals(elimColor)
					next if chn.cell().eliminated?(Chain.value())
					elim.addCell(chn.cell())
					elim.msgAdd("elim by Color " + elimColor + " " + Chain.value() + " from " + chn.cell().to_s())
				}
			end
			return elim
		end
		
		def self.elimTwoColors(sameUnit = false):ElimGroup
			if Chain.hasConflicts?()
				puts "Colour Conflict in Chain"
				return ElimGroup(nil)
			end
			elim = ElimGroup.new()
			elim.addVal(@@val)
			@@reg.length.times {|oci|
				break if elim.cells().length > 0
				oc = @@reg[oci]
				next unless oc.coloured?()
				@@reg.length.times {|ici|
					break if elim.cells().length > 0
					next unless ici > oci
					ic = @@reg[ici]
					next unless ic.coloured?()
					next if oc.colour().equals(ic.colour())
					@@cels.each {|c|
						next if Chain.inChain?(c)
						next if c == oc.cell()
						next if c == ic.cell()
						if sameUnit
							next unless oc.cell().canSee?(SuClass(ic.cell()))
						end
						next unless c.canSee?(SuClass(oc.cell()))
						next unless c.canSee?(SuClass(ic.cell()))
						next if c.eliminated?(@@val)
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
		
		def valid?():boolean
			return Ops.contains?(cell().pmarks(), val())
		end
		
		def brc():int[]
			@cel.brc()
		end
		
		def brc_s():String
			@cel.brc_s()
		end
		
		def to_s():String
			return ("Chain Value: " + Chain.value() + " Cell: " + @cel.to_s() + " Color: " + @colour + " End?: " + chainEnd?())
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
		
		def coloured?():boolean
			!colour().equals(:none)
		end
		
		def conflict?():boolean
			colour().equals(:conflict)
		end
		
		def thisColour?(color:String):boolean
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
			out.add(@boxNbr.brc_s()) if boxNbr?()
			out.add(@rowNbr.brc_s()) if rowNbr?()
			out.add(@colNbr.brc_s()) if colNbr?()
			return String[0] if out.size < 1
			return out.toArray(String[0])
		end
		
		def nbrCells():SuCell[]
			out = ArrayList.new()
			out.add(@boxNbr) if boxNbr?()
			out.add(@rowNbr) if rowNbr?()
			out.add(@colNbr) if colNbr?()
			return SuCell[0] if out.size < 1
			return out.toArray(SuCell[0])
		end
		
		def boxNbr():Chain
			return Chain.get(@boxNbr) if boxNbr?()
			return Chain(nil)
		end
		
		def rowNbr():Chain
			return Chain.get(@rowNbr) if rowNbr?()
			return Chain(nil)
		end
		
		def colNbr():Chain
			return Chain.get(@colNbr) if colNbr?()
			return Chain(nil)
		end
		
		def boxNbr?():boolean
			return (@boxNbr != nil)
		end
		
		def rowNbr?():boolean
			return (@rowNbr != nil)
		end
		
		def colNbr?():boolean
			return (@colNbr != nil)
		end
		
		def boxNbrReg?():boolean
			return (boxNbr?() and Chain.inChain?(@boxNbr))
		end
		
		def rowNbrReg?():boolean
			return (rowNbr?() and Chain.inChain?(@rowNbr))
		end
		
		def colNbrReg?():boolean
			return (colNbr?() and Chain.inChain?(@colNbr))
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
			return 0 unless valid?()
			cnt = 0
			cnt = cnt + 1 if boxNbr?() # (@boxNbr.length != 0)
			cnt = cnt + 1 if rowNbr?() # (@rowNbr.length != 0)
			cnt = cnt + 1 if colNbr?() # (@colNbr.length != 0)
			return cnt
		end
		
		def countRegNeighbors():int
			return 0 unless valid?()
			cnt = 0
			cnt = cnt + 1 if boxNbrReg?() # (@boxNbr.length != 0)
			cnt = cnt + 1 if rowNbrReg?() # (@rowNbr.length != 0)
			cnt = cnt + 1 if colNbrReg?() # (@colNbr.length != 0)
			return cnt
		end
		
		def unRegNbrs?():boolean
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
#			puts Arrays.toString(ba) + " Length: " + ba.length
#			puts Arrays.toString(ra) + " Length: " + ra.length
#			puts Arrays.toString(ca) + " Length: " + ca.length
#			return unless continue?()
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
			if boxNbr?()
				test[0] = boxNbr().colour()
			else
				test[0] = :none
			end
			if rowNbr?()
				test[1] = rowNbr().colour()
			else
				test[1] = :none
			end
			if colNbr?()
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
		
		def noChain?():boolean
			return false unless valid?()
			return (countNeighbors() == 0)
		end
		
		def chainEnd?():boolean
			return false unless valid?()
			return (countNeighbors() == 1)
		end
		
		def followChain(clr1:String, clr2:String):void
			return if (coloured?() or conflict?())
			noFollow = false
			if chainEnd?()
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
			boxNbr().followChain(clr1, clr2) if boxNbr?()
			rowNbr().followChain(clr1, clr2) if rowNbr?()
			colNbr().followChain(clr1, clr2) if colNbr?()
		end
		
		def continue?():boolean
			#console = System.console()
			#rl = console.readLine("Continue? ")
			#return false if rl.equals("q")
			return true
		end
	end
	
	def initialize(syze:int):void
		@size = syze
		@cells = SuCell[Ops.pow(@size, 4)]
		@sorted = int[Ops.pow(@size, 4)]
		Ops.pow(@size, 4).times {|n| 
			@cells[n] = SuCell.new(SuClass(self))
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
		return SuCell.new(SuClass(self))
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
		tmp = String[].cast(cstr.replaceAll("[^0-9 ]", "").replaceAll("  +"," ").split(" "))
		return unless (tmp.length == sz)
		test = true
		n = Ops.pow(@size, 2)
		tmp.each do |s:String|
			next unless test
			i = Integer.parseInt(s)
			test = ((i > (-1)) and (i <= n))
		end
		return unless test
		itmp = int[sz]
		sz.times do |i:int|
			itmp[i] = Integer.parseInt(tmp[i])
		end
		setCells(itmp)
	end
	
	def setCells(ns:int[]):void
		Ops.pow(@size, 4).times {|i| @cells[i].set(ns[i]) } if ns.length == Ops.pow(@size, 4)
	end
	
	def setRow(n:int, ns:int[]):void
		Ops.pow(@size, 2).times {|i| @cells[i + (Ops.pow(@size, 2) * (n - 1))].set(ns[i]) } if ns.length == Ops.pow(@size, 2)
	end
	
	def print():void
		return if @guiMode
		puts pmarks_s() unless solved?()
		puts to_s()
	end
	
	def gprint():void
		return if @guiMode
		puts g_to_s()
	end
	
	def to_s():String
		s = ""
		s = s + "Fail\n" if broken?()
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
		s = s + "Fail\n" if broken?()
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
			blk.cells().length.times {|c| s = s +  blk.cells[c].to_s + "\n" if !blk.cells[c].set?() }
		}
		return s
	end
	
	def gpmarks_s():String
		s = ""
		Ops.pow(@size, 2).times {|b|
			blk = box(b + 1)
			blk.cells.length.times {|c| s = s + blk.cells[c].to_s + "\n" if !blk.cells[c].set?() }
		}
		return s
	end
	
	def block(g:String, n:int):SuBlock
		out = SuBlock.new(SuClass(self), g)
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
		grp.length.times {|n| SuBlock(out).setCell(n + 1, SuClass(grp[n]))}
		out
	end
	
	def box(n:int):SuClass
		SuClass(block(:box, n))
	end
	
	def row(n:int):SuClass
		SuClass(block(:row, n))
	end
	
	def col(n:int):SuClass
		SuClass(block(:col, n))
	end
	
	def setGuiMode(tf:boolean):void
		@guiMode = tf
	end
	
	def guiMode?():boolean
		@guiMode
	end
	
	def setGuessMode(tf:boolean):void
		@guessMode = tf
	end
	
	def guessMode?():boolean
		@guessMode
	end
	
	def solve():void # note to self. don't try to solve if there are no clues.
		puts to_s() unless guiMode?()
		basicCheck()
		unless solved?()
			print()
			autoCheck()
		end
		if (@guessMode and !(solved?() or broken?()))
			print()
			puts "Guessing..." unless guiMode?()
			guessCheck()
		end
		print()
	end
	
	def autoCheck():void
		i = 0
		until (solved?() or broken?())
			if checkStep(i)
				i = i + 1 unless broken?()
			else
				i = 0 unless broken?()
			end
			break if ((i >= @stepMax) or broken?())
		end
		puts "Broken By: " + i if broken?()
	end
	
	def stepCheck():void
		return if (solved?() or broken?())
		s1 = pmarks_s + to_s
		unless (solved?() or broken?())
			if checkStep(@step)
				@step = @step + 1 unless broken?()
			else
				@step = 0 unless broken?()
			end
		end
		s2 = pmarks_s + to_s
		stepCheck() if ((@step < @stepMax) and (s2.equals(s1) and (!solved?() and !broken?())))
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
						next if ic.set?()
						next unless ic.canbe?(n)
						elimGrp.add(ic) if ic.canSee?(SuClass(oc))
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
			next if c.set?()
			9.times do |i|
				n = i + 1
				if (box(c.box_id()).onlyCell?(SuClass(c), n) or (row(c.row_id()).onlyCell?(SuClass(c), n) or col(c.col_id()).onlyCell?(SuClass(c), n)))
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
				next unless c1.canSee?(SuClass(c2))
				next unless c2.pmarks().length == 2
				next unless Ops.union(c1.pmarks(), c2.pmarks()).length == 2
				elimGrp = ArrayList.new()
				@cells.each do |c:SuCell|
					next if c == c1
					next if c == c2
					next unless (c.canSee?(SuClass(c1)) and c.canSee?(SuClass(c2)))
					elimGrp.add(c)
				end
				na = c1.pmarks()
				cellElim(na, elimGrp.toArray(SuCell[0]), "Naked Pair: " + Arrays.toString(na)) if elimGrp.size > 0
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
					next if ((gflag and cels[oc].gset?()) or cels[oc].set?())
					if gflag
						ocr = cels[oc].gpmarks()
					else
						ocr = cels[oc].pmarks()
					end
					next unless ((ocr.length <= (Ops.pow(@size, 2) - 2)) and (ocr.length > 1))
					exclude = int[1]
					exclude[0] = oc
					cels.length.times {|ic|
						next if ((oc == ic) or ((gflag and cels[ic].gset?()) or cels[ic].set?()))
						if gflag
							icr = cels[ic].gpmarks()
						else
							icr = cels[ic].pmarks()
						end
						next unless ((icr.length > 1) and Ops.isSubset?(ocr, icr))
						exclude = Ops.appendUniq(exclude, ic)
					}
					next unless ((exclude.length > 1) and (ocr.length == exclude.length))
					ocr.length.times {|i|
						brcElim(brcs[ibrc], (brci + 1), ocr[i], exclude, "Naked Group: " + Arrays.toString(ocr), gflag)
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
					next if ((gflag and cels[c].gset?()) or cels[c].set?)
					next unless Ops.contains?(cels[c].pmarks(), num)
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
								next unless (((!cels1[oc].set?() and Ops.contains?(cels1[oc].pmarks(), num)) and (!cels1[ic].set?() and Ops.contains?(cels1[ic].pmarks(), num))) and 
										((!cels2[oc].set?() and Ops.contains?(cels2[oc].pmarks(), num)) and (!cels2[ic].set?() and Ops.contains?(cels2[ic].pmarks(), num))))
								#puts "Found Square r" + orc + "" + irc + "c" + (oc + 1) + "" + (ic + 1) + " num " + num
								test = true
								Ops.pow(@size, 2).times {|icol|
									next unless test
									next unless ((icol != oc) and (icol != ic))
									next unless ((!cels1[icol].set?() and Ops.contains?(cels1[icol].pmarks(), num)) or (!cels2[icol].set?() and Ops.contains?(cels2[icol].pmarks(), num)))
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
					next if (cels[c1].set?() or (cels[c2].set?() or cels[c3].set?()))
					next if ((((cels[c1].row_id == cels[c2].row_id) and (cels[c2].row_id == cels[c3].row_id)) or 
								((cels[c1].col_id == cels[c2].col_id) and (cels[c2].col_id == cels[c3].col_id))) or 
								((cels[c1].box_id == cels[c2].box_id) and (cels[c2].box_id == cels[c3].box_id)))
					next if (Ops.aEquals?(cels[c1].pmarks(), cels[c2].pmarks()) or 
							(Ops.aEquals?(cels[c1].pmarks(), cels[c3].pmarks()) or 
							Ops.aEquals?(cels[c2].pmarks(), cels[c3].pmarks())))
					#puts "Made it this far"
					#puts "c1: " + cels[c1].to_s
					#puts "c2: " + cels[c2].to_s
					#puts "c3: " + cels[c3].to_s
					if (cels[c1].canSee?(SuClass(cels[c2])) and (cels[c1].canSee?(SuClass(cels[c3])) and !cels[c2].canSee?(SuClass(cels[c3]))))
						# Hinge at c1
						u = Ops.union(cels[c2].pmarks(), cels[c3].pmarks())
						next if u.length == 0
						num = u[0]
						hinge = c1
						wing1 = c2
						wing2 = c3
					elsif (cels[c2].canSee?(SuClass(cels[c1])) and (cels[c2].canSee?(SuClass(cels[c3])) and !cels[c1].canSee?(SuClass(cels[c3]))))
						# Hinge at c2
						u = Ops.union(cels[c1].pmarks(), cels[c3].pmarks())
						next if u.length == 0
						num = u[0]
						hinge = c2
						wing1 = c1
						wing2 = c3
					elsif (cels[c3].canSee?(SuClass(cels[c1])) and (cels[c3].canSee?(SuClass(cels[c2])) and !cels[c1].canSee?(SuClass(cels[c2]))))
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
						next if @cells[ic].set?()
						s = @cells[ic].to_s
						next if (((@cells[ic] == cels[hinge]) or (@cells[ic] == cels[wing1])) or (@cells[ic] == cels[wing2]))
						next unless (@cells[ic].canSee?(SuClass(cels[wing1])) and @cells[ic].canSee?(SuClass(cels[wing2])))
						next if @cells[ic].eliminated?(num)
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
										crefs.each {|cn| cnt = cnt + 1 if (!cels1[cn].set?() and Ops.contains?(cels1[cn].pmarks(), num)) }
										next unless cnt >= 2
										cnt = 0
										crefs.each {|cn| cnt = cnt + 1 if (!cels2[cn].set?() and Ops.contains?(cels2[cn].pmarks(), num)) }
										next unless cnt >= 2
										cnt = 0
										crefs.each {|cn| cnt = cnt + 1 if (!cels3[cn].set?() and Ops.contains?(cels3[cn].pmarks(), num)) }
										next unless cnt >= 2
										#puts "Found Square r" + rc1 + "" + rc2 + "c" + (oc + 1) + "" + (ic + 1) + " num " + num
										cnt = 0
										crefs.each {|cn|
											icnt = 0
											icnt = icnt + 1 if (!cels1[cn].set?() and Ops.contains?(cels1[cn].pmarks(), num))
											icnt = icnt + 1 if (!cels2[cn].set?() and Ops.contains?(cels2[cn].pmarks(), num))
											icnt = icnt + 1 if (!cels3[cn].set?() and Ops.contains?(cels3[cn].pmarks(), num))
											cnt = cnt + 1 if (icnt >= 2)
										}
										next unless cnt == 3
										cnt = 0
										Ops.pow(@size, 2).times {|cn|
											next if cnt > 0
											next if Ops.contains?(crefs, cn)
											cnt = cnt + 1 if (!cels1[cn].set?() and Ops.contains?(cels1[cn].pmarks(), num))
											cnt = cnt + 1 if (!cels2[cn].set?() and Ops.contains?(cels2[cn].pmarks(), num))
											cnt = cnt + 1 if (!cels3[cn].set?() and Ops.contains?(cels3[cn].pmarks(), num))
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
										brcElim(rcs, c1 + 1, num, excluded, "Swordfish: " + num + " r" + Arrays.toString(sfrows) + "c" + Arrays.toString(sfcols), gflag)
										brcElim(rcs, c2 + 1, num, excluded, "Swordfish: " + num + " r" + Arrays.toString(sfrows) + "c" + Arrays.toString(sfcols), gflag)
										brcElim(rcs, c3 + 1, num, excluded, "Swordfish: " + num + " r" + Arrays.toString(sfrows) + "c" + Arrays.toString(sfcols), gflag)
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
			if XCycle.loopComplete?()
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
		return if gbroken?()
		#gcheck()
		#remainSort()
		#puts "Fail" unless guesser(0)
	end
	
	def guesser(c:int):boolean
		return guesser(c + 1) if @cells[@sorted[c]].set?()
		#gcheck(c, true)
		if @cells[@sorted[c]].gset?() # @sorted[c]
			if (gsolved?() or (((c + 1) < @cells.length) and guesser(c + 1)))
				@cells.length.times {|ic| @cells[@sorted[ic]].setToGuess() if (ic >= c) } unless @guessFail
				return true
			end
			@cells.length.times {|ic| @cells[@sorted[ic]].greset() if (ic >= c) }
			return false
		end
		while @cells[@sorted[c]].canGuess?()
			@cells.length.times {|ic| @cells[@sorted[ic]].greset() if (ic > c) }
			@cells[@sorted[c]].nextGuess()
			gcheck(c + 1, true)
			#gcheck2(c + 1, true)
			if gsolved?()
				@cells.length.times {|ic| @cells[@sorted[ic]].setToGuess() if (ic >= c) }
				return true
			end
			#(puts c; @guessFail = !continue?()) if c < 9 # if ((c >= (Ops.pow(@size, 2) * (Ops.pow(@size, 2) - 1))) and ((c % Ops.pow(@size, 2)) == 0))
			#return true if @guessFail
			if !gbroken?()
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
	
	def continue?():boolean
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
						if ((!used[c]) and (((l == 1) and @cells[c].set?()) or ((l > 1) and (@cells[c].pmarks().length == l))))
							@sorted[i] = c
							used[c] = true
							i = i + 1
						end
					end
				}
			end
		}
		#puts Arrays.toString(@sorted)
	end
	
	def twoRemain():SuCell[]
		out = SuCell[@cells.length]
		n = 0
		@cells.length.times {|c|
			next unless (!@cells[c].set?() and (@cells[c].pmarks().length == 2))
			out[n] = @cells[c]
			n = n + 1
		}
		return SuCell[0] if n == 0
		return SuCell[].cast(Arrays.copyOfRange(Object[].cast(out), 0, n))
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
			next unless (!Ops.contains?(exclude, c) and !cels[c].set?())
			next if cels[c].eliminated?(num)
			cnt = cnt + 1
		}
		puts message if (@verbose and (cnt > 0))
		cels.length.times {|c|
			next unless (!Ops.contains?(exclude, c) and !cels[c].set?())
			next if cels[c].eliminated?(num)
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
				next if c.set?()
				next if c.eliminated?(n)
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
#				if (box(c.box_id()).onlyCell?(c, n) or (row(c.row_id()).onlyCell?(c, n) or col(c.col_id()).onlyCell?(c, n)))
#					c.set(n)
#					msg = msg + "\n" + "Cell at " + c.brc_s + " is the only cell in it's row, col, or box that can be " + n + ". Set."
#				end
#			end
#		}
		puts msg if (@verbose and (cnt > 0))
		#print()
	end
	
	def solved?():boolean
		out = true
		Ops.pow(@size, 2).times {|n| 
			out = box(n + 1).solved?() if out
			out = row(n + 1).solved?() if out
			out = col(n + 1).solved?() if out
		}
		out
	end
	
	def gsolved?():boolean
		out = true
		Ops.pow(@size, 2).times {|n| 
			out = box(n + 1).gsolved?() if out
			out = row(n + 1).gsolved?() if out
			out = col(n + 1).gsolved?() if out
		}
		out
	end
	
	def complete?():boolean
		out = true
		Ops.pow(@size, 2).times {|n| 
			out = box(n + 1).complete?() if out
			out = row(n + 1).complete?() if out
			out = col(n + 1).complete?() if out
		}
		out
	end
	
	def gcomplete?():boolean
		out = true
		Ops.pow(@size, 2).times {|n| 
			out = box(n + 1).gcomplete?() if out
			out = row(n + 1).gcomplete?() if out
			out = col(n + 1).gcomplete?() if out
		}
		out
	end
	
	def broken?():boolean
		out = true
		Ops.pow(@size, 2).times {|n| 
			out = !box(n + 1).broken?() if out
			out = !row(n + 1).broken?() if out
			out = !col(n + 1).broken?() if out
		}
		!out
	end
	
	def gbroken?():boolean
		out = true
		Ops.pow(@size, 2).times {|n| 
			out = !box(n + 1).gbroken?() if out
			out = !row(n + 1).gbroken?() if out
			out = !col(n + 1).gbroken?() if out
		}
		!out
	end
end

