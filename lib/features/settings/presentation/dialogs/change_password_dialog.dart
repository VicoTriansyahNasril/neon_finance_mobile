import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../../../../core/theme/app_theme.dart';

void showChangePasswordDialog(BuildContext context) {
  final formKey = GlobalKey<FormState>();
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: AppTheme.cardBg,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: const Text(
        'Ubah Password',
        style: TextStyle(color: Colors.white, fontSize: 22),
      ),
      content: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: oldPasswordController,
                obscureText: true,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Password Lama',
                  labelStyle: const TextStyle(color: AppTheme.neonPurple),
                  filled: true,
                  fillColor: AppTheme.darkCard,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukkan password lama';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: newPasswordController,
                obscureText: true,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Password Baru',
                  labelStyle: const TextStyle(color: AppTheme.neonPurple),
                  filled: true,
                  fillColor: AppTheme.darkCard,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukkan password baru';
                  }
                  if (value.length < 6) {
                    return 'Password minimal 6 karakter';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: confirmPasswordController,
                obscureText: true,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Konfirmasi Password Baru',
                  labelStyle: const TextStyle(color: AppTheme.neonPurple),
                  filled: true,
                  fillColor: AppTheme.darkCard,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (value) {
                  if (value != newPasswordController.text) {
                    return 'Password tidak cocok';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(
            'Batal',
            style: TextStyle(color: Colors.white54),
          ),
        ),
        TextButton(
          onPressed: () async {
            if (formKey.currentState!.validate()) {
              final box = Hive.box('auth');
              final savedPassword = box.get('password') as String?;

              if (oldPasswordController.text == savedPassword) {
                await box.put('password', newPasswordController.text);

                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Password berhasil diubah'),
                      backgroundColor: Colors.green,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Password lama salah'),
                    backgroundColor: Colors.red,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            }
          },
          child: const Text(
            'Simpan',
            style: TextStyle(
              color: AppTheme.neonPurple,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    ),
  );
}
