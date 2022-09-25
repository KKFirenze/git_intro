import 'package:flutter/material.dart';
import 'package:git_project/constants/r.dart';
import 'package:git_project/view/main/latihan_soal/home_page.dart';
import 'package:git_project/view/main/profile/profile_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final _pageController = PageController();

  int index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, R.appRoutesTO.chatpage);
        },
        child: Stack(
          children: [
            Positioned(
                top: 12,
                left: 7.5,
                child: Image.asset(R.assets.icDiscuss, height: 45)),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _buildBottomNavigation(context),
      // INI DIPAKE BIAR BISA 1 Page banyak tampilan
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: const [
          HomePage(),
          ProfilePage(),
        ],
      ),
    );
  }

  Container _buildBottomNavigation(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
            // topLeft: Radius.circular(20),
            // topRight: Radius.circular(20),
            ),
        child: BottomAppBar(
          color: Colors.white,
          child: SizedBox(
            height: 60,
            child: Row(
              children: [
                BottomNavigationMainMenuButton(
                  title: 'Home',
                  child: Image.asset(
                    index == 0 ? R.assets.icHome : R.assets.icHomeUnActive,
                    height: 20,
                  ),
                  onTap: () {
                    index = 0;
                    _pageController.animateToPage(index,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut);
                    setState(() {});
                  },
                ),
                BottomNavigationMainMenuButton(
                    title: 'Diskusi',
                    onTap: () {
                      Navigator.pushNamed(context, R.appRoutesTO.chatpage);
                    }),
                BottomNavigationMainMenuButton(
                  title: 'Profile',
                  child: Image.asset(
                    index == 1
                        ? R.assets.icProfile
                        : R.assets.icProfileUnActive,
                    height: 20,
                  ),
                  onTap: () {
                    index = 1;
                    _pageController.animateToPage(index,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut);
                    setState(() {});
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class BottomNavigationMainMenuButton extends StatelessWidget {
  final String title;
  final Widget? child;
  final Function()? onTap;

  const BottomNavigationMainMenuButton({
    Key? key,
    required this.title,
    this.child,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: child == null ? null : onTap,
            child: Column(
              children: [
                child ?? Container(height: 20),
                Text(title),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
