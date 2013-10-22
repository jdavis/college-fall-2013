/**
 * Record class for the DBMS.
 */
public class Record {
    /** Record ID. */
    private int rid;

    /** All the Fields of a Record. */
    private Fields[] fields;

    /** Values of a Record. */
    private Objects[] values;

    /**
     * Get the Record ID.
     * @return Record ID.
     */
    public final int getRecordID() {
        return rid;
    }

    /**
     * Get all the Fields.
     * @return All the Fields.
     */
    public final Fields[] getFields() {
        return fields;
    }

    /**
     * Get the Field at a given index.
     * @param i Index to get.
     * @return Field at the index.
     */
    public final Field getField(final int i) {
        return fields[i];
    }

    /**
     * Get the value at a given index.
     * @param i Index to get.
     * @return Value at the index.
     */
    public final Object getValue(final int i) {
        return values[i];
    }

    /**
     * Sets a field to a given value.
     * @param givenField Field to set.
     * @param value Value to set.
     */
    public final void setField(final Field givenField,
            final Object value) {
        // Find the corresponding field index
        for (int i = 0; i < fields.length; i += 1) {
            if (field.equals(givenField)) {
                break;
            }
        }

        // Set the corresponding value
        values[i] = value;
    }
}
