import "time.dart";

List<String> cells = [];
int x = 0;

void makeArray() {
  if (x < 47) {
    for (int i = getCurrentHour(); i < 48; i++) {
      cells.add("Empty");
      print(x);
      x = i;
    }
  }
}