import 'package:flutter/material.dart';
import 'package:langkara/models/inspirasi_model.dart';

class DetailInspirasiPage extends StatelessWidget {
  final InspirasiModel inspirasi;

  const DetailInspirasiPage({super.key, required this.inspirasi});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1A2A4F)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Inspirasi",
          style: TextStyle(
            color: Color(0xFF1A2A4F),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Photo
            if (inspirasi.photoUrl != null)
              SizedBox(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.4,
                child: Image.network(
                  inspirasi.photoUrl!,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: Colors.grey[200],
                    child: const Center(
                      child: Icon(Icons.person, size: 64, color: Colors.grey),
                    ),
                  ),
                ),
              ),

            const SizedBox(height: 20),

            // Nama
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                inspirasi.nama,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A2A4F),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Deskripsi
            if (inspirasi.deskripsi != null && inspirasi.deskripsi!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  inspirasi.deskripsi!,
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[800],
                    height: 1.6,
                  ),
                ),
              ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
