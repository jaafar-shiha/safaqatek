import 'package:flutter/material.dart';
import 'package:safaqtek/constants/app_colors.dart';

class MainScaffold extends StatefulWidget {
  final Widget body;

  const MainScaffold({Key? key, required this.body}) : super(key: key);

  @override
  _MainScaffoldState createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {

  @override
  Widget build(BuildContext context) {

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.dirtyPurple,
            AppColors.royalFuchsia,
            AppColors.royalFuchsia,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: widget.body,
      ),
    );
  }
}
