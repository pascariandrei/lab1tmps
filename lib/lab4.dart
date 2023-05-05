//SRP
class Friend {
  String name;
  String surname;

  Friend(this.surname, this.name);
}

void addFriend(String name, String surname) {
  print("SRP");
  Friend friend = Friend(surname, name);
  print(friend.surname);
}

//OCP
abstract class Shape {
  double calculateArea();
}

class Rectangle implements Shape {
  final double width;
  final double height;

  Rectangle(this.width, this.height);

  @override
  double calculateArea() {
    print(width * height);

    return width * height;
  }
}

class Circle implements Shape {
  final double radius;

  Circle(this.radius);

  @override
  double calculateArea() {
    print(3.14 * radius * radius);

    return 3.14 * radius * radius;
  }
}

//Liskov
class ShapeLiscov {
  double area() {
    return 0;
  }
}

class RectangleLiscov extends ShapeLiscov {
  double width;
  double height;

  RectangleLiscov(this.width, this.height);

  @override
  double area() {
    return width * height;
  }
}

class Square extends ShapeLiscov {
  double side;

  Square(this.side);

  @override
  double area() {
    return side * side;
  }
}

void printArea(ShapeLiscov shape) {
  print('The area of the shape is ${shape.area()}');
}

//INTERFACE SEGREGATION PRINCIPLE
abstract class Worker {
  void work();
}

abstract class Sleeper {
  void sleep();
}

class Human implements Worker, Sleeper {
  void work() => print("EU LUCREZ");

  void sleep() => print("EU DORM");
}

class Robot implements Worker {
  void work() => print("EU LUCREZ SI NICIODATA NU DORM");
}

//DIP
abstract class Payment {
  payment();
}

class PaymentViaCreditCard implements Payment {
  @override
  payment() {
    print("Credit");
  }
}

class PaymentViaDebitCard implements Payment {
  @override
  payment() {
    print("Debit");
  }
}


class Checkout {
  // our checkout class knows nothing about how payment works
  // its knows pay.payment() is paying method
  checkOut(Payment pay) {
    pay.payment();
  }
}

void main() {
  //SRP
  addFriend("Andrei", "Pascari");
  //OCP
  print("ocp");
  Rectangle(100, 200).calculateArea();
  Circle(100).calculateArea();
  //liskov
  var rectangle = RectangleLiscov(5, 10);
  var square = Square(5);
  printArea(rectangle);
  printArea(square);
  //INTERFACE SEGREGATION PRINCIPLE
  var robot = Robot().work();
  var human = Human();
  robot;
  human.work();
  human.sleep();
  //DIP
  var credit = PaymentViaCreditCard();
  var debit = PaymentViaDebitCard();
  var checkout1 = Checkout().checkOut(debit);
  var checkout2 = Checkout().checkOut(credit);
}
