import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:langkara/Repository/auth_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:langkara/Services/profile_services.dart';
part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository repository;
  final ProfileService profileService = ProfileService();
  AuthBloc(this.repository) : super(AuthInitial()) {
    on<LoginSubmited>((event, emit) async {
      emit(AuthLoading());
      try {
        await repository.login(event.email, event.password);
        emit(LoginSuccess());
      } catch (e) {
        emit(LoginFailure(e.toString()));
        print(e.toString());
      }
    });

on<RegisterSubmited>((event, emit) async {
  emit(AuthLoading());
  try {
    await repository.register(
      event.email,
      event.password,
      event.nama,
      event.avatarurl,
    );

    emit(RegisterSuccess());
  } catch (e) {
    print(e.toString());
    emit(RegisterFailure(e.toString()));
  }
});

    on<UpdateAvatarEvent>((event, emit) async {
  final user = Supabase.instance.client.auth.currentUser;

  if (user == null) return;

  await Supabase.instance.client
      .from('profiles')
      .update({
        'avatar_url': event.avatarUrl,
      })
      .eq('id', user.id);

  final currentState = state;

  if (currentState is Authenticated) {
    emit(
      Authenticated(
        currentState.username,
        currentState.gmail,
        event.avatarUrl,
        jurusan: currentState.jurusan,
        universitas: currentState.universitas,
      ),
    );
  }
});

    on<GoogleSignInRequest>((event, emit) async {
      emit(AuthLoading());
      try {
        await repository.signInWithGoogle();
        emit(LoginSuccess());
      } catch (e) {
        print(e);
        print(e.toString());
      }
    });
    on<UpdateProfile>((event, emit) async {
      emit(AuthLoading());

      try {
        await profileService.updateProfile(
          nama: event.nama,
          username: event.username,
          email: event.email,
          jurusan: event.jurusan,
          universitas: event.universitas,
          gender: event.gender,
          kemampuan: event.kemampuan,
        );

        final user = Supabase.instance.client.auth.currentUser;

        final profile = await Supabase.instance.client
            .from('profiles')
            .select()
            .eq('id', user!.id)
            .single();

        emit(
          Authenticated(
            profile['username'],
            user.email ?? "",
            profile['avatar_url'],
            jurusan: profile['jurusan'],
            universitas: profile['universitas'],
          ),
        );
      } catch (e) {
        print(e);
      }
    });
    on<Logout>((event, emit) async {
      await repository.logout();
      emit(Unauthenticated());
    });
    on<CekAuth>((event, emit) async {
      final user = repository.authService.getCurrentUser();

      if (user != null) {
        final client = Supabase.instance.client;

        final profile = await client
            .from('profiles')
            .select()
            .eq('id', user.id)
            .single();

        emit(
          Authenticated(
            profile['username'],
            user.email ?? "",
            profile['avatar_url'],
            jurusan: profile['jurusan'],
            universitas: profile['universitas'],
          ),
        );
      } else {
        emit(Unauthenticated());
      }
    });
  }
}
