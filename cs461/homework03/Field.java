public class Field {
    /** Name of the field. */
    private String name;

    /** SQL Type of the field. */
    private String type;

    /** Optional variable size of the field. */
    private int variableSize;

    public String getName() {
        return name;
    }

    public String getType() {
        return type;
    }

    public int getSize() {
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
        }
    }
}
