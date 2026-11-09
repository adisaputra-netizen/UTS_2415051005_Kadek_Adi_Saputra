import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryTerracotta = Color(0xFF8D3028);
    const textEspresso = Color(0xFF302923);
    const accentGold = Color(0xFFD5A34A);
    const cardSurface = Color(0xFFFFFDF9);
    const warmCreamBox = Color(0xFFEADBC8);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Pengembang'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: accentGold, width: 2.5),
                ),
                child: const CircleAvatar(
                  radius: 46,
                  backgroundColor: warmCreamBox,
                  child: Icon(Icons.person_rounded, size: 54, color: primaryTerracotta),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Kadek Adi Saputra',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: textEspresso,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'NIM: 2415051005',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: primaryTerracotta.withValues(alpha: 0.9),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Pendidikan Teknik Informatika - Undiksha',
                style: TextStyle(
                  fontSize: 13,
                  color: textEspresso.withValues(alpha: 0.65),
                ),
              ),
              const SizedBox(height: 24),

              // Kartu Informasi Projek
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: cardSurface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: primaryTerracotta.withValues(alpha: 0.12)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: primaryTerracotta.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.info_outline, color: primaryTerracotta, size: 22),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Project UTS Pemrograman Mobile',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.5,
                                  color: textEspresso,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Dapur Dewata: Resep Kuliner Khas Bali',
                                style: TextStyle(
                                  fontSize: 12.5,
                                  color: textEspresso.withValues(alpha: 0.7),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 24),
                    _buildInfoRow('Teknologi', 'Flutter & Dart (Material 3)'),
                    const SizedBox(height: 8),
                    _buildInfoRow('Arsitektur', 'MVVM / Repository Pattern'),
                    const SizedBox(height: 8),
                    _buildInfoRow('State Management', 'Provider (ChangeNotifier)'),
                    const SizedBox(height: 8),
                    _buildInfoRow('Backend & Database', 'Supabase & REST API'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    const textEspresso = Color(0xFF302923);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 12.5, color: textEspresso.withValues(alpha: 0.65)),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.w600,
            color: textEspresso,
          ),
        ),
      ],
    );
  }
}
