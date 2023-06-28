import 'dart:io';
import 'dart:math';

void main() {
  ex6();
}

void ex2() {
  String? inpNum = stdin.readLineSync();
  int.parse(inpNum!) % 2 == 1 ? print(" is odd") : print("is even");
}

void ex3() {
  Random random = Random();
  List<int> list = [];
  for (var i = 0; i < 50; i++) {
    list.add(random.nextInt(10));
  }
  print("my list before $list");

  list.removeWhere((e) => e > 5);
  print("my list after $list");
}

void ex5() {
  /*and write a program that returns a list that contains only the elements that are common between them (without duplicates).
  Make sure your program works on two lists of different sizes*/
  Random random = Random();
  List<int> list1 = [];
  List<int> list2 = [];
  List<int> resultList = [];
  for (var i = 0; i < 5; i++) {
    list1.add(random.nextInt(10));
  }
  for (var i = 0; i < 25; i++) {
    list2.add(random.nextInt(10));
  }
  print("$list1 \n$list2");

  for (var i in list1) {
    for (var j in list2) {
      if (i == j && !resultList.contains(i)) resultList.add(i);
    }
  }
  print(resultList);
}

void ex6(){
  /**/
}
