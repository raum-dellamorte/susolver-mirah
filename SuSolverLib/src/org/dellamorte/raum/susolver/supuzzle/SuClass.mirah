package org.dellamorte.raum.susolver.supuzzle

/**
 *
 * @author Raum
 */
class SuClass 
	def size():int; end
	def to_s():String; end
	def colour(num:int):String; end
	def colouredBool(num:int):boolean; end
	def thisColourBool(num:int, color:String):boolean; end
	def setColour(num:int, color:String):void; end
	def resetColour(num:int):void; end
	def resetColours():void; end
	def guessingBool():boolean; end
	def guessMode(mode:boolean):void; end
	def setToGuess():void; end
	def setCell(n:int, cel:SuClass):void; end
	def cells():SuClass[]; end
	def eliminate(num:int):void; end
	def eliminatedBool(num:int):boolean; end
	def canSeeBool(cel:SuClass):boolean; end
	def box(n:int):SuClass; end
	def row(n:int):SuClass; end
	def col(n:int):SuClass; end
	def box_id():int; end
	def box_id=(v:int):void; end
	def row_id():int; end
	def row_id=(v:int):void; end
	def col_id():int; end
	def col_id=(v:int):void; end
	def brow_id():int; end
	def bcol_id():int; end
	def val():int; end
	def gval():int; end
	def set(is:int):void; end
	def gset(n:int):void; end
	def setBool():boolean; end
	def gsetBool():boolean; end
	def canbeBool(n:int):boolean; end
	def gcanbeBool(n:int):boolean; end
	def canbe2Bool(n:int):boolean; end
	def gcanbe2Bool(n:int):boolean; end
	def onlyCellBool(cel:SuClass, num:int):boolean; end
	def check():void; end
	def check2():void; end
	def gcheck():void; end
	def gcheck2():void; end
	def pmarks():int[]; end
	def gpmarks():int[]; end
	def brokenBool():boolean; end
	def gbrokenBool():boolean; end
	def completeBool():boolean; end
	def gcompleteBool():boolean; end
	def solvedBool():boolean; end
	def gsolvedBool():boolean; end
	def greset():void; end
	def canGuessBool():boolean; end
	def nextGuess():void; end
	def conflictBool(n:int):boolean; end
	def gconflictBool(n:int):boolean; end
	def conflict2Bool(cel:SuClass, n:int):boolean; end
	def gconflict2Bool(cel:SuClass, n:int):boolean; end
end

