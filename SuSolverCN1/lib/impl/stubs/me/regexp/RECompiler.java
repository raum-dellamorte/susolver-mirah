package me.regexp;


/**
 *  A regular expression compiler class.  This class compiles a pattern string into a
 *  regular expression program interpretable by the RE evaluator class.  The 'recompile'
 *  command line tool uses this compiler to pre-compile regular expressions for use
 *  with RE.  For a description of the syntax accepted by RECompiler and what you can
 *  do with regular expressions, see the documentation for the RE matcher class.
 * 
 *  @see RE
 * 
 *  @author <a href="mailto:jonl@muppetlabs.com">Jonathan Locke</a>
 *  @author <a href="mailto:gholam@xtra.co.nz">Michael McCallum</a>
 *  @version $Id: RECompiler.java 518156 2007-03-14 14:31:26Z vgritsenko $
 */
public class RECompiler {

	/**
	 *  Constructor.  Creates (initially empty) storage for a regular expression program.
	 */
	public RECompiler() {
	}

	/**
	 *  Compiles a regular expression pattern into a program runnable by the pattern
	 *  matcher class 'RE'.
	 *  @param pattern Regular expression pattern to compile (see RECompiler class
	 *  for details).
	 *  @return A compiled regular expression program.
	 *  @exception RESyntaxException Thrown if the regular expression has invalid syntax.
	 *  @see RECompiler
	 *  @see RE
	 */
	public REProgram compile(String pattern) {
	}
}
