part of 'ticket_bloc.dart';

@immutable
sealed class TicketEvent {}

class LoadTicket extends TicketEvent {}

class UseTicket extends TicketEvent {}