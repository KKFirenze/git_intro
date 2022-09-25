import 'package:flutter/cupertino.dart';
import 'package:git_project/models/latihan_soal_skor.dart';
import 'package:git_project/models/network_response/network_responses.dart';
import 'package:git_project/repository/latihan_soal_api.dart';

class LatihanSoalSkorProvider extends ChangeNotifier {
  LatihanSoalSkor? latihanSoalSkorData;

  getResultLatihanSoal(id) async {
    final result = await LatihanSoalAPI().getScoreResult(id);

    if (result.status == Status.success) {
      latihanSoalSkorData = LatihanSoalSkor.fromJson(result.data!);
      notifyListeners();
    }
  }
}
