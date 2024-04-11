import 'package:calendar_scheduler_mobile/app/domain/entities/meeting_range.dart';
import 'package:calendar_scheduler_mobile/app/ui/components/bottom_button.dart';
import 'package:calendar_scheduler_mobile/app/ui/components/duration_picker_field.component.dart';
import 'package:calendar_scheduler_mobile/app/ui/components/time_picker_field.component.dart';
import 'package:calendar_scheduler_mobile/app/ui/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'register_meeting.bloc.dart';

class RegisterMeetingView extends StatefulWidget {
  const RegisterMeetingView({super.key});

  @override
  State<RegisterMeetingView> createState() => _RegisterMeetingViewState();
}

class _RegisterMeetingViewState extends State<RegisterMeetingView> {
  late final GlobalKey<FormState> _formKey;
  late final RegisterMeetingBloc bloc;
  final _summaryController = TextEditingController();
  var startTime = TimeOfDay.now();
  var endTime = TimeOfDay.now();
  var duration = Duration.zero;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    bloc = RegisterMeetingBloc();
  }

  @override
  void dispose() {
    _summaryController.dispose();
    super.dispose();
    bloc.close();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegisterMeetingBloc, RegisterMeetingState>(
      bloc: bloc,
      listener: _stateListener,
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Create event'),
            bottom: PreferredSize(
              preferredSize: Size(MediaQuery.of(context).size.width, 4),
              child: Visibility(
                visible: state is LoadingMeetingState,
                child: const LinearProgressIndicator(),
              ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(kPadding),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TimePickerFieldComponent(
                        labelText: 'Start time',
                        onChanged: (time) => startTime = time,
                      ),
                      const VerticalDivider(
                        color: Colors.transparent,
                        width: kPadding,
                      ),
                      TimePickerFieldComponent(
                        labelText: 'End time',
                        onChanged: (time) => endTime = time,
                        validator: _endTimeValidator,
                      ),
                    ],
                  ),
                  DurationPickerFieldComponent(
                    labelText: 'Duration',
                    onChanged: (time) => duration = timeOfDayToDuration(time),
                  ),
                  TextFormField(
                    controller: _summaryController,
                    validator: summaryValidator,
                    decoration: const InputDecoration(
                      labelText: 'Summary',
                    ),
                  ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: BottomButton(
            onTap: _registerEvent,
            title: const Text('REGISTER'),
          ),
        );
      }
    );
  }

  String? _endTimeValidator(_) {
    final end = timeOfDayToDuration(endTime);
    final start = timeOfDayToDuration(startTime);
    if (end.inMinutes <= start.inMinutes) {
      return 'The end time cannot be lower or equal than start time';
    }
    return null;
  }

  String? summaryValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Summary field cannot be empty';
    }
    return null;
  }

  Duration timeOfDayToDuration(TimeOfDay time) => Duration(
    hours: time.hour,
    minutes: time.minute,
  );

  Future<void> _registerEvent() async {
    if (_formKey.currentState?.validate() ?? false) {
      bloc.add(
        SendMeetingEvent(
          MeetingRange(
            summary: _summaryController.text,
            duration: duration,
            start: startTime,
            end: endTime,
          ),
        ),
      );
    }
  }

  void _stateListener(BuildContext context, RegisterMeetingState state) {
    if (state is SuccessMeetingState) {
      Navigator.pop(context, true);
    }
    if (state is ErrorMeetingState) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.message),
          behavior: SnackBarBehavior.floating,
        )
      );
    }
    if (state is RedirectMeetingState) {
      Navigator.pop(context, true);
      launchUrl(Uri.parse(state.url));
    }
  }
}
