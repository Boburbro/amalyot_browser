// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:get/get.dart';
import 'package:hive/hive.dart';

import '../models/web_model.dart';

class HiveService extends GetxController {
  final sql = Hive.box('mydata');

  List<WebModel> getList() {
    List _list = sql.get(1) ?? [];

    return [
      ..._list.map(
        (e) => WebModel(
            id: e['id'].toString(),
            title: e['title'].toString(),
            url: e['url'].toString()),
      )
    ];
  }

  WebModel getWeb(String id) {
    List<WebModel> _list = getList();
    return _list.firstWhere((element) => element.id == id);
  }

  void addNew(WebModel webModel) {
    List _list = sql.get(1) ?? [];
    _list.add({
      "id": webModel.id,
      "title": webModel.title,
      "url": webModel.url,
    });
    sql.put(1, _list);
  }

  void delete(String id) {
    List _list = sql.get(1) ?? [];

    _list.removeWhere((element) => element['id'] == id);
    sql.put(1, _list);

    _list.obs();
  }

  void updateWeb(WebModel web) {
    List _list = sql.get(1) ?? [];
    int index = _list.indexWhere((element) => element['id'] == web.id);

    _list[index] = {"id": web.id, 'title': web.title, 'url': web.url};
    sql.put(1, _list);
  }
}
