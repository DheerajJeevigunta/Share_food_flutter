

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_food/address.dart';
import 'package:share_food/requestAssist.dart';
import 'package:share_food/divider.dart';
import 'package:share_food/models/placePredictions.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';


import 'datahandler/appdata.dart';
class searchScreen extends StatefulWidget {
  const searchScreen({ Key? key }) : super(key: key);

  @override
  _searchScreenState createState() => _searchScreenState();
}

class _searchScreenState extends State<searchScreen> {
  TextEditingController yourlocationtextEditingController=TextEditingController();
  TextEditingController nearbytextEditingController=TextEditingController();
  List<PlacePredictions> placePredictionsList=[],placePredictionsList1=[];
  @override
  Widget build(BuildContext context) {

    String placeAddress = Provider.of<AppData>(context).location!.placeName  ;
    yourlocationtextEditingController.text=placeAddress;
    return Scaffold(
       body: SingleChildScrollView(
         child: Column(
           children:<Widget>[
             Container(
               height: 215,
               decoration: BoxDecoration(color: Colors.white,
               boxShadow: [
                 BoxShadow(color:Colors.black,blurRadius: 6.0,
                 spreadRadius: 0.5,
                 offset: Offset(0.7,0.7),
                  ),
                 ]
               ),
               child: Padding(
                 padding: EdgeInsets.only(left:25,top: 30,right: 25,bottom: 20),
                 child: Column(
                   children: <Widget>[
                     SizedBox(height: 5,),
                     Stack(
                       children: <Widget>[
                         GestureDetector(
                           onTap: (){
                             Navigator.pop(context);
                           },
                           child: Icon(
                             Icons.arrow_back
                             ),
                         ),
                         Center(
                           child: Text("",style: TextStyle(fontSize: 18,fontFamily:  "Brand-Bold"),),
                         ),
                       ],
                     ),
                     SizedBox(height:16.0),
                     Row(
                       children: <Widget>[
                         Image.asset("assets/images/location.png",height: 16.0,width: 16.0,),
                         SizedBox(width: 18.0,),
                         Expanded(child: Container(
                           decoration: BoxDecoration(
                             color: Colors.black38,
                             borderRadius: BorderRadius.circular(5),
       
                           ),
                           child: Padding(
                             padding: EdgeInsets.all(3.0),
                             child: TextField(
                               controller: yourlocationtextEditingController,
                               decoration: InputDecoration(
                                 hintText: 'Your Location',
                                 fillColor: Colors.grey[200],filled: true,
                                 border:InputBorder.none,
                                 contentPadding: EdgeInsets.only(left: 11.0,top: 8.0,bottom: 8.0),
       
                               ),
                             ),
                           ),
                         ),)
                       ],
                     ),
                     SizedBox(height:10.0),
                     Row(
                       children: <Widget>[
                         Image.asset("assets/images/nearby.png",height: 16.0,width: 16.0,),
                         SizedBox(width: 18.0,),
                         Expanded(child: Container(
                           decoration: BoxDecoration(
                             color: Colors.black38,
                             borderRadius: BorderRadius.circular(5),
       
                           ),
                           child: Padding(
                             padding: EdgeInsets.all(3.0),
                             child: TextField(
                               onChanged: (val){
                                 findPlace(val);
                                 findNear(val,val,val);
                               },
                               controller: nearbytextEditingController,
                               decoration: InputDecoration(
                                 hintText: 'Nearby ngos & orphanages',
                                 fillColor: Colors.grey[200],filled: true,
                                 border:InputBorder.none,
                                 contentPadding: EdgeInsets.only(left: 11.0,top: 8.0,bottom: 8.0),
       
                               ),
                             ),
                           ),
                         ),)
                       ],
                     ),
                   ],
                 ),
               ),
             ), 
           //tile for displaying predictions
           SizedBox(height: 10,),
            (placePredictionsList1.length>0)? 
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8,horizontal: 16),
              child:ListView.separated(
                padding: EdgeInsets.all(0),
                itemBuilder: (context,index){
                  return PredictionTile(placePredictions: placePredictionsList1[index],);
                }, 
                separatorBuilder: (BuildContext context,int index)=>DividerWidget(),
                 itemCount: placePredictionsList1.length,
                 shrinkWrap: true,
                 physics: ClampingScrollPhysics(),
                 )
              )
              :(placePredictionsList.length>0)?
              Padding(
              padding: EdgeInsets.symmetric(vertical: 8,horizontal: 16),
              child:ListView.separated(
                padding: EdgeInsets.all(0),
                itemBuilder: (context,index){
                  return PredictionTile(placePredictions: placePredictionsList[index],);
                }, 
                separatorBuilder: (BuildContext context,int index)=>DividerWidget(),
                 itemCount: placePredictionsList.length,
                 shrinkWrap: true,
                 physics: ClampingScrollPhysics(),
                 )
              )
              
              :Container()
       
            
           
           ]
         ),
       ),
      
    );
  }
  void findPlace(String placeName)async{
    if(placeName.length>1){
      String autoCompleteUrl="https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$placeName&key=AIzaSyD4l1-2jyBsPnBlxECMJ-LkZDDa-VIcgjg&sessiontoken=1234567890&components=country:in&radius=5000"; 
    
     var res =await RequestAssist.getRequest(autoCompleteUrl);
      if( res=="failed"){
        return;
      }
      if(res["status"]=="OK"){
        var predictinos =res["predictions"];

        var placesList=(predictinos as List).map((e)=>PlacePredictions.fromJson(e)).toList();
        setState(() {
          placePredictionsList=placesList; 
        });
      }
    }
  }
    void findNear(String type,String place ,String keywrd)async{
    if(type.length>1){
      String queryCompleteUrl="https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=$place&radius=1500&type=$type&keyword=$keywrd&key=AIzaSyD4l1-2jyBsPnBlxECMJ-LkZDDa-VIcgjg"; 
     place = Provider.of<AppData>(context,listen:false).location!.placeName  ;
     var res =await RequestAssist.getRequest(queryCompleteUrl);
      if( res=="failed"){
        return;
      }
      if(res["status"]=="OK"){
        var predictinos =res["predictions"];

        var placesList=(predictinos as List).map((e)=>PlacePredictions.fromJson(e)).toList();
        setState(() {
          placePredictionsList1=placesList; 
        });
      }
    }
  }
}

