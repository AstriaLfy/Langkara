import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:langkara/Bloc/Materiku/materi_bloc.dart';
import 'package:langkara/Pages/Widgets/app_bar.dart';
import 'package:langkara/Pages/Widgets/materi_card.dart';
import 'package:langkara/repository/materi_repository.dart';
import 'package:langkara/services/materi_service.dart';

class MateriKuPage extends StatelessWidget {
  const MateriKuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
      MateriBloc(MateriRepository(MateriService()))..add(LoadMateriFeed()),
      child: Scaffold(
        appBar: MyCustomAppBar(),
        body: BlocBuilder<MateriBloc, MateriState>(
          builder: (context, state) {
            if (state is MateriLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (state is MateriLoaded) {
              final materiList = state.materi;

              if (materiList.isEmpty) {
                return const Center(
                  child: Text("Belum ada materi"),
                );
              }

              return CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16, top: 20, bottom: 8),
                      child: Text(
                        "Semua",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          color: Colors.grey[800],
                        ),
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.all(12),
                    sliver: SliverGrid(
                      gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.72,
                      ),
                      delegate: SliverChildBuilderDelegate(
                            (context, index) {
                          final materi = materiList[index];
                          return MateriCard(materi: materi);
                        },
                        childCount: materiList.length,
                      ),
                    ),
                  ),
                ],
              );
            }

            if (state is MateriError) {
              return Center(
                child: Text(state.message),
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }
}