import 'dart:math';
import '../models/math_question.dart';

class QuestionGenerator {
  QuestionGenerator._();
  static final _rng = Random();

  static List<MathQuestion> generate({
    required int grade,
    required MathTopic topic,
    required Difficulty difficulty,
    int count = 10,
  }) {
    final seen = <String>{};
    final questions = <MathQuestion>[];

    for (int i = 0; i < count * 2 && questions.length < count; i++) {
      final q = _generateOne(grade, topic, difficulty, i);
      if (q != null && seen.add(q.question)) questions.add(q);
    }
    return questions;
  }

  static MathQuestion? _generateOne(
      int grade, MathTopic topic, Difficulty difficulty, int index) {
    final id = '${grade}_${topic.name}_${difficulty.name}_$index';
    switch (grade) {
      case 1: return _grade1(id, topic, difficulty);
      case 2: return _grade2(id, topic, difficulty);
      case 3: return _grade3(id, topic, difficulty);
      case 4: return _grade4(id, topic, difficulty);
      case 5: return _grade5(id, topic, difficulty);
      case 6: return _grade6(id, topic, difficulty);
      default: return null;
    }
  }

  static int _r(int min, int max) => min + _rng.nextInt(max - min + 1);
  static bool _coin() => _rng.nextBool();

  static List<int> _opts(int correct, int lo, int hi, int count) {
    final result = <int>{correct};
    // Generate unique distractors near the correct answer
    for (int attempt = 0; attempt < 20 && result.length < count; attempt++) {
      final offset = _rng.nextInt(3) == 0 ? _r(1, 5) : _r(-10, 10);
      final val = correct + offset;
      if (val >= lo && val <= hi) result.add(val);
    }
    // If still not enough, fallback
    while (result.length < count) {
      result.add(_r(lo, hi));
    }
    return result.toList();
  }

  static List<int> _optsAround(int correct, int spread, int count) {
    return _opts(correct, correct - spread, correct + spread, count);
  }

  static MathQuestion _mc(String id, String q, String answer, List<String> opts,
          MathTopic t, Difficulty d, int g, {String explanation = ''}) {
    opts.shuffle(); // randomize order once — never shuffle on display
    if (opts.length > 4) opts = opts.sublist(0, 4);
    return MathQuestion(
      id: id,
      question: q,
      options: opts,
      correctAnswer: answer,
      topic: t,
      difficulty: d,
      type: QuestionType.multipleChoice,
      grade: g,
      explanation: explanation,
    );
  }

  static int _dMin(Difficulty d) {
    switch (d) {
      case Difficulty.easy: return 1;
      case Difficulty.medium: return 10;
      case Difficulty.hard: return 100;
    }
  }

  static int _dMax(Difficulty d) {
    switch (d) {
      case Difficulty.easy: return 9;
      case Difficulty.medium: return 99;
      case Difficulty.hard: return 999;
    }
  }

  // ── Base generators used across all grades ────────────────────────

  static MathQuestion? _genAddition(String id, MathTopic t, Difficulty d, int g) {
    final lo = _dMin(d);
    final hi = _dMax(d);
    final a = _r(lo, hi);
    final b = _r(lo, hi);
    final ans = a + b;
    return _mc(id, '$a + $b = ?', '$ans',
        _optsAround(ans, max(2, ans ~/ 4), 4).map((e) => e.toString()).toList(), t, d, g);
  }

  static MathQuestion? _genSubtraction(String id, MathTopic t, Difficulty d, int g) {
    final lo = _dMin(d);
    final hi = _dMax(d);
    final a = _r(lo, hi);
    final b = _r(lo, hi);
    final big = max(a, b);
    final small = min(a, b);
    final ans = big - small;
    return _mc(id, '$big − $small = ?', '$ans',
        _optsAround(ans, max(2, ans ~/ 3), 4).map((e) => e.toString()).toList(), t, d, g);
  }

  static MathQuestion? _genMultiplication(String id, MathTopic t, Difficulty d, int g) {
    final lo = _dMin(d);
    final hi = _dMax(d);
    // For easy, keep numbers small (2-5) even if single-digit
    final a = d == Difficulty.easy ? _r(2, 5) : _r(lo, hi);
    final b = d == Difficulty.easy ? _r(2, 5) : _r(max(2, lo), hi);
    final ans = a * b;
    return _mc(id, '$a × $b = ?', '$ans',
        _optsAround(ans, max(2, ans ~/ 3), 4).map((e) => e.toString()).toList(), t, d, g);
  }

