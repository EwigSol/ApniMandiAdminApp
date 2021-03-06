

import 'package:apni_mandi_admin/models/users_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../constants/helper.dart';

class UsersController extends GetxController {

  var isLoading = false.obs;
  bool get loadingStatus => isLoading.value;


  Future<List<UsersModel>?> getUsersData() async {
    isLoading.value = true;
    var val = await FirebaseFirestore.instance.collection("usersAuthData").get();
    var documents = val.docs;
    List<UsersModel> eventList = [];
    if (documents.isNotEmpty) {
      try {
        final data = documents.map((doc) => doc.data()).toList();
        for(int i=0; i<data.length; i++){
          eventList.add(UsersModel.fromJson(Map<String, dynamic>.from(data[i])));
        }
        isLoading.value = false;
        return eventList;
      } catch (e) {
        isLoading.value = false;
        errorToast("Error", e.toString());
        return null;
      }
    }
    isLoading.value = false;
    errorToast("Error", "No User Available");
    return null;
  }

  Future<UsersModel?> getUserData(String id) async {
    isLoading.value = true;
    var val = await FirebaseFirestore.instance.collection("usersAuthData").doc(id).get();
    var documents = val.data();
    if (documents != null) {
      try {
        UsersModel userData = UsersModel.fromJson(Map<String, dynamic>.from(documents));
        isLoading.value = false;
        return userData;
      } catch (e) {
        isLoading.value = false;
        return null;
      }
    }else{
      isLoading.value = false;
      return null;
    }

  }

}