import 'package:flutter/material.dart';
import 'package:langkara/models/materi_model.dart';

class MateriCard extends StatelessWidget {
  final MateriFeedModel materi;

  const MateriCard({super.key, required this.materi});

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
            blurRadius: 6,
            color: Colors.black12,
            offset: Offset(0, 3),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// HEADER
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 14,
                  backgroundImage: materi.authorAvatar != null
                      ? NetworkImage(materi.authorAvatar!)
                      : null,
                  child: materi.authorAvatar == null
                      ? const Icon(Icons.person, size: 16)
                      : null,
                ),

                const SizedBox(width: 8),

                Expanded(
                  child: Text(
                    materi.authorName,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

                const Icon(Icons.more_vert, size: 18),
              ],
            ),
          ),

          /// THUMBNAIL
          Expanded(
            child: Image.network(
              materi.coverUrl ?? "",
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                color: Colors.grey[200],
                child: const Icon(Icons.image_not_supported),
              ),
            ),
          ),

          /// INFO
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text(
                  materi.judul,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  "Sumber : ${materi.authorName}",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[700],
                  ),
                ),

                const SizedBox(height: 2),

                Text(
                  "${materi.authorJurusan ?? "-"}, ${materi.authorUniversitas ?? "-"}",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}