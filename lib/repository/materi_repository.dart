import 'package:langkara/services/materi_service.dart';
import 'package:langkara/models/materi_model.dart';

class MateriRepository {
  final MateriService materiService;

  MateriRepository(this.materiService);

  Future<List<MateriFeedModel>> getMateriFeed() {
    return materiService.getMateriFeed();
  }

  Future<void> uploadMateri({
    required String judul,
    required String deskripsi,
    required String kategori,
    required List<String> imagePaths,
  }) async {
    try {
      await materiService.materiUpload(
        judul: judul,
        deskripsi: deskripsi,
        kategori: kategori,
        imagePaths: imagePaths,
      );
    } catch (e) {
      throw Exception("Repo Error (Upload): ${e.toString()}");
    }
  }
}