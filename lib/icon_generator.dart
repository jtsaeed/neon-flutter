import 'package:flutter/material.dart';
import 'palette.dart';

Image _bank = new Image.asset("resources/icons/bank@3x.png", color: lightGrayColor);
Image _brush = new Image.asset("resources/icons/brush@3x.png", color: lightGrayColor);
Image _calendar = new Image.asset("resources/icons/calendar@3x.png", color: lightGrayColor);
Image _code = new Image.asset("resources/icons/code@3x.png", color: lightGrayColor);
Image _commute = new Image.asset("resources/icons/commute@3x.png", color: lightGrayColor);
Image _couch = new Image.asset("resources/icons/couch@3x.png", color: lightGrayColor);
Image _default = new Image.asset("resources/icons/default@3x.png", color: lightGrayColor);
Image _education = new Image.asset("resources/icons/education@3x.png", color: lightGrayColor);
Image _food = new Image.asset("resources/icons/food@3x.png", color: lightGrayColor);
Image _game = new Image.asset("resources/icons/game@3x.png", color: lightGrayColor);
Image _gym = new Image.asset("resources/icons/gym@3x.png", color: lightGrayColor);
Image _health = new Image.asset("resources/icons/health@3x.png", color: lightGrayColor);
Image _home = new Image.asset("resources/icons/home@3x.png", color: lightGrayColor);
Image _love = new Image.asset("resources/icons/love@3x.png", color: lightGrayColor);
Image _movie = new Image.asset("resources/icons/movie@3x.png", color: lightGrayColor);
Image _music = new Image.asset("resources/icons/music@3x.png", color: lightGrayColor);
Image _pencil = new Image.asset("resources/icons/pencil@3x.png", color: lightGrayColor);
Image _people = new Image.asset("resources/icons/people@3x.png", color: lightGrayColor);
Image _sleep = new Image.asset("resources/icons/sleep@3x.png", color: lightGrayColor);
Image _store = new Image.asset("resources/icons/store@3x.png", color: lightGrayColor);
Image _sun = new Image.asset("resources/icons/music@3x.png", color: lightGrayColor);
Image _work = new Image.asset("resources/icons/work@3x.png", color: lightGrayColor);

Image generateIcon(String s) {
  var title = s.toLowerCase();

  if (title.contains("bank") ||
      title.contains("finance") ||
      title.contains("money") ||
      title.contains("cash") ||
      title.contains("pay")) {
    return _bank;
  } else if (title.contains("draw") ||
      title.contains("brush") ||
      title.contains("art") ||
      title.contains("design") ||
      title.contains("sketch")) {
    return _brush;
  } else if (title.contains("code") ||
      title.contains("coding") ||
      title.contains("programming") ||
      title.contains("software")) {
    return _code;
  } else if (title.contains("commute") ||
      title.contains("drive") ||
      title.contains("travel") ||
      title.contains("train") ||
      title.contains("bus")) {
    return _commute;
  } else if (title.contains("relax") || title.contains("chill")) {
    return _couch;
  } else if (title.contains("study") ||
      title.contains("lecture") ||
      title.contains("school") ||
      title.contains("read") ||
      title.contains("research") ||
      title.contains("revise") ||
      title.contains("revision")) {
    return _education;
  } else if (title.contains("breakfast") ||
      title.contains("lunch") ||
      title.contains("dinner") ||
      title.contains("food") ||
      title.contains("meal") ||
      title.contains("eat") ||
      title.contains("snack") ||
      title.contains("brunch")) {
    return _food;
  } else if (title.contains("game") ||
      title.contains("play") ||
      title.contains("arcade")) {
    return _game;
  } else if (title.contains("gym") ||
      title.contains("exercise") ||
      title.contains("workout") ||
      title.contains("run")) {
    return _gym;
  } else if (title.contains("doctor") ||
      title.contains("dentist") ||
      title.contains("meditat") ||
      title.contains("appointment") ||
      title.contains("hospital")) {
    return _health;
  } else if (title.contains("home") ||
      title.contains("chores") ||
      title.contains("clean") ||
      title.contains("house")) {
    return _home;
  } else if (title.contains("date") ||
      title.contains("kids") ||
      title.contains("family")) {
    return _love;
  } else if (title.contains("movie") ||
      title.contains("film") ||
      title.contains("cinema")) {
    return _movie;
  } else if (title.contains("music") ||
      title.contains("concert") ||
      title.contains("gig") ||
      title.contains("song")) {
    return _music;
  } else if (title.contains("write")) {
    return _pencil;
  } else if (title.contains("party") ||
      title.contains("friend") ||
      title.contains("meet")) {
    return _people;
  } else if (title.contains("sleep") ||
      title.contains("bed") ||
      title.contains("nap") ||
      title.contains("rest")) {
    return _sleep;
  } else if (title.contains("store") ||
      title.contains("shopping") ||
      title.contains("shop")) {
    return _store;
  } else if (title.contains("morning") ||
      title.contains("beach") ||
      title.contains("park") ||
      title.contains("wake up") ||
      title.contains("walk") ||
      title.contains("garden")) {
    return _sun;
  } else if (title.contains("work") ||
      title.contains("meeting") ||
      title.contains("assignment") ||
      title.contains("project")) {
    return _work;
  } else {
    return _default;
  }
}
