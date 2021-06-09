import 'package:flutter/cupertino.dart';
import 'package:mcs_tracking/Models/user/user.dart';
import 'package:mcs_tracking/api/exception/custome_exception.dart';
import 'package:mcs_tracking/api/user/user_repository.dart';


class UserStateManagement extends ChangeNotifier{
  List<User> users = List();
  User _user;

  bool isLoading = false;

  UserRepository userRepository = UserRepository();

  void setUsers(List<User> userList){
    users = userList;
    isLoading = false;
    notifyListeners();
  }
  void setUser(User user){
    _user = user;
    isLoading = false;
    notifyListeners();
  }


  List<User> get getUsers => this.users;

  User get getUser => this._user;

  Future<void> getUserList()async{
    try{
      isLoading = true;
      notifyListeners();
      List<User> users = await userRepository.getUsers();
      setUsers(users);
    }catch(e){
      print(e);
    }
  }

  Future<void> postUser(var data)async{
    try{
      isLoading = true;
      notifyListeners();
      User user = await userRepository.postUser(data);
      setUser(user);
    }catch(e){
      throw CustomeException(e);
    }
  }
}