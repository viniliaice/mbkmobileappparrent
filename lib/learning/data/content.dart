import 'package:flutter/material.dart';
import '../models/topic.dart';
import '../models/vocab_word.dart';
import '../models/geo_shape.dart';
import 'helpers.dart';

class LearningContent {

  static List<LearningTopic> get mathematics =>
      _mathTopics.map((t) => t.toTopic()).toList();

  static List<LearningTopic> get english =>
      _englishTopics.map((t) => t.toTopic()).toList();

  static List<LearningTopic> topicsForSubject(bool isMath) =>
      isMath ? mathematics : english;

  static final List<T> _mathTopics = [
    _countingTopic,
    _numberRecognitionTopic,
    _additionTopic,
    _subtractionTopic,
    _multiplicationTopic,
    _divisionTopic,
    _fractionsTopic,
    _decimalsTopic,
    _timeTopic,
    _moneyTopic,
    _measurementTopic,
    _geometryTopic,
    _patternsTopic,
    _wordProblemsTopic,
    _placeValueTopic,
  ];

  // 1. Counting
  static final _countingTopic = T(
    id: 'counting', title: 'Counting', description: 'Learn to count objects and numbers step by step.',
    icon: Icons.numbers, color: Colors.blue, order: 1,
    lessons: [
      L('c_1', 'Counting 1 to 5', 'Count objects from 1 up to 5.', 'Touch each object once and say one number. 1, 2, 3, 4, 5.', 'Little Counter', '🍎', activities: [
        A.tap('c1_a1', 'How many apples? 🍎🍎🍎', 'Count them one by one.', ['2','3','4','5'], '3'),
        A.mc('c1_a2', 'What comes after 3?', 'Say: 1, 2, 3, 4...', ['2','4','5','6'], '4'),
        A.tap('c1_a3', 'How many fingers on one hand?', 'Hold up your hand and count.', ['4','5','6','10'], '5'),
        A.fb('c1_a4', 'Fill in: 1, 2, 3, __, 5', 'What comes after 3?', ['4','1','2','6'], '4'),
      ], xp: 50),
      L('c_2', 'Counting 1 to 10', 'Count objects from 1 up to 10.', 'We keep counting after 5: 6, 7, 8, 9, 10.', 'Number Explorer', '⭐', activities: [
        A.mc('c2_a1', 'Count the stars: ⭐⭐⭐⭐⭐⭐⭐', 'Count each star.', ['5','6','7','8'], '7'),
        A.mc('c2_a2', 'What number is one less than ten?', 'Think 10 - 1.', ['8','9','10','11'], '9'),
        A.tap('c2_a3', 'Count: ⚫⚫⚫⚫⚫⚫⚫⚫', 'Eight dots total.', ['6','7','8','9'], '8'),
        A.drag('c2_a4', 'Order smallest to biggest: 5, 2, 8, 4', 'Start with the smallest.', ['2','4','5','8'], '2,4,5,8'),
      ], xp: 55),
      L('c_3', 'Counting 11 to 20', 'Count objects from 11 up to 20.', 'After 10 we say eleven, twelve, thirteen... twenty.', 'Big Counter', '🎈', activities: [
        A.mc('c3_a1', 'What comes after 12?', '11, 12, 13...', ['11','13','14','15'], '13'),
        A.tap('c3_a2', 'Count to 15', 'Fifteen comes after fourteen.', ['12','13','14','15'], '15'),
        A.fb('c3_a3', '17, 18, __, 20', 'What is between 18 and 20?', ['17','19','16','21'], '19'),
        A.nl('c3_a4', 'Tap 16 on the number line.', 'Sixteen is between 10 and 20.', ['16'], '16'),
      ], xp: 60),
      L('c_4', 'Counting by 2s', 'Skip count by 2 to find even numbers.', '2, 4, 6, 8... we add 2 every time!', 'Skip Hero', '🦵', activities: [
        A.mc('c4_a1', '2, 4, 6, 8, __?', 'Add 2 each time.', ['9','10','11','12'], '10'),
        A.mc('c4_a2', 'What is 5 groups of 2?', '5 × 2 = ?', ['7','10','12','15'], '10'),
        A.fb('c4_a3', '__, 4, 6, 8', 'What comes first when counting by 2s?', ['1','2','3','5'], '2'),
        A.drag('c4_a4', 'Order these evens: 6, 2, 8, 4', 'Count by 2s.', ['2','4','6','8'], '2,4,6,8'),
      ], xp: 60),
      L('c_5', 'Counting by 5s', 'Skip count by 5.', '5, 10, 15, 20... each time we add 5.', 'Five Star', '⭐⭐⭐', activities: [
        A.mc('c5_a1', '5, 10, 15, __?', 'Add 5 each time.', ['18','19','20','25'], '20'),
        A.mc('c5_a2', 'How many fingers on two hands?', '5 × 2 = ?', ['8','10','12','15'], '10'),
        A.fb('c5_a3', '__, 10, 15', 'Beginning of count by 5s.', ['1','5','10','20'], '5'),
        A.tap('c5_a4', 'Count in 5s to 20: ⭐⭐⭐⭐×5', '4 sets of 5 stars.', ['15','20','25','30'], '20'),
      ], xp: 65),
      L('c_6', 'Counting by 10s', 'Skip count by 10.', '10, 20, 30, 40... we add 10 each time.', 'Ten Power', '🔟', activities: [
        A.mc('c6_a1', '10, 20, 30, __?', 'Add 10.', ['35','40','45','50'], '40'),
        A.mc('c6_a2', 'How many toes on ten feet?', '10 × 10 = ?', ['50','80','100','10'], '100'),
        A.fb('c6_a3', '50, 60, 70, __', 'Next multiple of 10.', ['75','80','85','90'], '80'),
        A.drag('c6_a4', 'Order: 30, 10, 50, 20 by 10s', 'Count by tens.', ['10','20','30','50'], '10,20,30,50'),
      ], xp: 65),
      L('c_7', 'Counting to 50', 'Count all the way to 50.', 'From 20 to 50: 21, 22, 23...', 'Half Hundred', '🎂', activities: [
        A.mc('c7_a1', 'What comes after 39?', 'Almost forty.', ['38','40','41','50'], '40'),
        A.fb('c7_a2', '48, 49, __, 51', 'The missing number.', ['47','50','51','52'], '50'),
        A.nl('c7_a3', 'Tap 35 on a 0-50 number line.', '35 is between 30 and 40.', ['35'], '35'),
        A.mc('c7_a4', 'How many groups of 10 in 50?', '50 ÷ 10 = ?', ['3','4','5','6'], '5'),
      ], xp: 70),
      L('c_8', 'Counting to 100', 'Count all the way to 100.', 'Numbers go up to one hundred!', 'Century Counter', '💯', activities: [
        A.mc('c8_a1', 'What is ten more than 90?', '90 + 10.', ['91','99','100','110'], '100'),
        A.fb('c8_a2', '98, 99, __', 'Just one more!', ['99','100','101','200'], '100'),
        A.mp('c8_a3', 'Match tens to words', '', ['10=ten','20=twenty','30=thirty','100=one hundred'], '10=ten,20=twenty,30=thirty,100=one hundred'),
        A.mc('c8_a4', '100 is how many tens?', 'Count by 10s to 100.', ['5','8','10','100'], '10'),
      ], xp: 70),
      L('c_9', 'Counting Backwards', 'Count backwards from small numbers.', 'We can count back too! 10, 9, 8, 7...', 'Reverse Ruler', '↩️', activities: [
        A.mc('c9_a1', 'What number comes before 10?', 'One less than 10.', ['8','9','10','11'], '9'),
        A.fb('c9_a2', '5, 4, __, 2, 1', 'What goes in the middle?', ['3','5','6','0'], '3'),
        A.mc('c9_a3', 'Count back from 7: 7, 6, 5, __', 'Keep going down.', ['2','3','4','5'], '4'),
        A.drag('c9_a4', 'Order biggest to smallest: 3, 9, 1, 6', 'Reverse order.', ['9','6','3','1'], '9,6,3,1'),
      ], xp: 70),
      L('c_10', 'Counting in Different Ways', 'Use different strategies to count.', 'You can count by 1s, 2s, 5s, or 10s.', 'Counting Wizard', '🎩', activities: [
        A.mc('c10_a1', 'Fastest way to count 20 jellybeans?', 'Count by tens!', ['1s','2s','5s','10s'], '10s'),
        A.fb('c10_a2', 'Count back by tens: 100, 90, __, 70', 'Subtract 10 each time.', ['80','70','60','50'], '80'),
        A.mc('c10_a3', 'How many pairs of socks in 8 socks?', 'A pair is 2.', ['3','4','6','8'], '4'),
        A.tap('c10_a4', 'Total stars: ⭐⭐ ⭐⭐ ⭐⭐ ⭐⭐', 'Count in 2s.', ['6','7','8','10'], '8'),
      ], xp: 80),
    ],
  );

  // 2. Number Recognition
  static final _numberRecognitionTopic = T(
    id: 'number_recognition', title: 'Number Recognition', description: 'Recognize numbers and understand what they mean.',
    icon: Icons.dialpad, color: Colors.indigo, order: 2,
    lessons: [
      L('nr_1', 'Numbers 1-10', 'Match numerals to quantities.', 'A number tells us how many. 5 means five things.', 'Number Pup', '🔢', activities: [
        A.mc('nr1_a1', 'Which number means five fingers?', 'Pick the numeral five.', ['2','4','5','7'], '5'),
        A.mp('nr1_a2', 'Match numbers to pictures', '', ['5=✋','7=🌟','9=🎈','3=🐟'], '5=✋,7=🌟,9=🎈,3=🐟'),
        A.tap('nr1_a3', 'Show me the number 8', 'Tap eight.', ['6','8','9','0'], '8'),
        A.fb('nr1_a4', 'The number after 3 is __', 'Count: 1, 2, 3...', ['4','5','6','7'], '4'),
      ], xp: 50),
      L('nr_2', 'Numbers 11-20', 'Recognize teen numbers.', '11 means 10 plus 1. 15 means 10 plus 5.', 'Teen Teaser', '🧒', activities: [
        A.mc('nr2_a1', 'What is 10 + 4?', 'Ten plus four.', ['13','14','15','16'], '14'),
        A.tap('nr2_a2', 'Pick sixteen', '', ['6','15','16','17'], '16'),
        A.fb('nr2_a3', '13 = ten and __', '13 = 10 + 3.', ['3','4','5','6'], '3'),
        A.mc('nr2_a4', 'Which is greatest: 14, 19, 12, 17?', 'Pick the biggest.', ['14','19','12','17'], '19'),
      ], xp: 55),
      L('nr_3', 'Number Words', 'Read number words and match to numerals.', '"Seven" means the number 7.', 'Word Reader', '🔤', activities: [
        A.mc('nr3_a1', 'Which number is "four"?', 'The word four = 4.', ['3','4','5','6'], '4'),
        A.mp('nr3_a2', 'Match word to numeral', '', ['one=1','two=2','three=3','four=4'], 'one=1,two=2,three=3,four=4'),
        A.mc('nr3_a3', 'What number is "eleven"?', 'Eleven comes after ten.', ['10','11','12','13'], '11'),
        A.fb('nr3_a4', '"twelve" = __', 'After eleven.', ['10','11','12','13'], '12'),
      ], xp: 60),
      L('nr_4', 'Comparing Numbers', 'Use more, less, and equal.', 'Bigger number = more.', 'Compare Champ', '⚖️', activities: [
        A.mc('nr4_a1', 'Which is more: 7 or 4?', '7 is bigger.', ['4','7','same'], '7'),
        A.mc('nr4_a2', 'Which is less: 9 or 6?', '6 is smaller.', ['6','9','same'], '6'),
        A.fb('nr4_a3', '8 ___ 8 (>, <, or =)', 'Same numbers.', ['>','<','='], '='),
        A.mc('nr4_a4', '12 is more than which?', 'Find a number less than 12.', ['10','11','20','100'], '11'),
      ], xp: 60),
      L('nr_5', 'Even and Odd', 'Sort numbers into even and odd.', 'Even ends in 0,2,4,6,8. Odd ends in 1,3,5,7,9.', 'Odd Buddy', '🎲', activities: [
        A.mc('nr5_a1', 'Is 6 even?', '6 ends in 6.', ['Even','Odd'], 'Even'),
        A.mc('nr5_a2', 'Is 7 odd?', '7 ends in 7.', ['Even','Odd'], 'Odd'),
        A.tap('nr5_a3', 'Pick the even number', '', ['4','5','7','9'], '4'),
        A.drag('nr5_a4', 'Sort evens then odds: 2, 5, 8, 7', '', ['2','8','5','7'], '2,8,5,7'),
      ], xp: 60),
      L('nr_6', 'Number Order to 100', 'Place numbers in the correct order.', 'Smallest to biggest, or biggest to smallest.', 'Order Owl', '🦉', activities: [
        A.drag('nr6_a1', 'Smallest to biggest: 45, 12, 78, 33', '', ['12','33','45','78'], '12,33,45,78'),
        A.mc('nr6_a2', 'Which number is between 49 and 51?', 'Think: 49, __, 51.', ['48','50','52','60'], '50'),
        A.tap('nr6_a3', 'Pick a number bigger than 50', '', ['40','45','60','30'], '60'),
        A.fb('nr6_a4', '__, 35, 36, 37', 'Before 35.', ['33','34','38','39'], '34'),
      ], xp: 65),
      L('nr_7', 'Place Value: Tens & Ones', 'Understand tens and ones.', '32 = 3 tens and 2 ones.', 'Place Pup', '🏠', activities: [
        A.mc('nr7_a1', 'In 45, how many tens?', 'First digit.', ['4','5','45','0'], '4'),
        A.mc('nr7_a2', 'In 83, how many ones?', 'Second digit.', ['3','8','80','83'], '3'),
        A.fb('nr7_a3', '5 tens and 7 ones = __', '50 + 7 = ?', ['57','75','50','7'], '57'),
        A.mp('nr7_a4', 'Match number to tens/ones', '', ['23=2t3o','47=4t7o','56=5t6o','71=7t1o'], '23=2t3o,47=4t7o,56=5t6o,71=7t1o'),
      ], xp: 70),
      L('nr_8', 'Three-Digit Numbers', 'Read 3-digit numbers.', 'Hundreds, tens, ones. 632 is 6 hundreds, 3 tens, 2 ones.', 'Big Bear', '🐻', activities: [
        A.mc('nr8_a1', 'How many digits in 632?', 'Count them.', ['2','3','4','5'], '3'),
        A.mc('nr8_a2', 'In 528, what is the tens digit?', 'Middle digit.', ['5','2','8','52'], '2'),
        A.fb('nr8_a3', '3 hundreds + 4 tens + 5 ones = __', '300 + 40 + 5 = ?', ['345','354','435','534'], '345'),
        A.nl('nr8_a4', 'Tap 750 on 0-1000 line.', '75% of 1000.', ['750'], '750'),
      ], xp: 75),
      L('nr_9', 'Ordinal Numbers', 'Use first, second, third...', 'Ordinal numbers tell position in a line.', 'Orderly', '🦦', activities: [
        A.mc('nr9_a1', 'You are 1st. Who is behind you?', 'Next in line.', ['1st','2nd','3rd','4th'], '2nd'),
        A.mc('nr9_a2', '5th position means?', 'Fifth from start.', ['five items','fifth','last','middle'], 'fifth'),
        A.drag('nr9_a3', 'Order: 1st, 4th, 2nd, 3rd', '', ['1st','2nd','3rd','4th'], '1st,2nd,3rd,4th'),
        A.fb('nr9_a4', 'After 7th comes __', 'One more.', ['8th','9th','1st','17th'], '8th'),
      ], xp: 70),
      L('nr_10', 'Number Puzzles', 'Mix of number challenges.', 'Practice all your number skills.', 'Number Ninja', '🥷', activities: [
        A.mc('nr10_a1', 'Pick the ODD number', '', ['2','6','9','8'], '9'),
        A.fb('nr10_a2', '1000 has __ zeros', 'Count them.', ['1','2','3','4'], '3'),
        A.mc('nr10_a3', 'Smallest 3-digit number?', 'Think 100.', ['100','999','010','001'], '100'),
        A.tap('nr10_a4', 'Pick the number fifty', '', ['15','50','25','5'], '50'),
      ], xp: 80),
    ],
  );

  // 3. Addition
  static final _additionTopic = T(
    id: 'addition', title: 'Addition', description: 'Learn to add numbers together.',
    icon: Icons.add, color: Colors.green, order: 3,
    lessons: [
      L('add_1', 'Adding 1', 'Add 1 to numbers up to 10.', 'Adding 1 means counting forward by one.', 'Plus One', '➕', activities: [
        A.mc('add1_a1', '3 + 1 = ?', 'Count: 3... then one more.', ['2','3','4','5'], '4'),
        A.tap('add1_a2', '5 + 1 = ?', 'One more than five.', ['4','5','6','7'], '6'),
        A.fb('add1_a3', '7 + 1 = __', 'One more than seven.', ['6','7','8','9'], '8'),
        A.mc('add1_a4', '9 + 1 = ?', 'Count up from nine.', ['8','9','10','11'], '10'),
      ], xp: 50),
      L('add_2', 'Sums to 5', 'Add numbers whose sum is up to 5.', 'Put groups together and count the total.', 'Tiny Totals', '🐣', activities: [
        A.mc('add2_a1', '2 + 3 = ?', 'Count: 2... 3, 4, 5.', ['4','5','6','7'], '5'),
        A.tap('add2_a2', '1 + 4 = ?', 'Start at 1, count four more.', ['3','4','5','6'], '5'),
        A.fb('add2_a3', '3 + 2 = __', '3 plus 2.', ['4','5','6','7'], '5'),
        A.mc('add2_a4', '1 + 1 = ?', 'One plus one.', ['1','2','3','4'], '2'),
      ], xp: 50),
      L('add_3', 'Sums to 10', 'Add numbers whose sum is up to 10.', 'Count both groups together.', 'Sum Seeker', '🔍', activities: [
        A.mc('add3_a1', '4 + 3 = ?', 'Count: 4, 5, 6, 7.', ['6','7','8','9'], '7'),
        A.mp('add3_a2', 'Match equation to sum', '', ['5+3=8','6+2=8','7+1=8','4+4=8'], '5+3=8,6+2=8,7+1=8,4+4=8'),
        A.fb('add3_a3', '6 + 4 = __', '6 plus 4.', ['8','9','10','11'], '10'),
        A.mc('add3_a4', '8 + 2 = ?', 'Eight plus two.', ['9','10','11','12'], '10'),
      ], xp: 55),
      L('add_4', 'Adding Zero', 'Add zero to any number.', 'Adding zero does not change the number.', 'Zero Hero', '0️⃣', activities: [
        A.mc('add4_a1', '5 + 0 = ?', 'Add nothing.', ['0','5','10','50'], '5'),
        A.mc('add4_a2', '0 + 9 = ?', 'Nine + nothing.', ['0','9','10','90'], '9'),
        A.fb('add4_a3', '3 + 0 = __', 'Three + nothing.', ['0','3','30','4'], '3'),
        A.tap('add4_a4', '7 + 0 = ?', 'Seven + zero.', ['0','7','8','70'], '7'),
      ], xp: 55),
      L('add_5', 'Sums to 20', 'Add numbers with sums up to 20.', 'Use your fingers or mental math.', 'Twenty Total', '🔢', activities: [
        A.mc('add5_a1', '10 + 5 = ?', 'Ten plus five.', ['5','10','15','20'], '15'),
        A.mc('add5_a2', '12 + 6 = ?', 'Twelve + six.', ['16','17','18','19'], '18'),
        A.fb('add5_a3', '9 + 9 = __', 'Double nine.', ['16','17','18','19'], '18'),
        A.nl('add5_a4', 'Show 7 + 8 on a number line.', 'Start at 7, jump 8.', ['15'], '15'),
      ], xp: 60),
      L('add_6', 'Three Numbers', 'Add three small numbers together.', 'Add the first two, then add the third.', 'Triple Add', '3️⃣', activities: [
        A.mc('add6_a1', '1 + 2 + 3 = ?', '1+2=3, then 3+3=?', ['5','6','7','8'], '6'),
        A.mc('add6_a2', '2 + 2 + 2 = ?', 'Three twos.', ['4','5','6','7'], '6'),
        A.fb('add6_a3', '4 + 1 + 3 = __', '4+1=5, then 5+3=?', ['7','8','9','10'], '8'),
        A.drag('add6_a4', 'Order sums: 2+3, 5+5, 1+1, 4+4', '', ['1+1','2+3','4+4','5+5'], '1+1,2+3,4+4,5+5'),
      ], xp: 65),
      L('add_7', 'Doubles', 'Add a number to itself.', 'Doubles: 1+1=2, 2+2=4, 3+3=6...', 'Double Dutch', '✌️', activities: [
        A.mc('add7_a1', '4 + 4 = ?', 'Double four.', ['6','7','8','9'], '8'),
        A.mc('add7_a2', '6 + 6 = ?', 'Double six.', ['10','11','12','13'], '12'),
        A.fb('add7_a3', '7 + 7 = __', 'Double seven.', ['13','14','15','16'], '14'),
        A.tap('add7_a4', 'What is double 5?', '5+5=?', ['8','9','10','11'], '10'),
      ], xp: 65),
      L('add_8', 'Near Doubles', 'Add close numbers using doubles.', 'If 5+5=10, then 5+6=11 — just one more.', 'Near Double', '🎯', activities: [
        A.mc('add8_a1', '5 + 6 = ?', 'Double 5 is 10, then +1.', ['10','11','12','13'], '11'),
        A.mc('add8_a2', '7 + 8 = ?', 'Double 7 is 14, then +1.', ['13','14','15','16'], '15'),
        A.fb('add8_a3', '4 + 5 = __', 'Double 4 is 8, then +1.', ['8','9','10','11'], '9'),
        A.mc('add8_a4', '9 + 10 = ?', 'Double 9 is 18, then +1.', ['17','18','19','20'], '19'),
      ], xp: 70),
      L('add_9', 'Adding Tens', 'Add numbers ending in 0.', '20 + 30 = 50 — just add the tens digits.', 'Tens Together', '🔟', activities: [
        A.mc('add9_a1', '20 + 30 = ?', '2 tens + 3 tens.', ['40','50','60','70'], '50'),
        A.mc('add9_a2', '40 + 50 = ?', '4 tens + 5 tens.', ['80','90','100','110'], '90'),
        A.fb('add9_a3', '10 + 70 = __', '1 ten + 7 tens.', ['70','80','90','100'], '80'),
        A.tap('add9_a4', '60 + 30 = ?', '6 tens + 3 tens.', ['80','90','100','110'], '90'),
      ], xp: 70),
      L('add_10', 'Addition Word Problems', 'Solve simple addition story problems.', 'Read carefully, then add to find the answer.', 'Story Adder', '📖', activities: [
        A.mc('add10_a1', '3 apples + 2 more = ?', '3+2=?', ['4','5','6','7'], '5'),
        A.mc('add10_a2', '5 birds + 3 more = ?', '5+3=?', ['7','8','9','10'], '8'),
        A.fb('add10_a3', '2 cats + 2 cats = __', '2+2=?', ['3','4','5','6'], '4'),
        A.tap('add10_a4', '4 red cars + 3 blue cars = ?', '4+3=?', ['6','7','8','9'], '7'),
      ], xp: 75),
    ],
  );

  // 4. Subtraction
  static final _subtractionTopic = T(
    id: 'subtraction', title: 'Subtraction', description: 'Learn to take away numbers.',
    icon: Icons.remove, color: Colors.red, order: 4,
    lessons: [
      L('sub_1', 'Subtracting 1', 'Subtract 1 from numbers up to 10.', 'Taking 1 away means counting backwards by one.', 'Minus One', '➖', activities: [
        A.mc('sub1_a1', '5 - 1 = ?', 'Count back from 5.', ['3','4','5','6'], '4'),
        A.tap('sub1_a2', '7 - 1 = ?', 'One less than seven.', ['5','6','7','8'], '6'),
        A.fb('sub1_a3', '4 - 1 = __', 'Take one from four.', ['2','3','4','5'], '3'),
        A.mc('sub1_a4', '10 - 1 = ?', 'One less than ten.', ['8','9','10','11'], '9'),
      ], xp: 50),
      L('sub_2', 'Subtract from 5', 'Subtract small numbers from up to 5.', 'Take away and count what is left.', 'Take Away', '🧸', activities: [
        A.mc('sub2_a1', '5 - 2 = ?', 'Start at 5, take 2.', ['2','3','4','5'], '3'),
        A.tap('sub2_a2', '4 - 1 = ?', 'Four take away one.', ['2','3','4','5'], '3'),
        A.fb('sub2_a3', '3 - 2 = __', 'Three take away two.', ['0','1','2','3'], '1'),
        A.mc('sub2_a4', '5 - 5 = ?', 'Take all away.', ['0','1','5','10'], '0'),
      ], xp: 50),
      L('sub_3', 'Subtract from 10', 'Subtract numbers from up to 10.', 'Take away and count what remains.', 'Minus Master', '🎯', activities: [
        A.mc('sub3_a1', '8 - 3 = ?', 'Start at 8, count back 3.', ['4','5','6','7'], '5'),
        A.mc('sub3_a2', '9 - 4 = ?', 'Nine take away four.', ['4','5','6','7'], '5'),
        A.fb('sub3_a3', '7 - 5 = __', 'Seven minus five.', ['1','2','3','4'], '2'),
        A.nl('sub3_a4', 'Show 10 - 4 on a number line.', 'Start at 10, go back 4.', ['6'], '6'),
      ], xp: 55),
      L('sub_4', 'Subtract with Zero', 'Subtract zero or subtract all.', 'Taking zero away leaves the same number.', 'Zero Hero', '0️⃣', activities: [
        A.mc('sub4_a1', '6 - 0 = ?', 'Take nothing away.', ['0','6','60','1'], '6'),
        A.mc('sub4_a2', '7 - 7 = ?', 'Take all away.', ['0','7','1','14'], '0'),
        A.fb('sub4_a3', '4 - 0 = __', 'Four take away nothing.', ['0','4','40','5'], '4'),
        A.tap('sub4_a4', '9 - 9 = ?', 'Take all nine away.', ['0','9','1','18'], '0'),
      ], xp: 55),
      L('sub_5', 'Subtract from 20', 'Subtract numbers from up to 20.', 'Use mental math to find the difference.', 'Twenty Minus', '🔢', activities: [
        A.mc('sub5_a1', '15 - 5 = ?', 'Fifteen minus five.', ['5','10','15','20'], '10'),
        A.mc('sub5_a2', '18 - 6 = ?', 'Eighteen minus six.', ['10','11','12','13'], '12'),
        A.fb('sub5_a3', '20 - 10 = __', 'Twenty minus ten.', ['5','10','15','20'], '10'),
        A.mc('sub5_a4', '14 - 7 = ?', 'Fourteen minus seven.', ['6','7','8','9'], '7'),
      ], xp: 60),
      L('sub_6', 'Subtract Tens', 'Subtract numbers ending in 0.', '50 - 20 = 30 — just subtract the tens digits.', 'Tens Takeaway', '🔟', activities: [
        A.mc('sub6_a1', '50 - 30 = ?', '5 tens minus 3 tens.', ['10','20','30','40'], '20'),
        A.mc('sub6_a2', '80 - 50 = ?', '8 tens minus 5 tens.', ['20','30','40','50'], '30'),
        A.fb('sub6_a3', '60 - 40 = __', '6 tens minus 4 tens.', ['10','20','30','40'], '20'),
        A.tap('sub6_a4', '90 - 60 = ?', '9 tens minus 6 tens.', ['20','30','40','50'], '30'),
      ], xp: 65),
      L('sub_7', 'Find the Difference', 'Find how much more or less.', 'Difference = subtract the smaller from the bigger.', 'Difference', '📏', activities: [
        A.mc('sub7_a1', 'How much more is 8 than 5?', '8 - 5 = ?', ['2','3','4','5'], '3'),
        A.mc('sub7_a2', 'How much less is 3 than 9?', '9 - 3 = ?', ['4','5','6','7'], '6'),
        A.fb('sub7_a3', 'Difference between 10 and 7 = __', '10 - 7 = ?', ['2','3','4','5'], '3'),
        A.mc('sub7_a4', 'You have 12 toys. Friend has 7. How many more?', '12 - 7 = ?', ['4','5','6','7'], '5'),
      ], xp: 70),
      L('sub_8', 'Number Line Subtraction', 'Use a number line to subtract.', 'Start at the big number and jump backwards.', 'Line Jumper', '↩️', activities: [
        A.nl('sub8_a1', 'Show 11 - 3 on a number line.', 'Start at 11, back 3.', ['8'], '8'),
        A.mc('sub8_a2', 'Start at 16, jump back 7. Land at?', '16 - 7 = ?', ['7','8','9','10'], '9'),
        A.nl('sub8_a3', 'Show 13 - 5 on a number line.', 'Start at 13, back 5.', ['8'], '8'),
        A.fb('sub8_a4', '19 - 9 = __', 'Start at 19, back 9.', ['9','10','11','12'], '10'),
      ], xp: 70),
      L('sub_9', 'Related Facts', 'Understand how +/- are related.', 'If 5 + 3 = 8, then 8 - 3 = 5.', 'Fact Family', '👪', activities: [
        A.mc('sub9_a1', 'If 4+2=6, what is 6-2?', 'Think backwards.', ['2','4','6','8'], '4'),
        A.mc('sub9_a2', 'If 7+3=10, what is 10-3?', 'Backwards.', ['3','7','10','13'], '7'),
        A.fb('sub9_a3', '8+5=13, so 13-5=__', 'Related fact.', ['5','8','13','18'], '8'),
        A.mp('sub9_a4', 'Match related facts', '', ['5+3=8—8-3=5','6+4=10—10-4=6','2+7=9—9-7=2','1+9=10—10-9=1'], '5+3=8—8-3=5,6+4=10—10-4=6,2+7=9—9-7=2,1+9=10—10-9=1'),
      ], xp: 70),
      L('sub_10', 'Subtraction Word Problems', 'Solve simple subtraction stories.', 'Read carefully and take away.', 'Story Subtract', '📖', activities: [
        A.mc('sub10_a1', '8 cookies, eat 3. Left?', '8-3=?', ['4','5','6','7'], '5'),
        A.mc('sub10_a2', '10 balloons, 4 fly away. Remain?', '10-4=?', ['5','6','7','8'], '6'),
        A.fb('sub10_a3', '6 ducks, 2 swim away. __ left.', '6-2=?', ['2','3','4','5'], '4'),
        A.tap('sub10_a4', '7 birds, 1 flies away. How many stay?', '7-1=?', ['5','6','7','8'], '6'),
      ], xp: 75),
    ],
  );

