

import 'package:flutter/cupertino.dart';

import 'package:share_food/address.dart';
class AppData extends ChangeNotifier
{
    Address? location,searchLocation; 
    
    void updateUserAddress(Address? updateLocation)
    {
      location =updateLocation!;
      notifyListeners();
    }

    void updateUserSearchAddress(Address? updateSearchLocation)
    {
      searchLocation=updateSearchLocation!;
      notifyListeners();
    }
    
    
} 