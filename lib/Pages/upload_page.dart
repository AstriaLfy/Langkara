import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:langkara/Bloc/Materiku/materi_bloc.dart';
import 'package:langkara/Pages/detail_upload_page.dart';
import 'package:photo_manager/photo_manager.dart';

class UploadPage extends StatefulWidget {
  const UploadPage({super.key});

  @override
  State<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  CameraController? _controller;
  List<CameraDescription>? _cameras;
  int _selectedCameraIndex = 0;
  bool _isCameraInitialized = false;

  List<AssetEntity> _galleryAssets = [];
  List<AssetEntity> _selectedAssets = [];

  final DraggableScrollableController _sheetController = DraggableScrollableController();

  @override
  void initState() {
    super.initState();
    _initCamera();
    _fetchAssets();
  }

  @override
  void dispose() {
    _controller?.dispose();
    _sheetController.dispose();
    super.dispose();
  }

  Future<void> _initCamera() async {
    _cameras = await availableCameras();
    if (_cameras != null && _cameras!.isNotEmpty) {
      _onNewCameraSelected(_cameras![_selectedCameraIndex]);
    }
  }

  Future<void> _onNewCameraSelected(CameraDescription description) async {
    if (_controller != null) {
      await _controller!.dispose();
    }

    _controller = CameraController(
      description,
      ResolutionPreset.medium,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    try {
      await _controller!.initialize();
      if (!mounted) return;
      setState(() => _isCameraInitialized = true);
    } catch (e) {
      debugPrint("Kamera error: $e");
    }
  }

  Future<void> _fetchAssets() async {
    final PermissionState ps = await PhotoManager.requestPermissionExtend();
    if (ps.isAuth) {
      List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(
          onlyAll: true,
          type: RequestType.image
      );
      if (albums.isNotEmpty) {
        List<AssetEntity> recentAssets = await albums[0].getAssetListRange(start: 0, end: 60);
        setState(() => _galleryAssets = recentAssets);
      }
    }
  }

  void _toggleSelection(AssetEntity asset) {
    setState(() {
      if (_selectedAssets.contains(asset)) {
        _selectedAssets.remove(asset);
      } else {
        if (_selectedAssets.length < 10) {
          _selectedAssets.add(asset);
        }
      }
    });
  }

  void _handleMultiUpload() async {
    List<String> selectedPaths = [];
    for (var asset in _selectedAssets) {
      final file = await asset.file;
      if (file != null) selectedPaths.add(file.path);
    }
    _goToDetailMulti(selectedPaths);
  }

  void _openGallerySheet() {
    _sheetController.animateTo(
        0.9,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutBack
    );
  }

  void _switchCamera() {
    if (_cameras == null || _cameras!.length < 2) return;
    _selectedCameraIndex = (_selectedCameraIndex + 1) % _cameras!.length;
    _onNewCameraSelected(_cameras![_selectedCameraIndex]);
  }

  void _takePicture() async {
    if (_controller == null || !_controller!.value.isInitialized) return;
    if (_controller!.value.isTakingPicture) return;

    try {
      final image = await _controller!.takePicture();
      _goToDetailSingle(image.path);
    } catch (e) {
      debugPrint("Gagal mengambil gambar: $e");
    }
  }

  void _goToDetailSingle(String path) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: context.read<MateriBloc>(),
          child: DetailUploadPage(imagePaths: [path]),
        ),
      ),
    );  }

  void _goToDetailMulti(List<String> paths) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: context.read<MateriBloc>(),
          child: DetailUploadPage(imagePaths: paths),
        ),
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
          "Kamera",
          style: TextStyle(color: Color(0xFF1A2A4F), fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // 1. MAIN UI (CAMERA)
          Column(
            children: [
              Expanded(
                child: Container(
                  width: double.infinity,
                  color: Colors.black,
                  child: _isCameraInitialized && _controller != null
                      ? ClipRect(
                    child: OverflowBox(
                      alignment: Alignment.center,
                      child: FittedBox(
                        fit: BoxFit.cover,
                        child: SizedBox(
                          width: _controller!.value.previewSize!.height,
                          height: _controller!.value.previewSize!.width,
                          child: CameraPreview(_controller!),
                        ),
                      ),
                    ),
                  )
                      : const Center(child: CircularProgressIndicator()),
                ),
              ),
              Container(
                color: Colors.white,
                padding: const EdgeInsets.only(bottom: 50, top: 25, left: 40, right: 40),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text("Materi", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF1A2A4F))),
                        SizedBox(width: 30),
                        Text("Pencapaian", style: TextStyle(fontSize: 16, color: Colors.grey)),
                      ],
                    ),
                    const SizedBox(height: 25),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildIconButton(Icons.photo_library_outlined, _openGallerySheet),
                        GestureDetector(
                          onTap: _takePicture,
                          child: Container(
                            height: 80, width: 80,
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: const Color(0xFF1A2A4F), width: 4),
                            ),
                            child: Container(
                              decoration: const BoxDecoration(color: Color(0xFF1A2A4F), shape: BoxShape.circle),
                            ),
                          ),
                        ),
                        _buildIconButton(Icons.cameraswitch_outlined, _switchCamera),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          // 2. SLIDING GALLERY
          DraggableScrollableSheet(
            controller: _sheetController,
            initialChildSize: 0.0,
            minChildSize: 0.0,
            maxChildSize: 0.9,
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, spreadRadius: 5)],
                ),
                child: Stack(
                  children: [
                    Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 12, bottom: 8),
                          height: 5, width: 45,
                          decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10)),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Text("Galeri", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        ),
                        Expanded(
                          child: GridView.builder(
                            controller: scrollController,
                            padding: const EdgeInsets.all(2),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3, crossAxisSpacing: 2, mainAxisSpacing: 2
                            ),
                            itemCount: _galleryAssets.length,
                            itemBuilder: (context, index) {
                              final asset = _galleryAssets[index];
                              final isSelected = _selectedAssets.contains(asset);
                              final selectIndex = _selectedAssets.indexOf(asset) + 1;

                              return GestureDetector(
                                onTap: () => _toggleSelection(asset),
                                child: Stack(
                                  children: [
                                    Positioned.fill(child: AssetThumbnail(asset: asset)),
                                    if (isSelected) Container(color: Colors.white.withOpacity(0.3)),
                                    Positioned(
                                      top: 8, right: 8,
                                      child: Container(
                                        height: 24, width: 24,
                                        decoration: BoxDecoration(
                                          color: isSelected ? const Color(0xFF1A2A4F) : Colors.white.withOpacity(0.7),
                                          shape: BoxShape.circle,
                                          border: Border.all(color: Colors.white, width: 2),
                                        ),
                                        child: Center(
                                          child: isSelected
                                              ? Text("$selectIndex", style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold))
                                              : const SizedBox(),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),

                    Positioned(
                      bottom: 30,
                      right: 20,
                      child: AnimatedOpacity(
                        duration: const Duration(milliseconds: 300),
                        opacity: _selectedAssets.isNotEmpty ? 1.0 : 0.0,
                        child: _selectedAssets.isNotEmpty
                            ? GestureDetector(
                          onTap: _handleMultiUpload,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              gradient: const LinearGradient(
                                colors: [Color(0xFF3E3159), Color(0xFFD27685)],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF3E3159).withOpacity(0.3),
                                  blurRadius: 10,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "Selanjutnya (${_selectedAssets.length})",
                                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                                const SizedBox(width: 10),
                                const Icon(Icons.arrow_forward, color: Colors.white),
                              ],
                            ),
                          ),
                        )
                            : const SizedBox.shrink(),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        height: 55, width: 55,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey.withOpacity(0.3)),
        ),
        child: Icon(icon, color: const Color(0xFF1A2A4F), size: 28),
      ),
    );
  }
}

class AssetThumbnail extends StatelessWidget {
  final AssetEntity asset;
  const AssetThumbnail({super.key, required this.asset});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: asset.thumbnailDataWithSize(const ThumbnailSize(250, 250)),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done && snapshot.data != null) {
          return Image.memory(snapshot.data!, fit: BoxFit.cover);
        }
        return Container(color: Colors.grey[100]);
      },
    );
  }
}