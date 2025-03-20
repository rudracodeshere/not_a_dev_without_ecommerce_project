import 'package:e_commerce_project/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';

class GenderAgePage extends StatefulWidget {
  const GenderAgePage({super.key});

  @override
  State<GenderAgePage> createState() => _GenderAgePageState();
}

class _GenderAgePageState extends State<GenderAgePage> {
  int _genderIndex = 0;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: CustomAppBar(),
        body: Container(
          padding: const EdgeInsets.symmetric(vertical: 110, horizontal: 16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Theme.of(context).colorScheme.primary,
                Theme.of(context).colorScheme.secondary,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [_text(), SizedBox(height: 20), _genderRow()],
            ),
          ),
        ),
      ),
    );
  }

  Widget _genderOption({required int option, required String label}) {
  return Expanded(
    child: GestureDetector(
      onTap: () => setState(() {
        _genderIndex = option;
      }),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: _genderIndex == option
              ? Theme.of(context).colorScheme.primaryContainer.withOpacity(0.2)
              : Theme.of(context).colorScheme.primaryContainer,
        ),
        height: 100,
        child: Center(
          child: Text(
            label,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    ),
  );
}

Widget _genderRow() {
  return Row(
    children: [
      _genderOption(option: 1, label: 'Male'),
      _genderOption(option: 2, label: 'Female'),
    ],
  );
}

  Widget _text() {
    return Center(
      child: Text(
        'Tell Us About Yourself !',
        style: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}