  static MathQuestion? _genDivision(String id, MathTopic t, Difficulty d, int g) {
    final lo = d == Difficulty.easy ? 2 : _dMin(d);
    final hi = d == Difficulty.easy ? 9 : _dMax(d);
    final b = _r(max(2, lo), hi);
    final ans = _r(lo, hi);
    final a = b * ans;
    return _mc(id, '$a ÷ $b = ?', '$ans',
        _optsAround(ans, max(2, ans ~/ 3), 4).map((e) => e.toString()).toList(), t, d, g);
  }

  // ── Grade 1 ──────────────────────────────────────────────────────
  static MathQuestion? _grade1(String id, MathTopic t, Difficulty d) {
    switch (t) {
      case MathTopic.counting:
        final maxStars = [10, 20, 30][d.index];
        final minStars = [3, 5, 10][d.index];
        final n = _r(minStars, maxStars);
        return _mc(id, 'How many? ${'★' * n}', '$n',
            _optsAround(n, 3, 4).map((e) => e.toString()).toList(), t, d, 1);
      case MathTopic.addition:
        return _genAddition(id, t, d, 1);
      case MathTopic.subtraction:
        return _genSubtraction(id, t, d, 1);
      case MathTopic.numberRecognition:
        final n = _r(max(1, _dMin(d)), _dMax(d));
        return _mc(id, 'Which number is $n?', '$n',
            _optsAround(n, 5, 4).map((e) => e.toString()).toList(), t, d, 1);
      case MathTopic.placeValue: {
        final tens = _r(1, 4), ones = _r(0, 9);
        final n = tens * 10 + ones;
        final q = _coin() ? 'How many tens are in $n?' : 'What is $tens tens and $ones ones?';
        final ans = q.startsWith('How many tens') ? '$tens' : '$n';
        return _mc(id, q, ans, _optsAround(int.parse(ans), 9, 4).map((e) => e.toString()).toList(), t, d, 1);
      }
      case MathTopic.patterns: {
        final items = ['★', '●', '♦', '♥'];
        final sym = items[_rng.nextInt(items.length)];
        final pattern = List.filled(_r(2, 3), sym).join(' ');
        return _mc(id, 'What comes next? $pattern __', sym, items, t, d, 1);
      }
      case MathTopic.geometry: {
        return _mc(id, 'Which shape has 3 sides?', 'Triangle',
            ['Triangle', 'Square', 'Circle', 'Hexagon'], t, d, 1,
            explanation: 'A triangle has 3 sides.');
      }
      case MathTopic.time: {
        final h = _r(1, 12);
        return _mc(id, 'What time is it when the clock shows $h:00?', '$h:00',
            ['$h:00', '${h % 12 + 1}:00', '${_r(1, 12)}:30', '${_r(1, 12)}:15'], t, d, 1);
      }
      case MathTopic.measurement: {
        final len = _r(2, 10);
        return _mc(id, 'A pencil is $len cm long. A book is 3 cm longer. How long is the book?',
            '${len + 3} cm', _optsAround(len + 3, 3, 4).map((e) => '$e cm').toList(), t, d, 1);
      }
      case MathTopic.money: {
        final coins = _r(1, 5);
        return _mc(id, 'How many cents is $coins nickel${coins > 1 ? 's' : ''} worth?',
            '${coins * 5}', _optsAround(coins * 5, 5, 4).map((e) => e.toString()).toList(), t, d, 1,
            explanation: 'Each nickel is worth 5 cents.');
      }
      case MathTopic.wordProblems: {
        final a = _r(max(2, _dMin(d)), min(5, _dMax(d)));
        final b = _r(max(2, _dMin(d)), min(5, _dMax(d)));
        return _mc(id, 'Sam has $a apples. Mom gives him $b more. How many does he have now?',
            '${a + b}', _optsAround(a + b, 3, 4).map((e) => e.toString()).toList(), t, d, 1);
      }
      default:
        return null;
    }
  }

