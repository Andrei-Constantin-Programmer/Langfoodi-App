import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe_social_media/pages/register/register_bloc.dart';
import 'package:recipe_social_media/repositories/authentication/auth_repo.dart';
import 'package:recipe_social_media/utilities/utilities.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
            reverse: true,
            child: Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Column(children: <Widget>[
                  Container(
                    key: const Key("registerPageBgImg"),
                    height: 350,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("assets/images/background.png"),
                          fit: BoxFit.fill),
                    ),
                    child: Stack(
                      children: <Widget>[
                        Positioned(
                          child: Center(
                            child: Text("Welcome", style: Theme.of(context).textTheme.displayLarge),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: BlocProvider<RegisterBloc>(
                          create: (_) => RegisterBloc(
                            authRepo: context.read<AuthenticationRepository>(),
                            networkManager: context.read<NetworkManager>()
                          ),
                          child: const RegisterForm()))
                ]))));
  }
}
