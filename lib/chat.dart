import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/src/provider.dart';
import 'package:share/share.dart';
import 'package:share_food/Firestore_Const.dart';
import 'package:share_food/chat_page.dart';
import 'package:share_food/debouncer.dart';
import 'package:share_food/login.dart';
import 'package:share_food/popupChoices.dart';
import 'package:share_food/services/auth.dart';
import 'package:share_food/services/authprovider.dart';
import 'package:share_food/services/home_provider.dart';
import 'package:share_food/settings.dart';
import 'package:share_food/user_chat.dart';
import 'package:share_food/utilities.dart';
import 'package:share_food/widget.dart';

import 'main.dart';
class Chat extends StatefulWidget {
  const Chat({ Key? key }) : super(key: key);

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {

  final FirebaseMessaging firebaseMessaging =FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin=FlutterLocalNotificationsPlugin();

  final GoogleSignIn googleSignIn =GoogleSignIn();
  final ScrollController listScrollController =ScrollController();
 
  int _limit =20;
  int _limitIncrement =20;
  String _search ="";
  bool _isloading =false;

late  Authprovider authProvider;
late String  currentUserId;
late  HomeProvider homeProvider;
 Debouncer searchDebouncer = Debouncer(milliseconds :300);
StreamController<bool>btnClearController =StreamController<bool>();
TextEditingController searchBarTec =TextEditingController();


  List<PopupChoices> choices =<PopupChoices>[
PopupChoices(title: 'Settings', icon:Icons. settings),
PopupChoices(title: 'Logout', icon:Icons. exit_to_app),
PopupChoices(title: 'Share', icon:Icons. share),
  ];



  void scrollListner(){
    if(listScrollController.offset >= listScrollController.position.maxScrollExtent && !listScrollController.position.outOfRange){
      setState(() {
        _limit += _limitIncrement;
      });
    }
  }
  Future<void> handleSignOut()async{
    authProvider.handleSignOut();
    Navigator.push(context, MaterialPageRoute(builder:(context) =>Login()));
    
  }
   void onSelected(BuildContext context)async{
 
    final url ='https://mega.nz/file/aaBFhYbJ#SmwbChs7aB_Pgy2vlT_IZwa1d_9g1jUimeEd5jiAGdM';
     await Share.share('Download Our App💗\n\n$url');
  
}

  void onItemMenuPress(PopupChoices choice)
{
  if(choice.title =="Logout"){

    handleSignOut();

  }else if(choice.title=="Share"){
  onSelected(context);
  
    
  }
  
  else{
    Navigator.push(context, MaterialPageRoute(builder:(context) => cSettings()));
  }
}


Future<bool> onBackPress(){
  openDialog();
  return Future.value(false);
}

Future<void>openDialog()async{
  switch(await showDialog(
    context:context,
    builder: (BuildContext context){
      return SimpleDialog(
        clipBehavior: Clip.hardEdge,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        contentPadding: EdgeInsets.zero,
        children: <Widget>[
          Container(
              color: Colors.red[300],
              padding: EdgeInsets.only(bottom: 10,top: 10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    child: Icon(
                      Icons.exit_to_app,
                      size: 30,color: Colors.white,

                    ),
                    margin:EdgeInsets.only(bottom: 10),
                  ),
                  Text('Exit  app',style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold),),
                  Text('Are You Sure',style: TextStyle(color: Colors.white70,fontSize: 14),)
                ],
              ),
          ),
          SimpleDialogOption(
            onPressed:(){
              Navigator.pop(context,0);

            },
            child: Row(
                children: <Widget>[
                  Container(
                    child: Icon(Icons.cancel,color: Colors.black,),
                    margin: EdgeInsets.only(right: 10),
                  ),
                  Text('Cancel'
                  ,style: TextStyle(color: Colors.blue ,fontWeight: FontWeight.bold),),
                ],
            ),
          ),
         SimpleDialogOption(
            onPressed:(){
              Navigator.pop(context,1);

            },
            child: Row(
                children: <Widget>[
                  Container(
                    child: Icon(Icons.check_circle,color: Colors.black,),
                    margin: EdgeInsets.only(right: 10),
                  ),
                  Text('Yes'
                  ,style: TextStyle(color: Colors.blue ,fontWeight: FontWeight.bold),),
                ],
            ),
          ),
        
       
        ],
      );
    }
  )){case 0:
  break;
  case 1:
  exit(0);
  }
}
Widget buildPopupMenu(){
  return PopupMenuButton<PopupChoices>(
    icon: Icon(Icons.more_vert,color: Colors.grey,),
    onSelected: onItemMenuPress,
    itemBuilder: (BuildContext Context)
  {
    return choices.map((PopupChoices choice){
      
        return PopupMenuItem<PopupChoices>(
           value: choice,
              child: Row(
                children: <Widget>[
                      Icon (
                         choice.icon,
                         color: Color(0xff841742),
                      ),
                      Container(
                        width: 10,
                      ),
                      Text(
                        choice.title ,
                        style: TextStyle(color: Color(0xff841742)),
                      )
              ],),
        );
    }).toList();
  });

}
@override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    btnClearController.close();
  }

