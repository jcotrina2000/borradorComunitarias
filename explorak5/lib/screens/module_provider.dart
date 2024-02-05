import 'package:explorak5/models/modules.dart';
import 'package:flutter/foundation.dart';

class ModuleProvider extends ChangeNotifier {
  static Map<String, List<Modules>> _modules = {"modules": []};
  Map<String, List<Modules>> get assignments => _modules;

  void setModulesResult(Map<String, List<Modules>> _results) {
    _modules["modules"] = _results["modules"]!;
    notifyListeners();
  }

  static List<Modules> get modules => _modules["modules"]!;

  void updateList(int modId) {
    Modules moduleEnviado =
        _modules["modules"]!.firstWhere((mod) => mod.id == modId);
      _modules["modules"]!.removeWhere((mod) => mod.id == modId);
      _modules["modules"]!.add(moduleEnviado);
    notifyListeners();
  }
}
