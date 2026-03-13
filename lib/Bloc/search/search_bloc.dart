import 'package:bloc/bloc.dart';
import 'package:langkara/Services/search_service.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchService searchService;

  SearchBloc(this.searchService) : super(SearchInitial()) {
    on<LoadSearchHistory>((event, emit) async {
      emit(SearchLoading());

      try {
        // Search history feature not yet implemented in SearchService
        // Emit empty state for now
        emit(SearchEmpty());
      } catch (e) {
        emit(SearchError(e.toString()));
      }
    });
  }
}