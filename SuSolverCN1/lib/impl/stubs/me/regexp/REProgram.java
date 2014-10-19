package me.regexp;


/**
 *  A class that holds compiled regular expressions.  You should not need to
 *  work directly with this class.
 * 
 *  @see RE
 *  @see RECompiler
 * 
 *  @author <a href="mailto:jonl@muppetlabs.com">Jonathan Locke</a>
 *  @version $Id: REProgram.java 518156 2007-03-14 14:31:26Z vgritsenko $
 */
public class REProgram {

	/**
	 *  Constructs a program object from a character array
	 *  @param instruction Character array with RE opcode instructions in it
	 */
	public REProgram(char[] instruction) {
	}

	/**
	 *  Constructs a program object from a character array
	 *  @param parens Count of parens in the program
	 *  @param instruction Character array with RE opcode instructions in it
	 */
	public REProgram(int parens, char[] instruction) {
	}

	/**
	 *  Constructs a program object from a character array
	 *  @param instruction Character array with RE opcode instructions in it
	 *  @param lenInstruction Amount of instruction array in use
	 */
	public REProgram(char[] instruction, int lenInstruction) {
	}

	/**
	 *  Returns a copy of the current regular expression program in a character
	 *  array that is exactly the right length to hold the program.  If there is
	 *  no program compiled yet, getInstructions() will return null.
	 *  @return A copy of the current compiled RE program
	 */
	public char[] getInstructions() {
	}

	/**
	 *  Sets a new regular expression program to run.  It is this method which
	 *  performs any special compile-time search optimizations.  Currently only
	 *  two optimizations are in place - one which checks for backreferences
	 *  (so that they can be lazily allocated) and another which attempts to
	 *  find an prefix anchor string so that substantial amounts of input can
	 *  potentially be skipped without running the actual program.
	 *  @param instruction Program instruction buffer
	 *  @param lenInstruction Length of instruction buffer in use
	 */
	public void setInstructions(char[] instruction, int lenInstruction) {
	}

	/**
	 *  Returns a copy of the prefix of current regular expression program
	 *  in a character array.  If there is no prefix, or there is no program
	 *  compiled yet, <code>getPrefix</code> will return null.
	 *  @return A copy of the prefix of current compiled RE program
	 */
	public char[] getPrefix() {
	}
}