  // ── Grade 2 ──────────────────────────────────────────────────────
  static MathQuestion? _grade2(String id, MathTopic t, Difficulty d) {
    switch (t) {
      case MathTopic.addition: return _genAddition(id, t, d, 2);
      case MathTopic.subtraction: return _genSubtraction(id, t, d, 2);
      case MathTopic.multiplication: return _genMultiplication(id, t, d, 2);
      case MathTopic.division: return _genDivision(id, t, d, 2);
      case MathTopic.placeValue: {
        final h = _r(1, 5), t2 = _r(0, 9), o = _r(0, 9);
        final n = h * 100 + t2 * 10 + o;
        return _mc(id, 'What is the value of the digit $h in $n?',
            '${h * 100}', ['${h * 100}', '${h * 10}', '$h', '$n'], t, d, 2);
      }
      case MathTopic.time: {
        final h = _r(1, 12);
        final m = _coin() ? 0 : 30;
        final label = m == 0 ? 'o\'clock' : 'half past';
        return _mc(id, 'What time is $label ${h > 12 ? h - 12 : h}?',
            '${h > 12 ? h - 12 : h}:${m.toString().padLeft(2, '0')}',
            ['${h > 12 ? h - 12 : h}:${m.toString().padLeft(2, '0')}',
             '${_r(1, 12)}:${_coin() ? '00' : '30'}',
             '${_r(1, 12)}:${_coin() ? '00' : '30'}',
             '${h == 12 ? 1 : h + 1}:${m.toString().padLeft(2, '0')}'],
            t, d, 2);
      }
      case MathTopic.money: {
        final dollars = _r(1, 5);
        final cents = _coin() ? 0 : _r(1, 3) * 25;
        return _mc(id,
            'You have $dollars dollar${dollars > 1 ? 's' : ''} and ${cents ~/ 25} quarter${cents ~/ 25 > 1 ? 's' : ''}. How much money do you have?',
            '\$${dollars}.${cents.toString().padLeft(2, '0')}',
            ['\$${dollars}.${cents.toString().padLeft(2, '0')}',
             '\$${_r(1, 10)}.${_r(0, 99).toString().padLeft(2, '0')}',
             '\$${_r(1, 10)}.${_r(0, 99).toString().padLeft(2, '0')}',
             '\$${_r(1, 10)}.${_r(0, 99).toString().padLeft(2, '0')}'],
            t, d, 2);
      }
      case MathTopic.measurement: {
        final m = _r(1, 5) * 100;
        return _mc(id, 'How many centimeters in ${m ~/ 100} meter${m ~/ 100 > 1 ? 's' : ''}?',
            '$m', _optsAround(m, 100, 4).map((e) => e.toString()).toList(), t, d, 2,
            explanation: '1 meter = 100 centimeters');
      }
      case MathTopic.geometry: {
        final sides = _r(3, 6);
        final shapes = {3: 'Triangle', 4: 'Square', 5: 'Pentagon', 6: 'Hexagon'};
        return _mc(id, 'What shape has $sides sides?', shapes[sides]!, shapes.values.toList(), t, d, 2);
      }
      case MathTopic.fractions: {
        final den = _r(2, 4), num = _r(1, den - 1);
        return _mc(id, 'What fraction is shaded? (${'■' * num}${'□' * (den - num)})',
            '$num/$den', ['$num/$den', '${num + 1}/$den', '$num/${den + 1}', '${num}/${den * 2}'], t, d, 2);
      }
      case MathTopic.patterns: {
        return _mc(id, 'What is the next number? 2, 4, 6, 8, __',
            '10', ['9', '10', '11', '12'], t, d, 2, explanation: 'Add 2 each time.');
      }
      case MathTopic.wordProblems: {
        final a = _r(max(10, _dMin(d)), min(30, _dMax(d)));
        final b = _r(max(5, _dMin(d)), min(15, _dMax(d)));
        return _mc(id, 'There are $a students in class. $b more join. How many students now?',
            '${a + b}', _optsAround(a + b, 5, 4).map((e) => e.toString()).toList(), t, d, 2);
      }
      default:
        return _grade1(id, t, d);
    }
  }

