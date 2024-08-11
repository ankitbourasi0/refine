

import 'package:flutter/material.dart';
import 'package:refine_basic/Enums/IconCategory.dart';
import 'package:refine_basic/Utils/IconInfo.dart';
import 'package:string_similarity/string_similarity.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
String getTodayMonthAndDate() {
  final now = DateTime.now();
  final monthNames = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];

  String month = monthNames[now.month - 1]; // month is 1-indexed
  int date = now.day;

  return 'Today, $month $date';
}

TimeOfDay parseTimeString(String timeString) {
  final parts = timeString.split(' ');
  final timeParts = parts[0].split(':');
  int hour = int.parse(timeParts[0]);
  int minute = 0;

  if (parts[1].toUpperCase() == 'PM' && hour != 12) {
    hour += 12;
  } else if (parts[1].toUpperCase() == 'AM' && hour == 12) {
    hour = 0;
  }

  return TimeOfDay(hour: hour, minute: minute);
}

Widget buildActionButton(IconData icon, String label, VoidCallback onPressed) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      IconButton(
        icon: Icon(icon),
        onPressed: onPressed,
      ),
      Text(label),
    ],
  );
}

Map<IconCategory, IconInfo> iconMap = {
IconCategory.write: IconInfo('write', 'assets/fallback_icons/write.png', ['journal', 'note', 'draft', 'compose', 'document']),
IconCategory.mail: IconInfo('mail', 'assets/fallback_icons/mail.png', ['email', 'message', 'communicate', 'send', 'reply']),
IconCategory.money: IconInfo('money', 'assets/fallback_icons/money.png', ['budget', 'save', 'invest', 'expense', 'income']),
IconCategory.gym: IconInfo('gym', 'assets/fallback_icons/gym.png', ['workout', 'exercise', 'fitness', 'train', 'strength']),
IconCategory.computer: IconInfo('computer', 'assets/fallback_icons/computer.png', ['work', 'code', 'study', 'research', 'type']),
IconCategory.lock: IconInfo('lock', 'assets/fallback_icons/lock.png', ['secure', 'protect', 'password', 'privacy', 'encrypt']),
IconCategory.location: IconInfo('location', 'assets/fallback_icons/location.png', ['navigate', 'travel', 'explore', 'visit', 'find']),
IconCategory.video: IconInfo('video', 'assets/fallback_icons/video.png', ['watch', 'film', 'record', 'stream', 'learn']),
IconCategory.heart: IconInfo('heart', 'assets/fallback_icons/heart.png', ['love', 'care', 'appreciate', 'support', 'connect']),
IconCategory.coffee: IconInfo('coffee', 'assets/fallback_icons/coffee.png', ['drink', 'brew', 'energize', 'morning', 'break','coffee']),
IconCategory.setting: IconInfo('setting', 'assets/fallback_icons/setting.png', ['configure', 'adjust', 'optimize', 'customize', 'maintain']),
IconCategory.alarm: IconInfo('alarm', 'assets/fallback_icons/alarm.png', ['wake', 'remind', 'schedule', 'alert', 'time']),
IconCategory.lightSun: IconInfo('light-sun', 'assets/fallback_icons/light-sun.png', ['outdoor', 'vitamin', 'walk', 'nature', 'daylight']),
IconCategory.chess: IconInfo('chess', 'assets/fallback_icons/chess.png', ['strategy', 'game', 'think', 'plan', 'compete']),
IconCategory.shopping: IconInfo('shopping', 'assets/fallback_icons/shopping.png', ['buy', 'groceries', 'errands', 'purchase', 'browse']),
IconCategory.travel: IconInfo('travel', 'assets/fallback_icons/travel.png', ['trip', 'vacation', 'explore', 'adventure', 'journey']),
IconCategory.add: IconInfo('add', 'assets/fallback_icons/add.png', ['create', 'new', 'start', 'begin', 'initiate']),
IconCategory.search: IconInfo('search', 'assets/fallback_icons/search.png', ['find', 'research', 'explore', 'investigate', 'lookup']),
IconCategory.creditcard: IconInfo('creditcard', 'assets/fallback_icons/creditcard.png', ['pay', 'purchase', 'finance', 'transaction', 'spend']),
IconCategory.copy: IconInfo('copy', 'assets/fallback_icons/copy.png', ['duplicate', 'backup', 'replicate', 'save', 'store']),
IconCategory.callReject: IconInfo('call-reject', 'assets/fallback_icons/call-reject.png', ['focus', 'silence', 'do-not-disturb', 'quiet', 'concentrate']),
IconCategory.check: IconInfo('check', 'assets/fallback_icons/check.png', ['complete', 'finish', 'done', 'accomplish', 'verify']),
IconCategory.fire: IconInfo('fire', 'assets/fallback_icons/fire.png', ['cook', 'heat', 'camp', 'energize', 'motivate']),
IconCategory.giftDark: IconInfo('gift-dark', 'assets/fallback_icons/gift-dark.png', ['give', 'present', 'surprise', 'celebrate', 'reward']),
IconCategory.hashtag: IconInfo('hashtag', 'assets/fallback_icons/hashtag.png', ['trend', 'topic', 'categorize', 'organize', 'tag']),
IconCategory.headphone: IconInfo('headphone', 'assets/fallback_icons/headphone.png', ['listen', 'music', 'podcast', 'focus', 'audio']),
IconCategory.key: IconInfo('key', 'assets/fallback_icons/key.png', ['unlock', 'access', 'open', 'secure', 'enter']),
IconCategory.light: IconInfo('light', 'assets/fallback_icons/light.png', ['illuminate', 'read', 'study', 'focus', 'idea']),
IconCategory.link: IconInfo('link', 'assets/fallback_icons/link.png', ['connect', 'share', 'reference', 'bookmark', 'associate']),
IconCategory.magic: IconInfo('magic', 'assets/fallback_icons/magic.png', ['create', 'transform', 'improve', 'enchant', 'imagine']),
IconCategory.medal: IconInfo('medal', 'assets/fallback_icons/medal.png', ['achieve', 'award', 'recognize', 'accomplish', 'honor']),
IconCategory.music: IconInfo('music', 'assets/fallback_icons/music.png', ['listen', 'play', 'sing', 'relax', 'motivate']),
IconCategory.nigh: IconInfo('nigh', 'assets/fallback_icons/nigh.png', ['sleep', 'rest', 'relax', 'unwind', 'dream']),
IconCategory.accelerate: IconInfo('accelerate', 'assets/fallback_icons/accelerate.png', ['speed', 'boost', 'quicken', 'efficiency', 'progress']),
IconCategory.art: IconInfo('art', 'assets/fallback_icons/art.png', ['draw', 'paint', 'create', 'design', 'express']),
IconCategory.charge: IconInfo('charge', 'assets/fallback_icons/charge.png', ['power', 'energy', 'recharge', 'battery', 'fuel']),
IconCategory.emptyFolder: IconInfo('empty-folder', 'assets/fallback_icons/empty-folder.png', ['organize', 'clean', 'declutter', 'file', 'sort']),
IconCategory.figma: IconInfo('figma', 'assets/fallback_icons/figma.png', ['design', 'create', 'prototype', 'collaborate', 'sketch']),
IconCategory.goal: IconInfo('goal', 'assets/fallback_icons/goal.png', ['target', 'aim', 'objective', 'plan', 'aspire']),
IconCategory.race: IconInfo('race', 'assets/fallback_icons/race.png', ['run', 'compete', 'challenge', 'sprint', 'endurance']),
IconCategory.read: IconInfo('read', 'assets/fallback_icons/read.png', ['book', 'study', 'learn', 'comprehend', 'literature']),
IconCategory.remove: IconInfo('remove', 'assets/fallback_icons/remove.png', ['delete', 'clean', 'eliminate', 'clear', 'declutter']),
IconCategory.save: IconInfo('save', 'assets/fallback_icons/save.png', ['store', 'keep', 'preserve', 'backup', 'archive']),
IconCategory.solve: IconInfo('solve', 'assets/fallback_icons/solve.png', ['problem', 'puzzle', 'resolve', 'figure-out', 'analyze']),
IconCategory.sound: IconInfo('sound', 'assets/fallback_icons/sound.png', ['listen', 'audio', 'volume', 'hear', 'adjust']),
IconCategory.star: IconInfo('star', 'assets/fallback_icons/star.png', ['favorite', 'rate', 'important', 'prioritize', 'highlight']),
IconCategory.switches: IconInfo('switch', 'assets/fallback_icons/switch.png', ['toggle', 'change', 'alternate', 'adapt', 'modify']),
IconCategory.tea: IconInfo('tea', 'assets/fallback_icons/tea.png', ['drink', 'brew', 'relax', 'sip', 'hydrate']),
IconCategory.test: IconInfo('test', 'assets/fallback_icons/test.png', ['exam', 'quiz', 'assess', 'evaluate', 'check']),
IconCategory.type: IconInfo('type', 'assets/fallback_icons/type.png', ['write', 'input', 'text', 'compose', 'document']),
// IconCategory.productivity: IconInfo('write', 'assets/fallback_icons/write.png', ['write', 'journal', 'blog', 'draft', 'essay', 'report']),
  // IconCategory.communication: IconInfo('mail', 'assets/fallback_icons/mail.png', ['email', 'respond', 'communicate', 'inbox', 'reply']),
  // IconCategory.finance: IconInfo('money', 'assets/fallback_icons/money.png', ['budget', 'save', 'invest', 'expense', 'income']),
  // IconCategory.health: IconInfo('gym', 'assets/fallback_icons/gym.png', ['workout', 'exercise', 'run', 'lift', 'stretch']),
  // IconCategory.technology: IconInfo('computer', 'assets/fallback_icons/computer.png', ['code', 'program', 'develop', 'debug', 'type']),
  // IconCategory.security: IconInfo('lock', 'assets/fallback_icons/lock.png', ['password', 'secure', 'protect', 'backup', 'encrypt']),
  // IconCategory.navigation: IconInfo('location', 'assets/fallback_icons/location.png', ['commute', 'travel', 'explore', 'visit', 'navigate']),
  // IconCategory.media: IconInfo('video', 'assets/fallback_icons/video.png', ['watch', 'film', 'record', 'edit', 'stream']),
  // IconCategory.social: IconInfo('heart', 'assets/fallback_icons/heart.png', ['appreciate', 'thank', 'love', 'care', 'support']),
  // IconCategory.lifestyle: IconInfo('coffee', 'assets/fallback_icons/coffee.png', ['drink', 'brew', 'sip', 'relax', 'energize']),
  // IconCategory.utilities: IconInfo('setting', 'assets/fallback_icons/setting.png', ['configure', 'adjust', 'optimize', 'customize', 'setup']),
  // IconCategory.time: IconInfo('alarm', 'assets/fallback_icons/alarm.png', ['wake', 'remind', 'schedule', 'time', 'plan']),
  // IconCategory.weather: IconInfo('light-sun', 'assets/fallback_icons/light-sun.png', ['sunbathe', 'garden', 'outdoor', 'walk', 'picnic']),
  // IconCategory.gaming: IconInfo('chess', 'assets/fallback_icons/chess.png', ['play', 'strategy', 'compete', 'learn', 'practice']),
  // IconCategory.shopping: IconInfo('shopping', 'assets/fallback_icons/shopping.png', ['buy', 'groceries', 'gift', 'compare', 'browse']),
  // IconCategory.travel: IconInfo('travel', 'assets/fallback_icons/travel.png', ['plan', 'book', 'pack', 'explore', 'vacation']),
  // IconCategory.productivity: IconInfo('add', 'assets/fallback_icons/add.png', ['create', 'start', 'begin', 'initiate', 'new']),
  // IconCategory.utilities: IconInfo('search', 'assets/fallback_icons/search.png', ['research', 'find', 'explore', 'investigate', 'lookup']),
  // IconCategory.finance: IconInfo('creditcard', 'assets/fallback_icons/creditcard.png', ['pay', 'purchase', 'subscribe', 'renew', 'order']),
  // IconCategory.utilities: IconInfo('copy', 'assets/fallback_icons/copy.png', ['duplicate', 'backup', 'archive', 'replicate', 'store']),
  // IconCategory.communication: IconInfo('call-reject', 'assets/fallback_icons/call-reject.png', ['decline', 'focus', 'silence', 'prioritize', 'pause']),
  // IconCategory.utilities: IconInfo('check', 'assets/fallback_icons/check.png', ['complete', 'finish', 'verify', 'confirm', 'accomplish']),
  // IconCategory.lifestyle: IconInfo('fire', 'assets/fallback_icons/fire.png', ['cook', 'grill', 'campfire', 'heat', 'warm']),
  // IconCategory.social: IconInfo('gift-dark', 'assets/fallback_icons/gift-dark.png', ['give', 'surprise', 'celebrate', 'reward', 'donate']),
  // IconCategory.social: IconInfo('hashtag', 'assets/fallback_icons/hashtag.png', ['trend', 'follow', 'engage', 'discuss', 'share']),
  // IconCategory.media: IconInfo('headphone', 'assets/fallback_icons/headphone.png', ['listen', 'podcast', 'audiobook', 'music', 'meditate']),
  // IconCategory.utilities: IconInfo('key', 'assets/fallback_icons/key.png', ['unlock', 'access', 'secure', 'open', 'enter']),
  // IconCategory.utilities: IconInfo('light', 'assets/fallback_icons/light.png', ['illuminate', 'read', 'study', 'focus', 'brainstorm']),
  // IconCategory.communication: IconInfo('link', 'assets/fallback_icons/link.png', ['share', 'connect', 'network', 'bookmark', 'reference']),
  // IconCategory.lifestyle: IconInfo('magic', 'assets/fallback_icons/magic.png', ['create', 'transform', 'improve', 'inspire', 'imagine']),
  // IconCategory.achievement: IconInfo('medal', 'assets/fallback_icons/medal.png', ['achieve', 'goal', 'reward', 'recognize', 'celebrate']),
  // IconCategory.media: IconInfo('music', 'assets/fallback_icons/music.png', ['listen', 'play', 'compose', 'sing', 'practice']),
  // IconCategory.time: IconInfo('nigh', 'assets/fallback_icons/nigh.png', ['sleep', 'rest', 'relax', 'unwind', 'dream']),
  // IconCategory.utilities: IconInfo('accelerate', 'assets/fallback_icons/accelerate.png', ['speed', 'optimize', 'efficiency', 'quicken', 'boost']),
  // IconCategory.lifestyle: IconInfo('art', 'assets/fallback_icons/art.png', ['draw', 'paint', 'create', 'design', 'sketch']),
  // IconCategory.utilities: IconInfo('charge', 'assets/fallback_icons/charge.png', ['recharge', 'power', 'energize', 'restore', 'fuel']),
  // IconCategory.utilities: IconInfo('empty-folder', 'assets/fallback_icons/empty-folder.png', ['organize', 'clean', 'declutter', 'sort', 'file']),
  // IconCategory.productivity: IconInfo('figma', 'assets/fallback_icons/figma.png', ['design', 'prototype', 'create', 'collaborate', 'iterate']),
  // IconCategory.achievement: IconInfo('goal', 'assets/fallback_icons/goal.png', ['target', 'aim', 'achieve', 'plan', 'aspire']),
  // IconCategory.achievement: IconInfo('race', 'assets/fallback_icons/race.png', ['compete', 'run', 'train', 'challenge', 'improve']),
  // IconCategory.productivity: IconInfo('read', 'assets/fallback_icons/read.png', ['study', 'learn', 'research', 'review', 'comprehend']),
  // IconCategory.utilities: IconInfo('remove', 'assets/fallback_icons/remove.png', ['delete', 'clean', 'declutter', 'minimize', 'simplify']),
  // IconCategory.productivity: IconInfo('save', 'assets/fallback_icons/save.png', ['store', 'backup', 'preserve', 'keep', 'archive']),
  // IconCategory.utilities: IconInfo('solve', 'assets/fallback_icons/solve.png', ['problem', 'puzzle', 'resolve', 'analyze', 'brainstorm']),
  // IconCategory.media: IconInfo('sound', 'assets/fallback_icons/sound.png', ['listen', 'record', 'podcast', 'adjust', 'focus']),
  // IconCategory.achievement: IconInfo('star', 'assets/fallback_icons/star.png', ['favorite', 'prioritize', 'highlight', 'important', 'rate']),
  // IconCategory.utilities: IconInfo('switch', 'assets/fallback_icons/switch.png', ['toggle', 'change', 'alternate', 'shift', 'adapt']),
  // IconCategory.lifestyle: IconInfo('tea', 'assets/fallback_icons/tea.png', ['drink', 'brew', 'relax', 'hydrate', 'sip']),
  // IconCategory.productivity: IconInfo('test', 'assets/fallback_icons/test.png', ['exam', 'quiz', 'assess', 'evaluate', 'practice']),
  // IconCategory.productivity: IconInfo('type', 'assets/fallback_icons/type.png', ['write', 'document', 'compose', 'draft', 'report']),
};

