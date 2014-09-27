/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package org.dellamorte.raum.susolver.supuzzle
import java.util.Arrays

/**
 *
 * @author Raum
 */
class Ops 
	def self.pow(i:int, p:int):int
		return i if p == 1
		return i * pow(i, p - 1)
	end
	
	def self.contains?(a:int[],n:int):boolean
		test = Arrays.copyOf(a, a.length)
		Arrays.sort(test)
		return (Arrays.binarySearch(test, n) >= 0)
	end
	
	def self.isSubset?(a1:int[], a2:int[]):boolean
		return false if (a2.length > a1.length)
		out = true
		a2.each {|i| out = (out and contains?(a1, i))}
		out
	end
	
	def self.aEquals?(a1:int[], a2:int[]):boolean
		return ((a1.length == a2.length) and isSubset?(a1, a2))
	end
	
	def self.appendUniq(ray:int[], num:int):int[]
		if ray.length == 0
			out = int[1]
			out[0] = num
			return out
		end
		Arrays.sort(ray)
		return ray if contains?(ray, num)
		out = int[ray.length + 1]
		ray.length.times {|i| out[i] = ray[i] }
		out[ray.length] = num
		Arrays.sort(out)
		return out
	end
	
	def self.joinUniq(ray1:int[], ray2:int[]):int[]
		out = Arrays.copyOf(ray1, ray1.length)
		Arrays.sort(out)
		ray2.length.times {|i| out = appendUniq(out, ray2[i]) }
		return out
	end
	
	def self.union(ray1:int[], ray2:int[]):int[]
		return int[0] if ((ray1.length == 0) or (ray2.length == 0))
		out = int[0]
		ray1.length.times {|i| out = appendUniq(out, ray1[i]) if contains?(ray2, ray1[i])}
		return out
	end
	
	def self.rotate(ray:int[]):int[]
		return ray if ray.length < 2
		out = int[ray.length]
		(out.length - 1).times {|i| out[i] = ray[i + 1] }
		out[out.length - 1] = ray[0]
		return out
	end
end

