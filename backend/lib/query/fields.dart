class Fields {

  Fields() :
    fields = <SelectField>[];

  final List<SelectField> fields;

  void add(String field, Type type) {
    final SelectField selectField = SelectTypeField(field, type);
    fields.add(selectField);
  }

  void addRaw(String rawSelect) {
    final SelectField selectField = SelectRawField(rawSelect);
    fields.add(selectField);
  }
}

abstract class SelectField {
  const SelectField();
}

class SelectTypeField extends SelectField {
  const SelectTypeField(this.field, this.type);

  final String field;
  final Type type;
}

class SelectRawField extends SelectField {
  const SelectRawField(this.rawField);

  final String rawField;
}