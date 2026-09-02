import 'package:restekueche/data/model/gemini_recipe_model.dart';
import 'package:restekueche/utils/recipe_json_parser.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RecipeService {
  Future<GeminiRecipeModel> generateRecipe(String ingredients) async {
    final response = await Supabase.instance.client.functions.invoke(
      'gemini-proxy',
      body: {
        'contents': [
          {
            'parts': [
              {'text': 'Gib die Antwort als structured json output. '
              'Du bist ein Experte darin anhand von den genannten '
                  'Lebensmitteln ein Rezept vorzuschlagen. Dieses soll folgende '
                  'Punkte enthalten: title, ingredients, steps, duration. '
                  'Lebenmittel: $ingredients. '
                  'Gib als Antwort nur die genannten Felder als json zurück.'
              }
            ]
          }
        ]
      },
    );

    if (response.status == 200) {
      print(response.data["modelVersion"]);
      print(response.data);
      return restructureJson(response.data);
    } else {
      print('Fehler: ${response.status}');
      return GeminiRecipeModel(title:'', ingredients: [''],
          steps: [''], duration: '');
    }
  }
}
