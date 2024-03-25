import 'package:calendar_scheduler_mobile/app/domain/usecases/meeting_usecase.dart';
import 'package:calendar_scheduler_mobile/app/ui/components/home_bottom.component.dart';
import 'package:calendar_scheduler_mobile/app/ui/constants/constants.dart';
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

class _ResumeMeetingViewState extends State<ResumeMeetingView> {
  final resumoBloc = ResumeEventBloc();

  @override
  void initState() {
    super.initState();
    resumoBloc.add(const GetResumeEvent());
  }
  @override
  void dispose() {
    super.dispose();
    resumoBloc.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meeting event'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(kPadding),
        child: BlocBuilder(
          bloc: resumoBloc,
          builder: (context, state) {
            if (state is FilledResumeState) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FilledResumeComponent(range: state.range),
                  Padding(
                    padding: const EdgeInsets.only(
                      bottom: kPadding/2,
                      left: kPadding/2,
                      top: kPadding*3,
                    ),
                    child: Text(
                      'Share your meeting link',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  CopyUrlComponent(url: MeetingUsecase(state.range).generateGuestUrl()),
                ],
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
                      await context.push('/app/create-event');
                      resumoBloc.add(const GetResumeEvent());
                    },
                  ),
                ],
              ),
            );
          }
        ),
      ),
    );
  }
}