  // 5. Multiplication
  static final _multiplicationTopic = T(
    id: 'multiplication', title: 'Multiplication', description: 'Learn to multiply numbers in groups.',
    icon: Icons.close, color: Colors.orange, order: 5,
    lessons: [
      L('mul_1', 'Repeated Addition', 'Multiplication as adding the same number.', '3 × 4 means 4 + 4 + 4.', 'Repeat Adder', '🔄', activities: [
        A.mc('mul1_a1', '3 × 2 = ?', '2+2+2=?', ['5','6','7','8'], '6'),
        A.mc('mul1_a2', '4 × 3 = ?', '3+3+3+3=?', ['10','11','12','13'], '12'),
        A.fb('mul1_a3', '2 × 5 = __', '5+5=?', ['7','10','12','15'], '10'),
        A.tap('mul1_a4', '5 × 2 = ?', '2+2+2+2+2=?', ['8','10','12','14'], '10'),
      ], xp: 60),
      L('mul_2', 'Times 2', 'Learn the 2 times table.', '2, 4, 6, 8, 10, 12, 14, 16, 18, 20.', 'Two Timer', '✌️', activities: [
        A.mc('mul2_a1', '2 × 4 = ?', '2, 4, 6, 8.', ['6','8','10','12'], '8'),
        A.mc('mul2_a2', '2 × 7 = ?', 'Count by 2s to 14.', ['12','14','16','18'], '14'),
        A.fb('mul2_a3', '2 × 9 = __', 'Two times nine.', ['16','18','20','22'], '18'),
        A.mc('mul2_a4', '2 × 1 = ?', 'Two once.', ['1','2','3','4'], '2'),
      ], xp: 65),
      L('mul_3', 'Times 5', 'Learn the 5 times table.', '5, 10, 15, 20, 25, 30, 35, 40, 45, 50.', 'Five Times', '🖐️', activities: [
        A.mc('mul3_a1', '5 × 3 = ?', '5, 10, 15.', ['10','15','20','25'], '15'),
        A.mc('mul3_a2', '5 × 6 = ?', 'Count by 5s to 30.', ['25','30','35','40'], '30'),
        A.fb('mul3_a3', '5 × 8 = __', 'Five times eight.', ['35','40','45','50'], '40'),
        A.mc('mul3_a4', '5 × 10 = ?', 'Five times ten.', ['45','50','55','60'], '50'),
      ], xp: 65),
      L('mul_4', 'Times 10', 'Learn the 10 times table.', '10, 20, 30, 40, 50, 60, 70, 80, 90, 100.', 'Ten Times', '🔟', activities: [
        A.mc('mul4_a1', '10 × 4 = ?', '10, 20, 30, 40.', ['30','40','50','60'], '40'),
        A.mc('mul4_a2', '10 × 7 = ?', 'Count by 10s to 70.', ['60','70','80','90'], '70'),
        A.fb('mul4_a3', '10 × 9 = __', 'Ten times nine.', ['80','90','100','110'], '90'),
        A.tap('mul4_a4', '10 × 10 = ?', 'Ten times ten.', ['100','110','1000','10'], '100'),
      ], xp: 65),
      L('mul_5', 'Times 3', 'Learn the 3 times table.', '3, 6, 9, 12, 15, 18, 21, 24, 27, 30.', 'Three Times', '3️⃣', activities: [
        A.mc('mul5_a1', '3 × 4 = ?', '3, 6, 9, 12.', ['9','12','15','18'], '12'),
        A.mc('mul5_a2', '3 × 7 = ?', 'Count by 3s to 21.', ['18','21','24','27'], '21'),
        A.fb('mul5_a3', '3 × 6 = __', 'Three times six.', ['15','18','21','24'], '18'),
        A.mc('mul5_a4', '3 × 1 = ?', 'Three once.', ['1','3','6','9'], '3'),
      ], xp: 70),
      L('mul_6', 'Times 4', 'Learn the 4 times table.', '4, 8, 12, 16, 20, 24, 28, 32, 36, 40.', 'Four Times', '4️⃣', activities: [
        A.mc('mul6_a1', '4 × 5 = ?', '4, 8, 12, 16, 20.', ['16','20','24','28'], '20'),
        A.mc('mul6_a2', '4 × 8 = ?', 'Count by 4s to 32.', ['28','32','36','40'], '32'),
        A.fb('mul6_a3', '4 × 6 = __', 'Four times six.', ['20','24','28','32'], '24'),
        A.mc('mul6_a4', '4 × 10 = ?', 'Four times ten.', ['40','44','45','50'], '40'),
      ], xp: 70),
      L('mul_7', 'Arrays', 'Use rows and columns to multiply.', '3 rows of 4 = 3 × 4 = 12.', 'Array Ray', '🔲', activities: [
        A.mc('mul7_a1', '2 rows of 6. Total?', '2×6=?', ['8','10','12','14'], '12'),
        A.mc('mul7_a2', '3 rows of 5 = ?', '3×5=?', ['12','15','18','20'], '15'),
        A.fb('mul7_a3', '4 rows of 2 = __', '4×2=?', ['6','8','10','12'], '8'),
        A.mp('mul7_a4', 'Match array to equation', '', ['2×3=6','3×4=12','5×2=10','4×3=12'], '2×3=6,3×4=12,5×2=10,4×3=12'),
      ], xp: 70),
      L('mul_8', 'Commutative Property', 'Order does not matter in multiplication.', '3 × 4 = 4 × 3 = 12.', 'Switch It', '🔄', activities: [
        A.mc('mul8_a1', '2×5 is same as?', 'Switch numbers.', ['5×2','2+5','5-2','5×5'], '5×2'),
        A.mc('mul8_a2', '3×6 = 6×?', 'Same product.', ['3','6','9','18'], '3'),
        A.fb('mul8_a3', '4×7 = 7×__', 'Switch the 4.', ['4','7','28','11'], '4'),
        A.tap('mul8_a4', 'Which equals 8×3?', '3×8=24.', ['3×8','8+3','8-3','8÷3'], '3×8'),
      ], xp: 75),
      L('mul_9', 'Times 1 and 0', 'Learn rules for 1 and 0.', 'Any number × 1 = itself. Any number × 0 = 0.', 'One Zero Hero', '🎯', activities: [
        A.mc('mul9_a1', '9 × 1 = ?', 'Times 1 = itself.', ['0','1','9','10'], '9'),
        A.mc('mul9_a2', '6 × 0 = ?', 'Times 0 = 0.', ['0','6','60','1'], '0'),
        A.fb('mul9_a3', '1 × 17 = __', 'Times 1 = itself.', ['0','1','17','18'], '17'),
        A.mc('mul9_a4', '100 × 0 = ?', 'Times 0 = 0.', ['0','1','100','1000'], '0'),
      ], xp: 70),
      L('mul_10', 'Multiplication Word Problems', 'Solve simple multiplication problems.', 'Find equal groups and multiply.', 'Story Multiply', '📖', activities: [
        A.mc('mul10_a1', '3 bags of 4 apples. Total?', '3×4=?', ['7','12','15','16'], '12'),
        A.mc('mul10_a2', '2 rows of 8 chairs. Total?', '2×8=?', ['10','14','16','18'], '16'),
        A.fb('mul10_a3', '4 boxes of 5 toys. __ total.', '4×5=?', ['9','15','20','25'], '20'),
        A.tap('mul10_a4', '5 kids, 2 hands each. Total hands?', '5×2=?', ['7','10','12','15'], '10'),
      ], xp: 80),
    ],
  );

  // 6. Division
  static final _divisionTopic = T(
    id: 'division', title: 'Division', description: 'Learn to share and divide numbers.',
    icon: Icons.call_split, color: Colors.purple, order: 6,
    lessons: [
      L('div_1', 'Sharing Equally', 'Share items into equal groups.', 'Dividing means sharing equally.', 'Fair Share', '🤝', activities: [
        A.mc('div1_a1', 'Share 6 cookies between 2 kids. Each gets?', '6÷2=?', ['2','3','4','5'], '3'),
        A.mc('div1_a2', '8 toys into 2 boxes. Each box?', '8÷2=?', ['3','4','5','6'], '4'),
        A.fb('div1_a3', '10 stickers for 5 friends. Each gets __', '10÷5=?', ['2','3','4','5'], '2'),
        A.tap('div1_a4', '8 candies shared among 4 kids. Each gets?', '8÷4=?', ['1','2','3','4'], '2'),
      ], xp: 60),
      L('div_2', 'Divide by 2', 'Divide numbers by 2.', 'Dividing by 2 means splitting into two equal groups.', 'Halve It', '✂️', activities: [
        A.mc('div2_a1', '10 ÷ 2 = ?', '10 shared between 2.', ['4','5','6','7'], '5'),
        A.mc('div2_a2', '14 ÷ 2 = ?', '14 shared between 2.', ['6','7','8','9'], '7'),
        A.fb('div2_a3', '6 ÷ 2 = __', 'Half of 6.', ['2','3','4','5'], '3'),
        A.mc('div2_a4', '20 ÷ 2 = ?', 'Half of 20.', ['10','12','15','20'], '10'),
      ], xp: 65),
      L('div_3', 'Divide by 5', 'Divide numbers by 5.', 'How many groups of 5 fit?', 'Five Groups', '🖐️', activities: [
        A.mc('div3_a1', '15 ÷ 5 = ?', 'How many 5s in 15?', ['2','3','4','5'], '3'),
        A.mc('div3_a2', '25 ÷ 5 = ?', 'How many 5s in 25?', ['4','5','6','7'], '5'),
        A.fb('div3_a3', '30 ÷ 5 = __', 'How many 5s make 30?', ['5','6','7','8'], '6'),
        A.tap('div3_a4', '40 ÷ 5 = ?', 'How many 5s in 40?', ['6','7','8','9'], '8'),
      ], xp: 65),
      L('div_4', 'Divide by 10', 'Divide numbers by 10.', 'Dividing by 10 removes one zero.', 'Ten Groups', '🔟', activities: [
        A.mc('div4_a1', '30 ÷ 10 = ?', 'How many 10s in 30?', ['2','3','4','5'], '3'),
        A.mc('div4_a2', '50 ÷ 10 = ?', 'How many 10s in 50?', ['4','5','6','7'], '5'),
        A.fb('div4_a3', '70 ÷ 10 = __', '70 split into 10s.', ['6','7','8','9'], '7'),
        A.mc('div4_a4', '100 ÷ 10 = ?', 'How many 10s in 100?', ['10','100','1','20'], '10'),
      ], xp: 65),
      L('div_5', 'Divide by 3', 'Divide numbers by 3.', 'How many groups of 3 fit?', 'Three Groups', '3️⃣', activities: [
        A.mc('div5_a1', '9 ÷ 3 = ?', 'How many 3s in 9?', ['2','3','4','5'], '3'),
        A.mc('div5_a2', '15 ÷ 3 = ?', 'How many 3s in 15?', ['3','4','5','6'], '5'),
        A.fb('div5_a3', '12 ÷ 3 = __', '12 split into 3s.', ['3','4','5','6'], '4'),
        A.mc('div5_a4', '24 ÷ 3 = ?', 'How many 3s in 24?', ['6','7','8','9'], '8'),
      ], xp: 70),
      L('div_6', 'Divide by 4', 'Divide numbers by 4.', 'How many groups of 4 fit?', 'Four Groups', '4️⃣', activities: [
        A.mc('div6_a1', '12 ÷ 4 = ?', 'How many 4s in 12?', ['2','3','4','5'], '3'),
        A.mc('div6_a2', '20 ÷ 4 = ?', 'How many 4s in 20?', ['4','5','6','7'], '5'),
        A.fb('div6_a3', '16 ÷ 4 = __', '16 split into 4s.', ['3','4','5','6'], '4'),
        A.mc('div6_a4', '32 ÷ 4 = ?', 'How many 4s in 32?', ['6','7','8','9'], '8'),
      ], xp: 70),
      L('div_7', 'Fact Families', 'Use multiplication to help divide.', 'If 3×4=12, then 12÷4=3.', 'Fact Family', '👪', activities: [
        A.mc('div7_a1', 'If 5×3=15, what is 15÷3?', 'Think backwards.', ['3','5','15','45'], '5'),
        A.mc('div7_a2', 'If 4×6=24, what is 24÷4?', 'Related fact.', ['4','6','24','28'], '6'),
        A.fb('div7_a3', '7×2=14, so 14÷2=__', 'Use multiplication.', ['2','7','14','28'], '7'),
        A.mp('div7_a4', 'Match fact families', '', ['3×4=12—12÷4=3','5×2=10—10÷2=5','6×3=18—18÷3=6','4×5=20—20÷5=4'], '3×4=12—12÷4=3,5×2=10—10÷2=5,6×3=18—18÷3=6,4×5=20—20÷5=4'),
      ], xp: 70),
      L('div_8', 'Remainders', 'Some divisions leave a remainder.', 'If a number does not divide evenly, there is a leftover.', 'Remainder', '🔄', activities: [
        A.mc('div8_a1', '7 ÷ 2 = ? remainder?', '2 fits 3 times, 1 left.', ['3 r1','3 r2','4 r1','2 r3'], '3 r1'),
        A.mc('div8_a2', '10 ÷ 3 = ?', '3 fits 3 times, 1 left.', ['3 r1','3 r2','4 r1','2 r4'], '3 r1'),
        A.fb('div8_a3', '9 ÷ 4 = 2 r__', '4×2=8, 9-8=?', ['1','2','3','4'], '1'),
        A.mc('div8_a4', '11 ÷ 5 = ?', '5 fits twice, 1 left.', ['2 r1','2 r2','3 r1','1 r6'], '2 r1'),
      ], xp: 75),
      L('div_9', 'Divide by 1', 'Dividing by 1 leaves the number unchanged.', 'Any number divided by 1 is itself.', 'One Share', '1️⃣', activities: [
        A.mc('div9_a1', '8 ÷ 1 = ?', 'Divided by 1 = itself.', ['0','1','8','9'], '8'),
        A.mc('div9_a2', '100 ÷ 1 = ?', 'Hundred divided by 1.', ['0','1','100','101'], '100'),
        A.fb('div9_a3', '5 ÷ 1 = __', 'Five divided by 1.', ['0','1','5','6'], '5'),
        A.tap('div9_a4', '37 ÷ 1 = ?', 'Divided by 1 = itself.', ['0','1','37','36'], '37'),
      ], xp: 70),
      L('div_10', 'Division Word Problems', 'Solve simple division stories.', 'Find equal groups and divide.', 'Story Divide', '📖', activities: [
        A.mc('div10_a1', '12 candies, 4 friends. Each gets?', '12÷4=?', ['2','3','4','5'], '3'),
        A.mc('div10_a2', '18 pencils, 3 boxes. Each box?', '18÷3=?', ['5','6','7','8'], '6'),
        A.fb('div10_a3', '20 students, 5 teams. __ per team.', '20÷5=?', ['3','4','5','6'], '4'),
        A.tap('div10_a4', '16 eggs, cartons of 2. How many cartons?', '16÷2=?', ['6','7','8','9'], '8'),
      ], xp: 80),
    ],
  );

  // 7. Fractions
  static final _fractionsTopic = T(
    id: 'fractions', title: 'Fractions', description: 'Learn about halves, thirds, quarters and more.',
    icon: Icons.pie_chart, color: Colors.pink, order: 7,
    lessons: [
      L('frac_1', 'Halves', 'Understand one half as one of two equal parts.', 'A half is when something is split into 2 equal parts.', 'Half Pint', '½', activities: [
        A.mc('frac1_a1', 'A pizza cut into 2 equal parts. One part is?', 'One of two.', ['Half','Third','Quarter','Whole'], 'Half'),
        A.tap('frac1_a2', 'Which shows half shaded?', 'Two parts, one shaded.', ['◐','◑','◒','◓'], '◐'),
        A.mc('frac1_a3', 'How many halves make a whole?', 'Two halves = ?', ['1','2','3','4'], '2'),
        A.fb('frac1_a4', '½ + ½ = __ whole', 'Half plus half.', ['0','½','1','2'], '1'),
      ], xp: 55),
      L('frac_2', 'Quarters (Fourths)', 'Understand one quarter as one of four equal parts.', 'A quarter is split into 4 equal parts.', 'Quarterback', '¼', activities: [
        A.mc('frac2_a1', 'A pie cut into 4 equal parts. One part is?', 'One of four.', ['Half','Third','Quarter','Whole'], 'Quarter'),
        A.tap('frac2_a2', 'How many quarters make a whole?', 'Count: ¼,¼,¼,¼.', ['2','3','4','5'], '4'),
        A.mc('frac2_a3', 'What fraction is one part of 4?', '1 out of 4.', ['¼','½','¾','⅓'], '¼'),
        A.fb('frac2_a4', '¼ × 4 = __ whole(s)', 'Quarter times 4.', ['0','¼','½','1'], '1'),
      ], xp: 60),
      L('frac_3', 'Thirds', 'Understand one third as one of three equal parts.', 'A third is split into 3 equal parts.', 'Third Wheel', '⅓', activities: [
        A.mc('frac3_a1', 'A bar cut into 3 equal parts. One part is?', 'One of three.', ['Half','Third','Quarter','Whole'], 'Third'),
        A.mc('frac3_a2', 'How many thirds make a whole?', '⅓+⅓+⅓=?', ['2','3','4','5'], '3'),
        A.tap('frac3_a3', 'Which picture shows ⅓ shaded?', '3 parts, 1 shaded.', ['▦','▥','▤','▣'], '▦'),
        A.fb('frac3_a4', '⅓ + ⅓ = __', 'Two thirds.', ['½','⅔','¾','1'], '⅔'),
      ], xp: 60),
      L('frac_4', 'Comparing Fractions', 'Compare simple fractions.', 'The bigger denominator = smaller pieces.', 'Compare Fractions', '⚖️', activities: [
        A.mc('frac4_a1', 'Which is bigger: ½ or ¼?', 'Half > quarter.', ['½','¼','Same'], '½'),
        A.mc('frac4_a2', 'Which is smaller: ⅓ or ¼?', '¼ is smaller.', ['⅓','¼','Same'], '¼'),
        A.fb('frac4_a3', '½ ___ ⅓ (>, <, or =)', 'Half vs third.', ['>','<','='], '>'),
        A.drag('frac4_a4', 'Order smallest: ¼, ½, ⅓', '', ['¼','⅓','½'], '¼,⅓,½'),
      ], xp: 65),
      L('frac_5', 'Fractions of a Set', 'Find fractions of a group of objects.', '¼ of 8 = divide 8 into 4 groups.', 'Set Fraction', '🧮', activities: [
        A.mc('frac5_a1', 'What is ½ of 6?', '6 ÷ 2 = ?', ['2','3','4','5'], '3'),
        A.mc('frac5_a2', 'What is ¼ of 8?', '8 ÷ 4 = ?', ['1','2','3','4'], '2'),
        A.fb('frac5_a3', '⅓ of 9 = __', '9 ÷ 3 = ?', ['1','2','3','4'], '3'),
        A.mc('frac5_a4', 'What is ½ of 10?', '10 ÷ 2 = ?', ['4','5','6','7'], '5'),
      ], xp: 70),
      L('frac_6', 'Fractions on a Number Line', 'Place fractions on a number line.', 'Fractions sit between whole numbers.', 'Fraction Line', '📏', activities: [
        A.nl('frac6_a1', 'Tap ½ on a 0 to 1 line.', 'Halfway.', ['0.5'], '0.5'),
        A.mc('frac6_a2', 'How many quarters between 0 and 1?', '0,¼,½,¾,1.', ['2','3','4','5'], '4'),
        A.nl('frac6_a3', 'Tap ¾ on a 0 to 1 line.', 'Three-quarters.', ['0.75'], '0.75'),
        A.fb('frac6_a4', '½ = __ quarters', 'Half = 2/4.', ['1','2','3','4'], '2'),
      ], xp: 70),
      L('frac_7', 'Equivalent Fractions', 'Find fractions that are the same.', '½ = 2/4 — they cover the same amount.', 'Equal Fractions', '🟰', activities: [
        A.mc('frac7_a1', '½ = how many quarters?', '½ pizza = 2/4.', ['1','2','3','4'], '2'),
        A.mc('frac7_a2', '1 whole equals?', 'Any fraction where top=bottom.', ['½','⅔','¾','4/4'], '4/4'),
        A.fb('frac7_a3', '¼+¼ = __', 'Two quarters = ?', ['½','⅓','¼','¾'], '½'),
        A.mp('frac7_a4', 'Match equivalent fractions', '', ['½=2/4','⅓=2/6','1=3/3','¾=6/8'], '½=2/4,⅓=2/6,1=3/3,¾=6/8'),
      ], xp: 75),
      L('frac_8', 'Adding Like Fractions', 'Add fractions with the same denominator.', 'Add the top numbers, keep the bottom.', 'Fraction Add', '➕', activities: [
        A.mc('frac8_a1', '¼ + ¼ = ?', '1+1=2, keep 4.', ['½','¼','¾','1'], '½'),
        A.mc('frac8_a2', '⅓ + ⅓ = ?', '1+1=2, keep 3.', ['⅓','⅔','¾','1'], '⅔'),
        A.fb('frac8_a3', '⅕+⅕+⅕ = __', 'Three fifths.', ['⅗','⅘','⅕','1'], '⅗'),
        A.tap('frac8_a4', '⅛ + ⅛ = ?', 'Two eighths = ?', ['¼','⅛','⅜','½'], '¼'),
      ], xp: 75),
      L('frac_9', 'Subtracting Like Fractions', 'Subtract fractions with same denominator.', 'Subtract top numbers, keep the bottom.', 'Fraction Subtract', '➖', activities: [
        A.mc('frac9_a1', '¾ - ¼ = ?', '3-1=2, keep 4.', ['¼','½','¾','1'], '½'),
        A.mc('frac9_a2', '⅔ - ⅓ = ?', '2-1=1, keep 3.', ['⅓','⅔','1','0'], '⅓'),
        A.fb('frac9_a3', '1 - ¼ = __', 'Whole take quarter.', ['¼','½','¾','1'], '¾'),
        A.mc('frac9_a4', '⅘ - ⅖ = ?', '4-2=2, keep 5.', ['⅕','⅖','⅗','⅘'], '⅖'),
      ], xp: 75),
      L('frac_10', 'Fraction Word Problems', 'Solve real-life fraction problems.', 'Use fractions to share things fairly.', 'Story Fractions', '📖', activities: [
        A.mc('frac10_a1', 'Eat ¼ of a pizza. Left?', '4/4 - ¼ = ?', ['¼','½','¾','1'], '¾'),
        A.mc('frac10_a2', 'Half of 10 apples are red. How many red?', '½ of 10 = ?', ['4','5','6','7'], '5'),
        A.fb('frac10_a3', 'Read ⅓ of 9 pages. __ read.', '9÷3=?', ['2','3','4','5'], '3'),
        A.tap('frac10_a4', '¾ of 8 balloons are red. How many red?', '¾ × 8 = 6.', ['4','5','6','7'], '6'),
      ], xp: 80),
    ],
  );

  // 8. Decimals
  static final _decimalsTopic = T(
    id: 'decimals', title: 'Decimals', description: 'Learn about tenths, hundredths, and decimal numbers.',
    icon: Icons.more_horiz, color: Colors.teal, order: 8,
    lessons: [
      L('dec_1', 'Tenths', 'Understand tenths as 1/10.', 'One tenth is one part of ten. 0.1 = 1/10.', 'Tenth Time', '0.1', activities: [
        A.mc('dec1_a1', '0.1 is the same as?', 'One part out of ten.', ['1/10','1/100','1/2','1/5'], '1/10'),
        A.mc('dec1_a2', 'How many tenths in one whole?', '10×0.1=?', ['5','10','100','2'], '10'),
        A.fb('dec1_a3', '0.3 = __ tenths', 'First decimal digit = tenths.', ['1','3','10','30'], '3'),
        A.tap('dec1_a4', 'Which is 0.7?', 'Seven tenths.', ['0.07','0.7','7.0','0.007'], '0.7'),
      ], xp: 55),
      L('dec_2', 'Hundredths', 'Understand hundredths as 1/100.', 'One hundredth is one part of one hundred.', 'Hundredth', '0.01', activities: [
        A.mc('dec2_a1', '0.01 is the same as?', 'One out of 100.', ['1/10','1/100','1/2','1/5'], '1/100'),
        A.mc('dec2_a2', 'How many hundredths in one whole?', '100×0.01=?', ['10','50','100','1000'], '100'),
        A.fb('dec2_a3', '0.25 = __ hundredths', 'Last two digits = hundredths.', ['2','5','25','250'], '25'),
        A.tap('dec2_a4', 'Which is 0.03?', 'Three hundredths.', ['0.3','0.03','3.0','0.003'], '0.03'),
      ], xp: 60),
      L('dec_3', 'Decimals & Fractions', 'Convert between decimals and fractions.', '0.5 = 5/10 = 1/2.', 'Decimal Fractions', '🔄', activities: [
        A.mc('dec3_a1', '0.5 as a fraction?', '5/10 = ?', ['1/2','1/5','1/10','1/4'], '1/2'),
        A.mc('dec3_a2', '0.25 as a fraction?', '25/100 = ?', ['1/2','1/4','1/5','1/10'], '1/4'),
        A.fb('dec3_a3', '0.75 = __ / 100', '75 hundredths.', ['7','75','750','0.75'], '75'),
        A.mp('dec3_a4', 'Match decimal to fraction', '', ['0.5=½','0.25=¼','0.75=¾','0.1=⅒'], '0.5=½,0.25=¼,0.75=¾,0.1=⅒'),
      ], xp: 65),
      L('dec_4', 'Comparing Decimals', 'Compare decimal numbers.', 'Compare tenths first, then hundredths.', 'Decimal Compare', '⚖️', activities: [
        A.mc('dec4_a1', 'Which is bigger: 0.5 or 0.3?', 'More tenths = bigger.', ['0.3','0.5','Same'], '0.5'),
        A.mc('dec4_a2', 'Which is smaller: 0.7 or 0.25?', '0.2 vs 0.7.', ['0.25','0.7','Same'], '0.25'),
        A.fb('dec4_a3', '0.6 ___ 0.8 (>, <, or =)', '0.6 vs 0.8.', ['>','<','='], '<'),
        A.drag('dec4_a4', 'Order smallest: 0.3, 0.15, 0.8, 0.05', '', ['0.05','0.15','0.3','0.8'], '0.05,0.15,0.3,0.8'),
      ], xp: 65),
      L('dec_5', 'Adding Decimals', 'Add decimal numbers.', 'Line up decimal points, add column by column.', 'Decimal Add', '➕', activities: [
        A.mc('dec5_a1', '0.3 + 0.4 = ?', '3+4 tenths.', ['0.07','0.7','7.0','0.1'], '0.7'),
        A.mc('dec5_a2', '0.25 + 0.10 = ?', '25+10 hundredths.', ['0.35','0.25','0.15','0.45'], '0.35'),
        A.fb('dec5_a3', '0.5 + 0.25 = __', '5 tenths + 25 hundredths.', ['0.75','0.55','0.25','0.50'], '0.75'),
        A.tap('dec5_a4', '0.05 + 0.05 = ?', '5+5 hundredths.', ['0.01','0.1','0.05','0.5'], '0.1'),
      ], xp: 70),
      L('dec_6', 'Subtracting Decimals', 'Subtract decimal numbers.', 'Line up decimal points and subtract.', 'Decimal Subtract', '➖', activities: [
        A.mc('dec6_a1', '0.8 - 0.3 = ?', '8-3 tenths.', ['0.11','0.5','5.0','0.05'], '0.5'),
        A.mc('dec6_a2', '0.75 - 0.25 = ?', '75-25 hundredths.', ['0.5','0.55','0.45','0.75'], '0.5'),
        A.fb('dec6_a3', '0.9 - 0.4 = __', '9-4 tenths.', ['0.05','0.5','5.0','0.4'], '0.5'),
        A.mc('dec6_a4', '1.0 - 0.5 = ?', 'One minus 5 tenths.', ['0.05','0.5','5.0','0.4'], '0.5'),
      ], xp: 70),
      L('dec_7', 'Decimals on a Number Line', 'Place decimals on a number line.', '0.3, 0.5, 0.75 sit between 0 and 1.', 'Decimal Line', '📏', activities: [
        A.nl('dec7_a1', 'Tap 0.5 on a 0-1 line.', 'Halfway.', ['0.5'], '0.5'),
        A.mc('dec7_a2', 'Halfway between 0.2 and 0.4?', '0.2+0.1=?', ['0.25','0.3','0.35','0.4'], '0.3'),
        A.nl('dec7_a3', 'Tap 0.8 on a 0-1 line.', 'Eight tenths.', ['0.8'], '0.8'),
        A.fb('dec7_a4', '0.25 on a 0-1 line is __ of the way', 'A quarter.', ['¼','½','¾','⅓'], '¼'),
      ], xp: 70),
      L('dec_8', 'Money & Decimals', 'Understand money amounts as decimals.', '\$1.50 = 1 dollar and 50 cents.', 'Decimal Money', '💰', activities: [
        A.mc('dec8_a1', 'How many cents in \$0.50?', '0.50×100=?', ['5','10','50','100'], '50'),
        A.mc('dec8_a2', '\$1.25 = __ dollars and __ cents', '1 + 0.25.', ['1 and 25','12 and 5','0 and 125','125 and 0'], '1 and 25'),
        A.fb('dec8_a3', '\$0.75 = __ cents', 'Three quarters.', ['7','15','75','750'], '75'),
        A.tap('dec8_a4', 'Which is \$0.10?', 'Ten cents.', ['\$0.01','\$0.10','\$1.00','\$10.00'], '\$0.10'),
      ], xp: 75),
      L('dec_9', 'Multiply Decimals by 10', 'Multiply decimals by 10.', 'Shift decimal one place right.', 'Ten Times Decimal', '🔟', activities: [
        A.mc('dec9_a1', '0.3 × 10 = ?', 'Shift right.', ['0.03','0.3','3.0','30'], '3.0'),
        A.mc('dec9_a2', '0.25 × 10 = ?', 'Shift right.', ['0.025','0.25','2.5','25'], '2.5'),
        A.fb('dec9_a3', '0.07 × 10 = __', 'Shift decimal right.', ['0.007','0.07','0.7','7.0'], '0.7'),
        A.tap('dec9_a4', '0.5 × 10 = ?', 'Five tenths × 10.', ['0.05','0.5','5.0','50'], '5.0'),
      ], xp: 75),
      L('dec_10', 'Decimal Word Problems', 'Solve real-world decimal problems.', 'Use decimals for money and measurements.', 'Story Decimals', '📖', activities: [
        A.mc('dec10_a1', 'Have \$1.50, spend \$0.50. Left?', '1.50-0.50=?', ['\$0.50','\$1.00','\$1.50','\$0.75'], '\$1.00'),
        A.mc('dec10_a2', 'Pencil 0.2 m + Book 0.5 m = ?', '0.2+0.5=?', ['0.07','0.7','7','0.25'], '0.7'),
        A.fb('dec10_a3', 'Drink 0.25 L, 0.75 L __ left.', '1.0-0.25=?', ['0.05','0.25','0.75','1.0'], '0.75'),
        A.tap('dec10_a4', 'Ribbon 1.5 m, cut 0.5 m. Remaining?', '1.5-0.5=?', ['0.5','1.0','1.5','2.0'], '1.0'),
      ], xp: 80),
    ],
  );

