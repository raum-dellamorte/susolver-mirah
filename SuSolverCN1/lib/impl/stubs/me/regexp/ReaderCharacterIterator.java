package me.regexp;


/**
 *  Encapsulates java.io.Reader as CharacterIterator
 * 
 *  @author <a href="mailto:ales.novak@netbeans.com">Ales Novak</a>
 *  @version CVS $Id: ReaderCharacterIterator.java 518156 2007-03-14 14:31:26Z vgritsenko $
 */
public final class ReaderCharacterIterator implements CharacterIterator {

	/**
	 * @param reader a Reader, which is parsed 
	 */
	public ReaderCharacterIterator(java.io.Reader reader) {
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
