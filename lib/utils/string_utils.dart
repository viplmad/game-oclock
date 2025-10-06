bool isStringEmpty(final String? value) => value == null || value.isEmpty;

bool isStringBlank(final String? value) =>
    value == null || value.trim().isEmpty;
