import 'package:langkara/services/teman_service.dart';
import 'package:langkara/models/teman_profile_model.dart';

class TemanRepository {
  final TemanService temanService;

  TemanRepository(this.temanService);

  Future<List<TemanProfileModel>> getTemanList() {
    return temanService.getTemanList();
  }
}
