import 'dart:math';
import 'package:calendar_scheduler_mobile/app/domain/usecases/meeting_usecase.dart';
import 'package:calendar_scheduler_mobile/app/infra/listeners/listener_nonweb.dart'
  if (dart.platform.html) 'package:calendar_scheduler_mobile/app/infra/listeners/listener_web.dart';
import 'package:calendar_scheduler_mobile/app/ui/constants/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';
import 'components/copy_url_component.dart';
import 'resume_meeting.events.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'components/filled_resume_component.dart';
import 'resume_meeting.bloc.dart';

class ResumeMeetingView extends StatefulWidget {
  const ResumeMeetingView({super.key});

  @override
  State<ResumeMeetingView> createState() => _ResumeMeetingViewState();
}

class _ResumeMeetingViewState extends State<ResumeMeetingView> with WidgetsBindingObserver {
  final resumoBloc = ResumeEventBloc();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    resumoBloc.add(const GetResumeEvent());
    if (kIsWeb) {
      addFocusListener(fetchDataWhenStateHasAuthUrl);
    }
  }

  @override
  void didChangeAppLifecycleState(lifeCycleState) async {
    super.didChangeAppLifecycleState(lifeCycleState);
    if (lifeCycleState == AppLifecycleState.resumed && !kIsWeb) {
      fetchDataWhenStateHasAuthUrl();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    resumoBloc.close();
    removeFocusListener(fetchDataWhenStateHasAuthUrl);
    super.dispose();
  }

  void fetchDataWhenStateHasAuthUrl([_]) {
    print('focused');
    if (resumoBloc.state is FilledWithoutGoogleAccessResumeState) {
      resumoBloc.add(const GetResumeEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meeting event'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(kPadding),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: max(MediaQuery.of(context).size.width*0.7, 500)
            ),
            child: BlocBuilder(
              bloc: resumoBloc,
              builder: (context, state) {
                if (state is FilledWithoutGoogleAccessResumeState) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FilledResumeComponent(range: state.range),
                      getBodyTitle('You need to authenticate in google'),
                      const SizedBox(height: kPadding),
                      Center(
                        child: Theme(
                          data: Theme.of(context).copyWith(
                            colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber),
                          ),
                          child: ElevatedButton(
                            child: const Text('Sign in'),
                            onPressed: () => _redirectGoogleAuth(state.authUrl),
                          ),
                        ),
                      ),
                    ],
                  );
                }
                if (state is FilledResumeState) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FilledResumeComponent(range: state.range),
                      getBodyTitle('Share your meeting link'),
                      CopyUrlComponent(url: MeetingUsecase(state.range).generateGuestUrl()),
                    ],
                  );
                }
                if (state is FailedResumeState) {
                  return Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Something wents wrong, please try again',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(height: kPadding),
                        Theme(
                          data: Theme.of(context).copyWith(
                            colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
                          ),
                          child: OutlinedButton(
                            child: const Text('Retry'),
                            onPressed: () async => resumoBloc.add(const GetResumeEvent()),
                          ),
                        ),
                      ],
                    ),
                  );
                }
                if (state is LoadingResumeState) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'You need to create a meeting event \nto share your available time',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: kPadding),
                      TextButton(
                        child: const Text('Create a event'),
                        onPressed: () async {
                          await context.push('/create-event');
                          resumoBloc.add(const GetResumeEvent());
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _redirectGoogleAuth(String url) async {
    await launchUrl(Uri.parse(url));
    resumoBloc.add(const GetResumeEvent());
  }

  Widget getBodyTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: kPadding / 2,
        left: kPadding / 2,
        top: kPadding * 3,
      ),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge,
      ),
    );
  }
}
