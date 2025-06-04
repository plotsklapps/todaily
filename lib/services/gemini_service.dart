import 'package:firebase_ai/firebase_ai.dart';
import 'package:todaily/state/gemini_signal.dart';

class GeminiService {
  Future<String?> generateTitleFromDescription(String description) async {
    // Access the GenerativeModel from the signal
    final GenerativeModel? model = sGenerativeModel.value;

    if (model == null) {
      // Handle the case where the model is not yet initialized
      print('GeminiService: GenerativeModel not initialized yet.');
      return null;
    }

    if (description.isEmpty) {
      // Handle the case where the description is empty
      print('GeminiService: Description is empty.');
      return null;
    }

    try {
      // Create a prompt for the model
      final String prompt =
          'Generate a single, concise title for the following journal entry summary. Provide only the title and nothing else:\n$description';

      // Send the prompt to the model and get the response
      final GenerateContentResponse response = await model.generateContent(
        <Content>[Content.text(prompt)],
      );

      // Return the generated title from the response
      return response.text;
    } catch (e) {
      // Handle any errors that occur during the AI call
      print('GeminiService: Error generating title: $e');
      return null;
    }
  }
}
