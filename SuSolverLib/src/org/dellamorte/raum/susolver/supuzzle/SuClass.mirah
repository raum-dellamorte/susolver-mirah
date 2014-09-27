/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package org.dellamorte.raum.susolver.supuzzle

/**
 *
 * @author Raum
 */
class SuClass 
	def size():int; end
	def to_s():String; end
	def colour(num:int):String; end
	def coloured?(num:int):boolean; end
	def thisColour?(num:int, color:String):boolean; end
	def setColour(num:int, color:String):void; end
	def resetColour(num:int):void; end
	def resetColours():void; end
	def guessing?():boolean; end
	def guessMode(mode:boolean):void; end
	def setToGuess():void; end
	def setCell(n:int, cel:SuClass):void; end
	def cells():SuClass[]; end
	def eliminate(num:int):void; end
	def eliminated?(num:int):boolean; end
	def canSee?(cel:SuClass):boolean; end
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
	def set?():boolean; end
	def gset?():boolean; end
	def canbe?(n:int):boolean; end
	def gcanbe?(n:int):boolean; end
	def canbe2?(n:int):boolean; end
	def gcanbe2?(n:int):boolean; end
	def onlyCell?(cel:SuClass, num:int):boolean; end
	def check():void; end
	def check2():void; end
	def gcheck():void; end
	def gcheck2():void; end
	def pmarks():int[]; end
	def gpmarks():int[]; end
	def broken?():boolean; end
	def gbroken?():boolean; end
	def complete?():boolean; end
	def gcomplete?():boolean; end
	def solved?():boolean; end
	def gsolved?():boolean; end
	def greset():void; end
	def canGuess?():boolean; end
	def nextGuess():void; end
	def conflict?(n:int):boolean; end
	def gconflict?(n:int):boolean; end
	def conflict2?(cel:SuClass, n:int):boolean; end
	def gconflict2?(cel:SuClass, n:int):boolean; end
end

