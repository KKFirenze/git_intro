import 'package:flutter/material.dart';
import 'package:git_project/constants/r.dart';
import 'package:git_project/providers/mapel_provider.dart';
import 'package:git_project/view/main/latihan_soal/paket_soal_page.dart';
import 'package:git_project/widgets/mapel.dart';
import 'package:provider/provider.dart';

class MapelPage extends StatelessWidget {
  const MapelPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final MapelProvider mapelProvider =
        Provider.of<MapelProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(R.strings.pilihPelajaranText),
      ),
      body: mapelProvider.mapelList == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Consumer<MapelProvider>(builder: (context, mapelProvider, child) {
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                child: ListView.builder(
                  itemCount: mapelProvider.mapelList!.data!.length,
                  itemBuilder: (context, index) {
                    final currentMapel = mapelProvider.mapelList!.data![index];

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                PaketSoalPage(id: currentMapel.courseId!),
                          ),
                        );
                      },
                      child: MapelWidget(
                        totalDone: currentMapel.jumlahDone ?? 0,
                        totalPacket: currentMapel.jumlahMateri ?? 0,
                        title: currentMapel.courseName ?? '',
                      ),
                    );
                  },
                ),
              );
            }),
    );
  }
}
