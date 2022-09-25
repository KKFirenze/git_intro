import 'package:flutter/material.dart';
import 'package:git_project/models/banner_list.dart';
import 'package:git_project/models/network_response/network_responses.dart';
import 'package:git_project/repository/latihan_soal_api.dart';

class BannerProvider extends ChangeNotifier {
  BannerList? bannerList;

  getBanner() async {
    final bannerResult = await LatihanSoalAPI().getBanner();

    if (bannerResult.status == Status.success) {
      bannerList = BannerList.fromJson(bannerResult.data!);
      notifyListeners();
    }
  }
}
