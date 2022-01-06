import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import 'package:share_food/Firestore_Const.dart';
import 'package:share_food/popupChoices.dart';
import 'package:share_food/services/setting_provider.dart';
import 'dart:ui' as ui;
import 'package:share/share.dart';

import 'package:url_launcher/url_launcher.dart';

class Posts extends StatefulWidget {


  @override
  _PostsState createState() => _PostsState();
}

class _PostsState extends State<Posts> {
  final double _borderRadius = 24;
  final number='';

  Widget _buildGrid(QuerySnapshot? snapshot){
    return  ListView.builder(
      itemCount: snapshot!.docs.length,
      itemBuilder: (context,index){
        final doc= snapshot.docs[index];
      
      return Padding(
        padding:  EdgeInsets.only(top:90),
        child: Center(
          child: Padding(
            padding: EdgeInsets.only(top:0,left: 10,right: 10,bottom: 0),
            child:Stack(
              children: <Widget>[
                Container(
                  height: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(_borderRadius),
                    gradient: LinearGradient(
                      colors:[Colors.pink,Colors.red],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [BoxShadow(
                      color: Colors.red,
                      blurRadius: 12,
                      offset: Offset(0,6),          
                      )
                    ]
                  ),
                ),
                Positioned(
                        right: 0,
                        bottom: 0,
                        top: 0,
                        child: CustomPaint(
                          size: Size(100, 150),
                          painter: CustomCardShapePainter(_borderRadius,
                              Colors.pink,Colors.red),
                        ),
                      ),
                Positioned.fill(
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Image.asset("assets/image/donate.png", height: 64,width: 64,),
                        flex: 2,
                        ),
                      Expanded(
                        flex: 4,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            
                            Text(doc["name"],
                            style: TextStyle(
                              color: Colors.white,fontWeight: FontWeight.w700,fontSize: 20
                            ),
                            ),
                            SizedBox(height: 3,),
                            IconButton(
                              onPressed: (){
              _callNumber();
            }, 
                              icon: Icon(Icons.phone_android,color: Colors.white,size: 16,)
                              ),
                            Text(doc["mobile"],
                            style: TextStyle(
                              color: Colors.white,fontWeight: FontWeight.w700,
                            ),
                            ),
                            SizedBox(height:17),
    
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  Icon(Icons.location_on,color:Colors.white,size:16),
                                  SizedBox(width: 8,),
                                  Text(doc["address"],
                                  style: TextStyle(
                                    color: Colors.white,fontWeight: FontWeight.w700,
                                  ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        
                      ),
                      Expanded(
                        flex: 2,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Icon(Icons.dinner_dining,
                            color: Colors.white,),
                            Text(doc["items"],style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,fontSize: 15
                            ),),
                            
                          ],
                        ),
                      ),
                
                    ],
                  ),
                )
              
              ],
            ),
            ),
        ),
      );
  }
    );
                   
  }
  void  _callPhoneNumber(String callPhoneNumber)async{
   var url ='tel:// $callPhoneNumber';  
   if(await canLaunch(url)){
     await launch(url);
   }else{
     throw 'Error occurred';
   }
} 
    List<PopupChoices> choices =<PopupChoices>[
PopupChoices(title: 'Share', icon:Icons. share),

  ];
  void onItemMenuPress(PopupChoices choice)
{
  if(choice.title =="Share"){

   

  }
}
void onSelected(BuildContext context,int item)async{
  switch(item){
    case 0:
    final url ='https://mega.nz/file/aaBFhYbJ#SmwbChs7aB_Pgy2vlT_IZwa1d_9g1jUimeEd5jiAGdM';
     await Share.share('Download Our App💗\n\n$url');
  }
}
  @override
  Widget build(BuildContext context) {
    Size size=MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white, size: 10.0),
        backgroundColor: Colors.transparent,
        toolbarHeight:80,
    actions: [
       Row(
        children: [
          Title(color: Colors.white, child: Text("Share Food/Requests",style: TextStyle(color: Colors.amber,fontSize: 15,fontWeight: FontWeight.bold),)),
        
       Column(
         children: [
           Padding(
            padding: EdgeInsets.only(right: 130,top:20),
            child: IconButton(
              icon: Image.asset('assets/image/app_icon.png',height: 104,width: 94,),
              
              onPressed: () {},
            ),
      
            
      ),
         ],
       ),
        ],
      ),
      PopupMenuButton<int>(
        onSelected:(item)async{onSelected(context,item);
        },
        itemBuilder: (context)=>[
          PopupMenuItem<int>(
            value: 0,
            child: Row(
              children: [ 
                Icon(Icons.share),
                Column(
                  children:[
                    Text("Share")
                  ]
                )
              ],
            )
            )
        ]
        )
    ]),
      backgroundColor:Colors.black,
      body: Stack(
        children: <Widget>[
        
           
                
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance.collection("Donations").snapshots(),
                    builder:(context,snapshot){
                      if(!snapshot.hasData) return LinearProgressIndicator();
                      return Container(
                        child: _buildGrid(snapshot.data)
                        );
                    } ,
                     
                  ),
                   
                
        ],
      )
      
    );
  }
}

class CustomCardShapePainter extends CustomPainter {
  final double radius;
  final Color startColor;
  final Color endColor;

  CustomCardShapePainter(this.radius, this.startColor, this.endColor);

  @override
  void paint(Canvas canvas, Size size) {
    var radius = 24.0;

    var paint = Paint();
    paint.shader = ui.Gradient.linear(
        Offset(0, 0), Offset(size.width, size.height), [
      HSLColor.fromColor(startColor).withLightness(0.8).toColor(),
      endColor
    ]);

    var path = Path()
      ..moveTo(0, size.height)
      ..lineTo(size.width - radius, size.height)
      ..quadraticBezierTo(
          size.width, size.height, size.width, size.height - radius)
      ..lineTo(size.width, radius)
      ..quadraticBezierTo(size.width, 0, size.width - radius, 0)
      ..lineTo(size.width - 1.5 * radius, 0)
      ..quadraticBezierTo(-radius, 2 * radius, 0, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}


  void _callNumber() async {
    String phoneNumber="";
    String url = "tel://" + phoneNumber;
    if (await canLaunch(url)) {
    await launch(url);
    } else {
    throw 'Could not call $phoneNumber';
    }
  }
 
