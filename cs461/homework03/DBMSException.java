/**
 * Exception to throw in this DBMS implementation.
 */
public class DBMSException extends Exception {
    /**
     * Throw an Exception with the given message.
     * @param msg Message to throw.
     */
    @Override
    public DBMSException(final String msg) {
        super(msg);
    }
}
