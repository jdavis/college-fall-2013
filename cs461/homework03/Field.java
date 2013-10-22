/**
 * Field class for the DBMS.
 */
public class Field {
    /** Name of the field. */
    private String name;

    /** SQL Type of the field. */
    private String type;

    /** Optional variable size of the field. */
    private int variableSize;

    /**
     * Basic constructor for a Field.
     * @param givenName Name of the Field.
     * @param givenType Type of the Field.
     * @param givenSize Size of the Field.
     */
    public Field(final String givenName,
            final String givenType,
            final int givenSize) {
        // Assign constructor values
        name = givenName;
        type = givenType;
        size = givenSize;
    }

    /**
     * Getter for the Field name.
     * @return Name of the Field.
     */
    public final String getName() {
        return name;
    }

    /**
     * Getter for the Field type.
     * @return Type of the Field.
     */
    public final String getType() {
        return type;
    }

    /**
     * Getter for the size of the field.
     * @return Size of the field.
     */
    public final int getSize() {
        if ("int".equals(type)) {
            return 4;
        } else if ("varchar".equals(type)) {
            return variableSize;
        }
        // ..
        // continued...
        // ..
        else {
            // and so on...
            return 0;
        }
    }
}