  // ── Grade 3 ──────────────────────────────────────────────────────
  static MathQuestion? _grade3(String id, MathTopic t, Difficulty d) {
    switch (t) {
      case MathTopic.addition: return _genAddition(id, t, d, 3);
      case MathTopic.subtraction: return _genSubtraction(id, t, d, 3);
      case MathTopic.multiplication: return _genMultiplication(id, t, d, 3);
      case MathTopic.division: return _genDivision(id, t, d, 3);
      case MathTopic.fractions: {
        final den = _r(4, 8), num = _r(1, den - 1);
        return _mc(id, 'Which is bigger: $num/$den or ${num + 1}/$den?',
            '${num + 1}/$den', ['$num/$den', '${num + 1}/$den', 'They are equal', 'Cannot tell'],
            t, d, 3, explanation: 'Larger numerator means larger fraction.');
      }
      case MathTopic.time: {
        final h = _r(1, 11), m = _coin() ? 15 : 45;
        return _mc(id, 'What time is it? $h:${m.toString().padLeft(2, '0')}',
            '$h:${m.toString().padLeft(2, '0')}',
            ['$h:${m.toString().padLeft(2, '0')}',
             '${h + 1}:${m.toString().padLeft(2, '0')}',
             '$h:${(m + 15) % 60}', '${h}:00'], t, d, 3);
      }
      case MathTopic.measurement: {
        final kg = _r(1, 10);
        return _mc(id, '$kg kg = ___ g', '${kg * 1000}',
            _optsAround(kg * 1000, 500, 4).map((e) => e.toString()).toList(), t, d, 3,
            explanation: '1 kg = 1000 g');
      }
      case MathTopic.geometry: {
        final w = _r(2, 8), h2 = _r(2, 8);
        return _mc(id, 'A rectangle has width $w cm and height $h2 cm. What is the area?',
            '${w * h2} cm²', ['${w * h2} cm²', '${w + h2} cm²', '${w * 2 + h2 * 2} cm²', '${w * h2 * 2} cm²'],
            t, d, 3, explanation: 'Area = width × height');
      }
      case MathTopic.decimals: {
        final n = _r(1, 9), d3 = _r(1, 9);
        return _mc(id, 'What is $n.$d3 as a fraction?', '$n ${d3}/10',
            ['$n ${d3}/10', '$n/${d3 * 10}', '${n * 10 + d3}/10', '${n * 10 + d3}/100'], t, d, 3);
      }
      case MathTopic.placeValue: {
        final n = _r(100, 999);
        final digits = n.toString();
        return _mc(id, 'In $n, what is the value of the digit ${digits[1]}?',
            '${int.parse(digits[1]) * 10}',
            ['${int.parse(digits[1]) * 10}', '${int.parse(digits[1])}', '${int.parse(digits[1]) * 100}', '$n'], t, d, 3);
      }
      case MathTopic.wordProblems: {
        final a = _r(max(2, _dMin(d)), min(9, _dMax(d)));
        final b = _r(max(2, _dMin(d)), min(9, _dMax(d)));
        return _mc(id, 'A pack has $a crayons. You buy $b packs. How many crayons do you have?',
            '${a * b}', _optsAround(a * b, 5, 4).map((e) => e.toString()).toList(), t, d, 3);
      }
      default:
        return _grade2(id, t, d);
    }
  }

