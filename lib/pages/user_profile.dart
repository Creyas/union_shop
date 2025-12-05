import 'package:flutter/material.dart';
import '../widgets/header_widget.dart';
import '../widgets/footer_widget.dart';
import '../services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final AuthService _authService = AuthService();
  final _formKey = GlobalKey<FormState>();
  
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  
  bool _isLoading = true;
  bool _isEditing = false;
  Map<String, dynamic>? _userData;
  User? _currentUser;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    setState(() {
      _isLoading = true;
    });

    _currentUser = _authService.currentUser;

    if (_currentUser != null) {
      _userData = await _authService.getUserData(_currentUser!.uid);
      
      if (_userData != null) {
        _nameController.text = _userData!['name'] ?? '';
        _emailController.text = _userData!['email'] ?? '';
      } else {
