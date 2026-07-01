import 'package:flutter/material.dart';

enum LearningSubject { mathematics, english }

extension LearningSubjectX on LearningSubject {
  String get label {
    switch (this) {
      case LearningSubject.mathematics:
        return 'Mathematics';
      case LearningSubject.english:
        return 'English';
    }
  }

  IconData get icon {
    switch (this) {
      case LearningSubject.mathematics:
        return Icons.calculate_rounded;
      case LearningSubject.english:
        return Icons.menu_book_rounded;
    }
  }

  Color accent(ColorScheme scheme) {
    switch (this) {
      case LearningSubject.mathematics:
        return scheme.primary;
      case LearningSubject.english:
        return scheme.tertiary;
    }
  }

  String get id => name;
}

enum StepKind {
  explanation,
  mcq,
  fillBlank,
  ordering,
  matching,
  tapShape,
  numberLine,
  visualCount,
  wordOrder,
  readAndAnswer,
  pronunciation,
  storyComplete,
  findPicture,
}

class LessonOption {
  final String id;
  final String text;
  final String? emoji;

  const LessonOption({required this.id, required this.text, this.emoji});

  Map<String, dynamic> toJson() => {
        'id': id,
        'text': text,
        'emoji': emoji,
      };

  factory LessonOption.fromJson(Map<String, dynamic> j) => LessonOption(
        id: j['id'] as String,
        text: j['text'] as String,
        emoji: j['emoji'] as String?,
      );
}

class MatchingPair {
  final String left;
  final String right;
  final String? rightEmoji;

  const MatchingPair({required this.left, required this.right, this.rightEmoji});

  Map<String, dynamic> toJson() => {
        'left': left,
        'right': right,
        'rightEmoji': rightEmoji,
      };

  factory MatchingPair.fromJson(Map<String, dynamic> j) => MatchingPair(
        left: j['left'] as String,
        right: j['right'] as String,
        rightEmoji: j['rightEmoji'] as String?,
      );
}

class LessonStep {
  final String id;
  final StepKind kind;
  final String prompt;
  final String? hint;
  final String? explanation;

  final List<String>? mcqOptions;
  final int? mcqCorrectIndex;

  final String? fillAnswer;
  final List<String>? fillAcceptedAnswers;
  final String? fillPreview;

  final List<String>? orderingItems;
  final List<String>? orderingCorrect;

  final List<MatchingPair>? matchingPairs;

  final List<String>? tapShapeEmojis;
  final int? tapShapeCorrectIndex;

  final int? numberLineMin;
  final int? numberLineMax;
  final int? numberLineAnswer;

  final int? visualCountAnswer;
  final List<String>? visualCountSymbols;

  final List<String>? wordOrderScrambled;
  final String? wordOrderAnswer;

  final String? readingPassage;
  final List<String>? readingOptions;
  final int? readingCorrectIndex;

  final String? pronunciationWord;

  final String? storySentence;
  final String? storyMissingWord;
  final List<String>? storyOptions;

  final List<String>? pictureOptions;
  final int? pictureCorrectIndex;
  final String? pictureEmoji;

  final int xpReward;

