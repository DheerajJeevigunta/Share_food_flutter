import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:provider/src/provider.dart';
import 'package:share_food/Firestore_Const.dart';
import 'package:share_food/full_pic.dart';
import 'package:share_food/loading_view.dart';
import 'package:share_food/login.dart';
import 'package:share_food/main.dart';
import 'package:share_food/message_chat.dart';
import 'package:share_food/services/authprovider.dart';
import 'package:share_food/services/chat_provider.dart';
import 'package:share_food/services/setting_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ChatPage extends StatefulWidget {
    final peerId;
    final peerAvtar;
    final peerNickname;
  const ChatPage({ Key? key,required this.peerId,required this.peerAvtar,required this.peerNickname }) : super(key: key);

  @override
  State createState() => ChatPageState(
    peerId: this.peerId,
    peerAvtar:this.peerAvtar,
    peerNickname :this.peerNickname
  );
}

class ChatPageState extends State<ChatPage> {
  ChatPageState({
    Key? key, required this.peerId,
    required this.peerAvtar,
    required this.peerNickname
  });
  String peerId;
  String peerAvtar;
  String peerNickname;
  late String currentUserId;

  List<QueryDocumentSnapshot> listMessage =new List.from([]); 
  int _limit =20;
  int _limitIncrement=20;
  String groupChatId="";
  File ? imageFile;
  bool isLoading=false;
  bool isShowSticker=false;
  String imageUrl="";
  final TextEditingController textEditingController= TextEditingController();
  final ScrollController listScrollController =ScrollController();
  final FocusNode focusNode =FocusNode();
  late ChatProvider chatProvider;
  late Authprovider authprovider;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    chatProvider =context.read<ChatProvider>();
    authprovider= context.read<Authprovider>();

    focusNode.addListener(onFocusChange);
    listScrollController.addListener(_scrollListener);
    readLocal();
  }
  _scrollListener(){
    if(listScrollController.offset >=listScrollController.position.maxScrollExtent && !listScrollController.position.outOfRange){
      setState(() {
        _limit +=_limitIncrement;
      });
    }
  }

void onFocusChange(){
  if(focusNode.hasFocus){
    setState(() {
      isShowSticker=false;
    });
  }
}

void readLocal(){
  if(authprovider.getUserFirebaseId()?.isNotEmpty==true){
    currentUserId =authprovider.getUserFirebaseId()!;
  }else{
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>Login()),
    (Route<dynamic>route)=>false );

  }
  if(currentUserId.hashCode <= peerId.hashCode){
    groupChatId ='$currentUserId-$peerId';

  }else{
    groupChatId ='$peerId-$currentUserId';
  }


  chatProvider.updateDataFirestore(FirestoreConstants.pathUserCollection, currentUserId, {FirestoreConstants.chattingWith:peerId});
}

Future getImage() async {

  ImagePicker imagePicker =ImagePicker();
  PickedFile? pickedFile;
  pickedFile =await imagePicker.getImage(source: ImageSource.gallery);
  if(pickedFile !=null){
    imageFile =File(pickedFile.path);
    if(imageFile!=null){
      setState(() {
        isLoading =true;
      });
      uploadFile();
    }
  }
}

void getSticker() {
  focusNode.unfocus();
  setState(() {
    isShowSticker = !isShowSticker;
  });

}

Future uploadFile() async{
  String fileName =DateTime.now().millisecondsSinceEpoch.toString();
  UploadTask uploadTask =chatProvider.uploadFile(imageFile!, fileName);
  try{
    TaskSnapshot snapshot =await uploadTask;
    imageUrl =await snapshot.ref.getDownloadURL();
    setState(() {
      isLoading=false;
      onSendMessage(imageUrl,TypeMessage.image);

    });
  }on FirebaseException catch(e){
    setState(() {
      isLoading =false;
    });
    Fluttertoast.showToast(msg: e.message ??e.toString());
  }
} 
 
 onSendMessage(String content,int type){
  if(content.trim().isNotEmpty){
    textEditingController.clear();
    chatProvider.sendMessage(content, type, groupChatId, currentUserId, peerId);
    listScrollController .animateTo(0, duration: Duration(milliseconds:300), curve: Curves.easeOut);

  }else{
    Fluttertoast.showToast(msg: 'Nothing to send',backgroundColor: Colors.grey);
  }
} 
  
bool isLastMessageLeft(int index){
  if((index > 0 && listMessage[index -1].get(FirestoreConstants.idFrom)==currentUserId)||index==0){
    return true;

  }else{
    return false;
  }
}  

