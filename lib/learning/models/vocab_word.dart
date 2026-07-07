/// A structured vocabulary word used in ESL-focused vocabulary lessons.
///
/// Each [VocabWord] contains a visual emoji, the word itself, a
/// child-friendly definition, and an example sentence showing usage.
class VocabWord {
  final String emoji;
  final String word;
  final String definition;
  final String example;

  const VocabWord(this.emoji, this.word, this.definition, this.example);
}
