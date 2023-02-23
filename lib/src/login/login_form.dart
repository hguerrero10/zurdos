import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:santiago4x4pro/bloc/authentication_bloc/bloc.dart';
import 'package:santiago4x4pro/bloc/login_bloc/bloc.dart';
import 'package:santiago4x4pro/repository/user_repository.dart';
import 'package:santiago4x4pro/src/registro/register_screen.dart';

class LoginForm extends StatefulWidget {
  
  final UserRepository _userRepository;

  const LoginForm({Key? key, required UserRepository userRepository}) : _userRepository = userRepository, super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  
  late LoginBloc _loginBloc;

  bool pass = false;
  
  UserRepository get _userRepository => widget._userRepository;
  
  bool get isPopulated => _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty;

  bool isLoginButtonEnabled(LoginState state) {
    return state.isFormValid && isPopulated && !state.isSubmitting;
  }

  @override
  void initState() {
    super.initState();
    _loginBloc = BlocProvider.of<LoginBloc>(context);
    _emailController.addListener(_onEmailChanged);
    _passwordController.addListener(_onPasswordChanged);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state.isFailure) {
          Scaffold.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text('Inicio Fallido'),
                  Icon(Icons.error)
                ],
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
        if (state.isSubmitting) {
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text('Iniciando sesion... '),
                  CircularProgressIndicator(),
                ],
              ),
            )
          );
        }
        if (state.isSuccess) {
          BlocProvider.of<AuthenticationBloc>(context).add(LoggedIn());
        }
      },
      child: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          return GestureDetector(
            onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
            child: Scaffold(
              body: SafeArea(
                bottom: false,
                top: false,
                child: Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      opacity: 97,
                      image: AssetImage("assets/2.jpg"),
                      fit: BoxFit.cover
                    ),
                  ),
                  child: SizedBox(
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                              Align(
                                alignment: FractionalOffset.bottomCenter,
                                child: Wrap(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 140),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Image.asset('assets/LOGO ZURDOS.png', width: 270, height: 220),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 5, bottom: 5),
                                      child: _input('Correo', 'Correo invalido', TextInputType.emailAddress, _emailController, Icons.email_outlined, false, false),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 5, bottom: 5),
                                      child: _inputPassword('Contraseña', 'Contraseña invalida', TextInputType.visiblePassword, _passwordController, Icons.vpn_key_outlined),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 15, bottom: 15),
                                      child: _buttons('Iniciar Sesion', const Color.fromRGBO(0, 17, 134, 1)  , _onFormSubmitted),
                                    ),
                                    const SizedBox(height: 10),
                                    Padding(
                                      padding: const EdgeInsets.only(left:15, right: 15),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          TextButton(
                                            child: const Text(
                                              'Crear cuenta',
                                              style: TextStyle(
                                                color: Colors.white,
                                              )
                                            ),
                                            onPressed: () {
                                              Navigator.of(context).push(
                                                MaterialPageRoute(builder: (context) {
                                                  return RegisterScreen(
                                                    userRepository: _userRepository,
                                                  );
                                                }
                                              )
                                            );
                                            },
                                          ),
                                          TextButton(
                                            child: const Text(
                                              'Restablecer contraseña',
                                              style: TextStyle(
                                                color: Colors.white,
                                              )
                                            ),
                                            onPressed: () {},
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                )
                              )
                            ],
                    ),
                  )
                ),
              ),
            ),
          );
        }
      )
    );
  }

  final kBoxDecorationStyle = BoxDecoration(
    color: Colors.black38,
    borderRadius: BorderRadius.circular(5.0),
    boxShadow: const [
      BoxShadow(
        color: Colors.transparent,
        blurRadius: 6.0,
        offset: Offset(0, 2),
      ),
    ],
  );

  Widget _input(String placeholder, String mensaje, TextInputType tipo, TextEditingController controller, IconData icon, [bool isPassword = false, bool isfocus = false]) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(left: 15, right: 15),
      height: 60,
      decoration: kBoxDecorationStyle,
      padding: const EdgeInsets.only(left: 10),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              autofocus: isfocus,
              controller: controller,
              obscureText: isPassword,
              onEditingComplete:() => FocusScope.of(context).nextFocus(),
              textInputAction: TextInputAction.next,
              style: const TextStyle(color: Colors.white, fontSize: 15),
              autocorrect: false,
              keyboardType: tipo,
              decoration: InputDecoration(
                icon: Icon(icon, color: Colors.white),
                border: InputBorder.none,
                hintText: placeholder,
                hintStyle: const TextStyle(color: Colors.white, fontSize: 15),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _inputPassword(String placeholder, String mensaje, TextInputType tipo, TextEditingController controller, IconData icon) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 60,
      margin: const EdgeInsets.only(left: 15, right: 15),
      decoration: kBoxDecorationStyle,
      padding: const EdgeInsets.only(left: 10),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: controller,
              obscureText: !pass,
              style: const TextStyle(color: Colors.white, fontSize: 15),
              autocorrect: false,
              textAlign: TextAlign.left,
              keyboardType: tipo,
              onEditingComplete:() => FocusScope.of(context).nextFocus(),
              decoration: InputDecoration(
                icon: Icon(icon, color: Colors.white),
                border: InputBorder.none,
                hintText: placeholder,
                contentPadding: const EdgeInsets.only(top: 17.0),
                suffixIcon: IconButton(
                  icon: Icon(
                    pass ?
                    Icons.visibility_off_outlined : Icons.visibility_outlined, 
                    color: Colors.white,
                  ), 
                  onPressed: () {
                    setState(() {
                      pass = !pass;
                    });
                  }
                ),
                hintStyle: const TextStyle(color: Colors.white, fontSize: 15),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buttons(String nombre, Color color, onPressed) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(left: 20, right: 20),
      alignment: Alignment.center,
      child: Row(
        children: <Widget>[
          Expanded(
            child:  ElevatedButton(
              onPressed: onPressed,
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(color),
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 15,
                  horizontal: 15,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        nombre,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white, 
                          fontWeight: FontWeight.bold,
                          fontSize: 17
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onEmailChanged() {
    _loginBloc.add(EmailChanged(email: _emailController.text));
  }

  void _onPasswordChanged() {
    _loginBloc.add(PasswordChanged(password: _passwordController.text));
  }

  void _onFormSubmitted() {
    _loginBloc.add(LoginWithCredentialsPressed(email: _emailController.text, password: _passwordController.text));
  }
}