  // 9. Time
  static final _timeTopic = T(
    id: 'time', title: 'Time', description: 'Learn to tell time and understand clocks.',
    icon: Icons.access_time, color: Colors.amber, order: 9,
    lessons: [
      L('time_1', 'Parts of a Clock', 'Learn the parts of a clock.', 'Clock has hour (short) and minute (long) hands.', 'Clock Watcher', '🕐', activities: [
        A.mc('time1_a1', 'Which hand is SHORT?', 'Hour hand is short.', ['Hour','Minute','Second','Both'], 'Hour'),
        A.mc('time1_a2', 'How many numbers on a clock?', '1 to 12.', ['10','12','24','60'], '12'),
        A.fb('time1_a3', 'The long hand shows __', 'Minutes.', ['hours','minutes','seconds','days'], 'minutes'),
        A.tap('time1_a4', 'Pick the number 12 on a clock', '', ['6','9','12','3'], '12'),
      ], xp: 50),
      L('time_2', 'O\'Clock', 'Tell time to the hour.', 'Minute hand on 12 = o\'clock.', 'Hour Hand', '🕐', activities: [
        A.mc('time2_a1', 'Short on 3, long on 12. Time?', '3 o\'clock.', ['2:00','3:00','4:00','12:00'], '3:00'),
        A.mc('time2_a2', 'What time is 5 o\'clock?', '5:00.', ['4:00','5:00','6:00','12:00'], '5:00'),
        A.fb('time2_a3', '7 o\'clock = 7:__', 'Minutes = 00.', ['00','15','30','45'], '00'),
        A.tap('time2_a4', 'Pick 9:00', '', ['🕐','🕤','🕘','🕥'], '🕘'),
      ], xp: 55),
      L('time_3', 'Half Past', 'Tell time to the half hour.', 'Half past = minute hand on 6 = :30.', 'Half Past', '🕐', activities: [
        A.mc('time3_a1', 'Minute on 6, hour past 3. Time?', 'Half past 3.', ['3:00','3:30','4:30','6:00'], '3:30'),
        A.mc('time3_a2', 'Half past 5 = ?', '5:30.', ['5:00','5:15','5:30','5:45'], '5:30'),
        A.fb('time3_a3', '8:30 = half past __', '', ['7','8','9','30'], '8'),
        A.tap('time3_a4', 'Pick half past 10', '', ['10:00','10:30','11:30','10:15'], '10:30'),
      ], xp: 60),
      L('time_4', 'Quarter Past', 'Tell time: quarter past the hour.', 'Quarter past = minute hand on 3 = :15.', 'Quarter Past', '🕐', activities: [
        A.mc('time4_a1', 'Minute on 3, hour past 2. Time?', 'Quarter past 2.', ['2:00','2:15','2:30','2:45'], '2:15'),
        A.mc('time4_a2', 'Quarter past 7 = ?', '7:15.', ['7:00','7:15','7:30','7:45'], '7:15'),
        A.fb('time4_a3', '9:15 = quarter past __', '', ['8','9','10','15'], '9'),
        A.mc('time4_a4', 'Minutes in a quarter hour?', '60÷4=?', ['10','15','20','30'], '15'),
      ], xp: 60),
      L('time_5', 'Quarter To', 'Tell time: quarter to the hour.', 'Quarter to = minute hand on 9 = :45.', 'Quarter To', '🕐', activities: [
        A.mc('time5_a1', 'Minute on 9, hour near 4. Time?', 'Quarter to 4.', ['3:45','4:15','4:45','3:30'], '3:45'),
        A.mc('time5_a2', 'Quarter to 6 = ?', '5:45.', ['5:45','6:15','6:45','5:30'], '5:45'),
        A.fb('time5_a3', '11:45 = quarter to __', '15 min before 12.', ['10','11','12','1'], '12'),
        A.mc('time5_a4', 'Quarter to 8 = ?', '7:45.', ['7:45','8:15','8:45','7:30'], '7:45'),
      ], xp: 65),
      L('time_6', 'To 5 Minutes', 'Tell time to nearest 5 minutes.', 'Count by 5s: 5, 10, 15, 20...', 'Five Minute', '⏰', activities: [
        A.mc('time6_a1', 'Minute hand on 2 = ? min', '2×5=?', ['2','5','10','15'], '10'),
        A.mc('time6_a2', 'Minute hand on 9 = ? min', '9×5=?', ['9','35','45','50'], '45'),
        A.fb('time6_a3', 'Minute hand on 7 = __ min', '7×5=?', ['7','35','42','45'], '35'),
        A.tap('time6_a4', 'Which shows 4:25?', 'Minute hand on 5.', ['4:05','4:20','4:25','4:30'], '4:25'),
      ], xp: 65),
      L('time_7', 'AM and PM', 'Understand AM and PM.', 'AM = morning, PM = afternoon/evening.', 'AM PM', '☀️', activities: [
        A.mc('time7_a1', '8:00 morning is AM or PM?', 'Morning = AM.', ['AM','PM','Both','Neither'], 'AM'),
        A.mc('time7_a2', '3:00 afternoon is AM or PM?', 'Afternoon = PM.', ['AM','PM','Both','Neither'], 'PM'),
        A.fb('time7_a3', 'Lunch 12:00 is __', 'Noon = PM.', ['AM','PM','Both','Neither'], 'PM'),
        A.tap('time7_a4', 'Pick the PM activity', '', ['Breakfast','Lunch','Dinner','Sunrise'], 'Dinner'),
      ], xp: 70),
      L('time_8', 'Duration', 'Calculate how much time has passed.', 'Subtract start from end time.', 'Time Keeper', '⏱️', activities: [
        A.mc('time8_a1', '2:00 to 3:00. How long?', '1 hour.', ['30 min','1 hour','2 hours','90 min'], '1 hour'),
        A.mc('time8_a2', '9:30 to 10:00. How long?', '30 min.', ['15','30','45','60'], '30'),
        A.fb('time8_a3', 'Movie 4:00 to 5:30. __ min long.', '1h30m = 90 min.', ['60','90','120','150'], '90'),
        A.mc('time8_a4', 'School 8:00 to 12:00. How many hours?', '8 to 12 = 4.', ['3','4','5','6'], '4'),
      ], xp: 75),
      L('time_9', 'Days, Weeks, Months', 'Understand days and months.', '7 days in a week. 12 months in a year.', 'Calendar Kid', '📅', activities: [
        A.mc('time9_a1', 'Days in a week?', 'Sun to Sat.', ['5','6','7','10'], '7'),
        A.mc('time9_a2', 'Months in a year?', 'Jan to Dec.', ['10','12','24','52'], '12'),
        A.fb('time9_a3', 'Sat + Sun = __', 'Not school days.', ['weekdays','weekend','holidays','months'], 'weekend'),
        A.drag('time9_a4', 'Order: Wed, Mon, Fri, Sun', '', ['Mon','Wed','Fri','Sun'], 'Mon,Wed,Fri,Sun'),
      ], xp: 70),
      L('time_10', 'Time Word Problems', 'Solve real-life time problems.', 'Use clocks and calendars in stories.', 'Story Time', '📖', activities: [
        A.mc('time10_a1', 'School 8:00, arrive 7:45. How early?', '15 min.', ['15','30','45','60'], '15'),
        A.mc('time10_a2', 'Play 30 min from 3:00. Stop at?', '3:30.', ['3:15','3:30','4:00','2:30'], '3:30'),
        A.fb('time10_a3', 'Bed 8:00. Read 20 min. To bed at?', '8:20.', ['8:10','8:20','8:30','9:00'], '8:20'),
        A.tap('time10_a4', 'Movie 2 hours from 1:00 PM. Ends at?', '3:00.', ['2:00','3:00','4:00','5:00'], '3:00'),
      ], xp: 80),
    ],
  );

  // 10. Money
  static final _moneyTopic = T(
    id: 'money', title: 'Money', description: 'Learn to count coins, bills, and make change.',
    icon: Icons.attach_money, color: Colors.green, order: 10,
    lessons: [
      L('money_1', 'Identifying Coins', 'Recognize penny, nickel, dime, quarter.', 'Each coin has different value.', 'Coin Spotter', '🪙', activities: [
        A.mc('m1_a1', 'Which coin is worth 1 cent?', 'Smallest value.', ['Penny','Nickel','Dime','Quarter'], 'Penny'),
        A.mc('m1_a2', 'Which coin is worth 25 cents?', 'Quarter.', ['Penny','Nickel','Dime','Quarter'], 'Quarter'),
        A.fb('m1_a3', 'A dime is worth __ cents', '10 cents.', ['1','5','10','25'], '10'),
        A.tap('m1_a4', 'Pick the nickel (5 cents)', '', ['Penny','Nickel','Dime','Quarter'], 'Nickel'),
      ], xp: 50),
      L('money_2', 'Counting Pennies', 'Count pennies to 10 cents.', 'Count by ones.', 'Penny Pincher', '1 cent', activities: [
        A.mc('m2_a1', '3 pennies = __ cents', '3x1 cent = ?', ['1','2','3','4'], '3'),
        A.mc('m2_a2', '7 pennies = __ cents', '7x1 cent = ?', ['5','6','7','8'], '7'),
        A.fb('m2_a3', '10 pennies = __ cents', '10x1 cent.', ['1','5','10','100'], '10'),
        A.tap('m2_a4', 'How many pennies in 6 cents?', '6.', ['4','5','6','7'], '6'),
      ], xp: 55),
      L('money_3', 'Counting Nickels', 'Count nickels by 5s.', 'Each nickel = 5 cents.', 'Nickel Knack', '5 cent', activities: [
        A.mc('m3_a1', '2 nickels = __ cents', '5+5=?', ['5','10','15','20'], '10'),
        A.mc('m3_a2', '4 nickels = __ cents', '4x5=?', ['10','15','20','25'], '20'),
        A.fb('m3_a3', '6 nickels = __ cents', '6x5=?', ['20','25','30','35'], '30'),
        A.tap('m3_a4', 'Nickels to make 25 cents?', '5x5=25.', ['3','4','5','6'], '5'),
      ], xp: 60),
      L('money_4', 'Counting Dimes', 'Count dimes by 10s.', 'Each dime = 10 cents.', 'Dime Time', '10 cent', activities: [
        A.mc('m4_a1', '3 dimes = __ cents', '3x10=?', ['10','20','30','40'], '30'),
        A.mc('m4_a2', '5 dimes = __ cents', '5x10=?', ['30','40','50','60'], '50'),
        A.fb('m4_a3', '7 dimes = __ cents', '7x10=?', ['50','60','70','80'], '70'),
        A.tap('m4_a4', 'Dimes to make \$1.00?', '10x10 cents = \$1.', ['5','8','10','20'], '10'),
      ], xp: 60),
      L('money_5', 'Counting Quarters', 'Count quarters by 25s.', 'Each quarter = 25 cents.', 'Quarter Count', '25 cent', activities: [
        A.mc('m5_a1', '2 quarters = __ cents', '25+25=?', ['25','40','50','75'], '50'),
        A.mc('m5_a2', '3 quarters = __ cents', '25+25+25=?', ['50','75','100','125'], '75'),
        A.fb('m5_a3', '4 quarters = \$__', '4x25 cents = 100 cents.', ['1','2','3','4'], '1'),
        A.tap('m5_a4', 'Quarters in \$1.00?', 'Each=25 cents.', ['2','3','4','5'], '4'),
      ], xp: 65),
      L('money_6', 'Mixed Coins', 'Count combinations of coins.', 'Start with largest coin first.', 'Coin Mix', '🪙', activities: [
        A.mc('m6_a1', '1 quarter + 1 dime = __ cents', '25+10=?', ['30','35','40','45'], '35'),
        A.mc('m6_a2', '2 dimes + 1 nickel = __ cents', '10+10+5=?', ['15','20','25','30'], '25'),
        A.fb('m6_a3', '1 quarter + 1 nickel = __ cents', '25+5=?', ['20','25','30','35'], '30'),
        A.drag('m6_a4', 'Order coin value: dime, quarter, penny, nickel', '', ['penny','nickel','dime','quarter'], 'penny,nickel,dime,quarter'),
      ], xp: 70),
      L('money_7', 'Dollar Bills', 'Recognize \$1, \$5, \$10, \$20 bills.', 'Each bill has a different value.', 'Bill Buster', '💵', activities: [
        A.mc('m7_a1', '\$1 bills to make \$5?', '5x\$1=\$5.', ['3','4','5','6'], '5'),
        A.mc('m7_a2', '\$10 bill = how many \$1?', '10x\$1=\$10.', ['5','10','15','20'], '10'),
        A.fb('m7_a3', '\$20 bill = __ \$5 bills', '20/5=?', ['2','3','4','5'], '4'),
        A.tap('m7_a4', 'Which bill is worth the most?', 'Largest value.', ['\$1','\$5','\$10','\$20'], '\$20'),
      ], xp: 65),
      L('money_8', 'Making Change', 'Calculate change from a purchase.', 'Change = money given - cost.', 'Change Maker', '🔄', activities: [
        A.mc('m8_a1', 'Pay \$1.00 for 75 cent toy. Change?', '\$1.00 - \$0.75 = ?', ['\$0.15','\$0.25','\$0.50','\$0.75'], '\$0.25'),
        A.mc('m8_a2', 'Buy 30 cent candy with \$1.00. Change?', '\$1.00 - \$0.30 = ?', ['\$0.30','\$0.50','\$0.70','\$0.90'], '\$0.70'),
        A.fb('m8_a3', 'Cost 50 cents, pay \$1.00. Change = __ cents', '100-50=?', ['25','40','50','75'], '50'),
        A.mc('m8_a4', 'Have \$2.00. Candy \$1.25. Change?', '\$2.00 - \$1.25 = ?', ['\$0.25','\$0.50','\$0.75','\$1.00'], '\$0.75'),
      ], xp: 75),
      L('money_9', 'Adding Money', 'Add money amounts together.', 'Line up the decimal points.', 'Money Total', '➕', activities: [
        A.mc('m9_a1', '\$1.50 + \$0.50 = ?', '1.50+0.50=?', ['\$1.00','\$2.00','\$2.50','\$1.50'], '\$2.00'),
        A.mc('m9_a2', '\$0.75 + \$0.25 = ?', 'Three quarter + one.', ['\$0.75','\$1.00','\$1.25','\$0.50'], '\$1.00'),
        A.fb('m9_a3', '\$2.00 + \$1.50 = \$__', '2+1.50=?', ['\$2.50','\$3.00','\$3.50','\$4.00'], '\$3.50'),
        A.tap('m9_a4', '\$3.50 + \$1.50 = ?', '3.50+1.50=?', ['\$4.00','\$4.50','\$5.00','\$5.50'], '\$5.00'),
      ], xp: 75),
      L('money_10', 'Money Word Problems', 'Solve real-world money problems.', 'Use coins, bills, and change in stories.', 'Story Money', '📖', activities: [
        A.mc('m10_a1', '3 quarters = how much?', '25+25+25=?', ['50 cents','75 cents','\$1.00','\$1.25'], '75 cents'),
        A.mc('m10_a2', '\$2 ice cream, pay \$5. Change?', '\$5-\$2=?', ['\$2','\$3','\$4','\$5'], '\$3'),
        A.fb('m10_a3', 'Save \$1.25 + \$0.75. Total saved?', '\$1.25+\$0.75=?', ['\$1.50','\$2.00','\$2.50','\$3.00'], '\$2.00'),
        A.tap('m10_a4', 'Need \$4.50, have \$2.00. Need more?', '\$4.50-\$2.00=?', ['\$1.50','\$2.00','\$2.50','\$3.00'], '\$2.50'),
      ], xp: 80),
    ],
  );

  // 11. Measurement
  static final _measurementTopic = T(
    id: 'measurement', title: 'Measurement', description: 'Learn to measure length, weight, and volume.',
    icon: Icons.straighten, color: Colors.brown, order: 11,
    lessons: [
      L('meas_1', 'Compare Length', 'Compare objects by length.', 'Use words like longer, shorter, taller.', 'Length Compare', '📏', activities: [
        A.mc('ms1_a1', 'A pencil is ___ than a crayon.', 'Pencil is longer.', ['shorter','longer','same','wider'], 'longer'),
        A.mc('ms1_a2', 'A book is ___ than a notebook.', 'Book has more pages.', ['shorter','longer','same','thinner'], 'longer'),
        A.fb('ms1_a3', 'A cat is ___ than a mouse.', 'Cat is bigger.', ['smaller','bigger','same'], 'bigger'),
        A.drag('ms1_a4', 'Shortest to longest: tree, flower, bush, grass', '', ['grass','flower','bush','tree'], 'grass,flower,bush,tree'),
      ], xp: 50),
      L('meas_2', 'Non-Standard Units', 'Measure using paperclips or cubes.', 'Count how many units long something is.', 'Measure Up', '📎', activities: [
        A.mc('ms2_a1', 'Book=5 paperclips, Pencil=3. Which longer?', '5>3.', ['Book','Pencil','Same'], 'Book'),
        A.mc('ms2_a2', 'Table=12 cubes, Desk=8 cubes. Which shorter?', '8<12.', ['Table','Desk','Same'], 'Desk'),
        A.tap('ms2_a3', 'How many cubes in a 4-cube train?', '4 cubes.', ['3','4','5','6'], '4'),
        A.fb('ms2_a4', 'Mat=7 cubes, Rug=10 cubes. Rug is __ cubes longer.', '10-7=?', ['2','3','4','5'], '3'),
      ], xp: 55),
      L('meas_3', 'Inches & Feet', 'Measure in inches and feet.', '12 inches = 1 foot.', 'Inch Worm', '📏', activities: [
        A.mc('ms3_a1', 'Inches in 1 foot?', '12 in = 1 ft.', ['10','12','24','36'], '12'),
        A.mc('ms3_a2', 'Pencil ~6 in, Foot = __ in. Which longer?', 'Foot is 12 in.', ['6','12','18','24'], '12'),
        A.fb('ms3_a3', '2 feet = __ inches', '2×12=?', ['12','24','36','48'], '24'),
        A.tap('ms3_a4', 'Which is longer: 1 ft or 10 in?', '12 in vs 10 in.', ['1 foot','10 inches','Same'], '1 foot'),
      ], xp: 60),
      L('meas_4', 'Centimeters & Meters', 'Measure in cm and m.', '100 cm = 1 m.', 'Metric Measurer', '📐', activities: [
        A.mc('ms4_a1', 'cm in 1 m?', '100 cm = 1 m.', ['10','100','1000','12'], '100'),
        A.mc('ms4_a2', 'Crayon ~10 cm, Door ~2 m. Which longer?', '2 m=200 cm.', ['Crayon','Door','Same'], 'Door'),
        A.fb('ms4_a3', '1 meter = __ cm', '100.', ['10','100','1000','50'], '100'),
        A.mc('ms4_a4', 'Which longer: 1 m or 150 cm?', '150 cm > 100 cm.', ['1 m','150 cm','Same'], '150 cm'),
      ], xp: 60),
      L('meas_5', 'Heavy or Light', 'Compare weight.', 'Use a balance scale.', 'Weight Watcher', '⚖️', activities: [
        A.mc('ms5_a1', 'Rock is ___ than a feather.', 'Rock is heavy.', ['lighter','heavier','same'], 'heavier'),
        A.mc('ms5_a2', 'Watermelon is ___ than an apple.', 'Melon is big.', ['lighter','heavier','same'], 'heavier'),
        A.fb('ms5_a3', 'Pillow is ___ than a book.', 'Pillow is light.', ['lighter','heavier','same'], 'lighter'),
        A.drag('ms5_a4', 'Lightest to heaviest: rock, feather, book, pillow', '', ['feather','pillow','book','rock'], 'feather,pillow,book,rock'),
      ], xp: 55),
      L('meas_6', 'Pounds & Ounces', 'Measure weight in lb and oz.', '16 oz = 1 lb.', 'Pound It', '🏋️', activities: [
        A.mc('ms6_a1', 'Ounces in 1 pound?', '16 oz = 1 lb.', ['8','12','16','24'], '16'),
        A.mc('ms6_a2', 'Sugar bag is about 1 __', 'Usually pounds.', ['ounce','pound','ton','gram'], 'pound'),
        A.fb('ms6_a3', '32 oz = __ lb', '32÷16=?', ['1','2','3','4'], '2'),
        A.tap('ms6_a4', 'Heavier: 1 lb or 20 oz?', '16 oz vs 20 oz.', ['1 lb','20 oz','Same'], '20 oz'),
      ], xp: 65),
      L('meas_7', 'Grams & Kilograms', 'Measure weight in g and kg.', '1000 g = 1 kg.', 'Gram Gram', '⚖️', activities: [
        A.mc('ms7_a1', 'Grams in 1 kg?', '1000 g = 1 kg.', ['100','500','1000','2000'], '1000'),
        A.mc('ms7_a2', 'Paperclip weighs about 1 __', 'Very light.', ['gram','kilogram','pound','ton'], 'gram'),
        A.fb('ms7_a3', '250 g + 750 g = __ kg', '1000 g = 1 kg.', ['0.5','1','1.5','2'], '1'),
        A.tap('ms7_a4', 'Heavier: 1 kg or 500 g?', '1 kg = 1000 g.', ['1 kg','500 g','Same'], '1 kg'),
      ], xp: 65),
      L('meas_8', 'Cups & Gallons', 'Measure capacity.', '2 cups=1 pint, 2 pt=1 qt, 4 qt=1 gal.', 'Capacity King', '🧪', activities: [
        A.mc('ms8_a1', 'Cups in 1 pint?', '2 cups = 1 pt.', ['1','2','3','4'], '2'),
        A.mc('ms8_a2', 'Quarts in 1 gallon?', '4 qt = 1 gal.', ['2','3','4','8'], '4'),
        A.fb('ms8_a3', '2 pints = __ quart', '2 pt = 1 qt.', ['1','2','3','4'], '1'),
        A.tap('ms8_a4', 'Holds more: cup or gallon?', 'Gallon is much bigger.', ['Cup','Gallon','Same'], 'Gallon'),
      ], xp: 65),
      L('meas_9', 'Liters & Milliliters', 'Measure volume in L and mL.', '1 L = 1000 mL.', 'Liter Leader', '🧴', activities: [
        A.mc('ms9_a1', 'mL in 1 L?', '1000 mL = 1 L.', ['100','500','1000','2000'], '1000'),
        A.mc('ms9_a2', 'Water bottle is about 1 __', 'Typically 1 L.', ['mL','L','oz','cup'], 'L'),
        A.fb('ms9_a3', '500 mL + 500 mL = __ L', '1000 mL = 1 L.', ['0.5','1','1.5','2'], '1'),
        A.mc('ms9_a4', 'More: 1 L or 750 mL?', '1 L = 1000 mL.', ['1 L','750 mL','Same'], '1 L'),
      ], xp: 70),
      L('meas_10', 'Measurement Word Problems', 'Solve measurement problems.', 'Use measurement in everyday situations.', 'Story Measure', '📖', activities: [
        A.mc('ms10_a1', 'Table 60 in long. How many feet?', '60÷12=?', ['4','5','6','10'], '5'),
        A.mc('ms10_a2', 'Need 2 L, have 500 mL. More needed?', '2000-500=1500 mL.', ['500 mL','1 L','1.5 L','2 L'], '1.5 L'),
        A.fb('ms10_a3', 'Rice 2 kg + Beans 1.5 kg = __ kg', '2+1.5=?', ['2.5','3','3.5','4'], '3.5'),
        A.tap('ms10_a4', 'Need 12 in ribbon, cut 8 in. More?', '12-8=?', ['2','3','4','5'], '4'),
      ], xp: 80),
    ],
  );