@override
  void initState() {
    // TODO: implement initState
    super.initState();
    authProvider = context.read<Authprovider>();
     homeProvider = context.read<HomeProvider>();

    if(authProvider.getUserFirebaseId()?.isNotEmpty== true){
      currentUserId =authProvider.getUserFirebaseId()!;
    }else{
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>Login( )), (Route<dynamic> route) => false);
    }
      registerNotification();
      configureLocalNotifications();
      listScrollController.addListener(scrollListner);
  }
void registerNotification(){
  firebaseMessaging.requestPermission();

  FirebaseMessaging.onMessage.listen((RemoteMessage message) { 
      if(message.notification !=null){
            //show notifications
            showNotification(message.notification!);
      }
      return;
  });
  firebaseMessaging.getToken().then((token) {
      if(token !=null){

        homeProvider.updateDataFirestore(FirestoreConstants.pathUserCollection, currentUserId, {
          'pushToken':token
        });

      }
  }).catchError((error){
    Fluttertoast.showToast(msg:error.message.toString());
  });
}
  
void configureLocalNotifications(){
  AndroidInitializationSettings androidInitializationSettings =AndroidInitializationSettings("app_icon");
  IOSInitializationSettings iosInitializationSettings = IOSInitializationSettings();
  InitializationSettings initializationSettings =InitializationSettings(android: androidInitializationSettings,iOS: iosInitializationSettings);
  flutterLocalNotificationsPlugin.initialize(initializationSettings);
}
  

  void showNotification(RemoteNotification remoteNotification) async{
    AndroidNotificationDetails androidNotificationDetails =AndroidNotificationDetails("com.example.share_food", "Share Food",
    playSound: true,
    enableVibration: true,
    channelShowBadge: true,
    importance: Importance.max,
    priority: Priority.high);
    IOSNotificationDetails iosNotificationDetails =IOSNotificationDetails();
    NotificationDetails notificationDetails =NotificationDetails(android: androidNotificationDetails,iOS: iosNotificationDetails);

    await flutterLocalNotificationsPlugin.show(
      0,
      remoteNotification.title,
      remoteNotification.body,
      notificationDetails,
      payload: null,
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isWhite ?  Colors.white :Colors.black,
      appBar: AppBar(
        backgroundColor: isWhite ?  Colors.white :Colors.black, 
        leading: IconButton(icon: Switch(
          value: isWhite,
          onChanged: (value){
            setState(() {
              isWhite=value;
              print(isWhite);
            });
          },
          activeTrackColor: Colors.grey,
          activeColor: Colors.white,
          inactiveTrackColor: Colors.grey,
          inactiveThumbColor: Colors.black45,

        ),
        onPressed: ()=>"",
        ),
        actions: <Widget>[
              buildPopupMenu()
        ],
      ),
      body: WillPopScope(
        onWillPop: onBackPress,
        child:Stack(
          children: <Widget>[
            Column(
                children: <Widget>[
                      buildSearchBar(),
                      Expanded(
                        child:StreamBuilder<QuerySnapshot>(
                          stream: homeProvider.getStreamFireStore(FirestoreConstants.pathUserCollection, _limit, _search),
                          builder: (BuildContext context , AsyncSnapshot<QuerySnapshot> snapshot){
                            if(snapshot.hasData){
                              if((snapshot.data?.docs.length ??0)>0){
                              return ListView.builder(
                                padding: EdgeInsets.all(10),
                                itemBuilder: (context , index)=>buildItem(context,snapshot.data?.docs[index]),
                                itemCount: snapshot.data?.docs.length,
                                controller: listScrollController,
                              );
                              }else{
                                return Center(
                                  child: Text('Sorry No user found...',style: TextStyle(color: Colors.grey),),
                                );
                              }
                            }else{
                              return Center(
                                child: CircularProgressIndicator(
                                  color: Colors.grey,
                                ),
                              );
                            }
                          },
                        ) 
                        )
                ],
            ),
            Positioned(child: _isloading ? LoadingView():SizedBox.shrink())
          ],
        ),
        ),
      
    );
  }
  Widget buildSearchBar(){
    return Container(
      height: 40,
      child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.search,color: Colors.black,size: 30,),
            SizedBox(width: 5,),
            Expanded(
              child: TextFormField(
                textInputAction: TextInputAction.search,
                controller: searchBarTec,
                onChanged: (value){
                  if(value.isNotEmpty){
                    btnClearController.add(true);
                    setState(() {
                      _search =value;
                    });
                  }else{
                    btnClearController.add(false);
                    setState(() {
                      _search="";
                    });
                  }
                },
                decoration: InputDecoration.collapsed(hintText: "search...  EG: NGO/Donar",
                hintStyle: TextStyle(fontSize: 13,color: Colors.grey),
                ),
                style:TextStyle(fontSize: 13),
              ),

              ),
              StreamBuilder(
                stream: btnClearController.stream,
                builder: (context,snapShot)
                {
                  return snapShot.data ==true ? 
                  GestureDetector(
                    onTap: (){
                      searchBarTec.clear();
                      btnClearController.add(false);
                      setState(() {
                        _search="";
                      });
                    },
                    child: Icon(Icons.clear_rounded,color: Colors.grey,size: 20,),)
                    :SizedBox.shrink();
                  
                  
                })
          ],
      ),
      decoration:BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
      ),
      padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
      margin: EdgeInsets.fromLTRB(16, 8, 16, 8),
    );
  }
  Widget buildItem(BuildContext,DocumentSnapshot? document){
    if(document !=null){
      UserChat userChat =UserChat.fromDocument(document);
      if(userChat.id == currentUserId){
            return SizedBox.shrink();

      }else{
        return Container(
          child: TextButton(

            child: Row(
              children: <Widget>[
                Material(
                  child: userChat.photoUrl.isNotEmpty ? 
                  Image.network(
                    userChat.photoUrl,
                    fit: BoxFit.cover,
                    width: 50,
                    height: 50,
                    loadingBuilder: (BuildContext,Widget child,ImageChunkEvent? loadingProgress){
                      if(loadingProgress==null)return child;
                      return Container(
                        width: 50,
                        height: 50,
                        child: CircularProgressIndicator(

                               color:Colors.red,
                        value:loadingProgress.expectedTotalBytes != null && loadingProgress.expectedTotalBytes != null ?
                        loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes! :null,
                        ),
                   
                      );
                    },
                    errorBuilder:(context,object,stackTrace){
                      return Icon(
                        Icons.account_circle,
                        size:50,
                        color: Colors.grey,
                      );
                    } ,
                    )
                    :Icon( Icons.account_circle,
                        size:50,
                        color: Colors.grey,),
                        borderRadius: BorderRadius.all(Radius.circular(25)),
                        clipBehavior: Clip.hardEdge,
                ),
                Flexible(
                  child: Container(
                    child: Column(
                      children: <Widget>[
                        Container(
                          child: Text('${userChat.nickname}',
                          maxLines: 1,
                          style:TextStyle(color:Colors.white,fontWeight: FontWeight.bold,fontSize: 18),
                          ),
                          alignment: Alignment.centerLeft,
                          margin: EdgeInsets.fromLTRB(10, 0, 0, 5),
                        ),
                        Container(
                          child: Text('${userChat.aboutMe}',
                          maxLines: 1,
                          style:TextStyle(color:Colors.white)
                          ),
                          alignment: Alignment.centerLeft,
                          margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                        ),
                      ],
                      ),
                      margin: EdgeInsets.only(left: 20),
                  ), 
                ),

            ],
            ),
            onPressed: (){
              if(Utilities.isKeyboardShowing()){
                Utilities.closeKeyboard(context);
              }
              Navigator.push(context, MaterialPageRoute(builder:  (context)=>ChatPage(
                peerId : userChat.id,
                peerAvtar :userChat.photoUrl,
                peerNickname:userChat.nickname
              )
              )
              );
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.blue.shade400.withOpacity(.9)),
              shape:MaterialStateProperty.all<OutlinedBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
              ),
            ),
          ),
          margin: EdgeInsets.only(bottom: 10,left: 5,right: 5), 
        );
      }
       
    }else{
      return SizedBox.shrink();
    }
  }
}
