String sanitizeImageUrl(String? rawUrl) {
  if (rawUrl == null) {
    return "";
  }

  final String trimmed = rawUrl.trim();
  if (trimmed.isEmpty) {
    return "";
  }

  final Uri? uri = Uri.tryParse(trimmed);
  if (uri == null) {
    return "";
  }

  final String scheme = uri.scheme.toLowerCase();
  if (scheme != "http" && scheme != "https") {
    return "";
  }

  return trimmed;
}