  // 12. Geometry
  static final _geometryTopic = T(
    id: 'geometry', title: 'Geometry', description: 'Learn about shapes, sides, corners, and space.',
    icon: Icons.category, color: Colors.cyan, order: 12,
    lessons: [
      L('geo_1', 'Basic Shapes', 'Identify circles, squares, rectangles, triangles.', 'Each shape has a special name.', 'Shape Spotter', '🔵',
        shapeIntros: [
          ShapeIntro(GeoShape.circle, 'Circle', Colors.blue, 'A circle is round with no corners — every point is the same distance from the center.'),
          ShapeIntro(GeoShape.square, 'Square', Colors.green, 'A square has 4 equal sides and 4 right-angle corners. Each side is the same length.'),
          ShapeIntro(GeoShape.rectangle, 'Rectangle', Colors.orange, 'A rectangle has 4 sides — opposite sides are equal. It has 4 right-angle corners.'),
          ShapeIntro(GeoShape.triangle, 'Triangle', Colors.red, 'A triangle has 3 sides and 3 corners. The corners always add up to 180°.'),
        ],
        activities: [
        A.mc('g1_a1', 'Sides of a triangle?', 'Tri=three.', ['2','3','4','5'], '3'),
        A.mc('g1_a2', 'A square has how many equal sides?', 'All four same.', ['2','3','4','5'], '4'),
        A.tap('g1_a3', 'Pick the circle', '', ['○','□','△','⬟'], '○'),
        A.fb('g1_a4', 'A rectangle has __ sides', 'Like a square.', ['3','4','5','6'], '4'),
      ], xp: 50),
      L('geo_2', 'Sides & Corners', 'Count sides and corners (vertices).', 'A corner is where two sides meet.', 'Corner Count', '📐',
        shapeIntros: [
          ShapeIntro(GeoShape.pentagon, 'Pentagon', Colors.purple, 'A pentagon has 5 sides and 5 corners. "Penta" means five.'),
          ShapeIntro(GeoShape.hexagon, 'Hexagon', Colors.teal, 'A hexagon has 6 sides and 6 corners. "Hexa" means six. A honeycomb cell is a hexagon!'),
          ShapeIntro(GeoShape.trapezoid, 'Trapezoid', Colors.cyan, 'A trapezoid has 4 sides — one pair of sides is parallel.'),
          ShapeIntro(GeoShape.rhombus, 'Rhombus', Colors.pink, 'A rhombus has 4 equal sides. It looks like a diamond. All sides are the same length!'),
        ],
        activities: [
        A.mc('g2_a1', 'Triangle has how many corners?', 'Three corners.', ['2','3','4','5'], '3'),
        A.mc('g2_a2', 'Square has how many corners?', 'Four corners.', ['2','3','4','5'], '4'),
        A.fb('g2_a3', 'Shape with 5 sides is a __', 'Penta=5.', ['Triangle','Square','Pentagon','Hexagon'], 'Pentagon'),
        A.mp('g2_a4', 'Match shape to sides', '', ['Square=4','Triangle=3','Pentagon=5','Hexagon=6'], 'Square=4,Triangle=3,Pentagon=5,Hexagon=6'),
      ], xp: 55),
      L('geo_3', '3D Shapes', 'Identify spheres, cubes, cones, cylinders.', '3D shapes have height, width, depth.', '3D Explore', '🧊', activities: [
        A.mc('g3_a1', 'A ball is a __', 'Round and rolls.', ['Cube','Sphere','Cone','Cylinder'], 'Sphere'),
        A.mc('g3_a2', 'A dice is a __', 'Six square faces.', ['Sphere','Cube','Cone','Pyramid'], 'Cube'),
        A.tap('g3_a3', 'Pick the cone shape', 'Ice cream.', ['⚽','🧊','🍦','🥫'], '🍦'),
        A.fb('g3_a4', 'A soup can is a __', 'Round ends, long body.', ['Cube','Sphere','Cylinder','Cone'], 'Cylinder'),
      ], xp: 60),
      L('geo_4', 'Flat vs Solid', 'Sort 2D flat and 3D solid shapes.', 'Flat = on paper. Solid = takes space.', 'Flat or Solid', '2D➡️3D', activities: [
        A.mc('g4_a1', 'A circle is a __ shape.', 'No depth.', ['Flat (2D)','Solid (3D)','Both'], 'Flat (2D)'),
        A.mc('g4_a2', 'A sphere is a __ shape.', 'Has depth.', ['Flat (2D)','Solid (3D)','Both'], 'Solid (3D)'),
        A.drag('g4_a3', 'Sort flats then solids: circle, cube, square, sphere', '', ['circle','square','cube','sphere'], 'circle,square,cube,sphere'),
        A.tap('g4_a4', 'Pick the 3D shape', '', ['△','□','🧊','○'], '🧊'),
      ], xp: 60),
      L('geo_5', 'Symmetry', 'Find lines of symmetry.', 'Fold so both halves match.', 'Symmetry', '🪞',
        shapeIntros: [
          ShapeIntro(GeoShape.square, 'Square Symmetry', Colors.green, 'A square has 4 lines of symmetry — vertical, horizontal, and 2 diagonals. Every fold matches perfectly!'),
          ShapeIntro(GeoShape.circle, 'Circle Symmetry', Colors.blue, 'A circle has infinite lines of symmetry — you can fold it through the center at any angle.'),
          ShapeIntro(GeoShape.triangle, 'Triangle Symmetry', Colors.red, 'An equilateral triangle has 3 lines of symmetry — one through each corner and the opposite side.'),
        ], activities: [
        A.mc('g5_a1', 'Square lines of symmetry?', 'Vertical, horizontal, 2 diagonal.', ['1','2','3','4'], '4'),
        A.mc('g5_a2', 'Circle lines of symmetry?', 'Infinite!', ['0','1','4','Infinite'], 'Infinite'),
        A.tap('g5_a3', 'Which shape is symmetric?', 'Both sides match.', ['💚','🖤','❤️','💛'], '❤️'),
        A.fb('g5_a4', 'Regular triangle has __ lines of symmetry', 'Equilateral has 3.', ['1','2','3','4'], '3'),
      ], xp: 65),
      L('geo_6', 'Perimeter', 'Find perimeter of shapes.', 'Perimeter = distance around. Add all sides.', 'Perimeter Pal', '📏',
        shapeIntros: [
          ShapeIntro(GeoShape.square, 'Square Perimeter', Colors.green, 'The perimeter of a square is 4 × side length. If a square has side 5 cm, the perimeter is 20 cm.'),
          ShapeIntro(GeoShape.rectangle, 'Rectangle Perimeter', Colors.orange, 'The perimeter of a rectangle is 2 × (length + width). For a 3 × 5 rectangle, the perimiter is 16.'),
          ShapeIntro(GeoShape.triangle, 'Triangle Perimeter', Colors.red, 'The perimeter of a triangle is the sum of all 3 sides. A triangle with sides 3, 4, 5 has perimiter 12.'),
        ], activities: [
        A.mc('g6_a1', 'Square side 4 cm. Perimeter?', '4+4+4+4=?', ['8','12','16','20'], '16'),
        A.mc('g6_a2', 'Rectangle 3×5 cm. Perimeter?', '3+5+3+5=?', ['8','15','16','20'], '16'),
        A.fb('g6_a3', 'Triangle 3,4,5 cm. Perimeter = __', '3+4+5=?', ['10','11','12','13'], '12'),
        A.tap('g6_a4', 'Rectangle 6×2. Perimeter?', '6+2+6+2=?', ['12','14','16','18'], '16'),
      ], xp: 70),
      L('geo_7', 'Area', 'Find area of rectangles.', 'Area = length × width.', 'Area Ace', '🔲',
        shapeIntros: [
          ShapeIntro(GeoShape.rectangle, 'Rectangle Area', Colors.orange, 'Area of a rectangle = length × width. A 3 × 4 cm rectangle has area 12 square cm.'),
          ShapeIntro(GeoShape.square, 'Square Area', Colors.green, 'Area of a square = side × side. A 5 cm square has area 25 square cm. That is 25 little 1 cm squares!'),
        ], activities: [
        A.mc('g7_a1', 'Rect 3×4. Area?', '3×4=?', ['7','12','14','16'], '12'),
        A.mc('g7_a2', 'Square 5×5 cm. Area?', '5×5=?', ['10','15','20','25'], '25'),
        A.fb('g7_a3', 'Area = length × __', 'Width or height.', ['width','perimeter','depth','side'], 'width'),
        A.tap('g7_a4', '2×6 rectangle area?', '2×6=?', ['8','10','12','14'], '12'),
      ], xp: 70),
      L('geo_8', 'Right Angles', 'Recognize right angles (90°).', 'Like the corner of a square.', 'Angle Ace', '∟',
        shapeIntros: [
          ShapeIntro(GeoShape.square, 'Square Right Angles', Colors.green, 'A square has 4 right angles — each corner is exactly 90°. That is why squares are so stable!'),
          ShapeIntro(GeoShape.rectangle, 'Rectangle Right Angles', Colors.orange, 'A rectangle also has 4 right angles. Every corner of a door, book, or screen is a right angle.'),
          ShapeIntro(GeoShape.triangle, 'Triangle Right Angle', Colors.red, 'A right triangle has one right angle (90°) and two smaller angles that add up to 90°.'),
        ], activities: [
        A.mc('g8_a1', 'Square has how many right angles?', 'Four 90° corners.', ['2','3','4','5'], '4'),
        A.mc('g8_a2', 'Rectangle has right angles?', 'Four.', ['2','3','4','5'], '4'),
        A.tap('g8_a3', 'Which letter has a right angle?', 'L is a corner.', ['O','L','S','C'], 'L'),
        A.fb('g8_a4', 'Triangle can have __ right angle(s)', 'Only one possible.', ['0','1','2','3'], '1'),
      ], xp: 65),
      L('geo_9', 'Tessellation', 'Shapes fitting without gaps.', 'Squares, triangles, hexagons tile.', 'Tessellator', '🧩',
        shapeIntros: [
          ShapeIntro(GeoShape.square, 'Square Tessellation', Colors.green, 'Squares tile perfectly — tiles, floors, and chessboards use square tessellation.'),
          ShapeIntro(GeoShape.triangle, 'Triangle Tessellation', Colors.red, 'Triangles also tile! Equilateral triangles fit together with no gaps.'),
          ShapeIntro(GeoShape.hexagon, 'Hexagon Tessellation', Colors.teal, 'Regular hexagons tile perfectly — just like honeycomb cells in a beehive.'),
        ],
        activities: [
        A.mc('g9_a1', 'Which shape tiles with no gaps?', 'Square tiles are common.', ['Circle','Square','Star','Heart'], 'Square'),
        A.mc('g9_a2', 'Honeycomb cells are what shape?', 'Six sides.', ['Square','Triangle','Hexagon','Circle'], 'Hexagon'),
        A.tap('g9_a3', 'Pick a tesselating shape', '', ['○','⬠','⬡','★'], '⬡'),
        A.fb('g9_a4', 'Tessellation = shapes with __ gaps', 'Perfect fit.', ['no','small','big','some'], 'no'),
      ], xp: 70),
      L('geo_10', 'Geometry Word Problems', 'Solve geometry in real life.', 'Use shape knowledge.', 'Story Shapes', '📖',
        shapeIntros: [
          ShapeIntro(GeoShape.square, 'Square in Real Life', Colors.green, 'A square garden 5 m per side needs 4 × 5 = 20 m of fencing. Square shapes are everywhere in building!'),
          ShapeIntro(GeoShape.rectangle, 'Rectangle in Real Life', Colors.orange, 'A rectangular floor 6 × 4 m has area 24 sq m. We use rectangles for rooms, tables, and screens.'),
          ShapeIntro(GeoShape.circle, 'Circle in Real Life', Colors.blue, 'A bicycle wheel is a circle. Two wheels = 2 circles. Circles roll smoothly because they have no corners!'),
        ], activities: [
        A.mc('g10_a1', 'Fence a square garden side 5 m. Fence length?', 'Perimeter = 4×5=?', ['15','20','25','10'], '20'),
        A.mc('g10_a2', 'Tile floor 6×4 m. Area?', '6×4=?', ['10','20','24','30'], '24'),
        A.fb('g10_a3', 'Triangular tent 3 sides: 2m, 2m, 3m. Perimeter?', '2+2+3=?', ['6','7','8','9'], '7'),
        A.tap('g10_a4', 'How many circles in a bicycle?', 'Wheels = 2.', ['1','2','3','4'], '2'),
      ], xp: 80),
    ],
  );

  // 13. Patterns
  static final _patternsTopic = T(
    id: 'patterns', title: 'Patterns', description: 'Learn to find, extend, and create patterns.',
    icon: Icons.repeat, color: Colors.deepPurple, order: 13,
    lessons: [
      L('pat_1', 'Color Patterns', 'Identify simple color patterns.', 'Red, blue, red, blue... what comes next?', 'Color Pattern', '🎨', activities: [
        A.mc('p1_a1', '🔴🔵🔴🔵🔴__?', 'The pattern repeats red, blue.', ['🔴','🔵','⚪','⚫'], '🔵'),
        A.mc('p1_a2', '🟢🟡🟢🟡🟢__?', 'Alternates green, yellow.', ['🟢','🟡','🔴','🔵'], '🟡'),
        A.tap('p1_a3', 'Pick the next: 🟣🟠🟣🟠🟣__?', 'Purple then orange.', ['🟣','🟠','⚪','⚫'], '🟠'),
        A.fb('p1_a4', 'Pattern: ⚪⚫⚪⚫⚪__', 'Next is black.', ['⚪','⚫'], '⚫'),
      ], xp: 50),
      L('pat_2', 'Shape Patterns', 'Identify shape patterns.', 'Circle, square, circle, square...', 'Shape Pattern', '🔷', activities: [
        A.mc('p2_a1', '○□○□○__?', 'Repeats circle, square.', ['○','□','△','⬟'], '□'),
        A.mc('p2_a2', '△△○○△△○○△△__?', 'Two triangles, two circles.', ['△','○','□','⬡'], '○'),
        A.tap('p2_a3', 'Next: □○□○□__?', 'Square then circle.', ['□','○','△','⬠'], '○'),
        A.drag('p2_a4', 'Complete pattern: ○□, __, ○□, __', '', ['○□','○□','⬡','⬠'], '○□,○□'),
      ], xp: 55),
      L('pat_3', 'Number Patterns', 'Find the pattern in numbers.', '2, 4, 6, 8... add 2 each time.', 'Number Pattern', '🔢', activities: [
        A.mc('p3_a1', '2, 4, 6, 8, __?', '+2 each time.', ['9','10','11','12'], '10'),
        A.mc('p3_a2', '5, 10, 15, 20, __?', '+5 each time.', ['21','22','23','25'], '25'),
        A.fb('p3_a3', '10, 20, 30, 40, __', '+10 each time.', ['45','50','55','60'], '50'),
        A.mc('p3_a4', '1, 3, 5, 7, __?', 'Odd numbers, +2.', ['8','9','10','11'], '9'),
      ], xp: 60),
      L('pat_4', 'Skip Counting Patterns', 'Patterns with skip counting.', 'Count by 2s, 5s, 10s to find patterns.', 'Skip Pattern', '🦘', activities: [
        A.mc('p4_a1', 'Count by 2s: 2,4,6,8,10, __', 'Next even.', ['11','12','13','14'], '12'),
        A.mc('p4_a2', 'Count by 5s: 5,10,15,20, __', '+5.', ['21','22','23','25'], '25'),
        A.fb('p4_a3', 'Count by 10s: 10,20,30,40,50, __', '+10.', ['55','60','65','70'], '60'),
        A.drag('p4_a4', 'Order by 5s: 15, 5, 20, 10', '', ['5','10','15','20'], '5,10,15,20'),
      ], xp: 60),
      L('pat_5', 'Growing Patterns', 'Patterns that get bigger.', '1, 2, 4, 8... each step doubles.', 'Growing Pattern', '🌱', activities: [
        A.mc('p5_a1', '1, 2, 4, 8, __?', 'Double each time.', ['10','12','14','16'], '16'),
        A.mc('p5_a2', '1, 3, 6, 10, __?', '+2,+3,+4,...', ['12','13','14','15'], '15'),
        A.fb('p5_a3', '1, 10, 100, __', '×10 each time.', ['500','1000','10000','100'], '1000'),
        A.tap('p5_a4', 'Next: ● ●● ●●● ●●●● __', 'Increasing dots.', ['●●●●●','●●●●','●●●','●●'], '●●●●●'),
      ], xp: 65),
      L('pat_6', 'Sound & Action Patterns', 'Patterns with sounds and actions.', 'Clap, stomp, clap, stomp...', 'Sound Pattern', '👏', activities: [
        A.mc('p6_a1', 'Clap, Stomp, Clap, Stomp, Clap, __?', 'Alternating.', ['Clap','Stomp','Jump','Wave'], 'Stomp'),
        A.mc('p6_a2', 'Snap, Snap, Clap, Snap, Snap, Clap, Snap, __?', 'Two snaps + clap.', ['Snap','Clap','Stomp','Wave'], 'Snap'),
        A.fb('p6_a3', 'Up, Down, Up, Down, Up, __', 'Alternating.', ['Up','Down','Left','Right'], 'Down'),
        A.drag('p6_a4', 'Order: Stomp, Clap, Stomp, Clap', '', ['Clap','Clap','Stomp','Stomp'], 'Clap,Clap,Stomp,Stomp'),
      ], xp: 65),
      L('pat_7', 'Increasing Patterns', 'Patterns with growing steps.', '+1, +2, +3, +4...', 'Increase', '📈', activities: [
        A.mc('p7_a1', '1, 2, 4, 7, 11, __?', '+1,+2,+3,+4,+5.', ['15','16','17','18'], '16'),
        A.mc('p7_a2', '2, 4, 7, 11, __?', '+2,+3,+4,+5.', ['14','15','16','17'], '16'),
        A.fb('p7_a3', '10, 20, 40, 70, __', '+10,+20,+30,+40.', ['100','110','120','130'], '110'),
        A.tap('p7_a4', 'Next: ●● ●●●● ●●●●●● __', 'Adding 2 each time.', ['●●●●●●●●','●●●●●●','●●●●','●●'], '●●●●●●●●'),
      ], xp: 70),
      L('pat_8', 'Decreasing Patterns', 'Patterns that get smaller.', '100, 90, 80, 70... subtract 10.', 'Decrease', '📉', activities: [
        A.mc('p8_a1', '100, 90, 80, 70, __?', '-10 each.', ['60','65','75','80'], '60'),
        A.mc('p8_a2', '20, 18, 16, 14, __?', '-2 each.', ['10','11','12','13'], '12'),
        A.fb('p8_a3', '50, 45, 40, 35, __', '-5 each.', ['25','28','30','32'], '30'),
        A.drag('p8_a4', 'Order decreasing: 30, 50, 10, 40', '', ['50','40','30','10'], '50,40,30,10'),
      ], xp: 70),
      L('pat_9', 'Pattern Rules', 'Describe the rule of a pattern.', 'Find what stays the same and what changes.', 'Rule Maker', '📋', activities: [
        A.mc('p9_a1', '2,4,6,8 rule?', 'Add 2 each time.', ['+1','+2','×2','-2'], '+2'),
        A.mc('p9_a2', '1,4,9,16 rule?', '1×1,2×2,3×3,4×4...', ['+3','×2','square','+4'], 'square'),
        A.fb('p9_a3', 'AB pattern means __ things alternate', 'Just two.', ['2','3','4','5'], '2'),
        A.mp('p9_a4', 'Match pattern to rule', '', ['2,4,6,8=+2','10,20,30=+10','1,2,4,8=×2','50,40,30=-10'], '2,4,6,8=+2,10,20,30=+10,1,2,4,8=×2,50,40,30=-10'),
      ], xp: 75),
      L('pat_10', 'Pattern Word Problems', 'Solve pattern problems in real life.', 'Find and use patterns around you.', 'Story Pattern', '📖', activities: [
        A.mc('p10_a1', 'Every 3 days you water a plant. Day 1 water, Day 4 water, Day __?', '+3.', ['5','6','7','8'], '7'),
        A.mc('p10_a2', 'You save  Mon,  Tue,  Wed. Thu?', '+1 each day.', ['','','',''], ''),
        A.fb('p10_a3', 'Beads: red,blue,red,blue. 5th bead is __', 'Odd=red.', ['red','blue','green','yellow'], 'red'),
        A.tap('p10_a4', 'Clap every 4 counts: 1,5,9, next?', '+4.', ['10','11','12','13'], '13'),
      ], xp: 80),
    ],
  );

  // 14. Word Problems
  static final _wordProblemsTopic = T(
    id: 'word_problems', title: 'Word Problems', description: 'Solve real-world problems using math skills.',
    icon: Icons.quiz, color: Colors.lightBlue, order: 14,
    lessons: [
      L('wp_1', 'Addition Stories', 'Solve simple addition word problems.', 'Read the story, then add to find the answer.', 'Add Stories', '📖', activities: [
        A.mc('wp1_a1', '3 cats + 2 cats = ?', '3+2=?', ['4','5','6','7'], '5'),
        A.mc('wp1_a2', '4 red balloons + 3 blue = ?', '4+3=?', ['6','7','8','9'], '7'),
        A.fb('wp1_a3', '2 birds + 5 birds = __ birds', '2+5=?', ['6','7','8','9'], '7'),
        A.tap('wp1_a4', '6 cookies + 4 more = ?', '6+4=?', ['8','9','10','11'], '10'),
      ], xp: 50),
      L('wp_2', 'Subtraction Stories', 'Solve simple subtraction stories.', 'Read carefully and take away.', 'Subtract Stories', '📖', activities: [
        A.mc('wp2_a1', '9 toys, give away 4. Left?', '9-4=?', ['4','5','6','7'], '5'),
        A.mc('wp2_a2', '7 candies, eat 2. Left?', '7-2=?', ['4','5','6','7'], '5'),
        A.fb('wp2_a3', '10 fish, 3 swim away. __ left.', '10-3=?', ['6','7','8','9'], '7'),
        A.tap('wp2_a4', '8 crayons, lose 1. Left?', '8-1=?', ['6','7','8','9'], '7'),
      ], xp: 55),
      L('wp_3', 'Addition and Subtraction Mixed', 'Decide whether to add or subtract.', 'Look for keywords: "more" = add, "left" = subtract.', 'Add or Subtract', '🤔', activities: [
        A.mc('wp3_a1', '5 birds + 3 more = ? Add or subtract?', 'More = add.', ['Add','Subtract','Multiply','Divide'], 'Add'),
        A.mc('wp3_a2', '8 cookies, eat 5 = ? Add or subtract?', 'Eat = take away.', ['Add','Subtract','Multiply','Divide'], 'Subtract'),
        A.fb('wp3_a3', '"10 apples, give 3 away" = __?', 'Take away.', ['add','subtract','multiply','divide'], 'subtract'),
        A.tap('wp3_a4', '"6 balloons + 4 more" = __?', 'More = add.', ['add','subtract','multiply','divide'], 'add'),
      ], xp: 60),
      L('wp_4', 'Multiplication Stories', 'Solve multiplication word problems.', 'Look for equal groups.', 'Multiply Stories', '📖', activities: [
        A.mc('wp4_a1', '3 bags × 4 apples = ?', '3×4=?', ['7','12','15','16'], '12'),
        A.mc('wp4_a2', '2 rows × 6 chairs = ?', '2×6=?', ['8','10','12','14'], '12'),
        A.fb('wp4_a3', '4 boxes × 5 toys = __ toys', '4×5=?', ['9','15','20','25'], '20'),
        A.tap('wp4_a4', '5 kids × 2 hands = ?', '5×2=?', ['7','10','12','15'], '10'),
      ], xp: 65),
      L('wp_5', 'Division Stories', 'Solve division word problems.', 'Look for sharing equally.', 'Divide Stories', '📖', activities: [
        A.mc('wp5_a1', '12 candies ÷ 4 friends = ?', '12÷4=?', ['2','3','4','5'], '3'),
        A.mc('wp5_a2', '15 cookies ÷ 5 kids = ?', '15÷5=?', ['2','3','4','5'], '3'),
        A.fb('wp5_a3', '20 pencils ÷ 4 boxes = __ each', '20÷4=?', ['4','5','6','7'], '5'),
        A.tap('wp5_a4', '16 eggs in cartons of 2 = ? cartons', '16÷2=?', ['6','7','8','9'], '8'),
      ], xp: 70),
      L('wp_6', 'Money Stories', 'Solve money word problems.', 'Add, subtract, multiply money amounts.', 'Money Stories', '💰', activities: [
        A.mc('wp6_a1', '75¢ + 25¢ = ?', '75+25=?', ['75¢','.00','.25','.50'], '.00'),
        A.mc('wp6_a2', '.00 - .50 = ?', '5-2.50=?', ['.00','.50','.00','.50'], '.50'),
        A.fb('wp6_a3', '3 × 25¢ = __ ¢', '3 quarters.', ['50','75','100','125'], '75'),
        A.tap('wp6_a4', '.00 - .50 = ?', '10-3.50=?', ['.00','.50','.00','.50'], '.50'),
      ], xp: 70),
      L('wp_7', 'Time Stories', 'Solve time word problems.', 'Add and subtract time.', 'Time Stories', '⏰', activities: [
        A.mc('wp7_a1', 'Start 2:00, end 3:00. Duration?', '1 hour.', ['30 min','1 hour','2 hours','90 min'], '1 hour'),
        A.mc('wp7_a2', 'Movie 7:00-8:30 = __ min', '90 min.', ['60','75','90','120'], '90'),
        A.fb('wp7_a3', 'School 8:00-12:00 = __ hours', '4 hours.', ['3','4','5','6'], '4'),
        A.tap('wp7_a4', 'Bedtime 8:30, read 30 min. To bed at?', '9:00.', ['8:45','9:00','9:30','10:00'], '9:00'),
      ], xp: 70),
      L('wp_8', 'Measurement Stories', 'Solve measurement word problems.', 'Use length, weight, volume.', 'Measure Stories', '📖', activities: [
        A.mc('wp8_a1', 'Ribbon 2 m + 3 m = ?', '2+3=?', ['4 m','5 m','6 m','7 m'], '5 m'),
        A.mc('wp8_a2', '5 kg - 2 kg = ?', '5-2=?', ['2 kg','3 kg','4 kg','5 kg'], '3 kg'),
        A.fb('wp8_a3', '1 L + 500 mL = __ mL', '1000+500=?', ['1000','1500','2000','2500'], '1500'),
        A.tap('wp8_a4', 'Tape 30 cm long, cut 10 cm. Left?', '30-10=?', ['15','20','25','30'], '20'),
      ], xp: 75),
      L('wp_9', 'Multi-Step Stories', 'Solve problems with two steps.', 'First add, then subtract (or vice versa).', 'Two-Step', '2️⃣', activities: [
        A.mc('wp9_a1', 'Have 10 toys. Get 3 more. Give 2 away. Left?', '10+3=13, 13-2=?', ['9','10','11','12'], '11'),
        A.mc('wp9_a2', '8 cookies. Eat 2. Friend gives 3 more. Total?', '8-2=6, 6+3=?', ['7','8','9','10'], '9'),
        A.fb('wp9_a3', '.00. Spend .50. Find .00. Have ', '5-2.5=2.5, 2.5+1=?', ['.50','.00','.50','.00'], '.50'),
        A.drag('wp9_a4', 'Steps for: 5+3-2', '', ['add 3','subtract 2','start 5'], 'start 5,add 3,subtract 2'),
      ], xp: 80),
      L('wp_10', 'Challenge Stories', 'Tricky word problems using all skills.', 'Think carefully about what the question asks.', 'Challenge', '🏆', activities: [
        A.mc('wp10_a1', '24 students in groups of 4. How many groups?', '24÷4=?', ['4','5','6','8'], '6'),
        A.mc('wp10_a2', '36 eggs, 12 per carton. How many cartons?', '36÷12=?', ['2','3','4','5'], '3'),
        A.fb('wp10_a3', 'Share  among 4 kids =  each.', '20÷4=?', ['','','',''], ''),
        A.tap('wp10_a4', '3 km walk, stop every 500 m. How many stops?', '3000÷500=?', ['4','5','6','7'], '6'),
      ], xp: 90),
    ],
  );

