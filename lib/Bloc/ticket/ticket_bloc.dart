import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:langkara/Services/profile_services.dart';

part 'ticket_event.dart';
part 'ticket_state.dart';

class TicketBloc extends Bloc<TicketEvent, TicketState> {
  final ProfileService profileService;

  TicketBloc(this.profileService) : super(TicketInitial()) {

    on<LoadTicket>((event, emit) async {
      emit(TicketLoading());

      try {
        final profile = await profileService.getCurrentUserProfile();
        final ticket = profile['tiket_baca_sisa'];

        emit(TicketLoaded(ticket));

      } catch (e) {
        emit(TicketError(e.toString()));
      }
    });

    on<UseTicket>((event, emit) async {
      try {

        await profileService.useTicket();

        final profile = await profileService.getCurrentUserProfile();
        final ticket = profile['tiket_baca_sisa'];

        emit(TicketLoaded(ticket));

      } catch (e) {
        emit(TicketError(e.toString()));
      }
    });

  }
}