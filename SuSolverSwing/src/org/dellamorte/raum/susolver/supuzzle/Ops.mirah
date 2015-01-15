/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package org.dellamorte.raum.susolver.supuzzle
import DualPivotQuicksort

#import java.util.Arrays

/**
 *
 * @author Raum
 */
class Ops 
	def self.pow(i:int, p:int):int
		return i if p == 1
		return i * pow(i, p - 1)
	end
	
	def self.containsBool(a:int[],n:int):boolean
		test = copyOf(a, a.length)
		sort(test)
		return (binarySearch(test, n) >= 0)
	end
	
	def self.isSubsetBool(a1:int[], a2:int[]):boolean
		return false if (a2.length > a1.length)
		out = true
		a2.each {|i| out = (out and containsBool(a1, i))}
		out
	end
	
	def self.aEqualsBool(a1:int[], a2:int[]):boolean
		return ((a1.length == a2.length) and isSubsetBool(a1, a2))
	end
	
	def self.appendUniq(ray:int[], num:int):int[]
		if ray.length == 0
			out = int[1]
			out[0] = num
			return out
		end
		sort(ray)
		return ray if containsBool(ray, num)
		out = int[ray.length + 1]
		ray.length.times {|i| out[i] = ray[i] }
		out[ray.length] = num
		sort(out)
		return out
	end
	
	def self.joinUniq(ray1:int[], ray2:int[]):int[]
		out = copyOf(ray1, ray1.length)
		sort(out)
		ray2.length.times {|i| out = appendUniq(out, ray2[i]) }
		return out
	end
	
	def self.union(ray1:int[], ray2:int[]):int[]
		return int[0] if ((ray1.length == 0) or (ray2.length == 0))
		out = int[0]
		ray1.length.times {|i| out = appendUniq(out, ray1[i]) if containsBool(ray2, ray1[i])}
		return out
	end
	
	def self.rotate(ray:int[]):int[]
		return ray if ray.length < 2
		out = int[ray.length]
		(out.length - 1).times {|i| out[i] = ray[i + 1] }
		out[out.length - 1] = ray[0]
		return out
	end
	
	def self.copyOf(original:int[], newLength:int):int[]
		copy = int[newLength]
		System.arraycopy(original, 0, copy, 0, Math.min(original.length, newLength))
		return copy
	end
	
	def self.copyOfRange(original:int[], from:int, to:int):int[]
		newLength = (to - from)
		(return int[0]) if (newLength < 0)
		copy = int[newLength]
		System.arraycopy(original, from, copy, 0, Math.min((original.length - from), newLength))
		return copy
	end
	
	def self.copyOfRange(original:Object[], from:int, to:int):Object[]
		newLength = (to - from)
		(return Object[0]) if (newLength < 0)
		copy = Object[newLength]
		System.arraycopy(original, from, copy, 0, Math.min((original.length - from), newLength))
		return copy
	end
	
	def self.toString(a:int[]):String
		return "null" if (a == nil)
		return "[]" if (a.length == 0)
		b = StringBuilder.new()
		b.append('[');
		a.length.times do |i:int|
			b.append(a[i])
			b.append(", ")
		end
		b.append(']').toString()
	end
	
	def self.sort(a:int[]):void
		DualPivotQuicksort.sort(a)
	end
	
	def self.binarySearch(a:int[], key:int):int
		return binarySearch0(a, 0, a.length, key)
	end
	
	def self.binarySearch0(a:int[], fromIndex:int, toIndex:int, key:int):int
		low = fromIndex
		high = toIndex - 1

		while (low <= high)
			mid = uRtShift(low + high, 1)
			midVal = a[mid]
			if (midVal < key)
				low = (mid + 1)
			elsif (midVal > key)
				high = (mid - 1)
			else
				return mid; # key found
			end
		end
		return (-(low + 1))  # key not found.
	end
	
	def self.uRtShift(n:int, i:int):int
		str = Integer.toBinaryString(n)
		return Integer.parseInt(str.substring(0, (str.length() - (1 + i))), 2) if ((str.length() - (1 + i)) > 0)
		return 0
	end
end

