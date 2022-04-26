import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:santiago4x4pro/bloc/authentication_bloc/bloc.dart';
import 'package:santiago4x4pro/bloc/registro_bloc/bloc.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({Key? key}) : super(key: key);

  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  late RegisterBloc _registerBloc;

  bool pass = false;

  // bool get isPopulated => _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty;

  bool isRegisterButtonEnabled(RegisterState state) {
    return state.isFormValid && !state.isSubmitting;
  }

  @override
  void initState() {
    super.initState();
    _registerBloc = BlocProvider.of<RegisterBloc>(context);
    _emailController.addListener(_onEmailChanged);
    _passwordController.addListener(_onPasswordChanged);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterBloc, RegisterState>(
      listener: (context, state) {
      if (state.isFailure) {
        Scaffold.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text('Registro fallido'), 
                  Icon(Icons.error)
                ],
              ),
              backgroundColor: Colors.red,
            ),
          );
      }
      if (state.isEmailDuplicate) {
        Scaffold.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
          SnackBar(
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text('El correo ya esta en uso'),
                Icon(Icons.error),
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
                Text('Registrando...'),
                CircularProgressIndicator(),
              ],
            ),
          )
        );
      }
      if (state.isSuccess) {
        BlocProvider.of<AuthenticationBloc>(context).add(LoggedIn());
        Navigator.of(context).pop();
      }
    }, child: BlocBuilder<RegisterBloc, RegisterState>(builder: (context, state) {
      return Stack(
        children: [
          Scaffold(
            extendBodyBehindAppBar : true,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0.0,
            ),
            body: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/jeeps.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: ListView(
                      children:  [
                        const Padding(
                          padding: EdgeInsets.only(top: 30),
                          child: Center(
                            child:  Text(
                              "Registro",
                              style: TextStyle(
                                fontSize: 35,
                                color: Colors.white
                              ),
                            )
                          ),
                        ),
                        const SizedBox(height: 50),
                        _input('Nombre', 'Nombre invalido', _nameController, TextInputType.text, Icons.person_outline, 10, false, false),
                        const SizedBox(height: 15),
                        _input('Telefono', 'Telefono invalido', _phoneController, TextInputType.phone, Icons.phone_outlined, 10, false, false),
                        const SizedBox(height: 15),
                        _input('Correo', 'Correo invalido', _emailController, TextInputType.emailAddress, Icons.email_outlined, 100, false, false),
                        const SizedBox(height: 15),
                        _inputPassword('Contraseña', 'Contraseña invalida', TextInputType.visiblePassword, _passwordController, Icons.vpn_key_outlined),
                        const SizedBox(height: 30),
                        _button('Registrar', const Color.fromRGBO(44, 197, 94, 1), _onFormSubmitted),
                      ],
                    )
                  )
                ]
              )
            ),
          ),
        ],
      );
    }));
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

  Widget _input(String placeholder, String mensaje,  TextEditingController controller, TextInputType tipo, IconData icon, int max, [bool isPassword = false, bool isfocus = false]) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 60,
      margin: const EdgeInsets.only(left: 15, right: 15),
      alignment: Alignment.center,
      decoration: kBoxDecorationStyle,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: TextFormField(
              autofocus: isfocus,
              controller: controller,
              obscureText: isPassword,
              autovalidateMode: AutovalidateMode.always,
              style: const TextStyle(color: Colors.white, fontSize: 18),
              autocorrect: false,
              keyboardType: tipo,
              maxLength: max,
              decoration: InputDecoration(
                counterText: '',
                prefixIcon: Icon(icon, color: Colors.white),
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
      margin: const EdgeInsets.only(left: 15, right: 15),
      height: 60,
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

  Widget _button(String nombre, Color color, onPressed) {
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

  void _onEmailChanged() {
    _registerBloc.add(EmailChanged(email: _emailController.text));
  }

  void _onPasswordChanged() {
    _registerBloc.add(PasswordChanged(password: _passwordController.text));
  }

  void _onFormSubmitted() {
    _registerBloc.add(
        Submitted(
        email: _emailController.text,
        password: _passwordController.text,
        dateBorn: '',
        image: '',
        insurance: '',
        name: _nameController.text,
        phone: _phoneController.text,
        socio: '0',
        typeBlood: '',
        auto: '0',
        uid: ''
      )
    );
  }
}
