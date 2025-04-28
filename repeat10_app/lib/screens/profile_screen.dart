import 'package:flutter/material.dart';
import '../models/user_profile.dart';
import 'loading_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  String _profession = '';
  String _hobbies = '';
  String _motivation = '';
  String _englishType = 'USA';
  final List<String> _englishOptions = ['USA', 'AUD', 'UK'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil de Usuario'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: '¿A qué te dedicas?'),
                onSaved: (val) => _profession = val ?? '',
                validator: (val) => val == null || val.isEmpty ? 'Por favor ingresa tu profesión' : null,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: '¿Cuáles son tus hobbies?'),
                onSaved: (val) => _hobbies = val ?? '',
                validator: (val) => val == null || val.isEmpty ? 'Por favor ingresa tus hobbies' : null,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: '¿Por qué quieres aprender inglés?'),
                onSaved: (val) => _motivation = val ?? '',
                validator: (val) => val == null || val.isEmpty ? 'Por favor ingresa tu motivación' : null,
              ),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Tipo de inglés preferido'),
                value: _englishType,
                onChanged: (val) => setState(() => _englishType = val!),
                items: _englishOptions.map((opt) => DropdownMenuItem(value: opt, child: Text(opt))).toList(),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submit,
                child: const Text('Continuar'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState!.save();
      final profile = UserProfile(
        profession: _profession,
        hobbies: _hobbies,
        motivation: _motivation,
        englishType: _englishType,
      );
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => LoadingScreen(profile: profile),
        ),
      );
    }
  }
} 