import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../models/user_create.dart';

class GenderAgePage extends StatefulWidget {
  final String firstName;
  final String lastName;
  final String email;
  final String password;

  const GenderAgePage({
    super.key,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
  });

  @override
  State<GenderAgePage> createState() => _GenderAgePageState();
}

class _GenderAgePageState extends State<GenderAgePage> {
  bool _isLoading = false;
  int _selectedGender = 0;
  String _selectedAge = "Select Age Range";

  void _showAgeSelectionSheet() {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      context: context,
      builder: (_) => Container(
        height: MediaQuery.of(context).size.height * 0.6,
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16, bottom: 10),
              child: Text(
                'Select Age Range',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            const Divider(),
            Expanded(child: _buildAgeSelectionSheet()),
          ],
        ),
      ),
    );
  }

  Future<void> _createAccount(UserModel user) async {
    setState(() => _isLoading = true);
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final theme = Theme.of(context);
    try {
      final userData = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: user.email, password: user.password);

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

      if (mounted) {
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Text(
              'Account Created Successfully!',
              style: TextStyle(color: theme.colorScheme.onPrimary),
            ),
            backgroundColor: theme.colorScheme.primary,
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Text(e.message ?? 'Something went wrong'),
            backgroundColor: theme.colorScheme.error,
          ),
        );
      }
    }
    if (mounted) setState(() => _isLoading = false);
  }

  Widget _buildAgeSelectionSheet() {
    return FutureBuilder(
      future: FirebaseFirestore.instance
          .collection('ages')
          .orderBy('value')
          .get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).colorScheme.primary,
            ),
          );
        }
        if (snapshot.hasError) {
          return Center(
            child: Text(
              'An error occurred!',
              style:
                  TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          );
        }
        final ageDocs = snapshot.data!.docs;
        return ListView(
          children: ageDocs.map<Widget>((doc) {
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
    final bool isSelected = _selectedGender == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedGender = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 140,
        height: 140,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: isSelected
              ? Theme.of(context).colorScheme.secondary.withOpacity(0.7)
              : Theme.of(context)
                  .colorScheme
                  .secondaryContainer
                  .withOpacity(0.5),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color:
                        Theme.of(context).shadowColor.withOpacity(0.2),
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
              color: isSelected ? Colors.white : Colors.white.withOpacity(0.7),
            ),
            const SizedBox(height: 10),
            Text(
              label,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color:
                    isSelected ? Colors.white : Colors.white.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFinishButton(bool isSmallScreen) {
    return SizedBox(
      width: double.infinity,
      height: isSmallScreen ? 50 : 60,
      child: ElevatedButton(
        onPressed: _isLoading
            ? null
            : () {
                if (_selectedAge == 'Select Age Range') {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Please select your age!'),
                      backgroundColor:
                          Theme.of(context).colorScheme.error,
                    ),
                  );
                  return;
                }
                if (_selectedGender == 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Please select your gender!'),
                      backgroundColor:
                          Theme.of(context).colorScheme.error,
                    ),
                  );
                  return;
                }
                final user = UserModel(
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: _isLoading
            ? SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: Theme.of(context).colorScheme.onSecondary,
                ),
              )
            : Text(
                'Finish',
                style: TextStyle(
                  fontSize: isSmallScreen ? 16 : 18,
                ),
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(backgroundColor: Colors.transparent),
        body: Container(
          height: size.height,
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
          child: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: size.width * 0.05,
                vertical: size.height * 0.03,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 50),
                  const Text(
                    'Tell Us About Yourself!',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 40),
                  _buildGenderSelection(),
                  const SizedBox(height: 40),
                  const Text(
                    'How Old Are You?',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: _showAgeSelectionSheet,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 25, vertical: 16),
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .secondaryContainer
                            .withOpacity(0.5),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _selectedAge,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[300],
                            ),
                          ),
                          Icon(
                            Icons.arrow_drop_down,
                            size: 28,
                            color: Colors.grey[300],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  _buildFinishButton(isSmallScreen),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
