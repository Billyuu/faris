import 'dart:convert';

import 'package:faris/app/data/models/user_model.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class HomeController extends GetxController {
  var users = <UserModel>[].obs;
  var isLoading = true.obs;
  var page = 1.obs;

  @override
  void onInit() {
    fetchUsers();
    super.onInit();
  }

  Future<void> fetchUsers() async {
    try {
      isLoading.value = true;
      var response = await http.get(
          Uri.parse('https://reqres.in/api/users?page=${page.value}'));
      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        var jsonResponse = jsonData['data'] as List;
        print(jsonResponse);
        var data = jsonResponse.map((e) => UserModel.fromJson(e),);
        users.assignAll(data);
        isLoading.value = false;
      } else {
        isLoading.value = true;
        print('${response.statusCode}');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> refreshUsers() async {
    page.value++;
    print(page.value);
    await fetchUsers();
  }
}
