import 'package:flutter/material.dart';

Icon generateIcon(String s) {
  var title = s.toLowerCase();

  if (title.contains("bank") ||
      title.contains("finance") ||
      title.contains("money") ||
      title.contains("cash") ||
      title.contains("pay")) {
    return Icon(Icons.account_balance);
  } else if (title.contains("draw") ||
      title.contains("brush") ||
      title.contains("art") ||
      title.contains("design") ||
      title.contains("sketch")) {
    return Icon(Icons.brush);
  } else if (title.contains("code") ||
      title.contains("coding") ||
      title.contains("programming") ||
      title.contains("software")) {
    return Icon(Icons.code);
  } else if (title.contains("commute") ||
      title.contains("drive") ||
      title.contains("travel") ||
      title.contains("train") ||
      title.contains("bus")) {
    return Icon(Icons.drive_eta);
  } else if (title.contains("relax") || title.contains("chill")) {
    return Icon(Icons.weekend);
  } else if (title.contains("study") ||
      title.contains("lecture") ||
      title.contains("school") ||
      title.contains("read") ||
      title.contains("research") ||
      title.contains("revise") ||
      title.contains("revision")) {
    return Icon(Icons.school);
  } else if (title.contains("breakfast") ||
      title.contains("lunch") ||
      title.contains("dinner") ||
      title.contains("food") ||
      title.contains("meal") ||
      title.contains("eat") ||
      title.contains("snack") ||
      title.contains("brunch")) {
    return Icon(Icons.restaurant);
  } else if (title.contains("game") ||
      title.contains("play") ||
      title.contains("arcade") ||
      title.contains("raid") ||
      title.contains("online") ||
      title.contains("win")) {
    return Icon(Icons.videogame_asset);
  } else if (title.contains("gym") ||
      title.contains("exercise") ||
      title.contains("workout") ||
      title.contains("run")) {
    return Icon(Icons.fitness_center);
  } else if (title.contains("doctor") ||
      title.contains("dentist") ||
      title.contains("meditat") ||
      title.contains("appointment") ||
      title.contains("nurse") ||
      title.contains("hospital")) {
    return Icon(Icons.local_hospital);
  } else if (title.contains("home") ||
      title.contains("chores") ||
      title.contains("clean") ||
      title.contains("house")) {
    return Icon(Icons.home);
  } else if (title.contains("date") ||
      title.contains("kids") ||
      title.contains("family")) {
    return Icon(Icons.favorite);
  } else if (title.contains("movie") ||
      title.contains("film") ||
      title.contains("cinema")) {
    return Icon(Icons.local_movies);
  } else if (title.contains("music") ||
      title.contains("concert") ||
      title.contains("gig") ||
      title.contains("song")) {
    return Icon(Icons.music_note);
  } else if (title.contains("write")) {
    return Icon(Icons.edit);
  } else if (title.contains("party") ||
      title.contains("friend") ||
      title.contains("meet")) {
    return Icon(Icons.people);
  } else if (title.contains("sleep") ||
      title.contains("bed") ||
      title.contains("nap") ||
      title.contains("rest")) {
    return Icon(Icons.hotel);
  } else if (title.contains("store") ||
      title.contains("shopping") ||
      title.contains("shop")) {
    return Icon(Icons.store);
  } else if (title.contains("morning") ||
      title.contains("beach") ||
      title.contains("park") ||
      title.contains("wake up") ||
      title.contains("walk") ||
      title.contains("garden")) {
    return Icon(Icons.wb_sunny);
  } else if (title.contains("work") ||
      title.contains("meeting") ||
      title.contains("assignment") ||
      title.contains("project")) {
    return Icon(Icons.work);
  } else {
    return Icon(Icons.dashboard);
  }
}