  // ── Grade 4 ──────────────────────────────────────────────────────
  static MathQuestion? _grade4(String id, MathTopic t, Difficulty d) {
    switch (t) {
      case MathTopic.multiplication: return _genMultiplication(id, t, d, 4);
      case MathTopic.division: return _genDivision(id, t, d, 4);
      case MathTopic.addition: return _genAddition(id, t, d, 4);
      case MathTopic.subtraction: return _genSubtraction(id, t, d, 4);
      case MathTopic.fractions: {
        final num1 = _r(1, 5), den = _r(6, 12), num2 = _r(1, 5);
        final sumNum = num1 + num2;
        return _mc(id, '$num1/$den + $num2/$den = ?', '$sumNum/$den',
            ['$sumNum/$den', '${sumNum}/${den * 2}', '${num1 * num2}/$den', '${num2}/${num1 + den}'], t, d, 4,
            explanation: 'Add numerators, keep denominator the same');
      }
      case MathTopic.decimals: {
        final a = _r(1, 99), b = _r(1, 99);
        final da = a / 100, db = b / 100;
        final ans = (da + db).toStringAsFixed(2);
        return _mc(id, '$da + $db = ?', ans,
            [ans, (da + db + 0.01).toStringAsFixed(2), (da + db - 0.01).toStringAsFixed(2), (da + db + 0.02).toStringAsFixed(2)], t, d, 4);
      }
      case MathTopic.geometry: {
        final s = _r(3, 10);
        return _mc(id, 'A square has side $s cm. What is the perimeter?',
            '${s * 4} cm', ['${s * 4} cm', '${s * s} cm²', '${s * 2} cm', '${s * 8} cm'], t, d, 4,
            explanation: 'Perimeter = 4 × side');
      }
      case MathTopic.measurement: {
        final l = _r(1, 5);
        return _mc(id, '$l L = ___ mL', '${l * 1000}',
            _optsAround(l * 1000, 500, 4).map((e) => e.toString()).toList(), t, d, 4,
            explanation: '1 L = 1000 mL');
      }
      case MathTopic.money: {
        final d4 = _r(1, 10), c = _r(1, 99);
        final change = 100 - c;
        return _mc(id, 'You buy an item for \$${d4}.${c.toString().padLeft(2, '0')} and pay with \$${d4 + 1}. What is your change?',
            '\$0.${change.toString().padLeft(2, '0')}',
            ['\$0.${change.toString().padLeft(2, '0')}',
             '\$${c / 100}', '\$${d4}.${c.toString().padLeft(2, '0')}', '\$1.00'], t, d, 4);
      }
      case MathTopic.time: {
        final h = _r(1, 11), m = _coin() ? 10 : 20;
        final add = _coin() ? 15 : 30;
        final totalMin = h * 60 + m + add;
        final newH = (totalMin ~/ 60) % 12;
        final newM = totalMin % 60;
        return _mc(id, 'If it is $h:${m.toString().padLeft(2, '0')} now, what time will it be in $add minutes?',
            '${newH == 0 ? 12 : newH}:${newM.toString().padLeft(2, '0')}',
            ['${newH == 0 ? 12 : newH}:${newM.toString().padLeft(2, '0')}',
             '$h:${(m + add).toString().padLeft(2, '0')}',
             '${newH + 1 > 12 ? 1 : newH + 1}:${newM.toString().padLeft(2, '0')}',
             '${newH == 0 ? 12 : newH}:00'], t, d, 4);
      }
      case MathTopic.wordProblems: {
        final a = _r(10, 50), c = _r(2, 5);
        return _mc(id, 'A baker has $a cookies. He puts them into boxes of $c. How many boxes does he need?',
            '${(a / c).ceil()}', _optsAround((a / c).ceil(), 3, 4).map((e) => e.toString()).toList(), t, d, 4);
      }
      default:
        return _grade3(id, t, d);
    }
  }

  // ── Grade 5 ──────────────────────────────────────────────────────
  static MathQuestion? _grade5(String id, MathTopic t, Difficulty d) {
    switch (t) {
      case MathTopic.fractions: {
        final den1 = _r(2, 5), den2 = _r(2, 5);
        if (den1 == den2) return _grade4(id, t, d);
        final n1 = _r(1, den1 - 1), n2 = _r(1, den2 - 1);
        final common = den1 * den2;
        final opt1 = '${n1 * den2 + n2 * den1}/$common';
        final opt2 = '${n1 * den2}/$common';
        final opt3 = '${n2 * den1}/$common';
        return _mc(id, '$n1/$den1 + $n2/$den2 = ?', opt1,
            [opt1, opt2, opt3, '${n1 + n2}/${den1 + den2}'], t, d, 5);
      }
      case MathTopic.decimals: {
        final a = _r(1, 99), b = _r(2, 10);
        final da = a / 10;
        final ans = (da * b).toStringAsFixed(1);
        return _mc(id, '$da × $b = ?', ans,
            [ans, (da * (b + 1)).toStringAsFixed(1), (da * (b - 1)).toStringAsFixed(1), (da * (b + 2)).toStringAsFixed(1)], t, d, 5);
      }
      case MathTopic.geometry: {
        final len = _r(3, 15), wid = _r(2, 10);
        return _mc(id, 'A rectangle is $len m by $wid m. What is the area?',
            '${len * wid} m²', _optsAround(len * wid, 5, 4).map((e) => '$e m²').toList(), t, d, 5);
      }
      case MathTopic.measurement: {
        final km = _r(1, 5);
        return _mc(id, '$km km = ___ m', '${km * 1000}',
            _optsAround(km * 1000, 500, 4).map((e) => e.toString()).toList(), t, d, 5,
            explanation: '1 km = 1000 m');
      }
      case MathTopic.division: return _genDivision(id, t, d, 5);
      case MathTopic.wordProblems: {
        final rate = _r(2, 8) * 5, hours = _r(2, 4);
        return _mc(id, 'A car travels $rate km per hour. How far does it go in $hours hours?',
            '${rate * hours} km', _optsAround(rate * hours, 10, 4).map((e) => '$e km').toList(), t, d, 5);
      }
      case MathTopic.money: {
        final p = _r(10, 99) / 100, q = _r(2, 10);
        final total = (p * q).toStringAsFixed(2);
        return _mc(id, 'One apple costs \$${p.toStringAsFixed(2)}. How much for $q apples?',
            '\$$total',
            ['\$$total', '\$${(p * (q + 1)).toStringAsFixed(2)}',
             '\$${(p * (q - 1)).toStringAsFixed(2)}', '\$${(p * 2).toStringAsFixed(2)}'], t, d, 5);
      }
      default:
        return _grade4(id, t, d);
    }
  }