  // 15. Place Value
  static final _placeValueTopic = T(
    id: 'place_value', title: 'Place Value', description: 'Learn about ones, tens, hundreds, and more.',
    icon: Icons.grid_view, color: Colors.blueGrey, order: 15,
    lessons: [
      L('pv_1', 'Ones', 'Understand the ones place.', 'The rightmost digit shows how many ones.', 'One Place', '1️⃣', activities: [
        A.mc('pv1_a1', 'In 7, how many ones?', '7 means 7 ones.', ['0','7','70','1'], '7'),
        A.mc('pv1_a2', 'In 23, the digit in the ones place is?', '3 is the rightmost.', ['2','3','23','30'], '3'),
        A.fb('pv1_a3', '6 ones = __', 'The number 6.', ['6','60','16','61'], '6'),
        A.tap('pv1_a4', 'Tap number with 9 ones', '', ['9','90','19','91'], '9'),
      ], xp: 50),
      L('pv_2', 'Tens and Ones', 'Understand two-digit numbers.', '32 = 3 tens + 2 ones.', 'Tens Place', '🔟', activities: [
        A.mc('pv2_a1', 'In 45, how many tens?', 'First digit.', ['4','5','45','0'], '4'),
        A.mc('pv2_a2', 'In 83, how many ones?', 'Second digit.', ['3','8','80','83'], '3'),
        A.fb('pv2_a3', '5 tens + 7 ones = __', '50+7=?', ['57','75','50','7'], '57'),
        A.mp('pv2_a4', 'Match numbers to place value', '', ['23=2t3o','47=4t7o','56=5t6o','71=7t1o'], '23=2t3o,47=4t7o,56=5t6o,71=7t1o'),
      ], xp: 55),
      L('pv_3', 'Hundreds', 'Understand three-digit numbers.', '632 = 6 hundreds + 3 tens + 2 ones.', 'Hundreds', '💯', activities: [
        A.mc('pv3_a1', 'In 528, which digit is hundreds?', 'First digit.', ['5','2','8','52'], '5'),
        A.mc('pv3_a2', 'In 604, how many tens?', 'Zero tens!', ['0','6','4','60'], '0'),
        A.fb('pv3_a3', '300 + 40 + 5 = __', '345.', ['345','354','435','534'], '345'),
        A.tap('pv3_a4', 'Pick the number with 7 hundreds', '', ['700','70','770','707'], '700'),
      ], xp: 60),
      L('pv_4', 'Expanded Form', 'Write numbers in expanded form.', '425 = 400 + 20 + 5.', 'Expand It', '🧩', activities: [
        A.mc('pv4_a1', '300 + 50 + 2 = ?', '352.', ['325','352','523','253'], '352'),
        A.mc('pv4_a2', '200 + 80 + 1 = ?', '281.', ['218','281','821','182'], '281'),
        A.fb('pv4_a3', '467 = 400 + __ + 7', '60.', ['60','6','600','0'], '60'),
        A.drag('pv4_a4', 'Order expanded form: 200+5, 200+50, 200+50+5, 20+5', '', ['20+5','200+5','200+50','200+50+5'], '20+5,200+5,200+50,200+50+5'),
      ], xp: 65),
      L('pv_5', 'Thousands', 'Understand four-digit numbers.', '1,000 = 10 hundreds = 100 tens = 1,000 ones.', 'Thousands', '💲', activities: [
        A.mc('pv5_a1', 'How many zeros in 1,000?', 'Three zeros.', ['1','2','3','4'], '3'),
        A.mc('pv5_a2', '2,000 = __ hundreds', '2000÷100=?', ['2','20','200','2000'], '20'),
        A.fb('pv5_a3', '1,000 + 200 + 30 + 4 = __', '1234.', ['1234','4321','1000','1243'], '1234'),
        A.nl('pv5_a4', 'Tap 2,500 on a 0-5,000 line.', 'Halfway.', ['2500'], '2500'),
      ], xp: 70),
      L('pv_6', 'Comparing Place Values', 'Compare numbers using place value.', 'Compare hundreds first, then tens, then ones.', 'Value Compare', '⚖️', activities: [
        A.mc('pv6_a1', 'Which is bigger: 123 or 132?', 'Compare tens: 2 vs 3.', ['123','132','Same'], '132'),
        A.mc('pv6_a2', 'Which is smaller: 456 or 465?', 'Compare tens: 5 vs 6.', ['456','465','Same'], '456'),
        A.fb('pv6_a3', '789 ___ 798 (>, <, or =)', '789 < 798.', ['>','<','='], '<'),
        A.drag('pv6_a4', 'Order smallest: 345, 354, 334, 343', 'Compare carefully.', ['334','343','345','354'], '334,343,345,354'),
      ], xp: 70),
      L('pv_7', 'Rounding to 10', 'Round numbers to the nearest 10.', 'If ones digit >=5, round up. Otherwise round down.', 'Round Ten', '🔟', activities: [
        A.mc('pv7_a1', 'Round 23 to nearest 10?', 'Ones=3 < 5, round down.', ['10','20','25','30'], '20'),
        A.mc('pv7_a2', 'Round 37 to nearest 10?', 'Ones=7 >= 5, round up.', ['30','35','40','50'], '40'),
        A.fb('pv7_a3', 'Round 45 to nearest 10 = __', 'Ones=5, round up.', ['40','45','50','55'], '50'),
        A.tap('pv7_a4', 'Round 52 to nearest 10?', 'Ones=2 < 5.', ['50','55','60','40'], '50'),
      ], xp: 75),
      L('pv_8', 'Rounding to 100', 'Round numbers to the nearest 100.', 'If tens digit >=5, round up. Otherwise round down.', 'Round Hundred', '💯', activities: [
        A.mc('pv8_a1', 'Round 230 to nearest 100?', 'Tens=3 < 5, round down.', ['100','200','250','300'], '200'),
        A.mc('pv8_a2', 'Round 278 to nearest 100?', 'Tens=7 >= 5, round up.', ['200','250','280','300'], '300'),
        A.fb('pv8_a3', 'Round 350 to nearest 100 = __', 'Tens=5, round up.', ['300','350','400','500'], '400'),
        A.tap('pv8_a4', 'Round 149 to nearest 100?', 'Tens=4 < 5.', ['100','140','150','200'], '100'),
      ], xp: 75),
      L('pv_9', 'Place Value in Decimals', 'Extend place value to decimals.', 'Tenths = first decimal place, hundredths = second.', 'Decimal Value', '0.1', activities: [
        A.mc('pv9_a1', 'In 0.5, which place is the 5?', 'First decimal = tenths.', ['Ones','Tenths','Hundredths','Thousands'], 'Tenths'),
        A.mc('pv9_a2', 'In 0.25, the 5 is in __ place.', 'Second decimal = hundredths.', ['Ones','Tenths','Hundredths','Thousands'], 'Hundredths'),
        A.fb('pv9_a3', '0.3 = __ tenths', 'The digit 3 is in tenths.', ['3','30','0.3','0.03'], '3'),
        A.tap('pv9_a4', 'Which number has 7 in the hundredths place?', 'Second decimal digit.', ['0.7','0.07','7.0','0.007'], '0.07'),
      ], xp: 80),
      L('pv_10', 'Place Value Puzzles', 'Challenging place value problems.', 'Use all your place value skills.', 'Value Puzzle', '🧩', activities: [
        A.mc('pv10_a1', 'I have 4 tens and 3 ones. What number?', '40+3=?', ['34','43','403','430'], '43'),
        A.mc('pv10_a2', 'I have 5 hundreds, 0 tens, 2 ones. Number?', '500+0+2=?', ['502','520','52','5002'], '502'),
        A.fb('pv10_a3', 'Largest 3-digit number = __', 'All 9s.', ['900','999','990','909'], '999'),
        A.tap('pv10_a4', 'Smallest 4-digit number?', '1000.', ['100','1000','10000','0'], '1000'),
      ], xp: 90),
    ],
  );

  static final List<T> _englishTopics = [
    _alphabetTopic,
    _phonicsTopic,
    _vocabularyTopic,
    _readingTopic,
    _grammarTopic,
    _spellingTopic,
    _sentenceBuildingTopic,
    _speakingTopic,
    _listeningTopic,
    _comprehensionTopic,
    _storytellingTopic,
    _creativeWritingTopic,
    _punctuationTopic,
  ];

  // E1. Alphabet
  static final _alphabetTopic = T(
    id: 'alphabet', title: 'Alphabet', description: 'Learn letters A-Z, uppercase and lowercase.',
    icon: Icons.abc, color: Colors.red, order: 1,
    lessons: [
      L('abc_1', 'Letters A-E', 'Recognize letters A through E.', 'A, B, C, D, E — the first five letters.', 'ABC Star', '🔤', activities: [
        A.mc('abc1_a1', 'Which letter comes after A?', 'A, B, C...', ['B','C','D','E'], 'B'),
        A.mc('abc1_a2', 'Which letter starts "apple"?', 'Apple begins with A.', ['A','B','C','D'], 'A'),
        A.tap('abc1_a3', 'Pick the letter D', '', ['A','B','C','D'], 'D'),
        A.fb('abc1_a4', 'A, B, C, D, __', 'Next after D.', ['E','F','G','H'], 'E'),
      ], xp: 50),
      L('abc_2', 'Letters F-J', 'Recognize letters F through J.', 'F, G, H, I, J — the next five letters.', 'Letter Spotter', '🔤', activities: [
        A.mc('abc2_a1', 'Which letter comes after F?', 'F, G...', ['E','G','H','I'], 'G'),
        A.mc('abc2_a2', 'Which letter starts "fish"?', 'Fish begins with F.', ['F','G','H','I'], 'F'),
        A.tap('abc2_a3', 'Pick the letter H', '', ['F','G','H','I'], 'H'),
        A.fb('abc2_a4', 'F, G, H, __, J', 'Missing letter.', ['E','I','K','L'], 'I'),
      ], xp: 50),
      L('abc_3', 'Letters K-O', 'Recognize letters K through O.', 'K, L, M, N, O — the middle five.', 'Letter Finder', '🔤', activities: [
        A.mc('abc3_a1', 'Which letter comes after K?', 'K, L...', ['J','L','M','N'], 'L'),
        A.mc('abc3_a2', 'Which letter starts "monkey"?', 'Monkey begins with M.', ['K','L','M','N'], 'M'),
        A.tap('abc3_a3', 'Pick the letter N', '', ['K','L','M','N'], 'N'),
        A.fb('abc3_a4', 'K, L, M, N, __', 'Next after N.', ['O','P','Q','R'], 'O'),
      ], xp: 55),
      L('abc_4', 'Letters P-T', 'Recognize letters P through T.', 'P, Q, R, S, T — nearly there!', 'Letter Hunter', '🔤', activities: [
        A.mc('abc4_a1', 'Which letter comes after R?', 'P, Q, R, S...', ['Q','S','T','U'], 'S'),
        A.mc('abc4_a2', 'Which letter starts "sun"?', 'Sun begins with S.', ['P','Q','R','S'], 'S'),
        A.tap('abc4_a3', 'Pick the letter Q', '', ['P','Q','R','S'], 'Q'),
        A.fb('abc4_a4', 'P, Q, R, S, __', 'Next after S.', ['T','U','V','W'], 'T'),
      ], xp: 55),
      L('abc_5', 'Letters U-Z', 'Recognize letters U through Z.', 'U, V, W, X, Y, Z — the last six!', 'Letter Star', '🔤', activities: [
        A.mc('abc5_a1', 'Which letter comes after V?', 'U, V, W...', ['U','W','X','Y'], 'W'),
        A.mc('abc5_a2', 'Which letter starts "zebra"?', 'Zebra begins with Z.', ['V','W','X','Z'], 'Z'),
        A.tap('abc5_a3', 'Pick the letter X', '', ['U','V','W','X'], 'X'),
        A.fb('abc5_a4', 'U, V, W, X, Y, __', 'The last letter!', ['Z','A','B','C'], 'Z'),
      ], xp: 55),
      L('abc_6', 'Uppercase Letters', 'Recognize capital letters A-Z.', 'Uppercase letters are big letters used at the start of sentences.', 'Capital Star', '⬆️', activities: [
        A.mc('abc6_a1', 'Which is uppercase A?', 'Big A.', ['a','A','а','@'], 'A'),
        A.mc('abc6_a2', 'Which is uppercase G?', 'Big G.', ['g','G','6','9'], 'G'),
        A.tap('abc6_a3', 'Pick the uppercase M', '', ['m','M','n','N'], 'M'),
        A.drag('abc6_a4', 'Match uppercase to lowercase: A, B, C to a, b, c', '', ['A=a','B=b','C=c'], 'A=a,B=b,C=c'),
      ], xp: 55),
      L('abc_7', 'Lowercase Letters', 'Recognize small letters a-z.', 'Lowercase letters are used most of the time.', 'Small Star', '⬇️', activities: [
        A.mc('abc7_a1', 'Which is lowercase b?', 'Small b.', ['B','b','p','d'], 'b'),
        A.mc('abc7_a2', 'Which is lowercase q?', 'Small q.', ['Q','q','p','9'], 'q'),
        A.tap('abc7_a3', 'Pick the lowercase f', '', ['F','f','t','h'], 'f'),
        A.fb('abc7_a4', 'The lowercase of M is __', 'Small m.', ['m','M','n','N'], 'm'),
      ], xp: 55),
      L('abc_8', 'Vowels: A, E, I, O, U', 'Learn the vowel letters.', 'Vowels are special letters. Every word has a vowel!', 'Vowel Vibe', '🅰️', activities: [
        A.mc('abc8_a1', 'Which letter is a vowel?', 'Vowels: A, E, I, O, U.', ['A','B','C','D'], 'A'),
        A.mc('abc8_a2', 'How many vowels are there?', 'A, E, I, O, U = 5.', ['3','4','5','6'], '5'),
        A.tap('abc8_a3', 'Pick the vowel', '', ['A','B','C','D'], 'A'),
        A.fb('abc8_a4', 'The vowels are A, E, I, O, __', 'Last vowel.', ['U','Y','W','Z'], 'U'),
      ], xp: 60),
      L('abc_9', 'ABC Order', 'Put letters in alphabetical order.', 'ABC order means A comes first, Z comes last.', 'ABC Order', '📋', activities: [
        A.drag('abc9_a1', 'Order: C, A, B', '', ['A','B','C'], 'A,B,C'),
        A.drag('abc9_a2', 'Order: F, D, E, G', '', ['D','E','F','G'], 'D,E,F,G'),
        A.mc('abc9_a3', 'Which comes first: M or N?', 'M is before N.', ['M','N','Same'], 'M'),
        A.fb('abc9_a4', 'Before Z comes __', 'Y is before Z.', ['X','Y','A','Z'], 'Y'),
      ], xp: 60),
      L('abc_10', 'Alphabet Challenge', 'Mix of all alphabet skills.', 'Show what you know about letters!', 'ABC Champ', '🏆', activities: [
        A.mc('abc10_a1', 'How many letters in the alphabet?', 'Count them!', ['24','25','26','27'], '26'),
        A.mc('abc10_a2', 'First letter of the alphabet?', 'A is first.', ['A','B','Z','1'], 'A'),
        A.fb('abc10_a3', 'Last letter of the alphabet is __', 'Z is last.', ['A','Y','Z','X'], 'Z'),
        A.mp('abc10_a4', 'Match uppercase to lowercase', '', ['A=a','M=m','P=p','Z=z'], 'A=a,M=m,P=p,Z=z'),
      ], xp: 70),
    ],
  );

  // E2. Phonics
  static final _phonicsTopic = T(
    id: 'phonics', title: 'Phonics', description: 'Learn letter sounds and how to blend them.',
    icon: Icons.record_voice_over, color: Colors.pink, order: 2,
    lessons: [
      L('ph_1', 'Letter Sounds A-D', 'Learn the sounds of A, B, C, D.', 'A says /a/ like apple. B says /b/ like ball.', 'Sound Start', '🔊', activities: [
        A.mc('ph1_a1', 'What sound does A make?', '/a/ as in apple.', ['/a/','/b/','/c/','/d/'], '/a/'),
        A.mc('ph1_a2', 'What sound does B make?', '/b/ as in ball.', ['/a/','/b/','/c/','/d/'], '/b/'),
        A.tap('ph1_a3', 'Which letter makes /k/?', 'C says /k/ like cat.', ['A','B','C','D'], 'C'),
        A.fb('ph1_a4', 'D says /__/', '/d/ like dog.', ['a','b','c','d'], 'd'),
      ], xp: 50),
      L('ph_2', 'Letter Sounds E-H', 'Learn the sounds of E, F, G, H.', 'E says /e/ like egg. F says /f/ like fish.', 'Sound Builder', '🔊', activities: [
        A.mc('ph2_a1', 'What sound does E make?', '/e/ as in egg.', ['/e/','/f/','/g/','/h/'], '/e/'),
        A.mc('ph2_a2', 'What starts with /f/?', 'Fish starts with F.', ['egg','fish','goat','hat'], 'fish'),
        A.tap('ph2_a3', 'Which letter makes /g/?', 'G says /g/ like goat.', ['E','F','G','H'], 'G'),
        A.fb('ph2_a4', 'H says /__/', '/h/ like hat.', ['e','f','g','h'], 'h'),
      ], xp: 50),
      L('ph_3', 'Letter Sounds I-L', 'Learn the sounds of I, J, K, L.', 'I says /i/ like igloo.', 'Sound Learner', '🔊', activities: [
        A.mc('ph3_a1', 'What sound does I make?', '/i/ as in igloo.', ['/i/','/j/','/k/','/l/'], '/i/'),
        A.mc('ph3_a2', 'What starts with /j/?', 'Jump starts with J.', ['igloo','jump','kite','lion'], 'jump'),
        A.tap('ph3_a3', 'Which letter makes /k/?', 'K says /k/ like kite.', ['I','J','K','L'], 'K'),
        A.fb('ph3_a4', 'L says /__/', '/l/ like lion.', ['i','j','k','l'], 'l'),
      ], xp: 55),
      L('ph_4', 'CVC Words: Short A', 'Blend consonant-vowel-consonant words with short A.', 'c-a-t = cat! Blend each sound.', 'CVC Reader', '🐱', activities: [
        A.mc('ph4_a1', 'c-a-t = ?', 'Blend: c, a, t.', ['cat','cut','cot','kit'], 'cat'),
        A.mc('ph4_a2', 'h-a-t = ?', 'Blend: h, a, t.', ['hat','hit','hot','hut'], 'hat'),
        A.fb('ph4_a3', 'm-a-n = __', 'Blend: m, a, n.', ['men','man','min','mon'], 'man'),
        A.tap('ph4_a4', 'Which word is b-a-t?', 'b-a-t = bat.', ['bat','bet','bit','bot'], 'bat'),
      ], xp: 55),
      L('ph_5', 'CVC Words: Short E', 'Blend CVC words with short E.', 'p-e-n = pen! Blend each sound.', 'Short E', '✏️', activities: [
        A.mc('ph5_a1', 'p-e-n = ?', 'Blend: p, e, n.', ['pen','pan','pin','pun'], 'pen'),
        A.mc('ph5_a2', 'r-e-d = ?', 'Blend: r, e, d.', ['red','rod','rad','rid'], 'red'),
        A.fb('ph5_a3', 't-e-n = __', 'Blend: t, e, n.', ['tan','tin','ten','ton'], 'ten'),
        A.tap('ph5_a4', 'Which word is b-e-d?', 'b-e-d = bed.', ['bad','bed','bid','bud'], 'bed'),
      ], xp: 60),
      L('ph_6', 'CVC Words: Short I', 'Blend CVC words with short I.', 'p-i-g = pig!', 'Short I', '🐷', activities: [
        A.mc('ph6_a1', 'p-i-g = ?', 'Blend: p, i, g.', ['pig','peg','pag','pug'], 'pig'),
        A.mc('ph6_a2', 's-i-t = ?', 'Blend: s, i, t.', ['sat','sit','set','sot'], 'sit'),
        A.fb('ph6_a3', 'f-i-sh = __', 'Blend: f, i, sh.', ['fish','fash','fosh','fush'], 'fish'),
        A.tap('ph6_a4', 'Which word is b-i-g?', 'b-i-g = big.', ['bag','beg','big','bug'], 'big'),
      ], xp: 60),
      L('ph_7', 'CVC Words: Short O', 'Blend CVC words with short O.', 'd-o-g = dog!', 'Short O', '🐕', activities: [
        A.mc('ph7_a1', 'd-o-g = ?', 'Blend: d, o, g.', ['dog','dig','dag','dug'], 'dog'),
        A.mc('ph7_a2', 'h-o-t = ?', 'Blend: h, o, t.', ['hat','hit','hot','hut'], 'hot'),
        A.fb('ph7_a3', 'f-o-x = __', 'Blend: f, o, x.', ['fox','fax','fix','fex'], 'fox'),
        A.tap('ph7_a4', 'Which word is b-o-x?', 'b-o-x = box.', ['box','bax','bex','bix'], 'box'),
      ], xp: 60),
      L('ph_8', 'CVC Words: Short U', 'Blend CVC words with short U.', 'b-u-s = bus!', 'Short U', '🚌', activities: [
        A.mc('ph8_a1', 'b-u-s = ?', 'Blend: b, u, s.', ['bus','bas','bes','bos'], 'bus'),
        A.mc('ph8_a2', 'c-u-p = ?', 'Blend: c, u, p.', ['cap','cep','cip','cup'], 'cup'),
        A.fb('ph8_a3', 's-u-n = __', 'Blend: s, u, n.', ['san','sen','son','sun'], 'sun'),
        A.tap('ph8_a4', 'Which word is r-u-g?', 'r-u-g = rug.', ['rag','reg','rig','rug'], 'rug'),
      ], xp: 60),
      L('ph_9', 'Beginning Blends', 'Blend two consonants at the start.', 'bl, cl, fl, gl, pl, sl — say them together.', 'Blend It', '🔗', activities: [
        A.mc('ph9_a1', 'bl plus ue = ?', 'bl + ue = blue.', ['blue','black','blow','bloom'], 'blue'),
        A.mc('ph9_a2', 'fl plus ag = ?', 'fl + ag = flag.', ['flag','flap','flog','flit'], 'flag'),
        A.fb('ph9_a3', 'cl + ap = __', 'cl + ap = clap.', ['cap','clap','lap','clip'], 'clap'),
        A.tap('ph9_a4', 'Which word starts with "gr"?', 'Green starts with gr.', ['green','red','blue','pink'], 'green'),
      ], xp: 70),
      L('ph_10', 'Digraphs: sh, ch, th', 'Learn two-letter sounds.', 'sh = /sh/, ch = /ch/, th = /th/.', 'Digraphs', '🔤', activities: [
        A.mc('ph10_a1', 'sh + ip = ?', 'sh + ip = ship.', ['ship','chip','tip','shop'], 'ship'),
        A.mc('ph10_a2', 'ch + in = ?', 'ch + in = chin.', ['chin','shin','thin','win'], 'chin'),
        A.fb('ph10_a3', 'th + ree = __', 'th + ree = three.', ['three','tree','free','there'], 'three'),
        A.tap('ph10_a4', 'Which word starts with "sh"?', 'Ship starts with sh.', ['ship','chip','tip','dip'], 'ship'),
      ], xp: 75),
    ],
  );

  // E3. Vocabulary
  static final _vocabularyTopic = T(
    id: 'vocabulary', title: 'Vocabulary', description: 'Build your English vocabulary with common words.',
    icon: Icons.book, color: Colors.blue, order: 3,
    lessons: [
      L('voc_1', 'Animals', 'Learn animal names.',
        'Animals are living things that move, eat, and breathe. Let\'s learn some of their names!',
        'Animal Friend', '🐾',
        vocabWords: [
          VocabWord('🐶', 'Dog', 'A friendly animal that wags its tail and barks.', 'The dog runs in the yard.'),
          VocabWord('🐱', 'Cat', 'A small animal with soft fur that says meow.', 'The cat sleeps on the warm rug.'),
          VocabWord('🐦', 'Bird', 'A small animal with wings and feathers that can fly.', 'The bird sings a sweet song.'),
          VocabWord('🐟', 'Fish', 'An animal that swims and lives under water.', 'The fish swims in the blue pond.'),
        ],
        activities: [
          A.mc('voc1_a1', 'Which animal says "woof"?', 'Think of a barking animal.', ['Cat','Dog','Bird','Fish'], 'Dog'),
          A.mc('voc1_a2', 'Which animal has feathers and can fly?', 'Think of a winged creature.', ['Dog','Cat','Bird','Fish'], 'Bird'),
          A.tap('voc1_a3', 'Pick the cat', 'Look for the feline emoji.', ['🐱','🐶','🐟','🐦'], '🐱'),
          A.fb('voc1_a4', 'A fish lives in the __', 'Where do fish swim?', ['water','tree','house','sky'], 'water'),
        ], xp: 50),
      L('voc_2', 'Colors', 'Learn color names.',
        'Colors make our world bright and beautiful. Let\'s learn the names of primary colors!',
        'Color Fun', '🎨',
        vocabWords: [
          VocabWord('🔴', 'Red', 'The color of apples, fire, and strawberries.', 'She wore a red coat today.'),
          VocabWord('🔵', 'Blue', 'The color of the clear sky and deep ocean.', 'The blue sky is beautiful today.'),
          VocabWord('🟡', 'Yellow', 'The color of bananas, lemons, and the bright sun.', 'The yellow banana is ripe and sweet.'),
          VocabWord('🟢', 'Green', 'The color of grass, leaves, and frogs.', 'The green grass is soft to step on.'),
        ],
        activities: [
          A.mc('voc2_a1', 'What color is the clear daytime sky?', 'Look up at the sky.', ['Red','Blue','Green','Yellow'], 'Blue'),
          A.mc('voc2_a2', 'What color is fresh summer grass?', 'Think of nature and leaves.', ['Red','Blue','Green','Yellow'], 'Green'),
          A.tap('voc2_a3', 'Pick the color red', 'Look for the red circle.', ['🔴','🔵','🟢','🟡'], '🔴'),
          A.fb('voc2_a4', 'A banana is __ when it is ripe.', 'Think of bright fruit colors.', ['red','blue','green','yellow'], 'yellow'),
        ], xp: 50),
      L('voc_3', 'Food', 'Learn food vocabulary.',
        'Food gives us energy to play and learn. Let\'s discover some delicious foods!',
        'Foodie', '🍎',
        vocabWords: [
          VocabWord('🍎', 'Apple', 'A sweet, round fruit that can be red, green, or yellow.', 'He ate a crunchy red apple.'),
          VocabWord('🍞', 'Bread', 'A soft food made from flour, water, and yeast.', 'I eat toast made of sliced bread.'),
          VocabWord('🥛', 'Milk', 'A white liquid drink that comes from cows.', 'A cold glass of milk is delicious.'),
          VocabWord('🥚', 'Egg', 'An oval food with a shell, laid by chickens.', 'She had a boiled egg for breakfast.'),
        ],
        activities: [
          A.mc('voc3_a1', 'Which round fruit can be red or green?', 'It is crunchy and sweet.', ['Apple','Bread','Milk','Egg'], 'Apple'),
          A.mc('voc3_a2', 'Which healthy drink is white and comes from cows?', 'Drink it cold.', ['Apple','Bread','Milk','Egg'], 'Milk'),
          A.tap('voc3_a3', 'Pick the bread', 'Look for the loaf icon.', ['🍞','🥛','🍎','🥚'], '🍞'),
          A.fb('voc3_a4', 'An egg has a hard outer __.', 'It protects the inside.', ['shell','skin','fur','feather'], 'shell'),
        ], xp: 55),
      L('voc_4', 'Body Parts', 'Learn parts of the body.',
        'Our body has different parts that help us do things every day. Let\'s name them!',
        'Body Builder', '🧍',
        vocabWords: [
          VocabWord('👃', 'Nose', 'The part of your face that you use for smelling.', 'I can smell the flower with my nose.'),
          VocabWord('👀', 'Eyes', 'The parts of your head that you use to see.', 'Close your eyes when you sleep.'),
          VocabWord('👂', 'Ear', 'The part of your head that you use for hearing sounds.', 'She listens to music with her ears.'),
          VocabWord('👄', 'Mouth', 'The part of your face that you use for eating and speaking.', 'Put the food in your mouth.'),
        ],
        activities: [
          A.mc('voc4_a1', 'Which part of your face is used for smelling?', 'It is in the middle of your face.', ['Nose','Knee','Elbow','Toe'], 'Nose'),
          A.mc('voc4_a2', 'How many eyes does a person have?', 'Think of how you see.', ['1','2','3','4'], '2'),
          A.tap('voc4_a3', 'Pick the ear', 'Look for the listening emoji.', ['👂','👃','👀','👄'], '👂'),
          A.fb('voc4_a4', 'You use your __ to see the world.', 'Open them to see.', ['ears','eyes','nose','mouth'], 'eyes'),
        ], xp: 55),
      L('voc_5', 'Clothes', 'Learn clothing vocabulary.',
        'Clothes keep us warm and protect our bodies. Let\'s name what we wear!',
        'Fashion', '👕',
        vocabWords: [
          VocabWord('👕', 'Shirt', 'A piece of clothing worn on the upper part of the body.', 'He wears a blue shirt to school.'),
          VocabWord('👖', 'Pants', 'Clothing worn on the lower body, covering both legs.', 'She wore long blue pants.'),
          VocabWord('👟', 'Shoes', 'Outer coverings for the feet, used when walking.', 'Tie the laces of your shoes.'),
          VocabWord('🧢', 'Hat', 'A covering for the head, worn for warmth or shade.', 'Put on a hat to block the sun.'),
        ],
        activities: [
          A.mc('voc5_a1', 'What do you wear on your feet to protect them?', 'They have soles and laces.', ['Hat','Shirt','Shoes','Pants'], 'Shoes'),
          A.mc('voc5_a2', 'What do you wear on your head for shade?', 'It sits on top of your head.', ['Hat','Shirt','Shoes','Pants'], 'Hat'),
          A.tap('voc5_a3', 'Pick the shirt', 'Look for the short sleeve tee.', ['👕','👖','👟','🧢'], '👕'),
          A.fb('voc5_a4', 'You wear pants to cover your __.', 'They cover the lower body.', ['head','arms','legs','feet'], 'legs'),
        ], xp: 55),
      L('voc_6', 'Weather', 'Learn weather words.',
        'Weather changes from day to day. Let\'s learn words to describe the sky and air!',
        'Weather', '☀️',
        vocabWords: [
          VocabWord('☀️', 'Sunny', 'Filled with bright light and warmth from the sun.', 'It is a hot and sunny summer day.'),
          VocabWord('🌧️', 'Rainy', 'Having a lot of rain falling from the clouds.', 'Take an umbrella on this rainy day.'),
          VocabWord('☁️', 'Cloudy', 'Covered with grey or white clouds in the sky.', 'The sky is cloudy, so we cannot see the sun.'),
          VocabWord('❄️', 'Snowy', 'Covered with soft, white flakes of cold ice.', 'We made a snowman on a snowy day.'),
        ],
        activities: [
          A.mc('voc6_a1', 'When it is hot and bright outside, it is __.', 'The sun is shining.', ['Sunny','Rainy','Cloudy','Snowy'], 'Sunny'),
          A.mc('voc6_a2', 'When water drops fall from the sky, it is __.', 'Use an umbrella.', ['Sunny','Rainy','Cloudy','Snowy'], 'Rainy'),
          A.tap('voc6_a3', 'Pick the snowflake', 'Look for the cold crystal.', ['☀️','🌧️','☁️','❄️'], '❄️'),
          A.fb('voc6_a4', 'When there are many clouds in the sky, it is __.', 'Not clear, not raining yet.', ['cloudy','sunny','rainy','windy'], 'cloudy'),
        ], xp: 60),
      L('voc_7', 'Opposites', 'Learn opposite words.',
        'Opposite words are pairs that are completely different from each other. Let\'s see!',
        'Opposites', '↔️',
        vocabWords: [
          VocabWord('🐘', 'Big', 'Very large in size or amount.', 'An elephant is a big animal.'),
          VocabWord('🐭', 'Small', 'Tiny or little in size.', 'A mouse is a small animal.'),
          VocabWord('🔥', 'Hot', 'Having a very high temperature.', 'The soup is too hot to eat.'),
          VocabWord('❄️', 'Cold', 'Having a very low temperature.', 'Ice cream is sweet and cold.'),
        ],
        activities: [
          A.mc('voc7_a1', 'What is the opposite of the word "big"?', 'Think of a tiny mouse.', ['Small','Tall','Hot','Fast'], 'Small'),
          A.mc('voc7_a2', 'What is the opposite of the word "hot"?', 'Think of cold ice.', ['Cold','Warm','Big','Fast'], 'Cold'),
          A.mp('voc7_a3', 'Match the opposite pairs', 'Connect opposites together.', ['big=small','hot=cold','up=down','yes=no'], 'big=small,hot=cold,up=down,yes=no'),
          A.fb('voc7_a4', 'The opposite of "up" is __.', 'Look down at the floor.', ['down','left','right','over'], 'down'),
        ], xp: 60),
      L('voc_8', 'School Items', 'Learn classroom objects.',
        'We use special tools at school to write, draw, and study. Let\'s find them!',
        'School', '📚',
        vocabWords: [
          VocabWord('📖', 'Book', 'Pages of words and pictures bound together for reading.', 'I read a fun story book.'),
          VocabWord('✏️', 'Pencil', 'A wooden tool containing lead, used for writing or drawing.', 'Use a pencil to write your name.'),
          VocabWord('🪑', 'Chair', 'A piece of furniture designed for one person to sit on.', 'Pull up a chair and sit down.'),
          VocabWord('📁', 'Paper', 'Thin sheets of material used for writing, printing, or drawing.', 'Draw a picture on paper.'),
        ],
        activities: [
          A.mc('voc8_a1', 'What wooden tool do you use to write or draw?', 'It has an eraser on top.', ['Book','Pencil','Desk','Chair'], 'Pencil'),
          A.mc('voc8_a2', 'What object with pages do you read to learn stories?', 'It has a cover and pages.', ['Book','Pencil','Desk','Chair'], 'Book'),
          A.tap('voc8_a3', 'Pick the chair', 'Look for the furniture emoji.', ['🪑','📚','✏️','🖥️'], '🪑'),
          A.fb('voc8_a4', 'At school, you sit on a comfortable __.', 'It is next to your desk.', ['chair','desk','book','pencil'], 'chair'),
        ], xp: 60),
      L('voc_9', 'Family', 'Learn family member names.',
        'Family members are the people who love and care for us. Let\'s learn their names!',
        'Family', '👨‍👩‍👧‍👦',
        vocabWords: [
          VocabWord('👩', 'Mother', 'A female parent of a child.', 'My mother helps me with my homework.'),
          VocabWord('👨', 'Father', 'A male parent of a child.', 'My father teaches me how to ride a bike.'),
          VocabWord('👧', 'Sister', 'A girl or woman who shares the same parents.', 'My sister plays dolls with me.'),
          VocabWord('👦', 'Brother', 'A boy or man who shares the same parents.', 'My brother plays soccer with me.'),
        ],
        activities: [
          A.mc('voc9_a1', 'What is another name for your mother?', 'Your female parent.', ['Mom','Dad','Sister','Brother'], 'Mom'),
          A.mc('voc9_a2', 'What is another name for your father?', 'Your male parent.', ['Mom','Dad','Sister','Brother'], 'Dad'),
          A.tap('voc9_a3', 'Pick the baby emoji', 'Look for the infant face.', ['👶','👦','👧','👨'], '👶'),
          A.fb('voc9_a4', 'A sister is a __ sibling.', 'Is a sister a boy or girl?', ['girl','boy','baby','pet'], 'girl'),
        ], xp: 60),
      L('voc_10', 'Places', 'Learn names of places.',
        'We live, play, and learn in many different places. Let\'s name them!',
        'Places', '🏠',
        vocabWords: [
          VocabWord('🏫', 'School', 'A place where students go to learn from teachers.', 'We learn math and English at school.'),
          VocabWord('🌳', 'Park', 'A green public space with grass and trees for playing.', 'I play on the slides at the park.'),
          VocabWord('🛒', 'Store', 'A building where you buy things like food or clothes.', 'We bought fresh fruit at the grocery store.'),
          VocabWord('🏠', 'Home', 'The house or place where a person lives.', 'I feel warm and safe at home.'),
        ],
        activities: [
          A.mc('voc10_a1', 'Where do you go to study and learn with friends?', 'Teachers work here.', ['School','Park','Store','Home'], 'School'),
          A.mc('voc10_a2', 'Where do you play outside on swings and slides?', 'It is green and open.', ['School','Park','Store','Home'], 'Park'),
          A.tap('voc10_a3', 'Pick the hospital icon', 'Look for the red cross on a building.', ['🏥','🏫','🏪','🏠'], '🏥'),
          A.fb('voc10_a4', 'After a long day, you go to sleep at __.', 'Where your family lives.', ['school','park','store','home'], 'home'),
        ], xp: 65),
    ],
  );

