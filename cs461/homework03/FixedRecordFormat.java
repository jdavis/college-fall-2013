/**
 * Implementation of RecordFormat for fixed record format.
 */
public class FixedRecordFormat implements RecordFormat {

    @Override
    public final byte[] writeRecord(final Record record) {
        int length = 0;

        // Find the length of all Fields
        for (Field field : record.getFields()) {
            length += field.getSize();
        }

        byte[] result = new byte[length];

        // Write all the Field values to the result byte array
        int i = 0, field = 0;
        for (Field field : record.getFields()) {
            // writeBytes(result, i, field.getSize(), record.getValue(field));
            field += 1;
            i += field.getSize();
        }

        return result;
    }

    @Override
    public final Record readRecord(final Field[] fields, final byte[] bytes) {
        Record result = new Record(fields);

        // Extract all the values from the given byte array into the Record
        int i = 0, field = 0;
        for (Field field : fields) {
            Object value;
            // value = readValue(i, field.getSize(), field.getType());
            i += field.getSize();
            record.setField(field, value);
        }

        return result;
    }
}
