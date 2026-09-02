/// Thrown when a Gemini response carries no usable JSON payload.
class GeminiParseException implements Exception {
  GeminiParseException(this.message);

  final String message;

  @override
  String toString() => 'GeminiParseException: $message';
}

/// Picks the first answer part that actually carries a JSON object.
///
/// The part order is not guaranteed: thinking models emit reasoning parts
/// next to the answer, and those carry no `text` at all, so indexing
/// `parts[0]` blindly breaks as soon as a thought lands first.
String extractJsonPayload(Map<String, dynamic> response) {
  final Object? candidates = response['candidates'];
  if (candidates is! List) {
    throw GeminiParseException('Response carries no candidates.');
  }

  for (final Object? candidate in candidates) {
    if (candidate is! Map) {
      continue;
    }
    final Object? content = candidate['content'];
    if (content is! Map) {
      continue;
    }
    final Object? parts = content['parts'];
    if (parts is! List) {
      continue;
    }

    for (final Object? part in parts) {
      if (part is! Map || part['thought'] == true) {
        continue;
      }
      final Object? text = part['text'];
      if (text is! String) {
        continue;
      }
      final String? json = _sliceJsonObject(text);
      if (json != null) {
        return json;
      }
    }
  }

  throw GeminiParseException('Response carries no JSON payload.');
}

/// Cuts the outermost `{...}` out of [text], which may be wrapped in prose
/// or a ```json fence. Returns null when there is no object to slice.
String? _sliceJsonObject(String text) {
  final int start = text.indexOf('{');
  final int end = text.lastIndexOf('}');
  if (start == -1 || end <= start) {
    return null;
  }
  return text.substring(start, end + 1);
}