  // E4. Reading
  static final _readingTopic = T(
    id: 'reading', title: 'Reading', description: 'Learn to read simple words and sentences.',
    icon: Icons.chrome_reader_mode, color: Colors.teal, order: 4,
    lessons: [
      L('read_1', 'Sight Words: the, a, I', 'Read common sight words.', 'These words appear very often in reading.', 'Sight Star', '👁️', activities: [
        A.mc('r1_a1', 'Which word is "the"?', 't-h-e spells the.', ['the','a','I','and'], 'the'),
        A.mc('r1_a2', 'Which word is "a"?', 'Just the letter A.', ['the','a','I','and'], 'a'),
        A.tap('r1_a3', 'Pick "I"', '', ['the','a','I','and'], 'I'),
        A.fb('r1_a4', '"__ cat" — a or an?', 'Before consonant: a cat.', ['a','an','the','I'], 'a'),
      ], xp: 50),
      L('read_2', 'Sight Words: and, is, in', 'Read common sight words.', 'And connects things. Is describes. In shows place.', 'Sight Reader', '👁️', activities: [
        A.mc('r2_a1', 'Which word is "and"?', 'a-n-d = and.', ['and','is','in','it'], 'and'),
        A.mc('r2_a2', 'Which word is "is"?', 'i-s = is.', ['and','is','in','it'], 'is'),
        A.tap('r2_a3', 'Pick "in"', '', ['and','is','in','it'], 'in'),
        A.fb('r2_a4', '"The cat __ big." (and/is/on)', 'is describes.', ['and','is','on'], 'is'),
      ], xp: 55),
      L('read_3', 'Sight Words: it, he, she', 'Read sight words for people.', 'He = boy. She = girl. It = thing.', 'Sight People', '👁️', activities: [
        A.mc('r3_a1', 'Which word = boy?', 'He = boy.', ['He','She','It','We'], 'He'),
        A.mc('r3_a2', 'Which word = girl?', 'She = girl.', ['He','She','It','We'], 'She'),
        A.tap('r3_a3', 'Pick "it"', '', ['he','she','it','we'], 'it'),
        A.fb('r3_a4', '"__ is a dog." (He/She/It)', 'Dog = it!', ['He','She','It','We'], 'It'),
      ], xp: 55),
      L('read_4', 'Read CVC Words', 'Read simple CVC words.', 'Cat, hat, dog, bus — blend the sounds.', 'CVC Reader', '📖', activities: [
        A.mc('r4_a1', 'Read: c-a-t', 'Blend: c,a,t.', ['cat','cut','cot','kit'], 'cat'),
        A.mc('r4_a2', 'Read: d-o-g', 'Blend: d,o,g.', ['dog','dig','dag','dug'], 'dog'),
        A.tap('r4_a3', 'Which word is "sun"?', 's-u-n = sun.', ['sun','run','fun','bun'], 'sun'),
        A.fb('r4_a4', 'b-u-s spells __', 'Blend it!', ['bus','bas','bes','bos'], 'bus'),
      ], xp: 60),
      L('read_5', 'Read Short Sentences', 'Read simple sentences.', '"The cat is big." — read each word!', 'Sentence Reader', '📖', activities: [
        A.mc('r5_a1', 'Read: "The cat is big." Who is big?', 'The cat.', ['The cat','The dog','The rat','The hat'], 'The cat'),
        A.mc('r5_a2', 'Read: "I see a dog." What do you see?', 'A dog!', ['A cat','A dog','A bird','A fish'], 'A dog'),
        A.tap('r5_a3', 'Which sentence says "It is hot"?', 'Read the words.', ['It is hot','It is cold','It is big','It is small'], 'It is hot'),
        A.drag('r5_a4', 'Order words: "dog a I see"', '', ['I','see','a','dog'], 'I,see,a,dog'),
      ], xp: 65),
      L('read_6', 'Rhyming Words', 'Find words that rhyme.', 'Cat and hat rhyme! They sound the same at the end.', 'Rhyme Time', '🎵', activities: [
        A.mc('r6_a1', 'Which rhymes with "cat"?', 'Same ending: -at.', ['cat','hat','dog','sun'], 'hat'),
        A.mc('r6_a2', 'Which rhymes with "dog"?', 'Same ending: -og.', ['cat','hat','log','sun'], 'log'),
        A.tap('r6_a3', 'Pick the rhyme for "sun"', 'sun, fun, run...', ['run','dog','cat','hat'], 'run'),
        A.fb('r6_a4', '"Big" rhymes with "__"', '-ig words.', ['pig','bag','bug','bog'], 'pig'),
      ], xp: 65),
      L('read_7', 'Reading Comprehension: Who/What', 'Answer who and what questions.', 'Who does the action? What is it about?', 'Who What', '❓', activities: [
        A.mc('r7_a1', '"The boy runs." Who runs?', 'The boy.', ['The boy','The girl','The dog','The cat'], 'The boy'),
        A.mc('r7_a2', '"I see a bird." What do you see?', 'A bird.', ['A bird','A fish','A dog','A cat'], 'A bird'),
        A.tap('r7_a3', '"She has a red hat." What color?', 'Red!', ['Red','Blue','Green','Yellow'], 'Red'),
        A.fb('r7_a4', '"The sun is hot." What is hot?', 'The sun.', ['sun','moon','star','cloud'], 'sun'),
      ], xp: 70),
      L('read_8', 'Reading Comprehension: Where/When', 'Answer where and when questions.', 'Where does it happen? When?', 'Where When', '❓', activities: [
        A.mc('r8_a1', '"The cat is in the house." Where is the cat?', 'In the house.', ['In the house','In the car','In the tree','Outside'], 'In the house'),
        A.mc('r8_a2', '"We go to school in the morning." When?', 'Morning!', ['Morning','Afternoon','Evening','Night'], 'Morning'),
        A.tap('r8_a3', '"The ball is under the bed." Where?', 'Under the bed.', ['Under the bed','On the bed','In the box','On the chair'], 'Under the bed'),
        A.fb('r8_a4', '"He plays at the park." Where?', 'At the park.', ['school','park','store','home'], 'park'),
      ], xp: 70),
      L('read_9', 'Read Simple Stories', 'Read a short story and understand it.', 'Put it all together!', 'Story Reader', '📚', activities: [
        A.mc('r9_a1', '"Tom is a cat. Tom is big and fat." Who is Tom?', 'Tom is a cat.', ['A cat','A dog','A boy','A girl'], 'A cat'),
        A.mc('r9_a2', '"Ann has a pen. The pen is red." What color?', 'Red!', ['Red','Blue','Green','Black'], 'Red'),
        A.fb('r9_a3', '"The pig is in the mud. The pig is happy." Where?', 'In the mud.', ['mud','house','park','bed'], 'mud'),
        A.tap('r9_a4', '"I see a big bus. The bus is yellow." What color is the bus?', 'Yellow.', ['Red','Blue','Green','Yellow'], 'Yellow'),
      ], xp: 75),
      L('read_10', 'Reading Challenge', 'Read and answer questions.', 'Show your reading skills!', 'Reading Champ', '🏆', activities: [
        A.mc('r10_a1', '"Mom and I go to the store. We get milk." Where do they go?', 'To the store.', ['School','Park','Store','Home'], 'Store'),
        A.mc('r10_a2', '"The dog is in the yard. The dog is brown." What color?', 'Brown.', ['Black','White','Brown','Gray'], 'Brown'),
        A.fb('r10_a3', '"I can see a big tree. The tree is green." The tree is __', 'Green.', ['big','small','red','blue'], 'big'),
        A.drag('r10_a4', 'Order: "cat the fat is" into a sentence', '', ['The','cat','is','fat'], 'The,cat,is,fat'),
      ], xp: 80),
    ],
  );

  // E5. Grammar
  static final _grammarTopic = T(
    id: 'grammar', title: 'Grammar', description: 'Learn the rules of English grammar.',
    icon: Icons.text_fields, color: Colors.orange, order: 5,
    lessons: [
      L('gr_1', 'Nouns', 'Nouns are names of people, places, or things.', 'A noun is a person, place, animal, or thing.', 'Noun Knower', '🏷️', activities: [
        A.mc('gr1_a1', 'Which word is a noun?', 'A thing.', ['run','cat','fast','big'], 'cat'),
        A.mc('gr1_a2', 'Which word is a noun?', 'A place.', ['go','school','quick','blue'], 'school'),
        A.tap('gr1_a3', 'Pick the noun', '', ['dog','run','happy','slow'], 'dog'),
        A.fb('gr1_a4', 'Mom, park, book — these are __', 'All are people/places/things.', ['nouns','verbs','adjectives','colors'], 'nouns'),
      ], xp: 50),
      L('gr_2', 'Verbs', 'Verbs are action words.', 'A verb tells what someone does.', 'Verb Action', '🏃', activities: [
        A.mc('gr2_a1', 'Which word is a verb?', 'An action.', ['run','cat','big','red'], 'run'),
        A.mc('gr2_a2', 'Which word is a verb?', 'Something you do.', ['sleep','table','blue','happy'], 'sleep'),
        A.tap('gr2_a3', 'Pick the verb', '', ['jump','chair','green','slow'], 'jump'),
        A.fb('gr2_a4', 'Eat, drink, play — these are __', 'Action words.', ['nouns','verbs','adjectives'], 'verbs'),
      ], xp: 50),
      L('gr_3', 'Adjectives', 'Adjectives describe nouns.', 'An adjective tells how something looks or feels.', 'Adjective', '🌈', activities: [
        A.mc('gr3_a1', 'Which word is an adjective?', 'Describes something.', ['big','run','cat','and'], 'big'),
        A.mc('gr3_a2', 'Which word is an adjective?', 'Tells the color.', ['blue','dog','eat','she'], 'blue'),
        A.tap('gr3_a3', 'Pick the adjective', '', ['happy','chair','jump','milk'], 'happy'),
        A.fb('gr3_a4', 'Big, small, hot, cold — these are __', 'Describing words.', ['nouns','verbs','adjectives'], 'adjectives'),
      ], xp: 55),
      L('gr_4', 'A and An', 'Use "a" before consonants, "an" before vowels.', 'a dog, an apple.', 'A or An', '📝', activities: [
        A.mc('gr4_a1', '"__ cat" — a or an?', 'Cat starts with C (consonant).', ['a','an','the','none'], 'a'),
        A.mc('gr4_a2', '"__ apple" — a or an?', 'Apple starts with A (vowel).', ['a','an','the','none'], 'an'),
        A.tap('gr4_a3', '"__ egg" (a/an)', 'Egg starts with E.', ['a','an'], 'an'),
        A.fb('gr4_a4', '"__ dog" (a/an)', 'Dog starts with D.', ['a','an'], 'a'),
      ], xp: 55),
      L('gr_5', 'Plural Nouns', 'Add -s to make more than one.', 'One cat, two cats.', 'Plural', '👥', activities: [
        A.mc('gr5_a1', 'One cat, two __', 'Add -s.', ['cat','cats','cates','caties'], 'cats'),
        A.mc('gr5_a2', 'One dog, three __', 'Add -s.', ['dog','dogs','doges','dogies'], 'dogs'),
        A.fb('gr5_a3', 'One book, two __', 'Add -s.', ['book','books','bookes'], 'books'),
        A.tap('gr5_a4', 'Which is plural?', 'More than one.', ['cats','cat','dog','book'], 'cats'),
      ], xp: 60),
      L('gr_6', 'Pronouns', 'Pronouns replace nouns: I, you, he, she, it, we, they.', 'Instead of "Tom", say "he".', 'Pronoun Pro', '👤', activities: [
        A.mc('gr6_a1', 'Use __ for a boy.', 'He = boy.', ['He','She','It','They'], 'He'),
        A.mc('gr6_a2', 'Use __ for a girl.', 'She = girl.', ['He','She','It','They'], 'She'),
        A.tap('gr6_a3', 'What pronoun for a dog?', 'A thing = it.', ['He','She','It','They'], 'It'),
        A.fb('gr6_a4', 'For yourself, say "I" or "__"', 'I or me.', ['me','he','she','they'], 'me'),
      ], xp: 60),
      L('gr_7', 'Present Tense', 'Use -s for he/she/it.', 'I run. She runs. Add -s for one person.', 'Present', '⏱️', activities: [
        A.mc('gr7_a1', '"He __ fast." (run/runs)', 'He + verb + s.', ['run','runs','running','ran'], 'runs'),
        A.mc('gr7_a2', '"She __ a book." (read/reads)', 'She + verb + s.', ['read','reads','reading','readed'], 'reads'),
        A.fb('gr7_a3', '"The cat __ milk." (drink/drinks)', 'Cat = it, add s.', ['drink','drinks','drinking','drank'], 'drinks'),
        A.tap('gr7_a4', '"I __ to school." (walk/walks)', 'I = no s.', ['walk','walks','walking','walked'], 'walk'),
      ], xp: 65),
      L('gr_8', 'Past Tense -ed', 'Add -ed for past actions.', 'Today I walk. Yesterday I walked.', 'Past Tense', '⏪', activities: [
        A.mc('gr8_a1', 'Today I play. Yesterday I __', 'Add -ed.', ['play','played','playing','plays'], 'played'),
        A.mc('gr8_a2', 'Today she jumps. Yesterday she __', 'Add -ed.', ['jump','jumped','jumping','jumps'], 'jumped'),
        A.fb('gr8_a3', 'I __ my friend yesterday. (visit)', 'Add -ed.', ['visit','visited','visiting','visits'], 'visited'),
        A.tap('gr8_a4', '"She __ the door." (open, yesterday)', 'Add -ed.', ['open','opened','opening','opens'], 'opened'),
      ], xp: 70),
      L('gr_9', 'Prepositions: in, on, under', 'Words that show location.', 'in the box, on the table, under the chair.', 'Preposition', '📍', activities: [
        A.mc('gr9_a1', '"The cat is __ the box." (shows inside)', 'Inside = in.', ['in','on','under','behind'], 'in'),
        A.mc('gr9_a2', '"The book is __ the table." (shows top)', 'Top = on.', ['in','on','under','behind'], 'on'),
        A.tap('gr9_a3', '"The shoes are __ the bed." (below)', 'Below = under.', ['in','on','under','behind'], 'under'),
        A.fb('gr9_a4', 'Opposite of "under" is __', 'Above or on top.', ['in','on','under','over'], 'on'),
      ], xp: 65),
      L('gr_10', 'Grammar Review', 'Mix of all grammar skills.', 'Show everything you learned!', 'Grammar Star', '⭐', activities: [
        A.mc('gr10_a1', 'Which is a noun?', 'Person, place, or thing.', ['run','happy','book','slow'], 'book'),
        A.mc('gr10_a2', 'Which is a verb?', 'An action.', ['cat','big','eat','red'], 'eat'),
        A.fb('gr10_a3', '"__ orange" (a/an)', 'Orange starts with O.', ['a','an','the'], 'an'),
        A.drag('gr10_a4', 'Order: "The big cat" words into type: article, adjective, noun', '', ['The','big','cat'], 'The,big,cat'),
      ], xp: 80),
    ],
  );  // E6. Spelling
  static final _spellingTopic = T(
    id: 'spelling', title: 'Spelling', description: 'Learn to spell common English words correctly.',
    icon: Icons.spellcheck, color: Colors.purple, order: 6,
    lessons: [
      L('sp_1', 'Spell CVC Words', 'Spell three-letter CVC words.', 'Cat, dog, bus — listen for each sound.', 'CVC Speller', '✏️', activities: [
        A.mc('sp1_a1', 'How do you spell "cat"?', 'c-a-t.', ['cat','kat','cet','cot'], 'cat'),
        A.mc('sp1_a2', 'How do you spell "dog"?', 'd-o-g.', ['dog','dawg','doj','dug'], 'dog'),
        A.fb('sp1_a3', 'Spell "sun": s-u-__', 'Last letter.', ['n','m','p','r'], 'n'),
        A.tap('sp1_a4', 'Which spells "big"?', 'b-i-g.', ['big','beg','bag','bug'], 'big'),
      ], xp: 50),
      L('sp_2', 'Spell Numbers 1-5', 'Spell one, two, three, four, five.', 'Number words have special spellings.', 'Number Speller', '🔢', activities: [
        A.mc('sp2_a1', 'Spell the number 1', 'o-n-e.', ['one','won','on','wan'], 'one'),
        A.mc('sp2_a2', 'Spell the number 2', 't-w-o.', ['two','too','to','tu'], 'two'),
        A.fb('sp2_a3', '3 is spelled t-h-__-e', 'Middle letter.', ['r','h','e','i'], 'r'),
        A.tap('sp2_a4', 'Which spells "four"?', 'f-o-u-r.', ['four','for','foar','fowr'], 'four'),
      ], xp: 55),
      L('sp_3', 'Spell Colors', 'Spell red, blue, green, yellow.', 'Color words are fun to spell!', 'Color Speller', '🎨', activities: [
        A.mc('sp3_a1', 'Spell "red"', 'r-e-d.', ['red','rad','rid','rud'], 'red'),
        A.mc('sp3_a2', 'Spell "blue"', 'b-l-u-e.', ['blue','bloo','blu','blow'], 'blue'),
        A.fb('sp3_a3', 'Green: g-r-__-e-n', 'Two e spelling.', ['ee','ea','ei','ie'], 'ee'),
        A.tap('sp3_a4', 'Which spells "yellow"?', 'y-e-l-l-o-w.', ['yellow','yello','yelow','yelloo'], 'yellow'),
      ], xp: 60),
      L('sp_4', 'Spell Animals', 'Spell cat, dog, bird, fish.', 'Animal names are common words.', 'Animal Speller', '🐾', activities: [
        A.mc('sp4_a1', 'Spell "fish"', 'f-i-s-h.', ['fish','fsh','fesh','fich'], 'fish'),
        A.mc('sp4_a2', 'Spell "bird"', 'b-i-r-d.', ['bird','berd','brid','bord'], 'bird'),
        A.fb('sp4_a3', 'Dog: d-__-g', 'Vowel in the middle.', ['a','e','i','o'], 'o'),
        A.tap('sp4_a4', 'Which spells "frog"?', 'f-r-o-g.', ['frog','frawg','frogg','forg'], 'frog'),
      ], xp: 60),
      L('sp_5', 'Spell Body Parts', 'Spell head, hand, foot, eyes.', 'Learn the letters in body part names.', 'Body Speller', '🧍', activities: [
        A.mc('sp5_a1', 'Spell "hand"', 'h-a-n-d.', ['hand','hend','hond','handd'], 'hand'),
        A.mc('sp5_a2', 'Spell "foot"', 'f-o-o-t.', ['foot','fot','fote','fout'], 'foot'),
        A.fb('sp5_a3', 'Eyes: e-y-__-s', 'Middle letter.', ['a','e','i','o'], 'e'),
        A.tap('sp5_a4', 'Which spells "head"?', 'h-e-a-d.', ['head','hed','haed','hade'], 'head'),
      ], xp: 65),
      L('sp_6', 'Spell Food', 'Spell apple, bread, milk, egg.', 'Food words we use every day.', 'Food Speller', '🍎', activities: [
        A.mc('sp6_a1', 'Spell "apple"', 'a-p-p-l-e.', ['apple','aple','appel','aplay'], 'apple'),
        A.mc('sp6_a2', 'Spell "bread"', 'b-r-e-a-d.', ['bread','bred','brade','breed'], 'bread'),
        A.fb('sp6_a3', 'Milk: m-i-l-__', 'Last letter.', ['k','c','d','p'], 'k'),
        A.tap('sp6_a4', 'Which spells "egg"?', 'e-g-g.', ['egg','eg','egge','agg'], 'egg'),
      ], xp: 65),
      L('sp_7', 'Silent E Words', 'Words ending with silent e make the vowel say its name.', 'Make, like, hope — the e is silent!', 'Silent E', '🤫', activities: [
        A.mc('sp7_a1', 'Spell "make" (long A)', 'm-a-k-e.', ['make','mak','mack','mayk'], 'make'),
        A.mc('sp7_a2', 'Spell "like" (long I)', 'l-i-k-e.', ['like','lik','lick','lyke'], 'like'),
        A.fb('sp7_a3', 'Hope: h-o-p-__', 'Silent e at the end.', ['e','a','i','o'], 'e'),
        A.tap('sp7_a4', 'Which spells "cute"?', 'c-u-t-e.', ['cute','cut','kute','cuit'], 'cute'),
      ], xp: 70),
      L('sp_8', '-ing Words', 'Add -ing to verbs.', 'Jump + ing = jumping. Run + ing = running.', 'ING Words', '🏃', activities: [
        A.mc('sp8_a1', 'Jump + ing = ?', 'Just add -ing.', ['jumping','jump','jumpingg','jumpin'], 'jumping'),
        A.mc('sp8_a2', 'Run + ing = ?', 'Double the n!', ['running','runing','runingg','runnin'], 'running'),
        A.fb('sp8_a3', 'Play + ing = __', 'Add -ing.', ['playing','playin','plaing','playying'], 'playing'),
        A.tap('sp8_a4', 'Which spells "eating"?', 'eat + ing.', ['eating','eeting','eatin','etting'], 'eating'),
      ], xp: 70),
      L('sp_9', 'Long Vowel Patterns', 'Spell words with ee, ai, oa.', 'Bee, rain, boat — two vowels together.', 'Long Vowel', '🔤', activities: [
        A.mc('sp9_a1', 'Spell "bee" (long E)', 'b-e-e.', ['bee','be','bay','bea'], 'bee'),
        A.mc('sp9_a2', 'Spell "rain" (long A)', 'r-a-i-n.', ['rain','rane','ran','rein'], 'rain'),
        A.fb('sp9_a3', 'Boat: b-__-t', 'Middle vowel pair.', ['oa','ai','ee','ow'], 'oa'),
        A.tap('sp9_a4', 'Which spells "seed"?', 's-e-e-d.', ['seed','sed','sead','seede'], 'seed'),
      ], xp: 75),
      L('sp_10', 'Spelling Challenge', 'Mix of spelling words.', 'Show your spelling skills!', 'Spelling Champ', '🏆', activities: [
        A.mc('sp10_a1', 'Spell "water"', 'w-a-t-e-r.', ['water','watter','wator','watir'], 'water'),
        A.mc('sp10_a2', 'Spell "happy"', 'h-a-p-p-y.', ['happy','happi','hapee','happpy'], 'happy'),
        A.fb('sp10_a3', 'Pretty begins with p-r-__', 'Next letters.', ['e','i','a','o'], 'e'),
        A.tap('sp10_a4', 'Which spells "friend"?', 'f-r-i-e-n-d.', ['friend','freind','frend','fryend'], 'friend'),
      ], xp: 80),
    ],
  );

