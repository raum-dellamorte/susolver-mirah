/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package org.dellamorte.raum.mirah.awtextra
import java.util.Enumeration
import java.awt.*


/**
 *
 * @author Raum
 */
class AbsoluteLayout implements LayoutManager2 #, java.io.Serializable
	def initialize()
		super
		@constraints = java::util::Hashtable.new()
	end
	
    def addLayoutComponent(name:String, comp:Component):void
        raise IllegalArgumentException.new()
    end
	
    def removeLayoutComponent(comp:Component):void
        @constraints.remove(comp)
    end
	
    def preferredLayoutSize(parent:Container):Dimension
        maxWidth = 0
        maxHeight = 0
        e = java::util::Enumeration(@constraints.keys())
		while e.hasMoreElements()
            comp = Component(e.nextElement())
            ac = AbsoluteConstraints(constraints.get(comp))
            size = Dimension(comp.getPreferredSize())
			
            width = int(ac.getWidth())
            width = size.width if (width == (0 - 1))
            height = int(ac.getHeight())
            height = size.height if (height == (0 - 1))
            maxWidth = (ac.x + width) if ((ac.x + width) > maxWidth)
            maxHeight = (ac.y + height) if ((ac.y + height) > maxHeight)
        end
        return Dimension.new(maxWidth, maxHeight)
    end
	
    def minimumLayoutSize(parent:Container):Dimension
        maxWidth = 0;
        maxHeight = 0;
        e = java::util::Enumeration(@constraints.keys())
		while e.hasMoreElements()
            comp = Component(e.nextElement())
            ac = AbsoluteConstraints(constraints.get(comp))
			size = Dimension(comp.getMinimumSize())
			
            width = int(ac.getWidth())
            width = size.width if (width == (0 - 1))
			
            height = int(ac.getHeight())
            height = size.height if (height == (0 - 1))
            maxWidth = (ac.x + width) if (ac.x + width > maxWidth)
            maxHeight = (ac.y + height) if (ac.y + height > maxHeight)
        end
        return Dimension.new(maxWidth, maxHeight);
    end
	
    def layoutContainer(parent:Container):void
        e = java::util::Enumeration(@constraints.keys())
		while e.hasMoreElements()
            comp = Component(e.nextElement())
            ac = AbsoluteConstraints(constraints.get(comp))
            size = Dimension(comp.getPreferredSize())
            width = int(ac.getWidth())
            width = size.width if (width == (0 - 1))
            height = int(ac.getHeight())
            height = size.height if (height == (0 - 1))
			
            comp.setBounds(ac.x, ac.y, width, height);
        end
    end
	
    def addLayoutComponent(comp:Component, constr:Object):void
        begin
			con = AbsoluteConstraints(constr)
		rescue
			raise IllegalArgumentException.new()
		end
        @constraints.put(comp, con)
    end
	
    def maximumLayoutSize(target:Container):Dimension
        return Dimension.new(Integer.MAX_VALUE, Integer.MAX_VALUE);
    end
	
    def getLayoutAlignmentX(target:Container):float
        return float(0.0)
    end
	
    def getLayoutAlignmentY(target:Container):float
        return float(0.0)
    end
	
    def invalidateLayout(target:Container):void; end
end

