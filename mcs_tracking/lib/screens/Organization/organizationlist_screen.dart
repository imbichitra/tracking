import 'package:flutter/material.dart';
import 'package:mcs_tracking/screens/organization/organization_detail_screen.dart';
import 'package:mcs_tracking/constant.dart';
import 'package:mcs_tracking/loading.dart';
import 'package:mcs_tracking/StateManagement/Organization/organization_provider.dart';
import 'package:provider/provider.dart';

class OrganizationList extends StatefulWidget {

  @override
  _OrganizationListState createState() => _OrganizationListState();
}

class _OrganizationListState extends State<OrganizationList> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: ()=>Navigator.of(context).pop(),
          ),
          title: Text('Organization List',style: Theme.of(context).textTheme.headline3),
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
        ),
        body:
        Provider.of<OrganizationStateManagement>(context).getOrganizationList.length>0? Container(
          padding: EdgeInsets.all(10),
          child:ListView.builder(
            itemCount: Provider.of<OrganizationStateManagement>(context).getOrganizationList.length,
            itemBuilder: (context, index) {
              final item = Provider.of<OrganizationStateManagement>(context).getOrganizationList[index];

              return  Card(
                  // color: foregroundColor,
                  child: Container(
                    // height: MediaQuery.of(context).size.height/6,
                    padding: const EdgeInsets.all(10.0),
                    child: ListTile(
                      // leading: CircleAvatar(
                      //   backgroundImage: AssetImage('images/car.png'),
                      // ),

                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Organization Refrence Name : ' + Provider
                              .of<OrganizationStateManagement>(context)
                              .getOrganizationList[index].orgRefName,
                              style: Theme
                                  .of(context)
                                  .textTheme
                                  .subtitle1),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Organizartion Name : ' + Provider
                                .of<OrganizationStateManagement>(context)
                                .getOrganizationList[index].orgName,
                            style: Theme
                                .of(context)
                                .textTheme
                                .subtitle1,
                          ),
//                       SizedBox(
//                        height: 10,
//                      ),
//                      Text(
//                        'Status : ' + organizations[index]["status"].toString(),
//                        style: Theme.of(context).textTheme.subtitle1,
//                      ),
                        ],
                      ),

                      /*
                    trailing: Container(
                      // decoration: BoxDecoration(
                      //   color: Theme.of(context).accentColor,
                      //   borderRadius: BorderRadius.circular(10.0)
                      // ),
                      height: 40,
                      width: 40,
                      child:
                         IconButton(
                          icon: Icon(
                            Icons.arrow_forward_ios
                          ),
                          color: Theme.of(context).accentColor,
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => OrganizationDetailView(object:Provider.of<OrganizationStateManagement>(context).getOrganizationList[index])));
                          },

                        ),

                    ),
                    */
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    OrganizationDetailView(object: Provider
                                        .of<OrganizationStateManagement>(context)
                                        .getOrganizationList[index])));
                      },
                    ),
                  ),
                );
            },
          ),
        ):Loading()
      
    );
  }

}
