import 'package:calendar_scheduler_mobile/app/domain/usecases/auth_usecase.dart';
import 'package:calendar_scheduler_mobile/app/ui/constants/constants.dart';
import 'package:calendar_scheduler_mobile/app/ui/views/user/components/user_card.component.dart';
import 'package:calendar_scheduler_mobile/app/ui/views/user/user.bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'user.events.dart';

class UserView extends StatefulWidget {
  const UserView({super.key});

  @override
  State<UserView> createState() => _UserViewState();
}

class _UserViewState extends State<UserView> {
  late final UserBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = UserBloc()
      ..add(const GetUserEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      backgroundColor: const Color(0xfffafafa),
      body: Padding(
        padding: const EdgeInsets.all(kPadding),
        child: BlocBuilder<UserBloc, UserState>(
          bloc: bloc,
          builder: (context, state) {
            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (state case GetUserState(:final user)) ...[
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            UserCardComponent(
                              title: 'Name',
                              value: user.name,
                            ),
                            const Divider(
                              height: kPadding,
                              color: Colors.transparent,
                            ),
                            UserCardComponent(
                              title: 'E-mail',
                              value: user.email,
                            ),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          ListTile(
                            onTap: deleteAccount,
                            title: const Text('Delete account', style: TextStyle(color: Colors.red),),
                            trailing: const Icon(Icons.delete_forever_rounded, color: Colors.red),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: kPadding),
                            child: Divider(),
                          ),
                          ListTile(
                            onTap: signOut,
                            title: const Text('Sign out'),
                            trailing: const Icon(Icons.logout_rounded),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> deleteAccount() async {

  }

  Future<void> signOut() async {
    await AuthUsecase().signOut();
  }

}