  // ── Grade 6 ──────────────────────────────────────────────────────
  static MathQuestion? _grade6(String id, MathTopic t, Difficulty d) {
    switch (t) {
      case MathTopic.fractions: {
        final n1 = _r(1, 4), d1 = _r(5, 8), n2 = _r(1, 4), d2 = _r(5, 8);
        if (d1 == d2) return _grade5(id, t, d);
        final common = d1 * d2;
        final sumN = n1 * d2 + n2 * d1;
        final result = '$sumN/$common';
        return _mc(id, '$n1/$d1 + $n2/$d2 = ?', result,
            [result, '${n1 + n2}/${d1 + d2}', '${sumN * 2}/$common', '${n1 * d2}/${d1 * n2}'], t, d, 6);
      }
      case MathTopic.decimals: {
        final a = _r(1, 99) / 100, b = _r(1, 99) / 100;
        final diff = (a - b).abs();
        final ans = diff.toStringAsFixed(2);
        return _mc(id, 'What is ${a.toStringAsFixed(2)} − ${b.toStringAsFixed(2)}?', ans,
            [ans, (diff + 0.01).toStringAsFixed(2), (diff + 0.02).toStringAsFixed(2), '0.00'], t, d, 6);
      }
      case MathTopic.geometry: {
        final r = _r(2, 7);
        final area = (3.14 * r * r).round();
        return _mc(id, 'A circle has radius $r cm. What is the area (use π = 3.14)?',
            '$area cm²', _optsAround(area, 5, 4).map((e) => '$e cm²').toList(), t, d, 6,
            explanation: 'Area = π × r²');
      }
      case MathTopic.measurement: {
        final g = _r(500, 3000);
        final ans = (g / 1000).toStringAsFixed(1);
        return _mc(id, '$g g = ___ kg', ans,
            [ans, '${g * 1000}', '${g ~/ 1000}', '${g * 10}'], t, d, 6,
            explanation: '1000 g = 1 kg');
      }
      case MathTopic.division: return _genDivision(id, t, d, 6);
      case MathTopic.wordProblems: {
        final total = _r(100, 500);
        final percent = [10, 15, 20, 25][_rng.nextInt(4)];
        return _mc(id, 'A store has $total items. $percent% are sold. How many are sold?',
            '${total * percent ~/ 100}', _optsAround(total * percent ~/ 100, 10, 4).map((e) => e.toString()).toList(), t, d, 6);
      }
      case MathTopic.patterns: {
        final start = _r(1, 5), step = _r(2, 5);
        final terms = List.generate(4, (i) => start + i * step);
        return _mc(id, 'What is the next number? ${terms.join(', ')}, __',
            '${start + 4 * step}',
            ['${start + 4 * step}', '${start + 5 * step}', '${start + 3 * step}', '${start * 4}'], t, d, 6);
      }
      case MathTopic.money: {
        final rate = [5, 8, 10, 12][_rng.nextInt(4)];
        final yr = [1, 2, 3][_rng.nextInt(3)];
        final principal = _r(100, 500);
        final interest = principal * rate * yr ~/ 100;
        return _mc(id, 'You invest \$$principal at $rate% simple interest for $yr year${yr > 1 ? 's' : ''}. What is the interest?',
            '\$$interest', _optsAround(interest, 10, 4).map((e) => '\$$e').toList(), t, d, 6);
      }
      case MathTopic.addition: return _genAddition(id, t, d, 6);
      case MathTopic.subtraction: return _genSubtraction(id, t, d, 6);
      case MathTopic.multiplication: return _genMultiplication(id, t, d, 6);
      default:
        return _grade5(id, t, d);
    }
  }