// Map<IconCategory, IconInfo> iconMap = {
//   IconCategory.learning: IconInfo(FontAwesomeIcons.graduationCap, ['learn', 'education', 'study']),
//   IconCategory.study: IconInfo(FontAwesomeIcons.book, ['study', 'read', 'research']),
//   IconCategory.food: IconInfo(FontAwesomeIcons.utensils, ['food', 'eat', 'meal', 'cook']),
//   IconCategory.exercise: IconInfo(FontAwesomeIcons.dumbbell, ['exercise', 'workout', 'gym']),
//   IconCategory.coding: IconInfo(FontAwesomeIcons.code, ['coding', 'programming', 'development']),
//   IconCategory.music: IconInfo(FontAwesomeIcons.music, ['music', 'song', 'melody']),
//   IconCategory.art: IconInfo(FontAwesomeIcons.paintBrush, ['art', 'painting', 'creativity']),
//   IconCategory.writing: IconInfo(FontAwesomeIcons.pen, ['writing', 'compose', 'author']),
//   IconCategory.reading: IconInfo(FontAwesomeIcons.bookOpen, ['reading', 'literature', 'books']),
//   IconCategory.meditation: IconInfo(FontAwesomeIcons.om, ['meditation', 'mindfulness', 'zen']),
//   // ... continue for all categories
// };

String findBestMatchingIcon(String input) {
  double bestScore = 0;
  IconCategory bestCategory = IconCategory.goal;

  for (var entry in iconMap.entries) {
    for (var keyword in entry.value.keywords) {
      double similarity = input.toLowerCase().similarityTo(keyword.toLowerCase());
      if (similarity > bestScore) {
        bestScore = similarity;
        bestCategory = entry.key;
      }
    }
  }


  return iconMap[bestCategory]!.localAssetPath;
}