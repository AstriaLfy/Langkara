import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:langkara/Bloc/Materiku/materi_bloc.dart';
import 'package:langkara/Pages/Widgets/button_primary.dart';
import 'package:langkara/Pages/Widgets/dropdown_field.dart';
import 'package:langkara/Pages/Widgets/text_field.dart';

class DetailUploadPage extends StatefulWidget {
  final List<String> imagePaths;

  const DetailUploadPage({super.key, required this.imagePaths});

  @override
  State<DetailUploadPage> createState() => _DetailUploadPageState();
}

class _DetailUploadPageState extends State<DetailUploadPage> {

  final _judulMateri = TextEditingController();
  final _sumber = TextEditingController();
  final _rangkuman = TextEditingController();

  String? _selectedCategory;

  String? judulError;
  String? sumberError;
  String? rangkumanError;

  @override
  void dispose() {
    _judulMateri.dispose();
    _sumber.dispose();
    _rangkuman.dispose();
    super.dispose();
  }

  void _uploadMateri() {

    setState(() {
      judulError = null;
      sumberError = null;
      rangkumanError = null;
    });

    if (_judulMateri.text.isEmpty) {
      setState(() {
        judulError = "Judul tidak boleh kosong";
      });
      return;
    }

    if (_selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Silakan pilih kategori")),
      );
      return;
    }

    context.read<MateriBloc>().add(
      UploadMateriRequested(
        judul: _judulMateri.text,
        deskripsi: _rangkuman.text,
        kategori: _selectedCategory!,
        imagePaths: widget.imagePaths,
      ),
    );
  }

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
          "Postingan Baru",
          style: TextStyle(
            color: Color(0xFF1A2A4F),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),

      body: BlocConsumer<MateriBloc, MateriState>(

        listener: (context, state) {

          if (state is MateriUploadSuccess) {

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Materi berhasil diupload")),
            );

            Navigator.pop(context);
          }

          if (state is MateriError) {

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

                const SizedBox(height: 40),

                SizedBox(
                  height: MediaQuery.of(context).size.width * 0.7,

                  child: ListView.separated(

                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),

                    itemCount: widget.imagePaths.length,

                    separatorBuilder: (_, __) => const SizedBox(width: 12),

                    itemBuilder: (context, index) {

                      return AspectRatio(

                        aspectRatio: 1,

                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.file(
                            File(widget.imagePaths[index]),
                            fit: BoxFit.cover,
                          ),
                        ),

                      );
                    },
                  ),
                ),

                const SizedBox(height: 20),

                Padding(

                  padding: const EdgeInsets.symmetric(horizontal: 20),

                  child: Column(

                    children: [

                      NormalField(
                        controller: _judulMateri,
                        labelText: "Judul materi...",
                        hintText: "",
                        errorText: judulError,
                      ),

                      NormalField(
                        controller: _sumber,
                        labelText: "Sumber",
                        hintText: "",
                        errorText: sumberError,
                      ),

                      NormalField(
                        controller: _rangkuman,
                        labelText: "Keterangan Tambahan",
                        hintText: "",
                        errorText: rangkumanError,
                      ),

                      const SizedBox(height: 10),

                      CustomCategoryPicker(

                        categories: const [
                          "Sains",
                          "Teknologi",
                          "Rekayasa",
                          "Matematika"
                        ],

                        onSelected: (val) {

                          setState(() {
                            _selectedCategory = val;
                          });

                        },
                      ),

                      const SizedBox(height: 20),

                      state is MateriUploading
                          ? const CircularProgressIndicator()
                          : primaryButton(
                        text: "Bagikan",
                        onPressed: _uploadMateri,
                        foregroundColor: Colors.white,
                      )

                    ],
                  ),
                ),

              ],
            ),
          );
        },
      ),
    );
  }
}