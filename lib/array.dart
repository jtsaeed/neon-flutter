import "time.dart";

List<String> array = [];
int x = 0;

void makeArray() {
  if (x < 47) {
    for (int i = getCurrentHour(); i < 48; i++) {
      array.add("Empty");
      x = i;
    }
  }
}