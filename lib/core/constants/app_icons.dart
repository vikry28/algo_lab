import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

class AppIcons {
  static const bubble = Icons.blur_on;
  static const selection = LineIcons.tasks;
  static const search = LineIcons.search;
  static const rsa = LineIcons.lock;
  static const graph = LineIcons.projectDiagram;
  static const astar = LineIcons.route;
  static const insertion = Icons.list;
  static const quick = Icons.flash_on;
  static const home = Icons.home;
  static const learn = LineIcons.bookOpen;
  static const language = Icons.language_sharp;
  static const language2 = LineIcons.language;
  static const description = Icons.description_outlined;
  static const play = Icons.play_arrow_rounded;
  static const externalLink = Icons.language;
  static const back = Icons.arrow_back;
  static const darkMode = Icons.dark_mode;
  static const lightMode = Icons.light_mode;
  static const profile = LineIcons.user;
  static const bolt = Icons.bolt;
  static const code = Icons.code;
  static const xp = Icons.flash_on;
  static const streak = Icons.local_fire_department;
  static const trophy = Icons.emoji_events;
  static const edit = Icons.edit_outlined;
  static const lockOutline = Icons.lock_outline;
  static const notification = Icons.notifications_outlined;
  static const logout = Icons.logout;
  static const google = LineIcons.googleLogo;
  static const chevronRight = Icons.chevron_right;

  static IconData getIcon(String name) {
    switch (name) {
      case 'bubble':
        return bubble;
      case 'selection':
        return selection;
      case 'search':
        return search;
      case 'rsa':
        return rsa;
      case 'graph':
        return graph;
      case 'astar':
        return astar;
      case 'insertion':
        return insertion;
      case 'quick':
        return quick;
      case 'language':
        return language;
      default:
        return LineIcons.questionCircle;
    }
  }
}
