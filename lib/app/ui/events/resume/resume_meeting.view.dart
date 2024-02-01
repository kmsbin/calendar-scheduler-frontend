import 'package:calendar_scheduler_mobile/app/ui/constants/constants.dart';
import 'package:calendar_scheduler_mobile/app/ui/events/resume/resume_meeting.events.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

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
    resumoBloc.add(GetResumeEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Events'),
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
                  Text(
                    state.range.summary,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  Text('Start: ${_padLeft(state.range.start.hour)}h ${_padLeft(state.range.start.minute)}m'),
                  Text('End: ${_padLeft(state.range.end.hour)}h ${_padLeft(state.range.end.minute)}m'),
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
                  ElevatedButton(
                    child: const Text('Create a event'),
                    onPressed: () async {
                      final result = await context.push('/app/create-event');
                      print('result $result');
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

  String _padLeft(int time) {
    return time.toString().padLeft(2, '0');
  }
}
