import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class CustomAlertDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Theme.of(context).accentColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: Container(
        height: 125.0,
        width: 250.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
           Padding(
                padding: EdgeInsets.symmetric(horizontal: 20,vertical: 15),
                child: Text("Are you sure you want to exit ?",style: Theme.of(context).textTheme.bodyText1,),
              ),

            SizedBox(
              height: 5.0,
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: MaterialButton(
                      minWidth: double.infinity,
                      child: Text("Cancel",style:Theme.of(context).textTheme.bodyText1,),
                      onPressed: (){
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                  Flexible(
                    child: MaterialButton(
                      minWidth: double.infinity,
                      child: Text("Yes",style:Theme.of(context).textTheme.bodyText1,),
                      onPressed: ()  async{
                        SharedPreferences preferences =
                            await SharedPreferences.getInstance();
                        preferences.clear();
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            '/login', (Route<dynamic> route) => false);
                      },
                    ),
                  ),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}