  // E7. Sentence Building
  static final _sentenceBuildingTopic = T(
    id: 'sentence_building', title: 'Sentence Building', description: 'Learn to build correct English sentences.',
    icon: Icons.view_column, color: Colors.green, order: 7,
    lessons: [
      L('sb_1', 'Subject + Verb', 'Make simple subject-verb sentences.', '"The dog runs." — subject (who) + verb (action).', 'SV Builder', '📝', activities: [
        A.mc('sb1_a1', 'Which is correct?', 'Subject then verb.', ['The cat runs','Runs the cat','Cat the runs','Runs cat the'], 'The cat runs'),
        A.mc('sb1_a2', '"The bird __" — add verb.', 'Flies is an action.', ['flies','bird','the','sky'], 'flies'),
        A.fb('sb1_a3', '"The boy __" (play) — add verb + s', 'He plays.', ['plays','play','is play','playing'], 'plays'),
        A.drag('sb1_a4', 'Order: "runs dog the"', '', ['The','dog','runs'], 'The,dog,runs'),
      ], xp: 50),
      L('sb_2', 'Subject + Verb + Object', 'Add an object to the sentence.', '"The cat eats fish." — who + action + what.', 'SVO Builder', '📝', activities: [
        A.mc('sb2_a1', 'Which is a complete SVO sentence?', 'Subject + verb + object.', ['The cat eats fish','The cat eats','Eats fish','Fish the cat'], 'The cat eats fish'),
        A.mc('sb2_a2', '"She reads __" — add object.', 'A book is the object.', ['a book','reads','she','book'], 'a book'),
        A.fb('sb2_a3', '"I see __" (a car) — add object.', 'I see a car.', ['a car','see','I','car'], 'a car'),
        A.drag('sb2_a4', 'Order: "apple eats an he"', '', ['He','eats','an','apple'], 'He,eats,an,apple'),
      ], xp: 55),
      L('sb_3', 'Add Adjectives', 'Describe nouns with adjectives.', '"The big dog runs fast."', 'Add Description', '🌈', activities: [
        A.mc('sb3_a1', 'Which sentence has an adjective?', 'Big describes dog.', ['The big dog runs','The dog runs','Dog runs','Runs dog'], 'The big dog runs'),
        A.mc('sb3_a2', '"The __ cat sleeps." Add an adjective.', 'Fat describes cat.', ['fat','cat','sleeps','the'], 'fat'),
        A.fb('sb3_a3', '"The __ bird sings." (happy)', 'Happy describes bird.', ['happy','bird','sings','the'], 'happy'),
        A.drag('sb3_a4', 'Order: "red car a I see"', '', ['I','see','a','red','car'], 'I,see,a,red,car'),
      ], xp: 60),
      L('sb_4', 'Capital Letters', 'Sentences start with a capital letter.', 'Always capitalize the first word!', 'Capital', '⬆️', activities: [
        A.mc('sb4_a1', 'Which is correct?', 'Start with capital.', ['The cat is big.','the cat is big.','The cat is big','the cat is big'], 'The cat is big.'),
        A.mc('sb4_a2', 'Correct: "the dog runs" → __', 'Capital T.', ['The dog runs','the dog runs','The dog Runs','the Dog runs'], 'The dog runs'),
        A.fb('sb4_a3', '"__ boy plays." — start with', 'Capital letter.', ['The','the','a','an'], 'The'),
        A.tap('sb4_a4', 'Pick the correct sentence', '', ['I like cats.','i like cats.','I like Cats.','I Like cats.'], 'I like cats.'),
      ], xp: 60),
      L('sb_5', 'End Punctuation', 'End sentences with a period.', 'A period . ends a sentence.', 'Period', '🔚', activities: [
        A.mc('sb5_a1', 'Which has correct punctuation?', 'Period at the end.', ['The cat is big.','The cat is big','The cat is big!','The cat is big?'], 'The cat is big.'),
        A.mc('sb5_a2', '"I see a dog" — add __', 'Add period.', ['.','?','!',','], '.'),
        A.fb('sb5_a3', 'A sentence must end with a __', 'Punctuation mark.', ['period','word','letter','capital'], 'period'),
        A.tap('sb5_a4', 'Pick the complete sentence', '', ['She runs.','runs she','she run','run she'], 'She runs.'),
      ], xp: 60),
      L('sb_6', 'Word Order', 'Put words in the right order.', 'Subject then verb then object.', 'Word Order', '📋', activities: [
        A.drag('sb6_a1', 'Order: "girl the runs"', '', ['The','girl','runs'], 'The,girl,runs'),
        A.mc('sb6_a2', 'Correct order: cat / the / fish / eats', 'Subject + verb + object.', ['The cat eats fish','Cat the fish eats','Eats the cat fish','Fish eats the cat'], 'The cat eats fish'),
        A.drag('sb6_a3', 'Order: "a has she red hat"', '', ['She','has','a','red','hat'], 'She,has,a,red,hat'),
        A.fb('sb6_a4', '"big a is dog" → correct: __', 'A + adj + noun + verb.', ['A big dog is','Big dog is a','Is a big dog','Dog is a big'], 'A big dog is'),
      ], xp: 65),
      L('sb_7', 'Questions', 'Make questions with who, what, where.', 'Start a question with a question word!', 'Questions', '❓', activities: [
        A.mc('sb7_a1', 'Which is a question?', 'Starts with who/what/where.', ['Where is the cat?','The cat is big','Cat runs','I like cats'], 'Where is the cat?'),
        A.mc('sb7_a2', '"__ is your name?" — add question word', 'What for things.', ['What','Where','When','Why'], 'What'),
        A.fb('sb7_a3', '"__ is the dog?" (in/at location)', 'Where for location.', ['What','Where','Who','When'], 'Where'),
        A.tap('sb7_a4', 'Pick the question', '', ['What is that?','That is a dog.','I see a cat.','The cat is big.'], 'What is that?'),
      ], xp: 65),
      L('sb_8', 'Negatives', 'Make sentences with "not".', '"The cat is not big." — not makes it negative.', 'Negative', '🚫', activities: [
        A.mc('sb8_a1', 'Which is negative?', 'Has "not".', ['The cat is not big','The cat is big','Cat is big','The big cat'], 'The cat is not big'),
        A.mc('sb8_a2', '"I __ like apples." (do not)', "Don't means do not.", ["don't",'like','eat','see'], "don't"),
        A.fb('sb8_a3', '"She is __ happy." (not)', 'Is + not.', ['not','no','never','none'], 'not'),
        A.tap('sb8_a4', 'Pick the negative sentence', '', ['He is not tall.','He is tall.','Is he tall?','Tall he is.'], 'He is not tall.'),
      ], xp: 70),
      L('sb_9', 'Join Sentences', 'Use "and" to join two sentences.', '"The cat is big and the dog is small."', 'Join Words', '➕', activities: [
        A.mc('sb9_a1', 'Join: "The cat is big. The dog is small."', 'Use "and" between.', ['The cat is big and the dog is small.','The cat is big the dog is small.','The cat and dog is big and small.','Big cat small dog.'], 'The cat is big and the dog is small.'),
        A.mc('sb9_a2', '"I like cats __ I like dogs." — add join word', 'And connects.', ['and','but','or','because'], 'and'),
        A.fb('sb9_a3', '"She runs __ he walks." (contrast)', 'But shows difference.', ['and','but','or','so'], 'but'),
        A.drag('sb9_a4', 'Order: "and runs cat the dog the"', '', ['The','cat','runs','and','the','dog'], 'The,cat,runs,and,the,dog'),
      ], xp: 75),
      L('sb_10', 'Sentence Challenge', 'Put it all together!', 'Build correct sentences with all you learned.', 'Sentence Champ', '🏆', activities: [
        A.mc('sb10_a1', 'Which is a complete sentence?', 'Capital + subject + verb + object + period.', ['The boy eats an apple.','the boy eats an apple','boy eats apple','The boy an apple'], 'The boy eats an apple.'),
        A.mc('sb10_a2', '"Where is my __?" — add noun', 'Complete the sentence.', ['book','read','big','quick'], 'book'),
        A.fb('sb10_a3', '"She __ not happy." (is/are)', 'She + is.', ['is','are','am','be'], 'is'),
        A.drag('sb10_a4', 'Order: "park the to go we"', '', ['We','go','to','the','park'], 'We,go,to,the,park'),
      ], xp: 80),
    ],
  );

  // E8. Speaking
  static final _speakingTopic = T(
    id: 'speaking', title: 'Speaking', description: 'Practice speaking English phrases and sentences.',
    icon: Icons.mic, color: Colors.cyan, order: 8,
    lessons: [
      L('spk_1', 'Greetings', 'Learn hello, goodbye, and greetings.', 'Say "Hello!" when you meet someone.', 'Hello', '👋', activities: [
        A.mc('spk1_a1', 'What do you say when you meet someone?', 'Hello is a greeting.', ['Hello','Goodbye','Sorry','Thank you'], 'Hello'),
        A.mc('spk1_a2', 'What do you say when you leave?', 'Goodbye.', ['Hello','Goodbye','Sorry','Please'], 'Goodbye'),
        A.fb('spk1_a3', 'In the morning you say "Good __"', 'Morning greeting.', ['Morning','Afternoon','Evening','Night'], 'Morning'),
        A.tap('spk1_a4', 'Polite word for "thanks"', 'Say thank you.', ['Please','Sorry','Thank you','Hello'], 'Thank you'),
      ], xp: 50),
      L('spk_2', 'Introductions', 'Say your name and ask others.', '"Hello, I am Tom."', 'Introduce', '🗣️', activities: [
        A.mc('spk2_a1', 'How do you say your name?', '"I am___" or "My name is___".', ['I am Tom','You are Tom','He is Tom','She is Tom'], 'I am Tom'),
        A.mc('spk2_a2', 'How do you ask someone\'s name?', 'Politely ask.', ['What is your name?','What is my name?','What is his name?','What is her name?'], 'What is your name?'),
        A.fb('spk2_a3', '"Nice to __ you" (first meeting)', 'Meet you!', ['meet','see','know','have'], 'meet'),
        A.tap('spk2_a4', 'How do you introduce a friend?', '"This is..."', ['This is Ann','I am Ann','You are Ann','He is Ann'], 'This is Ann'),
      ], xp: 55),
      L('spk_3', 'Polite Words', 'Use please, thank you, sorry.', 'Politeness helps everyone!', 'Polite', '😊', activities: [
        A.mc('spk3_a1', 'What do you say when asking?', 'Please = polite request.', ['Please','Sorry','Thank you','Hello'], 'Please'),
        A.mc('spk3_a2', 'What do you say after receiving?', 'Thank you!', ['Please','Sorry','Thank you','Hello'], 'Thank you'),
        A.fb('spk3_a3', 'When you bump someone, say "__"', 'Sorry = apology.', ['Sorry','Please','Thanks','Hello'], 'Sorry'),
        A.tap('spk3_a4', 'Which is polite?', 'Saying please is polite.', ['Can I have water please?','Give me water!','Water! now','I want water'], 'Can I have water please?'),
      ], xp: 55),
      L('spk_4', 'Feelings', 'Say how you feel: happy, sad, tired.', '"I am happy!"', 'Feelings', '😃', activities: [
        A.mc('spk4_a1', 'How do you say you feel good?', 'Happy describes good feeling.', ['I am happy','I am sad','I am tired','I am hungry'], 'I am happy'),
        A.mc('spk4_a2', 'How do you say you need food?', 'Hungry = need food.', ['I am happy','I am sad','I am tired','I am hungry'], 'I am hungry'),
        A.fb('spk4_a3', '"I am __" (want to sleep)', 'Tired = need rest.', ['tired','happy','sad','angry'], 'tired'),
        A.tap('spk4_a4', 'Pick the feeling: 😢', 'Sad.', ['Happy','Sad','Tired','Hungry'], 'Sad'),
      ], xp: 55),
      L('spk_5', 'Asking for Things', 'Politely ask for something.', '"Can I have water, please?"', 'Ask', '🙏', activities: [
        A.mc('spk5_a1', 'Politely ask for a pencil:', 'Can I have + item + please.', ['Can I have a pencil, please?','Give me pencil!','Pencil! now','I want pencil'], 'Can I have a pencil, please?'),
        A.mc('spk5_a2', 'Ask for water:', 'Politely request.', ['May I have water, please?','Water! now','Give water','Want water'], 'May I have water, please?'),
        A.fb('spk5_a3', '"Can I __ a cookie?" (have/take)', 'Have is polite.', ['have','take','want','get'], 'have'),
        A.tap('spk5_a4', 'Which is polite?', 'Asking with please.', ['Can I go to the park, please?','I go park!','Go park now!','Park!'], 'Can I go to the park, please?'),
      ], xp: 60),
      L('spk_6', 'Describing Things', 'Use words to describe objects.', '"It is a big red ball."', 'Describe', '🗣️', activities: [
        A.mc('spk6_a1', 'Describe a lemon:', 'Yellow + sour.', ['It is a yellow sour lemon','It is a red sweet lemon','It is a big blue lemon','It is a small green lemon'], 'It is a yellow sour lemon'),
        A.mc('spk6_a2', 'Describe a puppy:', 'Small + cute.', ['It is a small cute puppy','It is a big scary puppy','It is a red puppy','It is a fast puppy'], 'It is a small cute puppy'),
        A.fb('spk6_a3', '"The sky is __" (color)', 'Blue sky.', ['blue','red','green','yellow'], 'blue'),
        A.tap('spk6_a4', 'Pick the best description', '', ['The flower is pretty and pink.','Flower pink.','Pink flower.','Is pink.'], 'The flower is pretty and pink.'),
      ], xp: 60),
      L('spk_7', 'Giving Directions', 'Use left, right, straight, stop.', '"Turn left. Go straight."', 'Directions', '🗺️', activities: [
        A.mc('spk7_a1', 'Which way is "left"?', 'Your left hand side.', ['←','→','↑','↓'], '←'),
        A.mc('spk7_a2', 'Which way is "right"?', 'Your right hand side.', ['←','→','↑','↓'], '→'),
        A.fb('spk7_a3', '"Go __" means keep going forward.', 'Straight ahead.', ['straight','left','right','back'], 'straight'),
        A.tap('spk7_a4', 'What do you say to stop?', 'Stop!', ['Stop!','Go!','Left!','Right!'], 'Stop!'),
      ], xp: 65),
      L('spk_8', 'Making Requests', 'Politely ask others to do things.', '"Could you help me, please?"', 'Request', '🙋', activities: [
        A.mc('spk8_a1', 'Ask for help:', 'Politely request.', ['Could you help me, please?','Help me!','Do it!','Now help!'], 'Could you help me, please?'),
        A.mc('spk8_a2', 'Ask someone to open the door:', 'Polite request.', ['Please open the door.','Open door!','Door open!','Open it!'], 'Please open the door.'),
        A.fb('spk8_a3', '"__ you pass the salt, please?" (Could/Can)', 'Both Could and Can.', ['Could','Are','Do','Will'], 'Could'),
        A.tap('spk8_a4', 'Which is a polite request?', 'Saying please.', ['Please sit down.','Sit!','Down!','Sit now!'], 'Please sit down.'),
      ], xp: 70),
      L('spk_9', 'Talking About Daily Life', 'Speak about your day.', '"I wake up at 7 o\'clock."', 'Daily Talk', '🗓️', activities: [
        A.mc('spk9_a1', 'Say when you wake up:', 'I wake up + time.', ['I wake up at 7 o\'clock.','Wake up 7.','At 7 wake up.','Wake up I at 7.'], 'I wake up at 7 o\'clock.'),
        A.mc('spk9_a2', 'Say what you eat for breakfast:', 'I eat + food + for breakfast.', ['I eat cereal for breakfast.','Cereal eat.','Breakfast cereal.','Eat I cereal.'], 'I eat cereal for breakfast.'),
        A.fb('spk9_a3', '"I __ to school" (go/went)', 'Present = go.', ['go','went','going','goes'], 'go'),
        A.tap('spk9_a4', 'How do you say what you like?', '"I like __."', ['I like pizza.','Pizza like.','Like I pizza.','Pizza I like.'], 'I like pizza.'),
      ], xp: 75),
      L('spk_10', 'Speaking Challenge', 'Use all your speaking skills!', 'Practice real conversations!', 'Speaker', '🎤', activities: [
        A.mc('spk10_a1', 'You see a friend. First say:', 'Hello!', ['Hello!','Goodbye!','Sorry!','Help!'], 'Hello!'),
        A.mc('spk10_a2', 'You want water. Say:', 'Politely ask.', ['May I have water, please?','Give water!','Water!','Want water'], 'May I have water, please?'),
        A.fb('spk10_a3', 'When someone helps you, say "__"', 'Thank you!', ['Thank you','Sorry','Hello','Goodbye'], 'Thank you'),
        A.tap('spk10_a4', 'How do you say goodbye?', 'Goodbye.', ['Goodbye!','Hello!','Please!','Sorry!'], 'Goodbye!'),
      ], xp: 80),
    ],
  );

  // E9. Listening
  static final _listeningTopic = T(
    id: 'listening', title: 'Listening', description: 'Train your ear to understand spoken English.',
    icon: Icons.headphones, color: Colors.amber, order: 9,
    lessons: [
      L('lis_1', 'Follow One-Step Instructions', 'Do simple one-step tasks.', '"Touch your nose." — listen and do!', 'Listen 1', '👂', activities: [
        A.mc('lis1_a1', '"Touch your nose." What do you touch?', 'Your nose!', ['Nose','Ear','Eye','Mouth'], 'Nose'),
        A.mc('lis1_a2', '"Point to the door." Where do you point?', 'The door!', ['Door','Window','Chair','Table'], 'Door'),
        A.fb('lis1_a3', '"Clap your hands." You clap your __', 'Hands!', ['hands','feet','head','knees'], 'hands'),
        A.tap('lis1_a4', '"Stand up." Do you sit or stand?', 'Stand!', ['Stand','Sit','Jump','Run'], 'Stand'),
      ], xp: 50),
      L('lis_2', 'Follow Two-Step Instructions', 'Do two simple instructions.', '"Stand up and clap your hands."', 'Listen 2', '👂', activities: [
        A.mc('lis2_a1', '"Stand up and turn around." What do you do first?', 'Stand up first.', ['Stand up','Turn around','Sit down','Clap'], 'Stand up'),
        A.mc('lis2_a2', '"Pick up the pencil and put it on the desk." Where does the pencil go?', 'On the desk!', ['On the desk','In the box','On the chair','In your bag'], 'On the desk'),
        A.fb('lis2_a3', '"Open the book and point to page 5." What number page?', 'Page 5.', ['5','2','6','3'], '5'),
        A.drag('lis2_a4', 'Order: "touch your nose then clap"', '', ['Touch nose','Clap'], 'Touch nose,Clap'),
      ], xp: 55),
      L('lis_3', 'Identify Sounds', 'Recognize common sounds.', 'What sound does a dog make?', 'Sound ID', '🔊', activities: [
        A.mc('lis3_a1', 'What sound does a dog make?', 'Woof!', ['Woof','Meow','Moo','Baa'], 'Woof'),
        A.mc('lis3_a2', 'What sound does a cat make?', 'Meow!', ['Woof','Meow','Moo','Baa'], 'Meow'),
        A.fb('lis3_a3', 'A bell goes "__"', 'Ring!', ['ring','woof','meow','moo'], 'ring'),
        A.tap('lis3_a4', 'Which animal says "moo"?', 'Cow!', ['Cow','Cat','Dog','Sheep'], 'Cow'),
      ], xp: 55),
      L('lis_4', 'Understand Wh- Questions', 'Answer who, what, where, when.', 'Listen for question words!', 'Wh- Words', '❓', activities: [
        A.mc('lis4_a1', '"Who is your teacher?" The answer is a __', 'A person.', ['person','place','thing','time'], 'person'),
        A.mc('lis4_a2', '"Where is the park?" The answer is a __', 'A place.', ['person','place','thing','time'], 'place'),
        A.fb('lis4_a3', '"What is this?" Answer tells the __', 'Thing or object.', ['thing','person','place','time'], 'thing'),
        A.tap('lis4_a4', '"When do we eat lunch?" Answer is a __', 'Time.', ['time','person','place','thing'], 'time'),
      ], xp: 60),
      L('lis_5', 'Listen for Details', 'Understand key details.', 'Listen to a sentence and find the key info.', 'Details', '🔍', activities: [
        A.mc('lis5_a1', '"The big dog is black." What color is the dog?', 'Black!', ['Black','White','Brown','Gray'], 'Black'),
        A.mc('lis5_a2', '"She has three apples." How many apples?', 'Three!', ['One','Two','Three','Four'], 'Three'),
        A.fb('lis5_a3', '"The boy is in the park." Where is the boy?', 'In the park!', ['park','school','store','home'], 'park'),
        A.tap('lis5_a4', '"I like red balloons." What color balloons?', 'Red!', ['Red','Blue','Green','Yellow'], 'Red'),
      ], xp: 65),
      L('lis_6', 'Sequence of Events', 'Listen and order events.', 'First this happened, then that.', 'Sequence', '📋', activities: [
        A.drag('lis6_a1', 'Order: Wake up, Eat breakfast, Go to school', '', ['Wake up','Eat breakfast','Go to school'], 'Wake up,Eat breakfast,Go to school'),
        A.mc('lis6_a2', '"First put on your shoes, then tie them." What do you do first?', 'Shoes first.', ['Put on shoes','Tie shoes','Walk','Run'], 'Put on shoes'),
        A.drag('lis6_a3', 'Order: Brush teeth, Get dressed, Eat breakfast', '', ['Brush teeth','Get dressed','Eat breakfast'], 'Brush teeth,Get dressed,Eat breakfast'),
        A.fb('lis6_a4', '"After school, I play then do homework." What do you do AFTER playing?', 'Homework.', ['play','homework','eat','sleep'], 'homework'),
      ], xp: 70),
      L('lis_7', 'Rhyming Words Listening', 'Hear words that rhyme.', 'Cat and hat rhyme!', 'Rhyming', '🎵', activities: [
        A.mc('lis7_a1', '"Cat" rhymes with which word?', '-at sound.', ['hat','dog','sun','fish'], 'hat'),
        A.mc('lis7_a2', '"Ball" rhymes with which word?', '-all sound.', ['tall','bell','ball','bowl'], 'tall'),
        A.fb('lis7_a3', '"Ring" rhymes with "__"', '-ing sound.', ['sing','rang','ring','long'], 'sing'),
        A.tap('lis7_a4', '"Fun" — which rhymes?', '-un sound.', ['run','fan','sun','fin'], 'run'),
      ], xp: 65),
      L('lis_8', 'Listen to Stories', 'Understand a short story.', 'Listen and answer questions.', 'Story Listen', '📖', activities: [
        A.mc('lis8_a1', '"Tom is a cat. Tom is big and fat." Who is Tom?', 'Tom is a cat.', ['A cat','A dog','A boy','A girl'], 'A cat'),
        A.mc('lis8_a2', '"Ann has a red pen." What color is the pen?', 'Red!', ['Red','Blue','Green','Black'], 'Red'),
        A.fb('lis8_a3', '"The pig is in the mud." Where is the pig?', 'In the mud.', ['mud','house','park','bed'], 'mud'),
        A.tap('lis8_a4', '"I see a big yellow bus." What color is the bus?', 'Yellow.', ['Red','Blue','Green','Yellow'], 'Yellow'),
      ], xp: 75),
      L('lis_9', 'Listen and Draw', 'Picture what you hear.', 'Visualize the description!', 'Listen Draw', '🎨', activities: [
        A.mc('lis9_a1', '"Draw a big red circle." What color?', 'Red!', ['Red','Blue','Green','Yellow'], 'Red'),
        A.mc('lis9_a2', '"Draw a small blue square." What shape?', 'Square!', ['Circle','Square','Triangle','Star'], 'Square'),
        A.fb('lis9_a3', '"Draw a yellow star." What color?', 'Yellow!', ['Yellow','Red','Blue','Green'], 'Yellow'),
        A.tap('lis9_a4', '"Draw a happy face." How does the face feel?', 'Happy!', ['Happy','Sad','Angry','Tired'], 'Happy'),
      ], xp: 75),
      L('lis_10', 'Listening Challenge', 'Use all your listening skills!', 'Show how well you listen!', 'Listener', '🏆', activities: [
        A.mc('lis10_a1', '"The big brown dog runs fast." What color?', 'Brown!', ['Brown','Black','White','Gray'], 'Brown'),
        A.mc('lis10_a2', '"She has 5 red flowers." How many flowers?', '5!', ['3','4','5','6'], '5'),
        A.fb('lis10_a3', '"Put the book on the table." Where does the book go?', 'On the table!', ['table','chair','floor','desk'], 'table'),
        A.drag('lis10_a4', 'Order steps: "get up, eat, brush, go"', '', ['Get up','Eat','Brush','Go'], 'Get up,Eat,Brush,Go'),
      ], xp: 80),
    ],
  );  // E10. Reading Comprehension
  static final _comprehensionTopic = T(
    id: 'reading_comprehension', title: 'Reading Comprehension', description: 'Read stories and understand what they mean.',
    icon: Icons.auto_stories, color: Colors.indigo, order: 10,
    lessons: [
      L('rc_1', 'Find the Main Idea', 'Identify what a story is mostly about.', 'The main idea is the most important thing.', 'Main Idea', '💡', activities: [
        A.mc('rc1_a1', '"The cat sat on the mat. The cat was happy." Main idea?', 'The cat is on the mat!', ['The cat is happy on the mat','The dog is big','The mat is red','The cat is sad'], 'The cat is happy on the mat'),
        A.mc('rc1_a2', '"Tom has a red ball. Tom plays with his ball." Main idea?', 'Tom plays ball!', ['Tom plays with his ball','The ball is red','Tom is a boy','The ball is big'], 'Tom plays with his ball'),
        A.fb('rc1_a3', '"I like to read books. I read every day." The main idea: I love to __', 'Read!', ['read','run','eat','sleep'], 'read'),
        A.tap('rc1_a4', 'What is the main idea of "The dog runs fast"?', 'Dog is fast.', ['The dog is fast','The dog is big','The dog is brown','The dog is small'], 'The dog is fast'),
      ], xp: 60),
      L('rc_2', 'Find Details', 'Find specific details in a text.', 'Details answer who, what, where, when.', 'Detail', '🔍', activities: [
        A.mc('rc2_a1', '"The big black dog is in the park." Where is the dog?', 'In the park!', ['In the park','In the house','In the car','At school'], 'In the park'),
        A.mc('rc2_a2', '"Ann has a small white cat." What color is the cat?', 'White!', ['White','Black','Brown','Gray'], 'White'),
        A.fb('rc2_a3', '"She eats an apple every morning." When does she eat?', 'In the morning!', ['morning','afternoon','evening','night'], 'morning'),
        A.tap('rc2_a4', '"The red car is fast." What is fast?', 'The car!', ['Car','Bike','Bus','Train'], 'Car'),
      ], xp: 60),
      L('rc_3', 'Infer Meaning', 'Guess what the text means.', 'Use clues to understand what is not said.', 'Inference', '🤔', activities: [
        A.mc('rc3_a1', '"Tom puts on his coat and hat." How does Tom feel?', 'Cold! Needs coat.', ['Cold','Hot','Happy','Sad'], 'Cold'),
        A.mc('rc3_a2', '"Ann is smiling and jumping." How does Ann feel?', 'Happy!', ['Happy','Sad','Tired','Angry'], 'Happy'),
        A.fb('rc3_a3', '"The girl picks up her umbrella." What is the weather?', 'Rainy!', ['rainy','sunny','snowy','cloudy'], 'rainy'),
        A.tap('rc3_a4', '"He eats a sandwich for lunch." What time is it?', 'Noon/lunchtime!', ['Noon','Morning','Night','Midnight'], 'Noon'),
      ], xp: 65),
      L('rc_4', 'Cause and Effect', 'Understand why things happen.', 'Cause = why. Effect = what happened.', 'Cause Effect', '🔗', activities: [
        A.mc('rc4_a1', '"Tom did not eat breakfast. He is hungry." Why is Tom hungry?', 'No breakfast.', ['No breakfast','Ate breakfast','Ate lunch','Ate dinner'], 'No breakfast'),
        A.mc('rc4_a2', '"It rained. Ann used an umbrella." Why did Ann use an umbrella?', 'Because it rained.', ['It rained','It was sunny','It was cold','It was hot'], 'It rained'),
        A.fb('rc4_a3', '"The dog ran because it saw a cat." The dog ran __', 'Because of the cat!', ['because of the cat','because of food','because of water','because of sleep'], 'because of the cat'),
        A.tap('rc4_a4', '"She studied hard. She got a star." Why did she get a star?', 'Because she studied!', ['She studied','She played','She slept','She ate'], 'She studied'),
      ], xp: 70),
      L('rc_5', 'Read and Answer', 'Read a short passage and answer questions.', 'Put your reading skills together!', 'Read Answer', '📖', activities: [
        A.mc('rc5_a1', '"Tom has a pet fish. The fish is orange. It lives in a tank." What pet does Tom have?', 'A fish!', ['A fish','A dog','A cat','A bird'], 'A fish'),
        A.mc('rc5_a2', '"Ann goes to the store. She buys milk and bread." What does Ann buy?', 'Milk and bread!', ['Milk and bread','Apples','Toys','Books'], 'Milk and bread'),
        A.fb('rc5_a3', '"The sun is bright and hot." How is the sun?', 'Bright and hot!', ['bright and hot','cold and dark','small and far','big and cold'], 'bright and hot'),
        A.tap('rc5_a4', '"The boy is in the yard. He plays with a ball." Where is the boy?', 'In the yard!', ['In the yard','In the house','At school','At the park'], 'In the yard'),
      ], xp: 70),
      L('rc_6', 'Character Feelings', 'Understand how characters feel.', 'Look at words that show feelings!', 'Feelings', '😊', activities: [
        A.mc('rc6_a1', '"The girl cried when her balloon popped." How did she feel?', 'Sad!', ['Sad','Happy','Excited','Tired'], 'Sad'),
        A.mc('rc6_a2', '"Tom laughed at the funny clown." How did Tom feel?', 'Happy!', ['Happy','Sad','Angry','Scared'], 'Happy'),
        A.fb('rc6_a3', '"She jumped up and down with joy." How did she feel?', 'Excited!', ['Excited','Sad','Tired','Angry'], 'Excited'),
        A.tap('rc6_a4', '"The boy hid under the bed." How did he feel?', 'Scared!', ['Scared','Happy','Excited','Proud'], 'Scared'),
      ], xp: 70),
      L('rc_7', 'Compare Characters', 'Find how characters are alike and different.', 'Both = same. But = different.', 'Compare', '⬌', activities: [
        A.mc('rc7_a1', '"Tom is tall. Ann is tall too." How are they alike?', 'Both are tall!', ['Both are tall','Tom is taller','Ann is taller','Neither is tall'], 'Both are tall'),
        A.mc('rc7_a2', '"The cat likes fish. The dog likes meat. Both like to eat." What do both like?', 'To eat!', ['To eat','Fish','Meat','Sleep'], 'To eat'),
        A.fb('rc7_a3', '"Tom is fast but Ann is slow." Who is faster?', 'Tom!', ['Tom','Ann','Both','Neither'], 'Tom'),
        A.tap('rc7_a4', '"Both the cat and dog are pets." What are they?', 'Pets!', ['Pets','Wild animals','Toys','Food'], 'Pets'),
      ], xp: 75),
      L('rc_8', 'Predict What Happens Next', 'Guess what comes next in the story.', 'Use clues to predict!', 'Predict', '🔮', activities: [
        A.mc('rc8_a1', '"Tom is climbing a tree. He reaches for a branch." What might happen?', 'He holds the branch.', ['He holds the branch','He flies away','He swims','He eats'], 'He holds the branch'),
        A.mc('rc8_a2', '"The sky is dark. The wind is strong." What might happen next?', 'It will rain!', ['It will rain','It is sunny','It is snowing','It is hot'], 'It will rain'),
        A.fb('rc8_a3', '"The baby is crying and rubbing her eyes." What will she do?', 'Sleep!', ['Sleep','Eat','Play','Run'], 'Sleep'),
        A.tap('rc8_a4', '"She puts bread in the toaster." What will happen?', 'The bread toasts!', ['The bread toasts','The bread freezes','The bread grows','The bread sings'], 'The bread toasts'),
      ], xp: 75),
      L('rc_9', 'Story Elements', 'Identify characters, setting, plot.', 'Who = characters. Where = setting. What = plot.', 'Story Elements', '📋', activities: [
        A.mc('rc9_a1', '"A girl and her dog walk in the park." Who are the characters?', 'Girl and dog!', ['Girl and dog','Park','Walking','Trees'], 'Girl and dog'),
        A.mc('rc9_a2', '"A girl and her dog walk in the park." What is the setting?', 'The park!', ['The park','The girl','The dog','Walking'], 'The park'),
        A.fb('rc9_a3', '"A girl and her dog walk in the park." What do they do?', 'Walk!', ['Walk','Run','Sleep','Eat'], 'Walk'),
        A.drag('rc9_a4', 'Order story parts: Beginning, Middle, End', '', ['Beginning','Middle','End'], 'Beginning,Middle,End'),
      ], xp: 75),
      L('rc_10', 'Comprehension Challenge', 'Read and show full understanding.', 'Put it all together!', 'Comprehension', '🏆', activities: [
        A.mc('rc10_a1', '"Tom went to the zoo. He saw a big lion and a tall giraffe. Tom was happy." Where did Tom go?', 'The zoo!', ['The zoo','The park','The store','The school'], 'The zoo'),
        A.mc('rc10_a2', '"Tom went to the zoo. He saw a big lion and a tall giraffe." What animal was tall?', 'Giraffe!', ['Giraffe','Lion','Elephant','Monkey'], 'Giraffe'),
        A.fb('rc10_a3', '"Tom went to the zoo." How did Tom feel?', 'Happy!', ['Happy','Sad','Angry','Tired'], 'Happy'),
        A.tap('rc10_a4', 'What is the main idea of "Tom went to the zoo and had fun"?', 'Tom had fun at the zoo!', ['Tom had fun at the zoo','The lion is big','The giraffe is tall','The zoo is far'], 'Tom had fun at the zoo'),
      ], xp: 80),
    ],
  );