bool isLastMessageRight(int index){
  if((index > 0 && listMessage[index -1].get(FirestoreConstants.idTo)!=currentUserId)||index==0){
    return true;

  }else{
    return false;
  }
}   
  
Future<bool> onBackPress(){
  if(isShowSticker){
    setState(() {
      isShowSticker =false;
    });
  }else{
    chatProvider.updateDataFirestore(FirestoreConstants.pathUserCollection, 
    currentUserId, 
    {FirestoreConstants.chattingWith:null}
    );
    Navigator.pop(context);
  }
  
  
  return Future.value(false);
}  
  
void  _callPhoneNumber(String callPhoneNumber)async{
   var url ='tel:// $callPhoneNumber';  
   if(await canLaunch(url)){
     await launch(url);
   }else{
     throw 'Error occurred';
   }
}  
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isWhite?Colors.white:Colors.black,
      
      appBar: AppBar(
          toolbarHeight: 90,
        backgroundColor: isWhite?Colors.white:Colors.grey[900],
        iconTheme: IconThemeData(
          color: Colors.red,
        ),
        title: Text(this.peerNickname,
        style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: <Widget>[
          IconButton( icon: Icon(
            Icons.phone_iphone,size: 30,color:Colors.blue
            ),
            onPressed: (){
              SettingProvider settingProvider;
              settingProvider =context.read<SettingProvider>();
              String callPhoneNumber =settingProvider.getPref(FirestoreConstants.phoneNumber)?? "";
              _callPhoneNumber(callPhoneNumber);
            },
          )
        ],
        ),
        body: WillPopScope(
          child: Stack(
            children: <Widget>[
              Column(
                children: <Widget>[
                  buildListMessage(),
                  isShowSticker? buildStickers():SizedBox.shrink(),
                  buildInput(),
                ],
              ),
              buildLoading()
            ],
          ),
          onWillPop: onBackPress,
        ),
      
    );
  }
  Widget buildStickers(){
    return Expanded(
      child: Container(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                TextButton(onPressed:()=> onSendMessage('mimi1', TypeMessage.sticker) ,

                child: Image.asset('assets/images/mimi1.gif',
                width: 50,
                height: 50,
                fit: BoxFit.cover,)
                ),
                  TextButton(onPressed:()=> onSendMessage('mimi2', TypeMessage.sticker) , 
                child: Image.asset('assets/images/mimi2.gif',
                width: 50,
                height: 50,
                fit: BoxFit.cover,)
                ),
                  TextButton(onPressed:()=> onSendMessage('mimi3', TypeMessage.sticker) , 
                child: Image.asset('assets/images/mimi3.gif',
                width: 50,
                height: 50,
                fit: BoxFit.cover,)
                ),
                  

             




              ],
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,

            ),
            Row(
              children:<Widget>[
                  TextButton(onPressed:()=> onSendMessage('mimi4', TypeMessage.sticker) , 
                child: Image.asset('assets/images/mimi4.gif',
                width: 50,
                height: 50,
                fit: BoxFit.cover,)
                ),
                  TextButton(onPressed:()=> onSendMessage('mimi5', TypeMessage.sticker) , 
                child: Image.asset('assets/images/mimi5.gif',
                width: 50,
                height: 50,
                fit: BoxFit.cover,)
                ),
                  TextButton(onPressed:()=> onSendMessage('mimi6', TypeMessage.sticker) , 
                child: Image.asset('assets/images/mimi6.gif',
                width: 50,
                height: 50,
                fit: BoxFit.cover,)
                ),
                  
              ],
               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            ),
            Row(children: <Widget>[
              TextButton(onPressed:()=> onSendMessage('mimi7', TypeMessage.sticker) , 
                child: Image.asset('assets/images/mimi7.gif',
                width: 50,
                height: 50,
                fit: BoxFit.cover,)
                ),
                  TextButton(onPressed:()=> onSendMessage('mimi8', TypeMessage.sticker) , 
                child: Image.asset('assets/images/mimi8.gif',
                width: 50,
                height: 50,
                fit: BoxFit.cover,)
                ),
                  TextButton(onPressed:()=> onSendMessage('mimi9', TypeMessage.sticker) , 
                child: Image.asset('assets/images/mimi9.gif',
                width: 50,
                height: 50,
                fit: BoxFit.cover,)
                ),
            ],
             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            )
            
          ],
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        ),
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Colors.grey.shade50,width: 0.5)),color: Colors.white
        ),
        padding: EdgeInsets.all(5),
        height: 180,
      ),

    );
  }
  
  Widget buildLoading(){
      return Positioned(
        child: isLoading ? LoadingView():SizedBox.shrink(),
      );
  }

  Widget buildInput(){
     return Container(
       child: Row(
         children: <Widget>[
           Material(
             child: Container(
               margin: EdgeInsets.symmetric(horizontal: 1),
               child:IconButton(icon: Icon(
                 Icons.camera_enhance
               ),
               onPressed: getImage,
               color: Colors.grey.shade500,)
             ),
             color: Colors.white,
           ),

           Material(
             child: Container(
               margin: EdgeInsets.symmetric(horizontal: 1),
               child:IconButton(icon: Icon(
                 Icons.face_retouching_natural
               ),
               onPressed: getSticker,
               color: Colors.grey.shade500,)
             ),
             color: Colors.white,
           ),

          Flexible(
          child: Container(
            child: TextField(
              onSubmitted: (value){
                onSendMessage(textEditingController.text, TypeMessage.text);
              },
              style: TextStyle(color:Colors.black,fontSize: 15,fontWeight: FontWeight.bold),
              controller: textEditingController,
              decoration: InputDecoration.collapsed(hintText: 'Type Message...',
              hintStyle: TextStyle(color: Colors.grey[700])
              ),
              focusNode: focusNode,
            ),
          ),
          ),
          
           Material(
             child: Container(
               margin: EdgeInsets.symmetric(horizontal: 8),
               child:IconButton(icon: Icon(
                 Icons.send,
               ),
               onPressed :()=>  onSendMessage(textEditingController.text,TypeMessage.text),
               color: Colors.red,)
             ),
             color: Colors.white,
           ),

          

         ],
         ),
         width: double.infinity,
         height: 50,
         decoration: BoxDecoration(
           border: Border(top: BorderSide(color: Colors.grey.shade50,width: 0.5)),color: Colors.white
         ),
     );
   }
  
  Widget buildItem(int index,DocumentSnapshot ? document){
    if(document !=null){
      MessageChat messageChat =MessageChat.fromDocument(document);
      if(messageChat.idFrom ==currentUserId){
        return Row(
          children: <Widget>[
              messageChat.type ==TypeMessage.text ? Container(
                  child: Text(messageChat.content,
                  style: TextStyle(color: Colors.white,fontWeight:FontWeight.bold),),
                  padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                  width: 200,
                  decoration: BoxDecoration(color:Colors.blue.shade400,borderRadius: BorderRadius.circular(8)),
                  margin: EdgeInsets.only(bottom: isLastMessageRight(index) ? 20:10,right: 10),
              ):messageChat.type ==TypeMessage.image ? 
              Container(
                child:OutlinedButton(
                  child: Material(
                    child: Image.network(messageChat.content,
                    loadingBuilder: (BuildContext context ,Widget child,ImageChunkEvent? loadingProgress )
                    {
                      if(loadingProgress ==null)return child;
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(8), 
                        ),
                        width: 200,
                        height: 200,
                        child: Center(
                          child: CircularProgressIndicator(
                            color: Colors.blue,
                            value: loadingProgress.expectedTotalBytes !=null && loadingProgress.expectedTotalBytes !=null ? loadingProgress.cumulativeBytesLoaded/loadingProgress.expectedTotalBytes!:null,
                          ),
                        ),
                      );
                    },
                    errorBuilder: (context,object,stackTrace){
                        return Material(
                          child: Image.asset('assets/images/img_not_available.jpeg',
                          width: 200,
                          height: 200,
                          fit: BoxFit.cover,),
                          borderRadius: BorderRadius.all(Radius.circular(8)
                          ),
                          clipBehavior: Clip.hardEdge,
                        );
                    },
                    width: 200,
                    height: 200,
                    fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    clipBehavior: Clip.hardEdge,
                  ),
                   onPressed: (){
                            Navigator.push(context,MaterialPageRoute(builder:(context)=>FullPhoto(url: messageChat.content)));
                   },
                   style:ButtonStyle(padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(0))),
                  ),
                  margin: EdgeInsets.only(bottom: isLastMessageRight(index)?20:10 ,right: 10),
              ): Container(
                child: Image.asset('assets/images/${messageChat.content}.gif',
                width: 100,
                height: 100,
                fit: BoxFit.cover,),
                margin: EdgeInsets.only(bottom: isLastMessageRight(index)?10:20,right: 10),
              ),
          ],
          mainAxisAlignment: MainAxisAlignment.end,
          );
      }else{
        return Container(
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    isLastMessageLeft(index)?
                    Material(
                      child: Image.network(peerAvtar,
                      loadingBuilder: (BuildContext context,Widget child,ImageChunkEvent? loadingProgress){
                        if(loadingProgress==null)return child;
                        return  Center(
                          child: CircularProgressIndicator(
                            color: Colors.blue,
                            value: loadingProgress.expectedTotalBytes !=null && loadingProgress.expectedTotalBytes !=null ? loadingProgress.cumulativeBytesLoaded/loadingProgress.expectedTotalBytes!:null,
                          ),
                        );
                      },errorBuilder: (context,object,stackTrace){
                      return   Icon(
                        Icons.account_circle,
                        size: 35,
                        color: Colors.grey[50],
                      );
                      
                      
                      },
                      width: 35,
                      height: 35,
                      fit: BoxFit.cover,
                      ),
                        borderRadius: BorderRadius.all(Radius.circular(18)),
                    clipBehavior: Clip.hardEdge,
                    ): Container(
                      width: 35,

                    ),
                    messageChat.type==TypeMessage.text ? 
                    Container(
                      child: Text(messageChat.content,style:TextStyle(color:Colors.white,fontWeight: FontWeight.bold),
                      ),
                      padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                      width:200,
                      decoration: BoxDecoration(
                        color: Colors.red,borderRadius: BorderRadius.circular(8)
                      ),
                      margin: EdgeInsets.only(left: 10),

                    ):messageChat.type==TypeMessage.image ?
                        Container(
                child:TextButton(
                  child: Material(
                    child: Image.network(messageChat.content,
                    loadingBuilder: (BuildContext context ,Widget child,ImageChunkEvent? loadingProgress )
                    {
                      if(loadingProgress ==null)return child;
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(8), 
                        ),
                        width: 200,
                        height: 200,
                        child: Center(
                          child: CircularProgressIndicator(
                            color: Colors.blue,
                            value: loadingProgress.expectedTotalBytes !=null && loadingProgress.expectedTotalBytes !=null ? loadingProgress.cumulativeBytesLoaded/loadingProgress.expectedTotalBytes!:null,
                          ),
                        ),
                      );
                    },
                    errorBuilder: (context,object,stackTrace) => Material(
                          child: Image.asset('assets/images/img_not_available.jpeg',
                          width: 200,
                          height: 200,
                          fit: BoxFit.cover,),
                          borderRadius: BorderRadius.all(Radius.circular(8)
                          ),
                          clipBehavior: Clip.hardEdge,                    ),
                    width: 200,
                    height: 200,
                    fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    clipBehavior: Clip.hardEdge,
                  ),
                   onPressed: (){
                        Navigator.push(context,MaterialPageRoute(builder:(context)=>FullPhoto(url: messageChat.content)));
                   },
                   style:ButtonStyle(padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(0))),
                  ),
                  margin: EdgeInsets.only(bottom: isLastMessageRight(index)?20:10 ,right: 10),
              ):Container(
                    child: Image.asset('assets/images/${messageChat.content}.gif',
                width: 100,
                height: 100,
                fit: BoxFit.cover,),
                                margin: EdgeInsets.only(bottom: isLastMessageRight(index)?10:20,right: 10),

              ),
                  ],
                ),
                isLastMessageLeft(index)?
                Container(
                  child: Text(
                    DateFormat('dd MMM yyyy, hh:mm a').format(DateTime.fromMillisecondsSinceEpoch(int.parse(messageChat.timestamp))),
                    style: TextStyle(color: Colors.grey,fontSize: 12,fontStyle: FontStyle.italic),
                    
                    ),
                    margin:EdgeInsets.only(left:50,bottom: 5,top: 5 )
                ):SizedBox.shrink(),
              ],
              crossAxisAlignment: CrossAxisAlignment.start,
            ),
            margin: EdgeInsets.only(bottom: 10),
        );
      }

    }else{
      return SizedBox.shrink();
    }
  }

  Widget buildListMessage(){
    return Flexible(
      child: groupChatId.isNotEmpty ? StreamBuilder<QuerySnapshot>(
        stream: chatProvider.getChatStream(groupChatId, _limit),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if(snapshot.hasData){
            listMessage.addAll(snapshot.data!.docs);
            
            return ListView.builder(
              padding: EdgeInsets.all(10),
              itemBuilder: (context,index)=>buildItem(index,snapshot.data?.docs[index]),
              itemCount: snapshot.data?.docs.length,
              reverse: true,
              controller: listScrollController,
              
              );
          }else{
            return Center(
              child: CircularProgressIndicator(color: Colors.blue,),
            );
          }
        },
        ) :Center(
                        child: CircularProgressIndicator(color: Colors.blue,),

        ),
      );


  }
}