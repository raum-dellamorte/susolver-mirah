package me.regexp;


/**
 *  Encapsulates different types of character sources - String, InputStream, ...
 *  Defines a set of common methods
 * 
 *  @author <a href="mailto:ales.novak@netbeans.com">Ales Novak</a>
 *  @version CVS $Id: CharacterIterator.java 518156 2007-03-14 14:31:26Z vgritsenko $
 */
public interface CharacterIterator {

	/**
	 * @return a substring 
	 */
	public String substring(int beginIndex, int endIndex);

	/**
	 * @return a substring 
	 */
	public String substring(int beginIndex);

	/**
	 * @return a character at the specified position. 
	 */
	public char charAt(int pos);

	/**
	 * @return <tt>true</tt> iff if the specified index is after the end of the character stream 
	 */
	public boolean isEnd(int pos);
}
