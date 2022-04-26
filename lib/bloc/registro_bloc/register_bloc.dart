// ignore_for_file: import_of_legacy_library_into_null_safe
import 'package:bloc/bloc.dart';
// ignore: unused_import
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:santiago4x4pro/repository/user_repository.dart';
import 'package:santiago4x4pro/util/validators.dart';
import 'bloc.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final UserRepository _userRepository;

  RegisterBloc({required UserRepository userRepository}) : _userRepository = userRepository;

  @override
  RegisterState get initialState => RegisterState.empty();

  @override
  Stream<Transition<RegisterEvent, RegisterState>> transformEvents(
    Stream<RegisterEvent> events,
    TransitionFunction<RegisterEvent, RegisterState> transitionFn,
  ) {
    final nonDebounceStream = events.where((event) {
      return(
        event is! EmailChanged && 
        event is! PasswordChanged && 
        event is! DateBornChanged && 
        event is!  ImageChanged && 
        event is! InsuranceChanged && 
        event is! NameChanged && 
        event is! PhoneChanged && 
        event is! SocioChanged && 
        event is! TypeBloodChanged && 
        event is! AutoChanged && 
        event is! UidChanged
      );
    });
    final debounceStream = events.where((event) {
      return(
        event is EmailChanged || 
        event is PasswordChanged || 
        event is DateBornChanged || 
        event is  ImageChanged || 
        event is InsuranceChanged  || 
        event is NameChanged || 
        event is PhoneChanged || 
        event is SocioChanged || 
        event is TypeBloodChanged || 
        event is AutoChanged || 
        event is UidChanged
      );
    }).debounceTime(const Duration(milliseconds: 300));
    return super.transformEvents(
      nonDebounceStream.mergeWith([debounceStream]),
      transitionFn,
    );
  }

  @override
  Stream<RegisterState> mapEventToState(
    RegisterEvent event,
  ) async* {
if (event is EmailChanged) {
      yield* _mapEmailChangedToState(event.email);
    } else if (event is PasswordChanged) {
      yield* _mapPasswordChangedToState(event.password);
    } else if (event is NameChanged) {
      yield* _mapNameChangedToState(event.name);
    }  else if (event is PhoneChanged) {
      yield* _mapPhoneChangedToState(event.phone); 
    } else if (event is SocioChanged) {
      yield* _mapSocioChangedToState(event.socio); 
    } else if (event is ImageChanged) {
      yield* _mapImageChangedToState(event.image); 
    } else if (event is InsuranceChanged) {
      yield* _mapInsuranceChangedToState(event.insurance); 
    } else if (event is TypeBloodChanged) {
      yield* _mapTypeBloodChangedToState(event.typeBlood); 
    } else if (event is DateBornChanged) {
      yield* _mapDateBornChangedToState(event.dateBorn); 
    } else if (event is AutoChanged) {
      yield* _mapAutoChangedToState(event.auto); 
    } else if (event is UidChanged) {
      yield* _mapUidChangedToState(event.uid); 
    }  else if (event is Submitted) {
      yield* _mapFormSubmittedToState(event.email, event.password,  event.name, event.phone, event.socio, event.image, event.insurance, event.typeBlood, event.dateBorn, event.auto, event.uid);
  }
  }

  Stream<RegisterState> _mapEmailChangedToState(String email) async*{
    yield state.update(
      isEmailValid: Validators.isValidEmail(email)
    );
  }

  Stream<RegisterState> _mapPasswordChangedToState(String password) async*{
    yield state.update(
      isPasswordValid: Validators.isValidPassword(password)
    );
  }

  Stream<RegisterState> _mapNameChangedToState(String name) async*{
    yield state.update(
      isPasswordValid: Validators.isValidPassword(name)
    );
  }

  Stream<RegisterState> _mapPhoneChangedToState(String phone) async*{
    yield state.update(
      isPasswordValid: Validators.isValidPassword(phone)
    );
  }

  Stream<RegisterState> _mapSocioChangedToState(String socio) async*{
    yield state.update(
      isPasswordValid: Validators.isValidPassword(socio)
    );
  }

  Stream<RegisterState> _mapImageChangedToState(String image) async*{
    yield state.update(
      isPasswordValid: Validators.isValidPassword(image)
    );
  }

  Stream<RegisterState> _mapInsuranceChangedToState(String insurance) async*{
    yield state.update(
      isPasswordValid: Validators.isValidPassword(insurance)
    );
  }


  Stream<RegisterState> _mapTypeBloodChangedToState(String typeBlood) async*{
    yield state.update(
      isPasswordValid: Validators.isValidPassword(typeBlood)
    );
  }

  Stream<RegisterState> _mapDateBornChangedToState(String dateBorn) async*{
    yield state.update(
      isPasswordValid: Validators.isValidPassword(dateBorn)
    );
  }
  
  Stream<RegisterState> _mapAutoChangedToState(String auto) async*{
    yield state.update(
      isPasswordValid: Validators.isValidPassword(auto)
    );
  }

  Stream<RegisterState> _mapUidChangedToState(String uid) async*{
    yield state.update(
      isPasswordValid: Validators.isValidPassword(uid)
    );
  }

  Stream<RegisterState> _mapFormSubmittedToState(String email, String password, String name, String phone, String socio,  String image, String insurance, String typeBlood, String dateBorn, String auto, String uid) async* {
    yield RegisterState.loading();
    try {
      await _userRepository.signUp(email, password, name, phone, socio, image, insurance, typeBlood, dateBorn, auto, uid);
      yield RegisterState.success();
    } catch (_) {
      if (_ == 'ERROR_EMAIL_ALREADY_IN_USE') {
        yield RegisterState.duplicate();
      } else {
        yield RegisterState.failure();
      }
    }
  }
}
