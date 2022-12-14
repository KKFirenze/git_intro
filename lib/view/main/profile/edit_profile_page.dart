import 'package:flutter/material.dart';

import 'package:git_project/constants/r.dart';
import 'package:git_project/helpers/preference_helpers.dart';
import 'package:git_project/helpers/user_helpers.dart';
import 'package:git_project/models/network_response/network_responses.dart';
import 'package:git_project/models/user_by_email.dart';
import 'package:git_project/providers/user_provider.dart';
import 'package:git_project/repository/auth_api.dart';
import 'package:git_project/widgets/gender_field_select.dart';
import 'package:git_project/widgets/login_button.dart';
import 'package:provider/provider.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  List<String> allKelasSLTA = ['10', '11', '12'];
  List<String> allGender = ['Laki-laki', 'Perempuan'];

  String? selectedKelas;
  UserProvider? userProvider;

  @override
  void initState() {
    userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider!.getUserData();
    userProvider!.initDataUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: R.colors.primary,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Edit Akun',
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child:
              Consumer<UserProvider>(builder: (context, userProvider, child) {
            return LoginButton(
              radius: 8,
              backgroundColor: R.colors.primary,
              borderColor: R.colors.primary,
              child: Text(
                R.strings.perbaharuiAkun,
                style:
                    const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              onTap: () async {
                final jsonDataUser = {
                  'email': userProvider.emailController.text,
                  'nama_lengkap': userProvider.fullNameController.text,
                  'nama_sekolah': userProvider.schoolNameController.text,
                  'gender': userProvider.gender,
                  'kelas': selectedKelas ?? userProvider.kelas,
                  'foto': UserHelpers.getUserPhotoURL(),
                };

                print(jsonDataUser);

                // Post data user ke API
                final result = await AuthAPI().postUpdateUser(jsonDataUser);

                if (result.status == Status.success) {
                  // Cek apakah statusnya == 1 sesuai response API?
                  final registerResult =
                      UserByEmail.fromJson(result.data ?? {});

                  if (registerResult.status == 1) {
                    // Simpan ke local data user yang telah register
                    await PreferenceHelpers().setUserData(registerResult.data!);

                    // diisi true biar bisa ditangkep data yg berubah disini ke page yg dituju
                    Navigator.pop(context, true);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          registerResult.message ?? '',
                        ),
                      ),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        R.strings.pesanErrorRegisText,
                      ),
                    ),
                  );
                }
              },
            );
          }),
        ),
      ),
      body: userProvider?.user == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Consumer<UserProvider>(
                    builder: (context, userProvider, child) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Data Diri',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildEditProfileTextField(
                        controller: userProvider.fullNameController,
                        hintText: 'Nama Lengkap',
                        labelText: 'Nama Lengkap',
                      ),
                      _buildEditProfileTextField(
                        controller: userProvider.emailController,
                        labelText: 'Email',
                        hintText: 'hatchibee@gmail.com',
                      ),
                      Row(
                        children: [
                          GenderFieldSelect(
                            gender: 'Laki-Laki',
                            onPressed: () {
                              userProvider.onTapGender(Gender.lakiLaki);
                            },
                            bgColor: userProvider.gender == 'Laki-laki'
                                ? R.colors.primary
                                : Colors.white,
                            textColor: userProvider.gender == 'Laki-laki'
                                ? Colors.white
                                : R.colors.blackLabelText,
                          ),
                          GenderFieldSelect(
                            gender: 'Perempuan',
                            onPressed: () {
                              userProvider.onTapGender(Gender.perempuan);
                            },
                            bgColor: userProvider.gender == 'Perempuan'
                                ? Colors.pink.shade600
                                : Colors.white,
                            textColor: userProvider.gender == 'Perempuan'
                                ? Colors.white
                                : R.colors.blackLabelText,
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      _buildDropDownForm(
                        labelText: 'Kelas',
                        data: allKelasSLTA,
                        value: userProvider.kelas ?? '',
                      ),
                      const SizedBox(height: 20),
                      _buildEditProfileTextField(
                        controller: userProvider.schoolNameController,
                        labelText: 'Sekolah',
                      ),
                    ],
                  );
                }),
              ),
            ),
    );
  }

  Column _buildDropDownForm({
    required String labelText,
    String? hintText,
    required List<String> data,
    required String value,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: TextStyle(
            color: R.colors.greyText,
          ),
        ),
        const SizedBox(height: 5),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: const BoxDecoration(
            border: BorderDirectional(
              bottom: BorderSide(
                color: Colors.grey,
                width: 1,
              ),
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              icon: Icon(Icons.keyboard_arrow_down,
                  color: R.colors.blackLabelText),
              hint: Text(
                hintText ?? '',
                style: TextStyle(
                  color: R.colors.greyHintText,
                ),
              ),
              value: selectedKelas ?? value,
              items: data
                  .map(
                    (value) => DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    ),
                  )
                  .toList(),
              onChanged: (newValue) {
                setState(() {
                  selectedKelas = newValue;
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Column _buildEditProfileTextField(
      {required String labelText,
      String? hintText,
      required TextEditingController controller}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: TextStyle(
            color: R.colors.greyText,
          ),
        ),
        TextField(
          controller: controller,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            hintText: hintText,
            focusColor: R.colors.primary,
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
