/// Converts a camelCase string to snake_case.
///
/// Example:
/// ```dart
/// camelToSnake('camelCase'); // 'camel_case'
/// ```
String camelToSnake(String input) {
  return input
      .replaceAllMapped(
        RegExp(r'([a-z0-9])([A-Z])'),
        (Match m) => '${m[1]}_${m[2]}',
      )
      .toLowerCase();
}
