import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:langkara/Bloc/Achievement/achievement_bloc.dart';
import 'package:langkara/Pages/Widgets/button_primary.dart';
import 'package:langkara/Pages/Widgets/text_field.dart';
import 'package:langkara/services/achievement_service.dart';

class DetailUploadAchievementPage extends StatefulWidget {
  final String imagePath;

  const DetailUploadAchievementPage({super.key, required this.imagePath});

  @override
  State<DetailUploadAchievementPage> createState() =>
      _DetailUploadAchievementPageState();
}

class _DetailUploadAchievementPageState
    extends State<DetailUploadAchievementPage> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _achievedAtController = TextEditingController();

  String? _selectedCategory;
  String? titleError;

  final List<String> _categories = [
    "Sains",
    "Teknologi",
    "Rekayasa",
    "Matematika",
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _achievedAtController.dispose();
    super.dispose();
  }

  void _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _achievedAtController.text =
            "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }

  void _uploadAchievement(BuildContext blocContext) {
    setState(() => titleError = null);

    if (_titleController.text.isEmpty) {
      setState(() => titleError = "Judul tidak boleh kosong");
      return;
    }

    if (_selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Silakan pilih kategori")),
      );
      return;
    }

    blocContext.read<AchievementBloc>().add(
          UploadAchievementRequested(
            title: _titleController.text,
            description: _descriptionController.text,
            category: _selectedCategory!,
            imagePath: widget.imagePath,
            achievedAt: _achievedAtController.text.isNotEmpty
                ? _achievedAtController.text
                : DateTime.now().toIso8601String().split('T')[0],
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AchievementBloc(AchievementService()),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0xFF1A2A4F)),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            "Pencapaian Baru",
            style: TextStyle(
              color: Color(0xFF1A2A4F),
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          centerTitle: true,
        ),
        body: BlocConsumer<AchievementBloc, AchievementState>(
          listener: (context, state) {
            if (state is AchievementUploadSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text("Pencapaian berhasil diupload!")),
              );
              Navigator.pop(context);
              Navigator.pop(context);
            }

            if (state is AchievementError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),

                  // Preview image
                  Center(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      height: MediaQuery.of(context).size.width * 0.6,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        image: DecorationImage(
                          image: FileImage(File(widget.imagePath)),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Form fields
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        NormalField(
                          controller: _titleController,
                          labelText: "Judul pencapaian...",
                          hintText: "",
                          errorText: titleError,
                        ),

                        NormalField(
                          controller: _descriptionController,
                          labelText: "Deskripsi",
                          hintText: "",
                          errorText: "",
                        ),

                        // Date picker
                        GestureDetector(
                          onTap: _pickDate,
                          child: AbsorbPointer(
                            child: NormalField(
                              controller: _achievedAtController,
                              labelText: "Tanggal pencapaian",
                              hintText: "Tap untuk pilih tanggal",
                              errorText: "",
                            ),
                          ),
                        ),

                        const SizedBox(height: 10),

                        // Category picker
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 4),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                color: Colors.grey.withValues(alpha: 0.3)),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              isExpanded: true,
                              hint: const Text("Pilih Kategori"),
                              value: _selectedCategory,
                              items: _categories
                                  .map((cat) => DropdownMenuItem(
                                        value: cat,
                                        child: Text(cat),
                                      ))
                                  .toList(),
                              onChanged: (val) {
                                setState(() => _selectedCategory = val);
                              },
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        state is AchievementUploading
                            ? const CircularProgressIndicator()
                            : primaryButton(
                                text: "Upload Pencapaian",
                                onPressed: () =>
                                    _uploadAchievement(context),
                                foregroundColor: Colors.white,
                              ),

                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