  // ── Speed Challenge ──────────────────────────────────────────────
  static List<MathQuestion> generateSpeedChallenge(int grade, int count) {
    final topics = _speedTopics(grade);
    final seen = <String>{};
    final questions = <MathQuestion>[];

    for (int i = 0; i < count * 3 && questions.length < count; i++) {
      final topic = topics[_rng.nextInt(topics.length)];
      // Use medium difficulty by default for speed challenge — Medium = 2-digit numbers
      final d = Difficulty.medium;
      final q = _generateOne(grade, topic, d, i);
      if (q != null && seen.add(q.question)) {
        questions.add(q);
      }
    }
    return questions;
  }

  static List<MathTopic> _speedTopics(int grade) {
    switch (grade) {
      case 1: return [MathTopic.addition, MathTopic.subtraction, MathTopic.counting, MathTopic.numberRecognition];
      case 2: return [MathTopic.addition, MathTopic.subtraction, MathTopic.multiplication, MathTopic.placeValue];
      case 3: return [MathTopic.addition, MathTopic.subtraction, MathTopic.multiplication, MathTopic.division];
      case 4: return [MathTopic.multiplication, MathTopic.division, MathTopic.fractions, MathTopic.decimals];
      case 5: return [MathTopic.fractions, MathTopic.decimals, MathTopic.division, MathTopic.wordProblems];
      case 6: return [MathTopic.fractions, MathTopic.decimals, MathTopic.geometry, MathTopic.wordProblems];
      default: return [MathTopic.addition];
    }
  }

  /// Returns all topics that can generate questions for a given grade.
  static List<MathTopic> topicsForGrade(int grade) {
    switch (grade) {
      case 1: return [
        MathTopic.counting, MathTopic.numberRecognition, MathTopic.addition,
        MathTopic.subtraction, MathTopic.placeValue, MathTopic.patterns,
        MathTopic.geometry, MathTopic.time, MathTopic.measurement,
        MathTopic.money, MathTopic.wordProblems,
      ];
      case 2: return [
        MathTopic.addition, MathTopic.subtraction, MathTopic.multiplication,
        MathTopic.division, MathTopic.placeValue, MathTopic.time,
        MathTopic.money, MathTopic.measurement, MathTopic.geometry,
        MathTopic.fractions, MathTopic.patterns, MathTopic.wordProblems,
      ];
      case 3: return [
        MathTopic.addition, MathTopic.subtraction, MathTopic.multiplication,
        MathTopic.division, MathTopic.fractions, MathTopic.time,
        MathTopic.measurement, MathTopic.geometry, MathTopic.decimals,
        MathTopic.placeValue, MathTopic.wordProblems,
      ];
      case 4: return [
        MathTopic.multiplication, MathTopic.division, MathTopic.addition,
        MathTopic.subtraction, MathTopic.fractions, MathTopic.decimals,
        MathTopic.geometry, MathTopic.measurement, MathTopic.money,
        MathTopic.time, MathTopic.wordProblems,
      ];
      case 5: return [
        MathTopic.fractions, MathTopic.decimals, MathTopic.geometry,
        MathTopic.measurement, MathTopic.division, MathTopic.wordProblems,
        MathTopic.money,
      ];
      case 6: return [
        MathTopic.fractions, MathTopic.decimals, MathTopic.geometry,
        MathTopic.measurement, MathTopic.division, MathTopic.wordProblems,
        MathTopic.patterns, MathTopic.money, MathTopic.addition,
        MathTopic.subtraction, MathTopic.multiplication,
      ];
      default: return MathTopic.values.toList();
    }
  }
}