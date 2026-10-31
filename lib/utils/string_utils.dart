bool isStringEmpty(String? value) => value == null || value.isEmpty;

bool isStringBlank(String? value) => value == null || value.trim().isEmpty;
