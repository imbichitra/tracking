import 'package:flutter/material.dart';
import 'package:mcs_tracking/StateManagement/User/user_provider.dart';
import 'package:mcs_tracking/loading.dart';
import 'package:provider/provider.dart';
import 'package:mcs_tracking/constant.dart';
import 'package:mcs_tracking/screens/User/userdetail_screen.dart';

class UserListScreen extends StatefulWidget {
  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  @override
  Widget build(BuildContext context) {
    print(Provider.of<UserStateManagement>(context).getUsers.length);
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Users",
            style: Theme.of(context).textTheme.headline3,
          ),
          centerTitle: true,
          elevation: 0,
        ),
        body: Provider.of<UserStateManagement>(context).getUsers.length>0
            ? Container(
          child: ListView.builder(
              itemCount: Provider.of<UserStateManagement>(context).getUsers.length,
              itemBuilder: (context,index){
                return GestureDetector(
                  onTap: (){
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => UserDetailScreen(
                              object:Provider.of<UserStateManagement>(context)
                                  .getUsers[index]
                              ,
                            )));
                  },
                  child: Card(
                    child: Container(
                      // height: MediaQuery.of(context).size.height / 8,
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 5),
                      child: ListTile(
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                'User Name : ' +
                                    Provider.of<UserStateManagement>(context).getUsers[index]
                                        .userName,
                                style:
                                Theme.of(context).textTheme.subtitle1),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              'Email: ' +
                                  Provider.of<UserStateManagement>(context)
                                      .getUsers[index]
                                      .email,
                              style: Theme.of(context).textTheme.subtitle1,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }
          ),
        )
            : Loading());
  }
}
