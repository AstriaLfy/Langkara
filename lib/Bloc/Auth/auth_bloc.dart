import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:langkara/Repository/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository repository;

  AuthBloc(this.repository) : super(AuthInitial()) {

    on<LoginSubmited>((event, emit) async {
      emit(AuthLoading());
      try {
        await repository.login(event.email, event.password);
        emit(LoginSuccess());
      } catch (e) {
        emit(LoginFailure(e.toString()));
      }
    });

    on<RegisterSubmited>((event, emit) async {
      emit(AuthLoading());
      try {
        await repository.register(event.email, event.password);
        emit(RegisterSuccess());
      } catch (e) {
        emit(RegisterFailure(e.toString()));
      }
    });

    on<Logout>((event, emit) async {
      await repository.logout();
      emit(Unauthenticated());
    });
  }
}