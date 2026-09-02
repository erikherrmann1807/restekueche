import 'dart:convert';

import 'package:restekueche/data/model/detected_ingredient_model.dart';
import 'package:restekueche/utils/image_compressor.dart';
import 'package:restekueche/utils/ingredient_json_parser.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Thrown when the proxy answers with anything but a 200.
class VisionRequestException implements Exception {
  VisionRequestException(this.status);

  final int? status;

  @override
  String toString() => 'VisionRequestException: status $status';
}

const String _prompt =
    'Du bist ein Experte darin, Lebensmittel auf Fotos zu erkennen. '
    'Nenne nur Lebensmittel und Zutaten, die auf dem Bild tatsächlich zu '
    'sehen sind. Rate nicht: wenn du dir unsicher bist, gib eine niedrige '
    'confidence an, statt die Zutat wegzulassen oder zu erfinden. '
    'Gib die Antwort als structured json output mit dem Feld "ingredients" '
    'zurück, einer Liste von Objekten mit "name" (deutscher Name, '
    'Singular) und "confidence" (Zahl zwischen 0 und 1). '
    'Gib als Antwort nur dieses json zurück.';

class VisionService {
  Future<List<DetectedIngredientModel>> detectIngredients(
    CompressedImage image,
  ) async {
    final response = await Supabase.instance.client.functions.invoke(
      'gemini-proxy',
      body: {
        'contents': [
          {
            'parts': [
              {
                'inline_data': {
                  'mime_type': image.mimeType,
                  'data': base64Encode(image.bytes),
                },
              },
              {'text': _prompt},
            ],
          },
        ],
        'generationConfig': {'responseMimeType': 'application/json'},
      },
    );

    // Unlike the recipe path we throw here instead of returning something
    // empty: the view model has to tell "request failed" apart from
    // "nothing recognisable on the photo", and those look identical once
    // the failure is flattened into an empty list.
    if (response.status != 200) {
      throw VisionRequestException(response.status);
    }

    return parseDetectedIngredients(response.data as Map<String, dynamic>);
  }
}
