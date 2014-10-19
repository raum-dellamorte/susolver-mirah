package org.dellamorte.raum.susolver.supuzzle;

import com.codename1.util.StringUtil;
import java.util.List;
import me.regexp.RE;

/**
 *
 * @author Raum
 */
public class Ops {
	private Ops() {}
	
	public static int[] strToIntArray(String str) {
		RE r = new RE("([^0-9]+)");
		String[] tmp = r.split(str);
		int[] itmp = new int[0];
		for (String tmp1 : tmp) {
			if (tmp1.length() > 0) {
				itmp = Ops.append(itmp, Integer.parseInt(tmp1));
			}
		}
		return itmp;
	}
	
	public static int pow(int i, int p) {
		if (p == 1) return i;
		return i * pow(i, p - 1);
	}
	
	public static boolean containsBool(int[] a,int n) {
		int[] test = copyOf(a, a.length);
		sort(test);
		return (binarySearch(test, n) >= 0);
	}
	
	public static boolean isSubsetBool(int[] a1, int[] a2) {
		if (a2.length > a1.length) return false;
		boolean out = true;
		//a2.each {|i| out = (out and containsBool(a1, i))}
		for (int i = 0; i < a2.length; i++) {
			out = (out && containsBool(a1, a2[i]));
		}
		return out;
	}
	
	public static boolean aEqualsBool(int[] a1, int[] a2) {
		return ((a1.length == a2.length) && isSubsetBool(a1, a2));
	}
	
	public static int[] append(int[] ray, int num) {
		if (ray.length == 0) {
			int[] out = new int[1];
			out[0] = num;
			return out;
		}
		int[] out = new int[ray.length + 1];
		for (int i = 0; i < ray.length; i++) {
			out[i] = ray[i];
		}
		out[ray.length] = num;
		return out;
	}
	
	public static int[] appendUniq(int[] ray, int num) {
		if (ray.length == 0) {
			int[] out = new int[1];
			out[0] = num;
			return out;
		}
		sort(ray);
		if (containsBool(ray, num)) return ray;
		int[] out = new int[ray.length + 1];
		//ray.length.times {|i| out[i] = ray[i] }
		for (int i = 0; i < ray.length; i++) {
			out[i] = ray[i];
		}
		out[ray.length] = num;
		sort(out);
		return out;
	}
	
	public static int[] joinUniq(int[] ray1, int[] ray2) {
		int[] out = copyOf(ray1, ray1.length);
		sort(out);
		//ray2.length.times {|i| out = appendUniq(out, ray2[i]) }
		for (int i = 0; i < ray2.length; i++) {
			out = appendUniq(out, ray2[i]);
		}
		return out;
	}
	
	public static int[] union(int[] ray1, int[] ray2) {
		if ((ray1.length == 0) || (ray2.length == 0)) return new int[0];
		int[] out = new int[0];
		//ray1.length.times {|i| out = appendUniq(out, ray1[i]) if containsBool(ray2, ray1[i])}
		for (int i = 0; i < ray1.length; i++) {
			if (containsBool(ray2, ray1[i])) out = appendUniq(out, ray1[i]);
		}
		return out;
	}
	
	public static int[] rotate(int[] ray) {
		if (ray.length < 2) return ray;
		int[] out = new int[ray.length];
		//(out.length - 1).times {|i| out[i] = ray[i + 1] }
		for (int i = 0; i < (out.length - 1); i++) {
			out[i] = ray[i + 1];
		}
		out[out.length - 1] = ray[0];
		return out;
	}
	
	public static int[] copyOf(int[] original, int newLength) {
		int[] copy = new int[newLength];
		System.arraycopy(original, 0, copy, 0, Math.min(original.length, newLength));
		return copy;
	}
	
	public static int[] copyOfRange(int[] original, int from, int to) {
		int newLength = (to - from);
		if (newLength < 0) return new int[0];
		int[] copy = new int[newLength];
		System.arraycopy(original, from, copy, 0, Math.min((original.length - from), newLength));
		return copy;
	}
	
	public static String[] copyOfRange(String[] original, int from, int to) {
		int newLength = (to - from);
		if (newLength < 0) return new String[0];
		String[] copy = new String[newLength];
		System.arraycopy(original, from, copy, 0, Math.min((original.length - from), newLength));
		return copy;
	}
	
	public static Object[] copyOfRange(Object[] original, int from, int to) {
		int newLength = (to - from);
		if (newLength < 0) return new Object[0];
		Object[] copy = new Object[newLength];
		System.arraycopy(original, from, copy, 0, Math.min((original.length - from), newLength));
		return copy;
	}
	
	public static String toString(int[] a) {
		if (a == null) return "null";
		if (a.length == 0) return "[]";
		StringBuilder b = new StringBuilder();
		b.append('[');
		//a.length.times do |i:int|
		for (int i = 0; i < a.length; i++) {
			b.append(a[i]);
			if (i < (a.length - 1)) b.append(", ");
		}
		return b.append(']').toString();
	}
	
	public static void sort(int[] a) {
		DualPivotQuicksort.sort(a);
	}
	
	public static int binarySearch(int[] a, int key) {
		return binarySearch0(a, 0, a.length, key);
	}
	
	public static int binarySearch0(int[] a, int fromIndex, int toIndex, int key) {
		int low = fromIndex;
		int high = (toIndex - 1);
		int mid;
		int midVal;
		while (low <= high) {
			mid = (low + high) >>> 1;
			midVal = a[mid];
			if (midVal < key) {
				low = (mid + 1);
			} else if (midVal > key) {
				high = (mid - 1);
			} else {
				return mid; // key found
			}
		}
		return -(low + 1);  // key not found.
	}
	
	public static int uRtShift(int n, int i) {
		return (n >>> i);
	}
}
