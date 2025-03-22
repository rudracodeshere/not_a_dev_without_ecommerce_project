import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_project/models/user_create.dart';
import 'package:e_commerce_project/widgets/custom_appbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class GenderAgePage extends StatefulWidget {
  const GenderAgePage({
    super.key,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
  });

  final String firstName;
  final String lastName;
  final String email;
  final String password;

  @override
  State<GenderAgePage> createState() => _GenderAgePageState();
}

class _GenderAgePageState extends State<GenderAgePage> {
  bool _isLoading = false;
  int _selectedGender = 0;
  String _selectedAge = "Select Age Range";

  void _showAgeSelectionSheet() {
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      context: context,
      builder: (_) => _buildAgeSelectionSheet(),
    );
  }

  Future<void> _createAccount(UserCreate user) async {
    setState(() => _isLoading = true);
    try {
      final userData = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: user.email,
            password: user.password,
          );

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userData.user!.uid)
          .set({
            'firstName': user.firstName,
            'lastName': user.lastName,
            'email': user.email,
            'gender': user.gender,
            'age': user.age,
          });

      ScaffoldMessenger.of(context).showSnackBar(
        _buildSnackBar('Account Created Successfully!', Theme.of(context).colorScheme.primary),
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        _buildSnackBar(e.message ?? 'Something went wrong', Theme.of(context).colorScheme.error),
      );
    }
    setState(() => _isLoading = false);
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
            _buildTitle('Tell Us About Yourself!'),
            const SizedBox(height: 30),
            _buildGenderSelection(),
            const SizedBox(height: 40),
            _buildTitle('How Old Are You?'),
            const SizedBox(height: 20),
            _buildAgeSelectionBox(),
            const Spacer(),
            _buildFinishButton(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.onPrimary,
        ),
      ),
    );
  }

  Widget _buildGenderSelection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildGenderCard(index: 1, label: 'Male', icon: Icons.male),
        const SizedBox(width: 20),
        _buildGenderCard(index: 2, label: 'Female', icon: Icons.female),
      ],
    );
  }

  Widget _buildGenderCard({
    required int index,
    required String label,
    required IconData icon,
  }) {
    bool isSelected = _selectedGender == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedGender = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 140,
        height: 140,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: isSelected 
              ? Theme.of(context).colorScheme.primary.withOpacity(0.6) 
              : Theme.of(context).colorScheme.surface,
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Theme.of(context).shadowColor.withOpacity(0.2),
                    blurRadius: 8,
                  ),
                ]
              : [],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 40,
              color: isSelected 
                  ? Theme.of(context).colorScheme.onPrimary
                  : Theme.of(context).colorScheme.onSurface,
            ),
            const SizedBox(height: 10),
            Text(
              label,
              style: TextStyle(
                fontSize: 18, 
                fontWeight: FontWeight.bold,
                color: isSelected 
                    ? Theme.of(context).colorScheme.onPrimary
                    : Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAgeSelectionBox() {
    return GestureDetector(
      onTap: _showAgeSelectionSheet,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).shadowColor.withOpacity(0.15), 
              blurRadius: 6
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _selectedAge,
              style: TextStyle(
                fontSize: 16, 
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            Icon(
              Icons.arrow_drop_down, 
              size: 28,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFinishButton() {
    return Center(
      child: SizedBox(
        width: double.infinity,
        height: 55,
        child: ElevatedButton(
          onPressed: _isLoading
              ? null
              : () {
                  if (_selectedAge == 'Select Age Range') {
                    ScaffoldMessenger.of(context).showSnackBar(
                      _buildSnackBar('Please select your age!', Theme.of(context).colorScheme.error),
                    );
                    return;
                  }
                  if (_selectedGender == 0) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      _buildSnackBar(
                        'Please select your gender!',
                        Theme.of(context).colorScheme.error,
                      ),
                    );
                    return;
                  }
                  final user = UserCreate(
                    firstName: widget.firstName,
                    lastName: widget.lastName,
                    email: widget.email,
                    password: widget.password,
                    gender: _selectedGender,
                    age: _selectedAge,
                  );
                  _createAccount(user);
                },
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.secondary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: _isLoading
              ? CircularProgressIndicator(
                  color: Theme.of(context).colorScheme.onSecondary,
                )
              : Text(
                  'Finish',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSecondary,
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildAgeSelectionSheet() {
    return FutureBuilder(
      future: FirebaseFirestore.instance.collection('ages').orderBy('value').get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting)
          return Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).colorScheme.primary,
            ),
          );
        if (snapshot.hasError)
          return Center(
            child: Text(
              'An error occurred!',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          );
        final ageDocs = snapshot.data!.docs;
        return ListView(
          children: ageDocs.map((doc) {
            return ListTile(
              title: Text(
                doc['value'],
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              onTap: () {
                setState(() => _selectedAge = doc['value']);
                Navigator.pop(context);
              },
            );
          }).toList(),
        );
      },
    );
  }

  SnackBar _buildSnackBar(String message, Color color) {
    return SnackBar(
      content: Text(message),
      behavior: SnackBarBehavior.floating,
      backgroundColor: color,
    );
  }
}