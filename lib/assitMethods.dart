import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:share_food/address.dart';
import 'package:share_food/requestAssist.dart';

import 'package:share_food/datahandler/appdata.dart';
import 'package:share_food/directionDetails.dart';

class assistMedhods{
   static Future <String> searchCoordinateAddress(Position position,context)async{
        String placeAddress="";
        String st1,st2,st3,st4;
        String url ="https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=AIzaSyD4l1-2jyBsPnBlxECMJ-LkZDDa-VIcgjg";

        var response =await  RequestAssist.getRequest(url);
        if( response != "Failed"){
            // placeAddress =response["results"][0]["formatted_address"];
             st1 =response["results"][0]["address_components"][3]["short_name"];
             st2 =response["results"][0]["address_components"][4]["short_name"];
             st3 =response["results"][0]["address_components"][5]["short_name"];
             st4 =response["results"][0]["address_components"][6]["short_name"];
             placeAddress =st1 + ", " + st2 + ", " + st3 + ", " + st4;
            Address userAddress =new Address(placeFormatAddress: "", placeId: "", placeName: "", latitude: 0, longitude: 0);
            userAddress.latitude =position.latitude;
            userAddress.longitude =position.longitude;
            userAddress.placeName =placeAddress;
            Provider .of<AppData>(context,listen: false).updateUserAddress(userAddress);
        }

        return placeAddress;
   }
   static Future<DirectionDetails?> obtainDirections(LatLng initialPosition,LatLng finalPosition)async{
      String directionUrl="https://maps.googleapis.com/maps/api/directions/json?destination=${finalPosition.latitude},${finalPosition.longitude}&origin=${initialPosition.latitude},${initialPosition.longitude}&key=AIzaSyD4l1-2jyBsPnBlxECMJ-LkZDDa-VIcgjg";
 
      var res =await RequestAssist.getRequest(directionUrl);
      if(res =="failed"){
        return null;
      }
      DirectionDetails directionDetails =DirectionDetails(distanceText: "", distanceValue: 0, durationText: "", durationValue: 0, encodedPoints: "");
      directionDetails.encodedPoints=res["routes"][0]["overview_polyline"]["points"];

      directionDetails.distanceText=res["routes"][0]["legs"][0]["distance"]["text"];
      directionDetails.distanceValue=res["routes"][0]["legs"][0]["distance"]["value"];

      directionDetails.durationText=res["routes"][0]["legs"][0]["duration"]["text"];
      directionDetails.durationValue=res["routes"][0]["legs"][0]["duration"]["value"];

      return directionDetails;

    }
   
}