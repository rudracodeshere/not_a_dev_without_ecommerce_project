import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_project/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';

class GenderAgePage extends StatefulWidget {
  const GenderAgePage({super.key});

  @override
  State<GenderAgePage> createState() => _GenderAgePageState();
}

class _GenderAgePageState extends State<GenderAgePage> {
  int _genderIndex = 0;
  String age = "Select Age Range";
  void _showSheet() {
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      context: context,
      builder: (context) => _selectAgeSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CustomAppBar(),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.primary.withOpacity(0.9),
              Theme.of(context).colorScheme.secondary.withOpacity(0.9),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 120),
            _titleText('Tell Us About Yourself!'),
            const SizedBox(height: 30),
            _genderSelection(),
            const SizedBox(height: 40),
            _titleText('How Old Are You?'),
            const SizedBox(height: 20),
            _ageBox(context),
            const Spacer(),
            _finishButton(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _titleText(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _genderSelection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _genderCard(index: 1, label: 'Male', icon: Icons.male),
        const SizedBox(width: 20),
        _genderCard(index: 2, label: 'Female', icon: Icons.female),
      ],
    );
  }

  Widget _genderCard({required int index, required String label, required IconData icon}) {
    bool isSelected = _genderIndex == index;

    return GestureDetector(
      onTap: () => setState(() => _genderIndex = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        width: 140,
        height: 140,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: isSelected
              ? Theme.of(context).colorScheme.primaryContainer.withOpacity(0.5)
              : Theme.of(context).colorScheme.primaryContainer,
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 8,
                spreadRadius: 2,
              ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: isSelected ? Colors.white : Colors.black),
            const SizedBox(height: 10),
            Text(
              label,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _ageBox(BuildContext context) {
    return GestureDetector(
      onTap: _showSheet,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 6,
              spreadRadius: 2,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children:[
            Text(age, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Icon(Icons.arrow_drop_down, size: 28),
          ],
        ),
      ),
    );
  }

  Widget _finishButton() {
    return Center(
      child: SizedBox(
        width: double.infinity,
        height: 55,
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.secondary,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 5,
          ),
          child: const Text(
            'Finish',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
      ),
    );
  }

Widget _selectAgeSheet() {
  return SizedBox(
    height: MediaQuery.of(context).size.height * 0.45,
    child: FutureBuilder(
      future: FirebaseFirestore.instance.collection('ages').orderBy('value').get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return const Center(child: Text('An error occurred!'));
        }
        final ageDocs = snapshot.data!.docs;
        return ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 20),
          separatorBuilder: (context, index) => const Divider(height: 5),
          itemCount: ageDocs.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(ageDocs[index]['value'], style: const TextStyle(fontSize: 18,fontWeight: FontWeight.bold)),
              onTap: () {
                setState(() => age = ageDocs[index]['value']);
                Navigator.of(context).pop();
              },
            );
          },
        );
      },
    ),
  );
}
}
