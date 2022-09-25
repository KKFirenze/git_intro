import 'package:flutter/material.dart';
import 'package:git_project/models/mapel_list.dart';
import 'package:git_project/models/network_response/network_responses.dart';
import 'package:git_project/repository/latihan_soal_api.dart';

class MapelProvider extends ChangeNotifier {
  MapelList? mapelList;

  getMapel() async {
    final mapelResult = await LatihanSoalAPI().getMapel();

    if (mapelResult.status == Status.success) {
      mapelList = MapelList.fromJson(mapelResult.data!);
      notifyListeners();
    }
  }
}
