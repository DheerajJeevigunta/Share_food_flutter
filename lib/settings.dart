import 'dart:io';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import 'package:flutter/material.dart';
import 'package:share_food/Firestore_Const.dart';
import 'package:share_food/loading_view.dart';
import 'package:share_food/services/database.dart';
import 'package:share_food/services/setting_provider.dart';
import 'package:share_food/shared/load.dart';
import 'package:share_food/user_chat.dart';

import 'main.dart';


 class cSettings extends StatelessWidget {
 const cSettings({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
       return Scaffold(
      backgroundColor: isWhite ?  Colors.white :Colors.black, 
      appBar: AppBar(
        toolbarHeight: 90,
        elevation:0.0,
        iconTheme: IconThemeData(color:  Colors.redAccent),
        title: Text(
           'Settings',style: TextStyle(color: Colors.redAccent,fontWeight: FontWeight.bold
           ),
        ),
          centerTitle:true      
      ),
      body: SettinState(),
        
      
    );
  }
 }




class SettinState extends StatefulWidget {
  const SettinState({ Key? key }) : super(key: key);

  @override
  _SettinStateState createState() => _SettinStateState();
}

class _SettinStateState extends State<SettinState> {
  TextEditingController? controllerNickname;
  TextEditingController? controllerAboutme;
  String dialCodeDigits ="+00";
  final TextEditingController _controller =TextEditingController();

  String id = '';
  String nickname= '';
  String phoneNumber  ='';
  String aboutme = '';
  String photoUrl ='';
  bool isLoading=false;
  File? avtarImageFile;
  late SettingProvider settingProvider;

  final focusNodeNickname =FocusNode();
  final focusNodeAboutMe =FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    settingProvider =context.read<SettingProvider>();
    readLocal();
  }
  void readLocal(){
      setState(() {
        id=settingProvider.getPref(FirestoreConstants.id)?? "";
        nickname =settingProvider.getPref(FirestoreConstants.nickname)?? "";
        phoneNumber =settingProvider.getPref(FirestoreConstants.phoneNumber)?? "";
                photoUrl =settingProvider.getPref(FirestoreConstants.photoUrl)?? "";

        aboutme =settingProvider.getPref(FirestoreConstants.aboutMe)?? "";
        
      });

      controllerNickname =TextEditingController(text: nickname);
      controllerAboutme =TextEditingController(text: aboutme);
  }


Future getImage() async{
  ImagePicker imagePicker =ImagePicker();
 PickedFile? pickedFile = await imagePicker.getImage(source: ImageSource.gallery) .catchError((err){
      Fluttertoast.showToast(msg: err.toString());
  });
  File? image;
  if(pickedFile != null){
    image= File(pickedFile.path);
  }
  if(image != null){
      setState(() {
        avtarImageFile =image;
        isLoading = false;
      });
      }
}


Future uploadFile() async{
  String fileName =id;
  UploadTask uploadTask =settingProvider.uploadFile(avtarImageFile!,fileName);
  try{
    TaskSnapshot snapshot =await uploadTask;
    photoUrl =await snapshot.ref.getDownloadURL();

    UserChat updateInfo =UserChat(
      id: id,
      photoUrl: photoUrl,
      nickname: nickname,
      phoneNumber: phoneNumber,
      aboutMe: aboutme
    );
    settingProvider.updateDataFirestore(FirestoreConstants.pathUserCollection, id, updateInfo.toJson()).
    then((data) async{
      await settingProvider.setPref(FirestoreConstants.photoUrl, photoUrl); 
      setState(() {
        isLoading=false;
      });

    }).catchError((err){
       setState(() {
        isLoading=false;
      });
        Fluttertoast.showToast(msg:err.toString());

    });
  } on FirebaseException catch(e){
     setState(() {
        isLoading=false;
      });
        Fluttertoast.showToast(msg:e.message?? e.toString());

  }
}
  


  void handleUpdateData(){
    focusNodeNickname.unfocus();
    focusNodeAboutMe.unfocus(); 

    setState(() {
      isLoading =false;

      if(dialCodeDigits != "+00" && _controller.text != ""){
        phoneNumber = dialCodeDigits + _controller.text.toString();
      }
    });
    UserChat updateInfo = UserChat(
      id:id,
      photoUrl: photoUrl,
      phoneNumber: phoneNumber,
      aboutMe: aboutme,
      nickname: nickname
    );
    settingProvider.updateDataFirestore(FirestoreConstants.pathUserCollection, id, updateInfo.toJson()).
    then((data)async{
      await settingProvider.setPref(FirestoreConstants.nickname, nickname);
      await settingProvider.setPref(FirestoreConstants.aboutMe, aboutme);
      await settingProvider.setPref(FirestoreConstants.phoneNumber, phoneNumber);
      await settingProvider.setPref(FirestoreConstants.photoUrl, photoUrl);
       setState(() {
         isLoading:false;
       });
       Fluttertoast.showToast(msg: "Update Succesfull");

    }).catchError((err){
      Fluttertoast.showToast(msg: err.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        SingleChildScrollView(
          padding: EdgeInsets.only(left: 15,right: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CupertinoButton(
                
               onPressed: getImage,
               child: Container(
                 margin: EdgeInsets.all(20),
                 child: avtarImageFile ==null ? photoUrl.isNotEmpty ?
                 ClipRRect(borderRadius: BorderRadius.circular(45),
                 child: Image.network(photoUrl,
                    fit: BoxFit.cover,
                    width: 90,
                    height: 90,
                    errorBuilder: (context,object,stackTrace){
                      return Icon(
                        Icons.account_circle,
                        size: 90,
                        color: Colors.grey,
                      );
                    },
                    loadingBuilder: (BuildContext context,Widget child,ImageChunkEvent? loadingProgress){
                            if(loadingProgress ==null)return child;
                            return Container(
                              width: 90,
                              height: 90,
                              child: Center(
                                child: CircularProgressIndicator(
                                  color:Colors.grey,
                                  value:loadingProgress.expectedTotalBytes != null && loadingProgress.expectedTotalBytes !=null 
                                  ? loadingProgress.cumulativeBytesLoaded /loadingProgress.expectedTotalBytes ! : null,
                                ),
                              ),
                            );
                    }
                 ),
                 ) : Icon(
                      Icons.account_circle,
                        size: 90,
                        color: Colors.grey,
                 )
                 : ClipRRect(
                   borderRadius: BorderRadius.circular(45),
                   child: Image.file(avtarImageFile!,
                   width: 90,
                   height: 90,
                   fit: BoxFit.cover,
                   )
                 )
               )
               ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: Text(
                    'Name:',
                    style: TextStyle(
                        fontFamily: "Montserrat Regular",fontWeight: FontWeight.bold,color: Colors.blue,
                    ),
                    
                    ),
                    margin: EdgeInsets.only(left: 10,bottom: 5,top: 10),

                ),
                Container(
                    margin: EdgeInsets.only(left: 30,right: 30),
                    child: Theme(
                      data: Theme.of(context).copyWith(primaryColor:Colors.blue),
                      child: TextField(
                        style: TextStyle(color: Colors.grey),
                        decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color:Colors.white ),
                          ),
                          hintText: 'Write Your Name...',
                          contentPadding: EdgeInsets.all(5),
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                        controller: controllerNickname,
                        onChanged: (value){
                          nickname=value;

                        },
                        focusNode: focusNodeNickname,
                      ),
                    ),
                ),

                Container(
                    child: Text(
                    'AboutMe:',
                    style: TextStyle(
                        fontFamily: "Montserrat Regular",fontWeight: FontWeight.bold,color: Colors.blue,
                    ),
                    
                    ),
                    margin: EdgeInsets.only(left: 10,bottom: 5,top: 30),

                ),


                      Container(
                    margin: EdgeInsets.only(left: 30,right: 30),
                    child: Theme(
                      data: Theme.of(context).copyWith(primaryColor:Colors.blue),
                      child: TextField(
                        style: TextStyle(color: Colors.grey),
                        decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color:Colors.white ),
                          ),
                          hintText: 'Specify Ngo/user/restaraunt',
                          contentPadding: EdgeInsets.all(5),
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                        controller: controllerAboutme,
                        onChanged: (value){
                          aboutme=value;

                        },
                        focusNode: focusNodeAboutMe
                      ),
                    ),
                ),

                Container(
                    child: Text(
                    'Mobile Number:',
                    style: TextStyle(
                        fontFamily: "Montserrat Regular",fontWeight: FontWeight.bold,color: Colors.blue,
                    ),
                    
                    ),
                    margin: EdgeInsets.only(left: 10,bottom: 5,top: 30),

                ),


                      Container(
                    margin: EdgeInsets.only(left: 30,right: 30),
                    child: Theme(
                      data: Theme.of(context).copyWith(primaryColor:Colors.blue),
                      child: TextField(
                        style: TextStyle(color: Colors.grey),
                        enabled: false,
                        decoration: InputDecoration(
                        
                          hintText: phoneNumber,
                          contentPadding: EdgeInsets.all(5),
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                       
                      ),
                    ),
                ),

                Container(
                  margin: EdgeInsets.only(left: 10,top: 30,bottom: 5),
                  child: SizedBox(
                    width: 400,
                    height: 60,
                    child:CountryCodePicker(
                      onChanged: (country){
                        setState(() {
                          dialCodeDigits =country.dialCode!;
                        });
                      },
                      initialSelection: "NGO",
                      showCountryOnly: false,
                      showOnlyCountryWhenClosed: false,
                      favorite: ["+91","India","+1","USA"],
                    ),
                ),
                ),
                Container(
                    margin: EdgeInsets.only(left: 30,right: 30),
                    child: TextField(
                      style:TextStyle(color:Colors.grey),
                      decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color:Colors.grey.shade300)
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue)
                        ),
                        hintText: "Mobile Number",
                        hintStyle: TextStyle(color: Colors.grey),
                        prefix :Padding(padding: EdgeInsets.all(4),
                        child:Text(dialCodeDigits,style: TextStyle(color:Colors.grey),)
                        )
                      ),
                      maxLength: 12,
                      keyboardType: TextInputType.number,
                      controller: _controller,
                    ),
                ),

                Container(
                  margin:EdgeInsets.only(top: 50, bottom: 50),
                  child: TextButton(onPressed: handleUpdateData,
                
                  child: Text('Update Details',style: TextStyle(fontSize: 16,color: Colors.white),
                  ),
                  style:ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                    padding:MaterialStateProperty.all<EdgeInsets>(
                     EdgeInsets.fromLTRB(30, 10, 30, 10)
                    )
                  )
                  ),
                ),


              ],
            )


            ],
          ),
        ),
        // Positioned(child: isLoading? LoadingView():SizedBox.shrink()),
      ],
      
    );
  }
  }

