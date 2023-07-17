import 'package:flutter/material.dart';
import 'package:purrfect/views/buyers/nav_screens/widgets/banner_widget.dart';
import 'package:purrfect/views/buyers/nav_screens/widgets/category_text.dart';
import 'package:purrfect/views/buyers/nav_screens/widgets/search_input_widget.dart';
import 'package:purrfect/views/buyers/nav_screens/widgets/welcome_text_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start ,
      children: [
        WelcomeText(),

          SizedBox(
            height: 10,
            ),

          SearchInputWidget(),

          BannerWidget(),

          CategoryText(),
      ],
    );
  }
}

