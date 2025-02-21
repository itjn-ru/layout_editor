

import 'package:flutter/material.dart';

class ActiveWidgetProvider extends ChangeNotifier {
 Key _activeKey=UniqueKey();

Key get activeKey=>_activeKey;
set activeKey(Key value){
  _activeKey=value;
  notifyListeners();
}

}
