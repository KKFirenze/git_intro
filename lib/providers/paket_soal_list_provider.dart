import 'package:flutter/cupertino.dart';
import 'package:git_project/models/network_response/network_responses.dart';
import 'package:git_project/models/paket_soal_list.dart';
import 'package:git_project/repository/latihan_soal_api.dart';

class PaketSoalListProvider extends ChangeNotifier {
  PaketSoalList? paketSoalList;

  getPaketSoal(String id) async {
    final mapelResult = await LatihanSoalAPI().getPaketSoal(id);

    if (mapelResult.status == Status.success) {
      paketSoalList = PaketSoalList.fromJson(mapelResult.data!);
      notifyListeners();
    }
  }

  @override
  void dispose() {
    paketSoalList;
    super.dispose();
  }
}
