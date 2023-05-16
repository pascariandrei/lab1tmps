//VISITOR PATTERN
abstract class Visitor {
  void visitElementA(ElementA element);

  void visitElementB(ElementB element);
}

// Define the Element interface
abstract class Element {
  void accept(Visitor visitor);
}

// Concrete Element A
class ElementA implements Element {
  @override
  void accept(Visitor visitor) {
    visitor.visitElementA(this);
  }

  void operationA() {
    print("Performing operation A on Element A");
  }
}

// Concrete Element B
class ElementB implements Element {
  @override
  void accept(Visitor visitor) {
    visitor.visitElementB(this);
  }

  void operationB() {
    print("Performing operation B on Element B");
  }
}

// Concrete Visitor
class ConcreteVisitor implements Visitor {
  @override
  void visitElementA(ElementA element) {
    print("Visiting Element A");
    element.operationA();
  }

  @override
  void visitElementB(ElementB element) {
    print("Visiting Element B");
    element.operationB();
  }
}

//Template Method
abstract class AbstractClass {
  void templateMethod() {
    // Perform common steps
    step1();
    step2();
    step3();
    // Optionally, allow subclasses to override a step
    if (hook()) {
      customStep();
    }
  }

  void step1();

  void step2();

  void step3();

  // Hook method (optional) to be overridden by subclasses
  bool hook() => true;

  // Custom step (optional) to be overridden by subclasses
  void customStep() {}
}

// Concrete implementation of the abstract class
class ConcreteClass extends AbstractClass {
  @override
  void step1() {
    print("ConcreteClass: Step 1");
  }

  @override
  void step2() {
    print("ConcreteClass: Step 2");
  }

  @override
  void step3() {
    print("ConcreteClass: Step 3");
  }

  @override
  void customStep() {
    print("ConcreteClass: Custom Step");
  }
}

//ITERATOR
class MyIterable extends Iterable<int> {
  final int _start;
  final int _end;

  MyIterable(this._start, this._end);

  @override
  Iterator<int> get iterator => MyIterator(_start, _end);
}

class MyIterator implements Iterator<int> {
  final int _start;
  final int _end;
  int _current;

  MyIterator(this._start, this._end) : _current = _start - 1;

  @override
  int get current => _current;

  @override
  bool moveNext() {
    if (_current < _end) {
      _current++;
      return true;
    }
    return false;
  }
}

//MEMENTO
class Memento {
  String _state = '';

  Memento(String s) {
    _state = s;
    print("[Memento] State \"$s\" has been saved!");
  }

  String get state {
    print("[Memento] Providing saved state \"$_state\"...");
    return _state;
  }
}

class Originator {
  String _state = '';

  // NOTE: This uses the state setter on init to get a handy print
  Originator(String s) {
    state = s;
  }

  String get state => _state;

  void set state(String newState) {
    _state = newState;
    print("[Originator] Set state to $newState");
  }

  Memento saveToMemento() {
    print("[Originator] Saving to memento...");
    return Memento(state);
  }

  void restoreFromMemento(Memento m) {
    print("[Originator] Restoring from memento...");
    _state = m.state;
    print("[Originator] Restored to $state.");
  }
}

class CareTaker {
  Memento? memento;
}

//MEDIATOR
abstract class Stateful {
  String _state = '';

  String get state => _state;

  void set state(String newState) => _state = newState;
}

class Mediator {
  List<Stateful> _parties;

  Mediator(this._parties);

  void update(String state) {
    for (var party in _parties) {
      party.state = state;
    }
  }
}

class Attendee extends Stateful {
  String name;

  Attendee(this.name);
}

void main() {
//VISITOR
  print("VISITOR");
  final elementA = ElementA();
  final elementB = ElementB();

  final visitor = ConcreteVisitor();

  elementA.accept(visitor);
  elementB.accept(visitor);


  //TEMPLATE METHOD
  print("\nTEMPLATE");

  final abstractClass = ConcreteClass();
  abstractClass.templateMethod();

  //ITERATOR
  print("\nITERATOR");

  final myIterable = MyIterable(1, 5);
  final iterator = myIterable.iterator;

  while (iterator.moveNext()) {
    final value = iterator.current;
    print(value);
  }
  //MEMENTO
  print("\nMEMENTO");

  var me = Originator("Returned from store");
  me.state = "Placing car keys down";
  var locationOfKeys = me.saveToMemento();

  var memory = CareTaker();
  memory.memento = locationOfKeys;

  me.state = "Putting away groceries";
  me.state = "Noticed missing pickles";
  me.state = "Looking for car keys...";

  me.restoreFromMemento(memory.memento!);
  me.state = "Going back to store for pickles";

  //MEDIATOR
  print("\nMEDIATOR");

  var curly = Attendee("Curly");
  var larry = Attendee("Larry");
  var moe = Attendee("I prefer not to disclose my name");
  var mixer = List<Attendee>.from([curly, larry, moe]);
  var publicAnnouncementSystem = Mediator(mixer);

  publicAnnouncementSystem.update("Do NOT eat the shrip tacos!");

  for (var person in mixer) {
    print("${person.name} heard \"${person.state}\".");
  }
}