  // E11. Storytelling
  static final _storytellingTopic = T(
    id: 'storytelling', title: 'Storytelling', description: 'Learn to tell stories in English.',
    icon: Icons.theater_comedy, color: Colors.deepOrange, order: 11,
    lessons: [
      L('st_1', 'Start a Story', 'Learn how to begin a story.', '"Once upon a time..." starts many stories!', 'Start', '📖', activities: [
        A.mc('st1_a1', 'How do many stories start?', 'Once upon a time...', ['Once upon a time','The end','Hello','Goodbye'], 'Once upon a time'),
        A.mc('st1_a2', 'A story usually starts with __', 'The beginning words.', ['Once upon a time','And then','Finally','After that'], 'Once upon a time'),
        A.fb('st1_a3', '"__ __ a time, a cat lived..." (first words)', 'Once upon!', ['Once upon','There was','In the','Long ago'], 'Once upon'),
        A.tap('st1_a4', 'Pick a good story starter', '', ['There was a little dog...','Dog!','The dog','A dog'], 'There was a little dog...'),
      ], xp: 50),
      L('st_2', 'Introduce Characters', 'Introduce who the story is about.', '"There was a little girl named Ann."', 'Characters', '👤', activities: [
        A.mc('st2_a1', 'How do you introduce a character?', 'There was a...', ['There was a girl named Ann.','Girl Ann.','Ann girl.','A girl.'], 'There was a girl named Ann.'),
        A.mc('st2_a2', '"Once there was a brave __." (add character)', 'A knight!', ['knight','big','fast','blue'], 'knight'),
        A.fb('st2_a3', '"There was a small __ named Pip." (animal)', 'A dog or cat works.', ['dog','big','tall','fast'], 'dog'),
        A.tap('st2_a4', 'Which introduces a character well?', 'Gives a name + description.', ['A happy cat named Max','A cat','Max','Happy cat'], 'A happy cat named Max'),
      ], xp: 55),
      L('st_3', 'Describe the Setting', 'Tell where the story happens.', '"It was a sunny day in the forest."', 'Setting', '🌳', activities: [
        A.mc('st3_a1', 'Where does a forest story happen?', 'In the forest!', ['In the forest','In the city','At school','In space'], 'In the forest'),
        A.mc('st3_a2', '"It was a dark night in the __." (castle)', 'Castle setting.', ['castle','pool','store','park'], 'castle'),
        A.fb('st3_a3', '"The story takes place at the __." (beach)', 'Beach setting.', ['beach','school','space','mountain'], 'beach'),
        A.tap('st3_a4', 'Pick a good setting description', '', ['A sunny beach with golden sand','Beach','Sand','Water'], 'A sunny beach with golden sand'),
      ], xp: 60),
      L('st_4', 'Add a Problem', 'Every story needs a problem.', '"One day, the cat lost its way home."', 'Problem', '😟', activities: [
        A.mc('st4_a1', 'Why do stories need a problem?', 'To make it interesting!', ['To make it interesting','To make it boring','To end it','To describe it'], 'To make it interesting'),
        A.mc('st4_a2', '"The dog could not find his __." (lost item)', 'Bone/toy!', ['bone','tail','food','water'], 'bone'),
        A.fb('st4_a3', '"The girl __ her way home." (problem)', 'Lost!', ['lost','found','walked','ran'], 'lost'),
        A.tap('st4_a4', 'Pick a story problem', '', ['The little bird could not fly','The bird flew','The bird ate','The bird slept'], 'The little bird could not fly'),
      ], xp: 65),
      L('st_5', 'Add a Solution', 'How does the problem get solved?', '"The cat asked for help and found its way home."', 'Solution', '😊', activities: [
        A.mc('st5_a1', '"The girl was lost. A kind man helped her." What is the solution?', 'The man helped!', ['The man helped','She stayed lost','She cried','She ran'], 'The man helped'),
        A.mc('st5_a2', '"The bird could not fly. Its mother taught it." How was the problem solved?', 'Mother taught it!', ['Mother taught it','It never flew','It gave up','It slept'], 'Mother taught it'),
        A.fb('st5_a3', '"The dog found his bone under the __." (where)', 'Found it somewhere!', ['bed','tree','sky','water'], 'bed'),
        A.tap('st5_a4', 'Pick a good solution', '', ['She asked for help and found her way.','She cried.','She gave up.','She slept.'], 'She asked for help and found her way.'),
      ], xp: 65),
      L('st_6', 'Add Dialogue', 'Make characters talk!', '"Hello," said the cat. "Can you help me?"', 'Dialogue', '💬', activities: [
        A.mc('st6_a1', 'Which has character speaking?', 'Quotes show speech.', ['"Help me!" said the cat.','The cat was big.','The cat ran.','A big cat.'], '"Help me!" said the cat.'),
        A.mc('st6_a2', '"How are you?" __ the girl.', 'Asked = speaking.', ['asked','ran','ate','slept'], 'asked'),
        A.fb('st6_a3', '"__ me!" cried the bird. (help/ask)', 'Help!', ['Help','Run','Eat','Sleep'], 'Help'),
        A.tap('st6_a4', 'Pick the sentence with dialogue', '', ['"I can do it!" she said.','She can do it.','She said it.','She did it.'], '"I can do it!" she said.'),
      ], xp: 70),
      L('st_7', 'Story Order', 'Tell events in the right order.', 'First, then, next, finally!', 'Order', '📋', activities: [
        A.drag('st7_a1', 'Order: Cat lost, Cat asks for help, Cat finds home', '', ['Cat lost','Cat asks for help','Cat finds home'], 'Cat lost,Cat asks for help,Cat finds home'),
        A.mc('st7_a2', '"__ the bird learned to fly." (at the end)', 'Finally!', ['Finally','First','Then','Next'], 'Finally'),
        A.drag('st7_a3', 'Order story steps: beginning, middle, end', '', ['Beginning','Middle','End'], 'Beginning,Middle,End'),
        A.fb('st7_a4', '"__ he woke up." (starting word)', 'First / Then.', ['First','Finally','After','Because'], 'First'),
      ], xp: 70),
      L('st_8', 'End a Story', 'Learn how to end a story.', '"And they lived happily ever after."', 'Ending', '🏁', activities: [
        A.mc('st8_a1', 'How do many stories end?', 'Happily ever after!', ['Happily ever after','Once upon a time','The problem','Hello'], 'Happily ever after'),
        A.mc('st8_a2', '"And they __ happily ever after."', 'Lived!', ['lived','ate','ran','slept'], 'lived'),
        A.fb('st8_a3', 'A happy ending means everything is __', 'Good / fine!', ['good','bad','sad','broken'], 'good'),
        A.tap('st8_a4', 'Pick a good story ending', '', ['And they were happy from that day on.','The end.','Goodbye.','It finished.'], 'And they were happy from that day on.'),
      ], xp: 70),
      L('st_9', 'Tell a Full Story', 'Put beginning, middle, end together.', 'Use all story parts!', 'Full Story', '📚', activities: [
        A.mc('st9_a1', 'A full story needs __', 'Beginning + middle + end.', ['Beginning + middle + end','Just the beginning','Just the end','Just a problem'], 'Beginning + middle + end'),
        A.mc('st9_a2', '"Once __ a time..." (story start)', 'Upon!', ['upon','in','at','for'], 'upon'),
        A.fb('st9_a3', 'The middle part has the __', 'Problem!', ['problem','ending','beginning','title'], 'problem'),
        A.drag('st9_a4', 'Order story: start, problem, help, ending', '', ['Start','Problem','Help','Ending'], 'Start,Problem,Help,Ending'),
      ], xp: 75),
      L('st_10', 'Storytelling Challenge', 'Put it all together!', 'Create a complete story!', 'Storyteller', '🏆', activities: [
        A.mc('st10_a1', 'What is the first step to tell a story?', 'Start with "Once upon a time"!', ['Start with an opening','Tell the ending','Describe the problem','Say goodbye'], 'Start with an opening'),
        A.mc('st10_a2', '"There was a __ cat." (describe)', 'Adjective!', ['small','run','eat','the'], 'small'),
        A.fb('st10_a3', 'End a story with: "And they lived __"', 'Happily ever after!', ['happily ever after','once upon a time','the problem started','finally'], 'happily ever after'),
        A.tap('st10_a4', 'What makes a story interesting?', 'A problem and solution!', ['A problem and solution','Just description','Just names','Just the weather'], 'A problem and solution'),
      ], xp: 80),
    ],
  );

  // E12. Creative Writing
  static final _creativeWritingTopic = T(
    id: 'creative_writing', title: 'Creative Writing', description: 'Use your imagination to write in English.',
    icon: Icons.edit, color: Colors.lightGreen, order: 12,
    lessons: [
      L('cw_1', 'Write About Yourself', 'Write a simple sentence about you.', '"I am a boy. I am 7 years old."', 'About Me', '✏️', activities: [
        A.mc('cw1_a1', 'Which is about you?', 'Starts with I.', ['I am 7 years old.','He is 7.','She is 7.','They are 7.'], 'I am 7 years old.'),
        A.mc('cw1_a2', '"I __ a student." (am/is/are)', 'I + am.', ['am','is','are','be'], 'am'),
        A.fb('cw1_a3', '"I like to __." (activity)', 'Play / read / eat!', ['play','is','are','the'], 'play'),
        A.tap('cw1_a4', 'Which sentence is about you?', 'I statements.', ['I have a pet cat.','She has a pet cat.','He has a pet cat.','They have a pet cat.'], 'I have a pet cat.'),
      ], xp: 50),
      L('cw_2', 'Write About a Pet', 'Describe a pet or animal.', '"I have a dog. It is brown."', 'My Pet', '🐾', activities: [
        A.mc('cw2_a1', 'Which describes a pet?', 'Tells what pet and color.', ['I have a brown dog.','I dog.','Dog brown.','Brown dog.'], 'I have a brown dog.'),
        A.mc('cw2_a2', '"My cat is __ and white." (color)', 'Black!', ['black','run','eat','sleep'], 'black'),
        A.fb('cw2_a3', '"My fish is __." (color)', 'Orange / gold!', ['orange','walk','fly','sing'], 'orange'),
        A.tap('cw2_a4', 'Pick a good pet sentence', '', ['I have a small white rabbit.','Rabbit small.','White rabbit.','Small rabbit. I have.'], 'I have a small white rabbit.'),
      ], xp: 55),
      L('cw_3', 'Write About a Friend', 'Describe a friend.', '"My friend Tom is tall and funny."', 'My Friend', '👫', activities: [
        A.mc('cw3_a1', 'Which describes a friend well?', 'Name + description.', ['My friend Ann is kind.','Friend Ann.','Kind friend.','Ann is.'], 'My friend Ann is kind.'),
        A.mc('cw3_a2', '"My friend is __ and smart." (describe)', 'Brave / funny / kind!', ['brave','the','a','an'], 'brave'),
        A.fb('cw3_a3', '"We like to __ together." (activity)', 'Play / read!', ['play','is','are','the'], 'play'),
        A.tap('cw3_a4', 'Pick a good friend description', '', ['My friend Ben is funny and fast.','Ben.','Friend.','Fast Ben.'], 'My friend Ben is funny and fast.'),
      ], xp: 60),
      L('cw_4', 'Write About Your Day', 'Describe your daily routine.', '"I wake up. I eat breakfast."', 'My Day', '🗓️', activities: [
        A.mc('cw4_a1', 'Which tells about your day?', 'Shows daily actions.', ['I wake up at 7 o\'clock.','7 o\'clock.','Wake up.','At 7.'], 'I wake up at 7 o\'clock.'),
        A.mc('cw4_a2', '"I __ breakfast at 8." (eat/have)', 'Eat or have.', ['eat','sleep','run','jump'], 'eat'),
        A.fb('cw4_a3', '"Then I __ to school." (go/went)', 'Present = go.', ['go','went','going','goes'], 'go'),
        A.tap('cw4_a4', 'Pick a good daily routine sentence', '', ['I brush my teeth every morning.','Brush teeth.','Every morning.','My teeth.'], 'I brush my teeth every morning.'),
      ], xp: 60),
      L('cw_5', 'Write About Feelings', 'Describe how you feel.', '"I feel happy when I play."', 'Feelings', '😊', activities: [
        A.mc('cw5_a1', 'Which tells about feelings?', 'Shows emotion.', ['I feel happy today.','I play.','Today.','Happy today.'], 'I feel happy today.'),
        A.mc('cw5_a2', '"I feel __ when I read." (emotion)', 'Happy / calm!', ['happy','book','read','fast'], 'happy'),
        A.fb('cw5_a3', '"I feel sad when __" (cause)', 'Something bad.', ['I lose my toy','I play','I eat','I sleep'], 'I lose my toy'),
        A.tap('cw5_a4', 'Pick a good feeling sentence', '', ['I am happy because I got a star.','I am.','Star.','Happy star.'], 'I am happy because I got a star.'),
      ], xp: 65),
      L('cw_6', 'Write a Description', 'Describe a place or thing.', '"My room is blue and clean."', 'Describe', '🌈', activities: [
        A.mc('cw6_a1', 'Which is a good description?', 'Tells how it looks.', ['The tree is tall and green.','Tree tall.','Tall green.','Green tree.'], 'The tree is tall and green.'),
        A.mc('cw6_a2', '"The flower is __ and pretty." (color)', 'Pink / red!', ['pink','run','bigly','beautifully'], 'pink'),
        A.fb('cw6_a3', '"The sky is __ today." (describe)', 'Blue / cloudy!', ['blue','the','a','an'], 'blue'),
        A.tap('cw6_a4', 'Pick a good description', '', ['The beach has soft white sand.','Beach.','Sand white.','Soft sand.'], 'The beach has soft white sand.'),
      ], xp: 65),
      L('cw_7', 'Use Your Imagination', 'Write about something make-believe.', '"If I had wings, I would fly."', 'Imagine', '💭', activities: [
        A.mc('cw7_a1', 'Which is imaginative?', 'Make-believe!', ['If I could fly, I would see clouds.','I can walk.','I eat food.','I go to school.'], 'If I could fly, I would see clouds.'),
        A.mc('cw7_a2', '"If I were a cat, I would __"', 'Sleep / play / climb!', ['sleep all day','walk to school','eat bread','do homework'], 'sleep all day'),
        A.fb('cw7_a3', '"I wish I had a __" (imaginative)', 'Dragon / magic!', ['dragon','chair','book','pencil'], 'dragon'),
        A.tap('cw7_a4', 'Pick an imaginative sentence', '', ['A dragon lived in a castle of candy.','The dog is brown.','I have a book.','She eats lunch.'], 'A dragon lived in a castle of candy.'),
      ], xp: 70),
      L('cw_8', 'Write Simple Poems', 'Write a simple rhyming poem.', '"I see a star. It is far."', 'Poem', '📝', activities: [
        A.mc('cw8_a1', 'Which words rhyme?', 'Same ending sound.', ['cat and hat','cat and dog','cat and sun','cat and fish'], 'cat and hat'),
        A.mc('cw8_a2', 'Complete the rhyme: "The sky is __"', 'Blue / true!', ['blue','green','red','tall'], 'blue'),
        A.fb('cw8_a3', '"I see a cat. It is __" (rhymes with cat)', 'Fat / bat / hat!', ['fat','dog','sun','fish'], 'fat'),
        A.drag('cw8_a4', 'Order rhyming pairs: cat/hat, dog/log, sun/fun', '', ['cat=hat','dog=log','sun=fun'], 'cat=hat,dog=log,sun=fun'),
      ], xp: 70),
      L('cw_9', 'Write a Short Paragraph', 'Write 3-4 connected sentences.', 'Sentences about one topic!', 'Paragraph', '📄', activities: [
        A.mc('cw9_a1', 'How many sentences in a short paragraph?', '3-4 sentences.', ['3-4','1','10','20'], '3-4'),
        A.mc('cw9_a2', 'A paragraph is about __ topic(s)', 'One topic.', ['one','two','three','many'], 'one'),
        A.drag('cw9_a3', 'Order: topic sentence, details, ending', '', ['Topic sentence','Details','Ending'], 'Topic sentence,Details,Ending'),
        A.tap('cw9_a4', 'Which is a paragraph?', 'Several sentences on one topic.', ['I have a cat. It is black. It likes milk. I love my cat.','Cat milk black.','I have a cat.','Black cat.'], 'I have a cat. It is black. It likes milk. I love my cat.'),
      ], xp: 75),
      L('cw_10', 'Creative Writing Challenge', 'Write your own creative sentences!', 'Show your imagination!', 'Writer', '🏆', activities: [
        A.mc('cw10_a1', 'Start a story with "__"', 'Once upon a time!', ['Once upon a time','The end','Goodbye','Hello'], 'Once upon a time'),
        A.mc('cw10_a2', '"The __ was magical." (add a noun)', 'Castle / forest!', ['forest','run','blue','quickly'], 'forest'),
        A.fb('cw10_a3', '"They lived happily __ after."', 'Ever!', ['ever','never','always','sometimes'], 'ever'),
        A.tap('cw10_a4', 'What makes writing creative?', 'Imagination!', ['Using imagination','Using only facts','Being short','Copying'], 'Using imagination'),
      ], xp: 80),
    ],
  );

  // E13. Punctuation
  static final _punctuationTopic = T(
    id: 'punctuation', title: 'Punctuation', description: 'Learn to use punctuation marks correctly.',
    icon: Icons.tag, color: Colors.brown, order: 13,
    lessons: [
      L('punc_1', 'Period (.)', 'Use a period at the end of a sentence.', 'A period shows the sentence is finished.', 'Period', '🔴', activities: [
        A.mc('punc1_a1', 'Which sentence has a period?', 'Period at the end.', ['The cat is big.','The cat is big','The cat is big!','The cat is big?'], 'The cat is big.'),
        A.mc('punc1_a2', 'Where does a period go?', 'At the end!', ['At the end','At the start','In the middle','Nowhere'], 'At the end'),
        A.fb('punc1_a3', '"I like dogs__" — add period or not?', 'Yes, add period.', ['.','?','!',','], '.'),
        A.tap('punc1_a4', 'Pick the correct sentence', '', ['She runs fast.','She runs fast','She runs fast!','She runs fast?'], 'She runs fast.'),
      ], xp: 50),
      L('punc_2', 'Question Mark (?)', 'Use ? for questions.', 'A question mark ends a question.', 'Question', '❓', activities: [
        A.mc('punc2_a1', 'Which is a question?', 'Ends with ?.', ['Where are you?','Where are you.','Where are you!','Where are you'], 'Where are you?'),
        A.mc('punc2_a2', 'Use a question mark for __', 'Questions!', ['questions','commands','excitement','statements'], 'questions'),
        A.fb('punc2_a3', '"What is your name__" — add __', 'Question mark!', ['?','.','!',','], '?'),
        A.tap('punc2_a4', 'Pick the correct question', '', ['How old are you?','How old are you.','How old are you!','How old are you'], 'How old are you?'),
      ], xp: 55),
      L('punc_3', 'Exclamation Mark (!)', 'Use ! for strong feelings.', 'Exclamation shows excitement or surprise!', 'Exclaim', '❗', activities: [
        A.mc('punc3_a1', 'Which shows excitement?', 'Ends with !.', ['Look out!','Look out.','Look out?','Look out'], 'Look out!'),
        A.mc('punc3_a2', 'Use ! when you are __', 'Excited or surprised!', ['excited','bored','tired','calm'], 'excited'),
        A.fb('punc3_a3', '"Watch __!" (add ! for urgency)', 'Watch out!', ['out','in','up','down'], 'out'),
        A.tap('punc3_a4', 'Pick the exciting sentence', '', ['We won the game!','We won the game.','We won the game?','We won the game'], 'We won the game!'),
      ], xp: 55),
      L('punc_4', 'Comma (,)', 'Use commas to separate items.', 'I like cats, dogs, and birds.', 'Comma', '🔻', activities: [
        A.mc('punc4_a1', 'Which has commas correctly?', 'Separates items.', ['I like cats, dogs, and birds.','I like cats dogs and birds.','I like, cats dogs and birds.','I like cats dogs, and birds.'], 'I like cats, dogs, and birds.'),
        A.mc('punc4_a2', 'Use a comma between __', 'Items in a list.', ['items in a list','every word','after every word','only at the end'], 'items in a list'),
        A.fb('punc4_a3', '"Apples, bananas, __ grapes" (add comma)', 'Comma before and! Wait, no — just fill.', ['and','or','but','the'], 'and'),
        A.drag('punc4_a4', 'Order with commas: apples, bananas, grapes', '', ['apples','bananas','grapes'], 'apples,bananas,grapes'),
      ], xp: 60),
      L('punc_5', 'Capital Letters', 'Capitalize the first word and names.', 'Always capitalize the beginning!', 'Capital', '⬆️', activities: [
        A.mc('punc5_a1', 'Which has correct capitals?', 'First word + names capitalized.', ['The cat is big.','the cat is big.','The Cat is Big.','the Cat is big.'], 'The cat is big.'),
        A.mc('punc5_a2', 'Names always start with __', 'Capital letters!', ['capital letters','small letters','numbers','punctuation'], 'capital letters'),
        A.fb('punc5_a3', '"__om" → capitalize the first letter', 'T!', ['T','t','S','s'], 'T'),
        A.tap('punc5_a4', 'Pick the correct capitalization', '', ['Tom and Ann play.','tom and ann play.','Tom and ann play.','tom and Ann play.'], 'Tom and Ann play.'),
      ], xp: 60),
      L('punc_6', 'Apostrophe Mark', 'Use apostrophe for ownership.', 'The cats toy - the toy belongs to the cat.', 'Apostrophe', '🟣', activities: [
        A.mc('punc6_a1', 'Which shows ownership? cats toy?', 'Add apostrophe.', ["cat's toy","cats toy","cat toy","cat toys"], "cat's toy"),
        A.mc('punc6_a2', 'Shows that something belongs to someone', 'Ownership.', ['ownership','color','size','shape'], 'ownership'),
        A.fb('punc6_a3', 'The dog__ bone (dog owns it)', "dog's", ["dog's","dogs","dog","dog'"], "dog's"),
        A.tap('punc6_a4', 'Which has correct apostrophe?', 'Shows ownership.', ["The girl's book","The girls book","The girl book","The girls book"], "The girl's book"),
      ], xp: 65),
      L('punc_7', 'Quotation Marks (" ")', 'Use quotes for what people say.', '"Hello," she said.', 'Quote', '💬', activities: [
        A.mc('punc7_a1', 'Which has quotes for speech?', '"Words" show speech.', ['"Hi!" said Tom.','Hi! said Tom.','Tom said hi.','Hi Tom.'], '"Hi!" said Tom.'),
        A.mc('punc7_a2', 'Quotes go around the __ words.', 'Spoken words!', ['spoken','written','big','first'], 'spoken'),
        A.fb('punc7_a3', '"__ __," she said. (add speech)', '"Hello" or "Help"!', ['Hello','The','A','An'], 'Hello'),
        A.tap('punc7_a4', 'Pick correct quotation use', '', ['"I am happy," she said.','I am happy, she said.','"I am happy", she said.','I am happy she said.'], '"I am happy," she said.'),
      ], xp: 70),
      L('punc_8', 'Colon (:)', 'Use colon before a list.', 'I need: pens, paper, and glue.', 'Colon', '🔵', activities: [
        A.mc('punc8_a1', 'Which uses colon correctly?', 'Colon introduces a list.', ['I need: pens and paper.','I need: pens and paper','I need pens: and paper','I need pens and: paper'], 'I need: pens and paper.'),
        A.mc('punc8_a2', 'A colon comes __ a list.', 'Before the list.', ['before','after','during','instead of'], 'before'),
        A.fb('punc8_a3', '"You need: __, paper, and glue." (item)', 'Pens!', ['pens','the','a','an'], 'pens'),
        A.tap('punc8_a4', 'Pick correct colon use', '', ['Bring: a pencil, a book, and a bag.','Bring a: pencil, book, and bag.','Bring a pencil: a book and a bag.','Bring a pencil a book: and a bag.'], 'Bring: a pencil, a book, and a bag.'),
      ], xp: 70),
      L('punc_9', 'Review All Punctuation', 'Use , . ? ! : correctly.', 'Mix of all punctuation marks!', 'Review', '📝', activities: [
        A.mc('punc9_a1', 'End a statement with __', 'Period!', ['.','?','!',','], '.'),
        A.mc('punc9_a2', 'End a question with __', 'Question mark!', ['.','?','!',','], '?'),
        A.fb('punc9_a3', 'Show excitement with __', 'Exclamation!', ['.','?','!',','], '!'),
        A.tap('punc9_a4', 'Separate list items with __', 'Comma!', [',','.','?','!'], ','),
      ], xp: 75),
      L('punc_10', 'Punctuation Challenge', 'Use all punctuation marks correctly!', 'Show your punctuation power!', 'Punctuation', '🏆', activities: [
        A.mc('punc10_a1', 'Which is correct?', 'Capital + end period.', ['The cat is big.','the cat is big.','The Cat is Big.','the Cat is Big.'], 'The cat is big.'),
        A.mc('punc10_a2', '"Where are you__" — add correct', 'Question mark.', ['?','.','!',','], '?'),
        A.fb('punc10_a3', '"The dog__ bone is big." (add apostrophe)', "dog's", ["dog's","dogs","dog","dog'"], "dog's"),
        A.drag('punc10_a4', 'Order: correct sentence "big cat the is."', '', ['The','cat','is','big','.'], 'The,cat,is,big,.'),
      ], xp: 80),
    ],
  );
}