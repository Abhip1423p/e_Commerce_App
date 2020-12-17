
import 'package:flutter/foundation.dart';


class AddressChanger extends ChangeNotifier{



    //counter for number of address
  int _counter = 0;
  int get counter => _counter;
  displayResult(int v)
  {
  _counter =v;
  notifyListeners();
  }

  }
