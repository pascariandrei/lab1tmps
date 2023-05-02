
//Adapter////////////////////////////////////////////////////////////////////////
const adapteeMessage = 'Adaptee#method was called';

class Adaptee {
  String method() {
    print('Adaptee#method is being called');

    return adapteeMessage;
  }
}

abstract class Target {
  String call();
}

class Adapter implements Target {
  @override
  String call() {
    var adaptee = Adaptee();
    print('Adapter#call is being called');

    return adaptee.method();
  }
}

//Bridge/////////////////////////////////////////////////////////////////////////
// Implementor
abstract class Device {
  void turnOn();
  void turnOff();
  void setVolume(int volume);
}

// Concrete Implementor 1
class TV implements Device {
  @override
  void turnOn() => print('TV turned on.');

  @override
  void turnOff() => print('TV turned off.');

  @override
  void setVolume(int volume) => print('TV volume set to $volume.');
}

// Concrete Implementor 2
class Radio implements Device {
  @override
  void turnOn() => print('Radio turned on.');

  @override
  void turnOff() => print('Radio turned off.');

  @override
  void setVolume(int volume) => print('Radio volume set to $volume.');
}

// Abstraction
abstract class Remote {
  final Device device;

  Remote(this.device);

  void power() {
    if (_isOn()) {
      device.turnOff();
    } else {
      device.turnOn();
    }
  }

  void volumeUp() {
    final currentVolume = _getVolume();
    device.setVolume(currentVolume + 1);
  }

  void volumeDown() {
    final currentVolume = _getVolume();
    device.setVolume(currentVolume - 1);
  }

  bool _isOn();
  int _getVolume();
}

// Refined Abstraction 1
class TVRemote extends Remote {
  TVRemote(Device device) : super(device);

  @override
  bool _isOn() => true; // replace with actual TV on/off check

  @override
  int _getVolume() => 10; // replace with actual TV volume check
}

// Refined Abstraction 2
class RadioRemote extends Remote {
  RadioRemote(Device device) : super(device);

  @override
  bool _isOn() => false; // replace with actual radio on/off check

  @override
  int _getVolume() => 5; // replace with actual radio volume check
}
// Component////////////////////////////////////////////////////////////////////////

abstract class Shape {
  void draw();
}

// Leaf
class Circle implements Shape {
  final String color;

  Circle(this.color);

  @override
  void draw() => print('Drawing a $color circle.');
}

// Leaf
class Square implements Shape {
  final String color;

  Square(this.color);

  @override
  void draw() => print('Drawing a $color square.');
}

// Composite
class CompositeShape implements Shape {
  final List<Shape> _shapes = [];

  void addShape(Shape shape) => _shapes.add(shape);

  void removeShape(Shape shape) => _shapes.remove(shape);

  @override
  void draw() {
    for (final shape in _shapes) {
      shape.draw();
    }
  }
}
//flyweight
abstract class FlyweightShape {
  void draw();
}

// Concrete flyweight
class FlyweightCircle implements FlyweightShape {
  final String color;
  final int radius;

  FlyweightCircle(this.color, this.radius);

  @override
  void draw() => print('Drawing a $color circle with radius $radius.');
}

// Flyweight factory
class ShapeFactory {
  final Map<String, FlyweightShape> _shapes = {};

  FlyweightShape getShape(String color, int radius) {
    final key = '$color:$radius';

    if (_shapes.containsKey(key)) {
      return _shapes[key]!;
    } else {
      final shape = FlyweightCircle(color, radius);
      _shapes[key] = shape;
      return shape;
    }
  }
}

//Facade
class CarEngine {
  void start() => print('Starting the engine.');
  void stop() => print('Stopping the engine.');
}

// Subsystem 2
class CarLights {
  void turnOn() => print('Turning on the lights.');
  void turnOff() => print('Turning off the lights.');
}

// Subsystem 3
class CarMusicPlayer {
  void playMusic() => print('Playing music.');
  void stopMusic() => print('Stopping music.');
}

// Facade
class Car {
  final CarEngine _engine = CarEngine();
  final CarLights _lights = CarLights();
  final CarMusicPlayer _musicPlayer = CarMusicPlayer();

  void start() {
    _engine.start();
    _lights.turnOn();
    _musicPlayer.playMusic();
  }

  void stop() {
    _engine.stop();
    _lights.turnOff();
    _musicPlayer.stopMusic();
  }
}

void main() {
  //Adapter
  print("\nAdaptor");

  var adapter = Adapter();
  var result = adapter.call();

  print(result == adapteeMessage);

  //Bridge
  print("\nBridge");

  final tv = TV();
  final radio = Radio();

  final tvRemote = TVRemote(tv);
  final radioRemote = RadioRemote(radio);

  tvRemote.power(); // TV turned off.
  tvRemote.volumeUp(); // TV volume set to 11.
  radioRemote.power(); // Radio turned on.
  radioRemote.volumeDown(); // Radio volume set to 4.

  //Composite
  print("\nComposite\n");
  final circle1 = Circle('red');
  final circle2 = Circle('blue');
  final square = Square('green');

  final composite = CompositeShape();
  composite.addShape(circle1);
  composite.addShape(circle2);
  composite.addShape(square);

  composite.draw();

  //Flyweight
  final factory = ShapeFactory();
  print("\nFlyWeight\n");

  final Flyweightcircle1 = factory.getShape('red', 10);
  Flyweightcircle1.draw(); // Drawing a red circle with radius 10.

  final Flyweightcircle2 = factory.getShape('blue', 20);
  Flyweightcircle2.draw(); // Drawing a blue circle with radius 20.

  final Flyweightcircle3 = factory.getShape('red', 10);
  Flyweightcircle3.draw(); // Drawing a red circle with radius 10.

  print(identical(Flyweightcircle1, Flyweightcircle2)); // false
  print(identical(Flyweightcircle1, Flyweightcircle3));

  //Facade
  print("\nFacade\n");


  final car = Car();
  car.start(); // Starting the engine. Turning on the lights. Playing music.
  car.stop(); // Stopping the engine. Turning off the lights. Stopping music.

}

