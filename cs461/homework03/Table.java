public class Table {
    private ArrayList<Field> fields;

    public Table() {
        fields = new ArrayList<Field>();
    }

    public void addField(Field field) {
        fields.add(field);
    }
}
