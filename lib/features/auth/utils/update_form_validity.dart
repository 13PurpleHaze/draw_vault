void updateFieldValidity<T>(bool isValid, T field, Set<T> validFields) {
  if (isValid) {
    validFields.add(field);
  } else {
    validFields.remove(field);
  }
}
