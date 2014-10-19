package me.regexp;


/**
 *  A subclass of RECompiler which can dump a regular expression program
 *  for debugging purposes.
 * 
 *  @author <a href="mailto:jonl@muppetlabs.com">Jonathan Locke</a>
 */
public class REDebugCompiler extends RECompiler {

	public REDebugCompiler() {
	}

	/**
	 *  Dumps the current program to a {@link PrintStream}.
	 * 
	 *  @param p PrintStream for program dump output
	 */
	public void dumpProgram(java.io.PrintStream p) {
	}

	/**
	 *  Dumps the current program to a <code>System.out</code>.
	 */
	public void dumpProgram() {
	}
}
