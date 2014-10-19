package me.regexp;


/**
 * 
 *  @author Nikolay Neizvesny
 */
public class RECharacter {

	public static final byte UNASSIGNED = 0;

	public static final byte UPPERCASE_LETTER = 1;

	public static final byte LOWERCASE_LETTER = 2;

	public static final byte TITLECASE_LETTER = 3;

	public static final byte MODIFIER_LETTER = 4;

	public static final byte OTHER_LETTER = 5;

	public static final byte NON_SPACING_MARK = 6;

	public static final byte ENCLOSING_MARK = 7;

	public static final byte COMBINING_SPACING_MARK = 8;

	public static final byte DECIMAL_DIGIT_NUMBER = 9;

	public static final byte LETTER_NUMBER = 10;

	public static final byte OTHER_NUMBER = 11;

	public static final byte SPACE_SEPARATOR = 12;

	public static final byte LINE_SEPARATOR = 13;

	public static final byte PARAGRAPH_SEPARATOR = 14;

	public static final byte CONTROL = 15;

	public static final byte FORMAT = 16;

	public static final byte PRIVATE_USE = 18;

	public static final byte SURROGATE = 19;

	public static final byte DASH_PUNCTUATION = 20;

	public static final byte START_PUNCTUATION = 21;

	public static final byte END_PUNCTUATION = 22;

	public static final byte CONNECTOR_PUNCTUATION = 23;

	public static final byte OTHER_PUNCTUATION = 24;

	public static final byte MATH_SYMBOL = 25;

	public static final byte CURRENCY_SYMBOL = 26;

	public static final byte MODIFIER_SYMBOL = 27;

	public static final byte OTHER_SYMBOL = 28;

	public RECharacter() {
	}

	public static char toLowerCase(char c) {
	}

	public static char toUpperCase(char c) {
	}

	public static boolean isWhitespace(char c) {
	}

	public static boolean isDigit(char c) {
	}

	public static boolean isLetter(char c) {
	}

	public static boolean isLetterOrDigit(char c) {
	}

	public static boolean isSpaceChar(char c) {
	}

	public static boolean isJavaIdentifierStart(char c) {
	}

	public static boolean isJavaIdentifierPart(char c) {
	}

	public static byte getType(char c) {
	}
}
