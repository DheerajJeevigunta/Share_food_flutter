import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:share_food/navbar.dart';
import 'package:share_food/services/authprovider.dart';
import 'package:share_food/shared/load.dart';

class Login extends StatefulWidget {
  const Login({ Key? key }) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool load= false;
  @override
  Widget build(BuildContext context) {

    Authprovider authprovider =Provider.of<Authprovider>(context);
    switch(authprovider.status){
      case Status.authenticateError:
        Fluttertoast.showToast(msg: "Sign in fail");
        break;
      case Status.authenticateCanceled:
        Fluttertoast.showToast(msg: "Sign in Canceled");
        break;
       case Status.authenticated:
        Fluttertoast.showToast(msg: "Sign in Success");
        break;
       default:
       break; 

    }
    


    return load ?Load():
    Stack(
      children: <Widget>[
        ShaderMask(
          shaderCallback: (rect) => LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.center,
            colors: [Colors.black, Colors.transparent],
          ).createShader(rect),
          blendMode: BlendMode.darken,
          child: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/ngo_reg.jpg'),
                    fit: BoxFit.cover,
                    colorFilter:
                        ColorFilter.mode(Colors.black54, BlendMode.darken))),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
           body: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(left: 95, top: 62.5, right: 35),
                child: Text('Sign In  with Google ',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 39,
                        fontFamily: 'Nunito regular')),
              ),
              SizedBox(height: 40,),
              Padding(padding: const EdgeInsets.all(20.0),
              child: GestureDetector(
                onTap: ()async{
                  setState(() => load = true);
                    bool isSuccess= await authprovider.handleSignIn();
                    if(isSuccess){
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Navbar()));
                    }

                } ,
                child: Image.asset(
                  "assets/images/google_login.jpg"
                ),
                ),
              ),

            ]
           )
        ),
      ]
    );
  }
}