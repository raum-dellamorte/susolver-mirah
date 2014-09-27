package org.dellamorte.raum.susolver.supuzzle
import java.util.Arrays
import java.util.ArrayList
import java.io.Console

import Ops
import SuClass
import SuCell
import SuBlock
import SuPuzzle

macro def _a(type:SimpleString, args:Array)
	result = NodeList.new(args.position)
	ray = quote {`gensym`}
	q = NodeList(quote {
		____temp = Integer[`NodeList(args.values).size`]
		____temp[0] = Integer.new(1)
	})
	assign = Call(LocalAssignment(q.get(0)).value)
	assign.target = type
	result.add(UnquoteAssign.new(ray, Node(assign)))
	elassign = ElemAssign(q.get(1))
	elassign.target = ray
	i = 0
	NodeList(args.values).each {|v|
		NodeList(elassign.args).set(0, Fixnum.new(i))
		elassign.value = if ("" + SimpleString(type)).equals("" + SimpleString.new(:Integer))
			NodeList.new.add(quote {Integer.new(`v`)})
		else
			Cast.new(TypeName(type), Node(v))
		end
		result.add(elassign)
		i = i + 1
	}
	result.add(ray)
	result
end


x1 = SuPuzzle.new(3)
x2 = SuPuzzle.new(3)
x3 = SuPuzzle.new(3)
x4 = SuPuzzle.new(3)
x5 = SuPuzzle.new(3)

#x.setCells("	0,0,0, 0,0,0, 0,0,0,
#				0,0,0, 0,0,0, 0,0,0,
#				0,0,0, 0,0,0, 0,0,0,
#				
#				0,0,0, 0,0,0, 0,0,0,
#				0,0,0, 0,0,0, 0,0,0,
#				0,0,0, 0,0,0, 0,0,0,
#				
#				0,0,0, 0,0,0, 0,0,0,
#				0,0,0, 0,0,0, 0,0,0,
#				0,0,0, 0,0,0, 0,0,0")
#x.solve()


puts "hard"
x1.setCells("	0 0 0  5 0 0  0 0 2 
				1 7 0  4 0 6  5 0 0 
				5 0 0  7 9 0  0 0 0 
				
				0 3 0  0 0 0  2 0 0 
				0 0 4  0 2 0  1 0 0 
				0 0 6  0 0 0  0 9 0 
				
				0 0 0  0 1 8  0 0 6 
				0 0 8  6 0 4  0 2 1 
				4 0 0  0 0 9  0 0 0")
x1.solve()

puts "evil"
x2.setCells("	3 0 0  0 9 0  0 0 8 
				0 0 0  7 0 0  0 9 0 
				0 0 4  0 8 6  0 0 0 
				
				0 0 6  0 0 0  0 2 0 
				0 9 0  1 3 5  0 7 0 
				0 5 0  0 0 0  9 0 0 
				
				0 0 0  9 2 0  1 0 0 
				0 6 0  0 0 3  0 0 0 
				5 0 0  0 1 0  0 0 9")
x2.solve()

puts "X-Wing"
x3.setCells("	0 9 3  0 0 4  5 6 0 
				0 6 0  0 0 3  1 4 0 
				0 0 4  6 0 8  3 0 9 
				
				9 8 1  3 4 5  0 0 0 
				3 4 7  2 8 6  9 5 1 
				6 5 2  0 7 0  4 8 3 
				
				4 0 6  0 0 2  8 9 0 
				0 0 0  4 0 0  0 1 0 
				0 2 9  8 0 0  0 3 4")
x3.solve()

puts "Hard 17 Clue"
x4.setCells("	0 0 2  0 9 0  3 0 0 
				8 0 5  0 0 0  0 0 0 
				1 0 0  0 0 0  0 0 0 
				
				0 9 0  0 6 0  0 4 0 
				0 0 0  0 0 0  0 5 8 
				0 0 0  0 0 0  0 0 1 
				
				0 7 0  0 0 0  2 0 0 
				3 0 0  5 0 0  0 0 0 
				0 0 0  1 0 0  0 0 0")
x4.solve()

puts "Expert from Windows Phone"
x5.setCells("	2 0 0  0 0 3  0 6 8 
				0 9 5  0 8 6  7 0 2 
				6 0 0  0 0 7  0 0 0 
				
				9 0 2  0 4 5  3 8 6 
				8 5 6  0 3 0  4 1 0 
				0 4 3  8 6 0  2 0 5 
				
				0 0 0  5 9 0  6 2 0 
				4 6 9  3 0 0  8 5 0 
				5 2 0  6 0 0  0 0 0")
x5.solve()
