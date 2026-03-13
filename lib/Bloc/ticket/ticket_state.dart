part of 'ticket_bloc.dart';

@immutable
sealed class TicketState {}

final class TicketInitial extends TicketState {}

final class TicketLoading extends TicketState {}

final class TicketLoaded extends TicketState {
  final int ticket;

  TicketLoaded(this.ticket);
}

final class TicketError extends TicketState {
  final String message;

  TicketError(this.message);
}