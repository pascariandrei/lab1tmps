import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:freezed/builder.dart';

/*
part 'main.freezed.dart';
part 'main.g.dart';

@freezed
class EventEntity with _$EventEntity {
  factory EventEntity({
    required int id,
    required String? description,
    required String? timer,
  }) = _EventEntity;
}
*/

class Category {
  int id;
  String name;
  int itemsCount;

  Category(this.itemsCount, this.id, this.name);

  Category.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        itemsCount = json['itemsCount'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'itemsCount': itemsCount,
      };
}

Future<void> getFromAPi() async {
  List<Category> list = [];
  http.Response response;
  var url = "https://localhost:44370/api/Category/categories";
  response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    var result = jsonDecode(response.body);
    print("rezultatul este ${result}");
    print("rezultatul este ${result[0]["name"]}");
  }
}

Future<void> deleteFromAPi(int id) async {
  http.Response response;
  var url = "https://localhost:44370/api/Category/categories/$id";
  response = await http.delete(Uri.parse(url));
  if (response.statusCode == 200) {
    //var result = jsonDecode(response.body);
    print("deleteFromAPi${id}");
  }
}

Future<void> getItemsFromCategory(int id) async {
  http.Response response;
  var url = "https://localhost:44370/api/Category/categories/$id/products";
  response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    var result = jsonDecode(response.body);
    print("getItemsFromCategory${result}");
  }
}

Future<void> postItemsFromCategory(int id, int prodId, String title, int price, int catId) async {
  http.Response response;
  var url = "https://localhost:44370/api/Category/categories/$id/products";
  response = await http.post(Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{"id": "$prodId", "title": "$title", "price": "$price", "categoryId": "$catId"}));
  if (response.statusCode == 200) {
    var result = jsonDecode(response.body);
    print("PostItemsFromCategory${id}${result}");
  }
}

Future<void> createCategory(String name) async {
  http.Response response;
  var url = "https://localhost:44370/api/Category/categories";

  response = await http.post(
    Uri.parse(url),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'title': '${name}',
    }),
  );
  if (response.statusCode == 200) {
    var result = jsonDecode(response.body);
    print("createCategory ${result}");
  }
}

Future<void> putCategories(int id, String mesaj) async {
  http.Response response;
  var url = "https://localhost:44370/api/Category/$id";

  response = await http.put(
    Uri.parse(url),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'title': '${mesaj}',
    }),
  );
  if (response.statusCode == 200) {
    var result = jsonDecode(response.body);
    print("createCategory ${result}");
  }
}

void main() {
  //deleteFromAPi(11);
  //getFromAPi();
  //createCategory("eu sar in sus");
  //postItemsFromCategory(4,222, "AAAAAAAAA", 12, 2);
  //getItemsFromCategory(4);
  //putCategories(8, "iuhu");
}