class PredictionTile extends StatelessWidget {
  final PlacePredictions placePredictions;
  const PredictionTile({ Key? key,required this.placePredictions }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      padding :EdgeInsets.all(0),
      onPressed: (){
        getPlaceDetails(placePredictions.place_id , context);
      },
      child: Container(
        child: Column(
          children: <Widget>[
            SizedBox(width: 10,),
             Row(
            children: <Widget>[
              Icon(Icons.add_location),
              SizedBox(width: 14.0,),
              Expanded(
                child: Column(
                   crossAxisAlignment:CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 8,),
                   Text(placePredictions.main_text,overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 16.0),),
                   SizedBox(height: 8,),
                  Text(placePredictions.secondary_text,overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 13,color: Colors.grey),),
                  SizedBox(height: 8,),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(width: 10,),
          ],
        ),
        
      ),
    );

    
  }
   getPlaceDetails(String placeId,context)async
  {
   
    
  {

    String placeDetailsUrl="https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=AIzaSyD4l1-2jyBsPnBlxECMJ-LkZDDa-VIcgjg";
    var res =await RequestAssist.getRequest(placeDetailsUrl);
    

    if(res=="failed"){
      return;
    }
    if(res["status"]=="OK"){
      Address address=Address(placeFormatAddress: "", placeId: "", placeName: "", latitude: 0, longitude: 0);
      address.placeName=res["result"]["name"];
      address.placeId=placeId;
      address.latitude=res ["result"]["geometry"]["location"]["lat"];
      address.longitude=res ["result"]["geometry"]["location"]["lng"];

      Provider.of<AppData>(context,listen: false).updateUserSearchAddress(address);
      print("This is Searched Location ::");
      print(address.placeName); 

       Navigator.pop(context,"obtainDirection");
    }
  }
}

}