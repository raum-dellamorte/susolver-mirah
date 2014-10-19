package me.regexp;


/**
 *  Encapsulates java.io.InputStream as CharacterIterator.
 * 
 *  @author <a href="mailto:ales.novak@netbeans.com">Ales Novak</a>
 *  @version CVS $Id: StreamCharacterIterator.java 518156 2007-03-14 14:31:26Z vgritsenko $
 */
public final class StreamCharacterIterator implements CharacterIterator {

	/**
	 * @param is an InputStream, which is parsed 
	 */
	public StreamCharacterIterator(java.io.InputStream is) {
	}

	/**
	 * @return a substring 
	 */
	public String substring(int beginIndex, int endIndex) {
	}

	/**
	 * @return a substring 
	 */
	public String substring(int beginIndex) {
	}

	/**
	 * @return a character at the specified position. 
	 */
	public char charAt(int pos) {
	}

	/**
	 * @return <tt>true</tt> iff if the specified index is after the end of the character stream 
	 */
	public boolean isEnd(int pos) {
	}
}
