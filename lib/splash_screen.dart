

import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import 'package:share_food/authenticate.dart';
import 'package:share_food/login.dart';
import 'package:share_food/navbar.dart';
import 'package:share_food/services/authprovider.dart';




class SplashScreen extends StatefulWidget {
  const SplashScreen({ Key? key }) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
@override

void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration( seconds: 5),(){
        checkSignedIn();
    });
  }
  void checkSignedIn() async{
    Authprovider authprovider= context.read<Authprovider>();
    bool isLoggedIn =await authprovider.isLoggedIn();
    if(isLoggedIn){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Navbar()));
      return;
    }
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Login()));

  }
  Widget build(BuildContext context) {
   
    return Scaffold(
        body: Stack(children: <Widget>[
      Container(
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                child: Column(
                  children: <Widget>[
                    Container(
                        margin: EdgeInsets.only(top: 40),
                        padding: EdgeInsets.only(left: 32),
                        child: Text('Food Share',
                            style: TextStyle(
                              height: 3.25,
                              color: Colors.indigo.shade900,
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              fontFamily: "Monserrat-Regular",
                            ))),
                    Container(
                      margin: EdgeInsets.all(12),
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                          'One App to Serve the World..',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Monserrat-Regular",
                          )),
                    )
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 32,vertical:32),
                child: Center(
                  child: Image.asset('assets/image/user.jpg',width: 400,height: 400,),
                ),
              ),
             
              Container(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(color: Colors.red,),
              ),
            ],
          )
          //  appBar: AppBar(
          //    centerTitle: true,,
          //       title: Text('Restaruant Login',style:TextStyle(height:3.25 ,color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold,fontFamily:"Montserrat Regular",)
          //       )
          //  ),

          ),
    ]));
  }
}
