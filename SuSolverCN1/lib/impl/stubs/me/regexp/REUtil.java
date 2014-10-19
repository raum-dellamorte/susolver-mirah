package me.regexp;


/**
 *  This is a class that contains utility helper methods for this package.
 * 
 *  @author <a href="mailto:jonl@muppetlabs.com">Jonathan Locke</a>
 *  @version $Id: REUtil.java 518156 2007-03-14 14:31:26Z vgritsenko $
 */
public class REUtil {

	public REUtil() {
	}

	/**
	 *  Creates a regular expression, permitting simple or complex syntax 
	 *  @param expression The expression, beginning with a prefix if it's complex or 
	 *  having no prefix if it's simple
	 *  @param matchFlags Matching style flags
	 *  @return The regular expression object
	 *  @exception RESyntaxException thrown in case of error
	 */
	public static RE createRE(String expression, int matchFlags) {
	}

	/**
	 *  Creates a regular expression, permitting simple or complex syntax 
	 *  @param expression The expression, beginning with a prefix if it's complex or 
	 *  having no prefix if it's simple 
	 *  @return The regular expression object
	 *  @exception RESyntaxException thrown in case of error
	 */
	public static RE createRE(String expression) {
	}
}
