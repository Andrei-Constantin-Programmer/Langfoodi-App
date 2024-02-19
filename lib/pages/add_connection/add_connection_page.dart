import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe_social_media/pages/add_connection/bloc/add_connection_bloc.dart';
import 'package:recipe_social_media/pages/add_connection/widgets/add_connection_widgets.dart';
import 'package:recipe_social_media/repositories/authentication/auth_repo.dart';
import 'package:recipe_social_media/repositories/conversation/conversation_repo.dart';

class AddConnectionPage extends StatelessWidget {
  const AddConnectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddConnectionBloc(
        context.read<AuthenticationRepository>(),
        context.read<ConversationRepository>()
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Add New Friend"),
          backgroundColor: Theme.of(context).primaryColor,
        ),
        body: Column(
          children: <Widget>[
            const UserSearchInput(),
            Divider(
              color: Theme.of(context).hintColor.withAlpha(40),
              thickness: 3,
              height: 5,
            ),
            const Expanded(child: UserList())
          ],
        ),
      ),
    );
  }
}