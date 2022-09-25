import 'package:flutter/material.dart';
import 'package:git_project/models/kerjakan_soal_list.dart';
import 'package:git_project/models/network_response/network_responses.dart';
import 'package:git_project/repository/latihan_soal_api.dart';

class KerjakanSoalListProvider with ChangeNotifier {
  KerjakanSoalList? kerjakanSoalList;

  getDaftarSoalList(id) async {
    final daftarSoalResult = await LatihanSoalAPI().postKerjakanSoal(id);

    if (daftarSoalResult.status == Status.success) {
      kerjakanSoalList = KerjakanSoalList.fromJson(daftarSoalResult.data!);
      notifyListeners();
    }
  }

  @override
  void dispose() {
    kerjakanSoalList;
    super.dispose();
  }
}