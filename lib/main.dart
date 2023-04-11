import 'package:dcdg/dcdg.dart';


//Singleton

class DataBase {
  static final DataBase _instance = DataBase._internal();

  DataBase._internal();

  static DataBase get instance => _instance;

  void readQuery(String table) {
    print('Read Query in $table');
  }
}

//Factory
class Square extends Shape {}

class Circle extends Shape {}

class Triangle extends Shape {}

class Shape {
  Shape();

  factory Shape.fromTypeName(String typeName) {
    if (typeName == 'square') return Square();
    if (typeName == 'circle') return Circle();
    if (typeName == 'triangle') return Triangle();
    throw "$typeName such shape is not recognised by the system";
  }
}

//Abstract Factory
abstract class Color {
  void paint();
}

class RedColor implements Color {
  @override
  void paint() {
    print("Red");
  }
}

class BlueColor implements Color {
  @override
  void paint() {
    print("Blue");
  }
}

class RedYellow implements Color {
  @override
  void paint() {
    print("RedYellow");
  }
}

class BlueRed implements Color {
  @override
  void paint() {
    print("BlueRed");
  }
}

abstract class AbstractFactory {
  Color? getColor(String colorType);
}

class ColorFactory extends AbstractFactory {
  @override
  Color? getColor(String colorType) {
    if (colorType == "red") {
      return RedColor();
    } else if (colorType == "blue") {
      return BlueColor();
    }
    return null;
  }
}

class ColorMixFactory extends AbstractFactory {
  @override
  Color? getColor(String colorType) {
    if (colorType == "red/yellow") {
      return RedYellow();
    } else if (colorType == "blue/red") {
      return BlueRed();
    }
    return null;
  }
}

class FactoryProducer {
  static AbstractFactory getFactory(bool mix) {
    if (mix) {
      return ColorMixFactory();
    } else {
      return ColorFactory();
    }
  }
}

//Builder
class Pizza {
  final String? sauce;
  final List<String>? toppings;
  final bool? hasExtraCheese;

  Pizza._builder(PizzaBuilder builder)
      : sauce = builder.sauce ?? '',
        toppings = builder.toppings,
        hasExtraCheese = builder.hasExtraCheese;
}

class PizzaBuilder {
  static const String neededTopping = 'cheese';
  final String? sauce;

  PizzaBuilder(this.sauce);

  List<String>? toppings;
  bool? hasExtraCheese;

  void setToppings(List<String> toppings) {
    if (!toppings.contains(neededTopping)) {
      throw 'Really, without $neededTopping? ';
    }
    this.toppings = toppings;
  }

  Pizza build() {
    return Pizza._builder(this);
  }
}

//Prototype
class Point {
  final int x;
  final int y;

  const Point(this.x, this.y);

  Point clone(int a, int b) => Point(a, b);
}

void main() {
  //Singleton
  print("Sigleton");

  DataBase? table1 = DataBase.instance;
  DataBase? table2 = DataBase.instance;
  print(identical(table1, table2));
  table1.readQuery("table1");
  table2.readQuery("table2");

  //Factory
  print("Factory");

  Shape shape = Shape.fromTypeName('circle');
  print(shape);

  //Abstract factory
  print("Abstract factory");
  AbstractFactory colorFactory = FactoryProducer.getFactory(false);

  Color? color1 = colorFactory.getColor("red");
  color1?.paint();

  Color? color2 = colorFactory.getColor("blue");
  color2?.paint();

  AbstractFactory mixColorFactory = FactoryProducer.getFactory(true);

  Color? color3 = mixColorFactory.getColor("red/yellow");
  color3?.paint();

  Color? color4 = mixColorFactory.getColor("blue/red");
  color4?.paint();

  //Builder
  Pizza pizza = (PizzaBuilder('bbq')
        ..setToppings(['tomato', 'cheese', 'chicken'])
        ..hasExtraCheese = true)
      .build();

  print(pizza.sauce);
  print(pizza.toppings);
  print(pizza.hasExtraCheese);

  Pizza pizza2 = (PizzaBuilder('cream')..hasExtraCheese = true).build();

  print(pizza2.sauce);
  print(pizza2.toppings);
  print(pizza2.hasExtraCheese);

  //Prototype
  final p1 = Point(1, 2);
  final p2 = p1.clone(3, 4);
  print(p2.x);
}
