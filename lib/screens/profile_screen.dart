import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Pengembang'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            children: [
              const CircleAvatar(
                radius: 46,
                backgroundColor: Color(0xFFC0392B),
                child: Icon(Icons.person, size: 50, color: Colors.white),
              ),
              const SizedBox(height: 16),
              const Text(
                'Kadek Adi Saputra',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                'NIM: 2415051005',
                style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
              ),
              const SizedBox(height: 2),
              Text(
                'Pendidikan Teknik Informatika - Undiksha',
                style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 24),
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: const ListTile(
                  leading: Icon(Icons.info_outline, color: Color(0xFFC0392B)),
                  title: Text('Project UTS Pemrograman Mobile'),
                  subtitle: Text('Dapur Dewata: Resep Kuliner Khas Bali'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}