  const LessonStep({
    required this.id,
    required this.kind,
    required this.prompt,
    this.hint,
    this.explanation,
    this.mcqOptions,
    this.mcqCorrectIndex,
    this.fillAnswer,
    this.fillAcceptedAnswers,
    this.fillPreview,
    this.orderingItems,
    this.orderingCorrect,
    this.matchingPairs,
    this.tapShapeEmojis,
    this.tapShapeCorrectIndex,
    this.numberLineMin,
    this.numberLineMax,
    this.numberLineAnswer,
    this.visualCountAnswer,
    this.visualCountSymbols,
    this.wordOrderScrambled,
    this.wordOrderAnswer,
    this.readingPassage,
    this.readingOptions,
    this.readingCorrectIndex,
    this.pronunciationWord,
    this.storySentence,
    this.storyMissingWord,
    this.storyOptions,
    this.pictureOptions,
    this.pictureCorrectIndex,
    this.pictureEmoji,
    this.xpReward = 10,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'kind': kind.name,
        'prompt': prompt,
        'hint': hint,
        'explanation': explanation,
        'mcqOptions': mcqOptions,
        'mcqCorrectIndex': mcqCorrectIndex,
        'fillAnswer': fillAnswer,
        'fillAcceptedAnswers': fillAcceptedAnswers,
        'fillPreview': fillPreview,
        'orderingItems': orderingItems,
        'orderingCorrect': orderingCorrect,
        'matchingPairs': matchingPairs?.map((e) => e.toJson()).toList(),
        'tapShapeEmojis': tapShapeEmojis,
        'tapShapeCorrectIndex': tapShapeCorrectIndex,
        'numberLineMin': numberLineMin,
        'numberLineMax': numberLineMax,
        'numberLineAnswer': numberLineAnswer,
        'visualCountAnswer': visualCountAnswer,
        'visualCountSymbols': visualCountSymbols,
        'wordOrderScrambled': wordOrderScrambled,
        'wordOrderAnswer': wordOrderAnswer,
        'readingPassage': readingPassage,
        'readingOptions': readingOptions,
        'readingCorrectIndex': readingCorrectIndex,
        'pronunciationWord': pronunciationWord,
        'storySentence': storySentence,
        'storyMissingWord': storyMissingWord,
        'storyOptions': storyOptions,
        'pictureOptions': pictureOptions,
        'pictureCorrectIndex': pictureCorrectIndex,
        'pictureEmoji': pictureEmoji,
        'xpReward': xpReward,
      };

  factory LessonStep.fromJson(Map<String, dynamic> j) => LessonStep(
        id: j['id'] as String,
        kind: StepKind.values.firstWhere((k) => k.name == j['kind']),
        prompt: j['prompt'] as String,
        hint: j['hint'] as String?,
        explanation: j['explanation'] as String?,
        mcqOptions: (j['mcqOptions'] as List?)?.cast<String>(),
        mcqCorrectIndex: j['mcqCorrectIndex'] as int?,
        fillAnswer: j['fillAnswer'] as String?,
        fillAcceptedAnswers: (j['fillAcceptedAnswers'] as List?)?.cast<String>(),
        fillPreview: j['fillPreview'] as String?,
        orderingItems: (j['orderingItems'] as List?)?.cast<String>(),
        orderingCorrect: (j['orderingCorrect'] as List?)?.cast<String>(),
        matchingPairs: j['matchingPairs'] == null
            ? null
            : (j['matchingPairs'] as List)
                .map((e) => MatchingPair.fromJson(e as Map<String, dynamic>))
                .toList(),
        tapShapeEmojis: (j['tapShapeEmojis'] as List?)?.cast<String>(),
        tapShapeCorrectIndex: j['tapShapeCorrectIndex'] as int?,
        numberLineMin: j['numberLineMin'] as int?,
        numberLineMax: j['numberLineMax'] as int?,
        numberLineAnswer: j['numberLineAnswer'] as int?,
        visualCountAnswer: j['visualCountAnswer'] as int?,
        visualCountSymbols: (j['visualCountSymbols'] as List?)?.cast<String>(),
        wordOrderScrambled: (j['wordOrderScrambled'] as List?)?.cast<String>(),
        wordOrderAnswer: j['wordOrderAnswer'] as String?,
        readingPassage: j['readingPassage'] as String?,
        readingOptions: (j['readingOptions'] as List?)?.cast<String>(),
        readingCorrectIndex: j['readingCorrectIndex'] as int?,
        pronunciationWord: j['pronunciationWord'] as String?,
        storySentence: j['storySentence'] as String?,
        storyMissingWord: j['storyMissingWord'] as String?,
        storyOptions: (j['storyOptions'] as List?)?.cast<String>(),
        pictureOptions: (j['pictureOptions'] as List?)?.cast<String>(),
        pictureCorrectIndex: j['pictureCorrectIndex'] as int?,
        pictureEmoji: j['pictureEmoji'] as String?,
        xpReward: j['xpReward'] as int? ?? 10,
      );
}

class Lesson {
  final String id;
  final String topicId;
  final String title;
  final String learningObjective;
  final int order;
  final List<LessonStep> steps;

  const Lesson({
    required this.id,
    required this.topicId,
    required this.title,
    required this.learningObjective,
    required this.order,
    required this.steps,
  });

  int get totalXp => steps.fold<int>(0, (sum, s) => sum + s.xpReward);

  Map<String, dynamic> toJson() => {
        'id': id,
        'topicId': topicId,
        'title': title,
        'learningObjective': learningObjective,
        'order': order,
        'steps': steps.map((e) => e.toJson()).toList(),
      };

  factory Lesson.fromJson(Map<String, dynamic> j) => Lesson(
        id: j['id'] as String,
        topicId: j['topicId'] as String,
        title: j['title'] as String,
        learningObjective: j['learningObjective'] as String,
        order: j['order'] as int,
        steps: (j['steps'] as List)
            .map((e) => LessonStep.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
}

class LearningTopic {
  final String id;
  final String subjectId;
  final int grade;
  final String title;
  final String description;
  final IconData icon;
  final List<Lesson> lessons;

  const LearningTopic({
    required this.id,
    required this.subjectId,
    required this.grade,
    required this.title,
    required this.description,
    required this.icon,
    required this.lessons,
  });
}
