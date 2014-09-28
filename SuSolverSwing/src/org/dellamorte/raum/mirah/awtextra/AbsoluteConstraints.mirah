/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package org.dellamorte.raum.mirah.awtextra
import java.awt.Dimension
import java.awt.Point


/**
 *
 * @author Raum
 */
class AbsoluteConstraints # implements java.io.Serializable
#	/** generated Serialized Version UID */
#	static final long serialVersionUID = 5261460716622152494L;
	def initialize():void
		@width = (0 - 1)
		@height = (0 - 1)
		@x = 0
		@y = 0
	end
	
	def initialize(pos:Point):void
		@width = (0 - 1)
		@height = (0 - 1)
		@x = pos.x
		@y = pos.y
	end
	
	def initialize(x:int, y:int):void
		@width = (0 - 1)
		@height = (0 - 1)
		@x = x
		@y = y
	end
	
	def initialize(pos:Point, size:Dimension):void
		@width = (0 - 1)
		@height = (0 - 1)
		@x = pos.x
		@y = pos.y
		if (size != nil)
			@width = size.width
			@height = size.height
		end
	end
	
	def initialize(x:int, y:int, width:int, height:int):void
		@x = x
		@y = y
		@width = width
		@height = height
	end
	
	def x():int
		return @x
	end
	
	def y():int
		return @y
	end
	
	def getX():int
		return x
	end
	
	def getY():int
		return y
	end
	
	def getWidth():int
		return @width
	end
	
	def getHeight():int
		return @height
	end

#	def toString():String
#		return super.toString () +" [x="+x+", y="+y+", width="+width+", height="+height+"]"
#	end

end

