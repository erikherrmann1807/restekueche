import 'package:flutter/foundation.dart';
// Re-exports XFile, so the util does not have to depend on image_picker.
import 'package:flutter_image_compress/flutter_image_compress.dart';

/// Thrown when a picked file cannot be turned into a JPEG.
class ImageCompressException implements Exception {
  ImageCompressException(this.message);

  final String message;

  @override
  String toString() => 'ImageCompressException: $message';
}

/// A JPEG small enough to travel to Gemini as inline data.
class CompressedImage {
  const CompressedImage({required this.bytes, required this.mimeType});

  final Uint8List bytes;
  final String mimeType;

  int get sizeInKb => (bytes.length / 1024).round();
}

/// Floor for the shorter edge of the picture.
///
/// The plugin scales down until neither side falls below this, so a 4:3
/// photo ends up around 1365x1024. Gemini tiles images at 768 px, so more
/// pixels than that buy no extra detail for ingredient recognition — they
/// only cost upload time.
const int _minEdge = 1024;

/// Byte budget for the JPEG. Base64 inflates it by another ~33 % on the
/// way through the edge function, so staying well under a megabyte here
/// keeps the round trip quick.
const int _maxBytes = 300 * 1024;

/// Quality steps tried in order until the result fits [_maxBytes].
const List<int> _qualitySteps = <int>[80, 60, 45];

/// Scales [photo] down and encodes it as JPEG under the size budget.
Future<CompressedImage> compressForVision(XFile photo) async {
  Uint8List? result;

  for (final int quality in _qualitySteps) {
    result = await FlutterImageCompress.compressWithFile(
      photo.path,
      minWidth: _minEdge,
      minHeight: _minEdge,
      quality: quality,
      format: CompressFormat.jpeg,
      // Phone cameras store the orientation in EXIF; without this the
      // model sees a sideways picture.
      autoCorrectionAngle: true,
    );

    if (result == null) {
      throw ImageCompressException('Could not read image at ${photo.path}');
    }
    if (result.length <= _maxBytes) {
      break;
    }
  }

  final CompressedImage image = CompressedImage(
    bytes: result!,
    mimeType: 'image/jpeg',
  );
  debugPrint('compressForVision: ${image.sizeInKb} KB');
  return image;
}
