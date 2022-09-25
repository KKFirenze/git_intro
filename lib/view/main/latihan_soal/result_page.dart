import 'package:flutter/material.dart';

import 'package:git_project/constants/r.dart';
import 'package:git_project/providers/latihan_soal_skor_provider.dart';
import 'package:provider/provider.dart';

class ResultScreen extends StatefulWidget {
  final String? id;

  const ResultScreen({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  LatihanSoalSkorProvider? latihanSoalSkorProvider;

  @override
  void initState() {
    super.initState();
    latihanSoalSkorProvider =
        Provider.of<LatihanSoalSkorProvider>(context, listen: false);
    latihanSoalSkorProvider!.getResultLatihanSoal(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Consumer<LatihanSoalSkorProvider>(
      builder: (context, latihanSoalSkorProvider, child) =>
          latihanSoalSkorProvider.latihanSoalSkorData == null
              ? Scaffold(
                  backgroundColor: R.colors.primary,
                  body: const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  ),
                )
              : Scaffold(
                  appBar: AppBar(
                    elevation: 0,
                    leading: IconButton(
                      onPressed: () {
                        Navigator.pop(context, true);
                        Navigator.pop(context, true);
                      },
                      icon: const Icon(
                        Icons.close,
                      ),
                    ),
                    title: const Text('Tutup'),
                  ),
                  body: Container(
                    width: width,
                    height: height,
                    color: R.colors.primary,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 50),
                          Text(
                            R.strings.selamatText,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                            ),
                          ),
                          Text(
                            R.strings.congratsResultText,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(height: 30),
                          Image.asset(R.assets.icResult,
                              height: 200, width: 200),
                          const SizedBox(height: 25),
                          Text(
                            R.strings.nilaiKamuText,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                            ),
                          ),
                          Consumer<LatihanSoalSkorProvider>(builder:
                              (context, latihanSoalSkorProvider, child) {
                            return Text(
                              '${latihanSoalSkorProvider.latihanSoalSkorData!.data!.result?.jumlahScore}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 100,
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                ),
    );
  }
}
