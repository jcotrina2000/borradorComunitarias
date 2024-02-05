import 'package:explorak5/models/pages.dart';
import 'package:flutter/foundation.dart';

class PageProvider extends ChangeNotifier {
  static Map<String, List<Pages>> _modules = {"modules": []};
  Map<String, List<Pages>> get assignments => _modules;

  void setModulesResult(Map<String, List<Pages>> _results) {
    _modules["modules"] = _results["modules"]!;
    notifyListeners();
  }

  static List<Pages> get modules => _modules["modules"]!;

  void updateList(int modId) {
    Pages moduleEnviado =
        _modules["modules"]!.firstWhere((mod) => mod.id == modId);

      _modules["modules"]!.removeWhere((mod) => mod.id == modId);
      _modules["modules"]!.add(moduleEnviado);
    notifyListeners();
  }
}
