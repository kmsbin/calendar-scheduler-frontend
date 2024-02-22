import 'package:calendar_scheduler_mobile/app/domain/entities/empty_meeting_range.dart';
import 'package:calendar_scheduler_mobile/app/ui/constants/constants.dart';
import 'package:calendar_scheduler_mobile/app/ui/guest_scheduler/guest_scheduler.bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'guest_scheduler.events.dart';

class GuestEventView extends StatefulWidget {
  final String code;

  const GuestEventView(this.code, {super.key});

  @override
  State<GuestEventView> createState() => _GuestEventViewState();
}

class _GuestEventViewState extends State<GuestEventView> {
  late final GuestSchedulerBloc bloc;
  final timeFormatter = DateFormat('HH:mm').format;
  var selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    bloc = GuestSchedulerBloc()
      ..add(GuestSchedulerRequestMeetingsEvent(widget.code, selectedDate));
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register in event'),
      ),
      body: BlocConsumer<GuestSchedulerBloc, GuestSchedulerState>(
        bloc: bloc,
        listener: _blocListener,
        builder: (context, state) {
          return Flex(
            direction: size.width > size.height
              ? Axis.horizontal
              : Axis.vertical,
            children: [
              Flexible(
                child: TableCalendar(
                  firstDay: DateTime.now(),
                  lastDay: DateTime.now().add(const Duration(days: 365)),
                  focusedDay: selectedDate,
                  headerStyle: const HeaderStyle(titleCentered: true, formatButtonVisible: false),
                  onDaySelected: (date, _) => setDate(date),
                  selectedDayPredicate: (day) => isSameDay(day, selectedDate),
                ),
              ),
              if (state is GuestSchedulerLoadingState)
                const Expanded(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              else if (state is GuestSchedulerSuccessGetListState && state.itens.isNotEmpty)
                Flexible(
                  child: ListView.builder(
                    itemCount: state.itens.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        onTap: () => _sendInviteToScheduledSpace(state.itens[index]),
                        title: Text('${timeFormatter(state.itens[index].startDate)} - ${timeFormatter(state.itens[index].endDate)}'),
                        contentPadding: const EdgeInsets.symmetric(horizontal: kPadding),
                        shape: Border(
                          bottom: BorderSide(
                            color: Colors.black.withAlpha(0x1F),
                            width: 1,
                          ),
                        ),
                      );
                    },
                  ),
                )
              else 
                const Expanded(
                  child: Center(
                    child: Text('All scheduled times alloweds went fillers'),
                  ),
                ),
            ],
          );
        },
      )
    );
  }

  void _blocListener(BuildContext context, GuestSchedulerState state) {
    if (state is GuestSchedulerErrorState) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.message),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
    if (state is GuestSchedulerSuccessCreateInvitationState) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invitation created with success!'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void setDate(DateTime date) {
    if (selectedDate.difference(date).inMinutes.abs() > 0) {
      setState(() => selectedDate = date);
      bloc.add(GuestSchedulerRequestMeetingsEvent(widget.code, selectedDate));
    }
  }

  Future<(String?, bool)> showShouldSentInvitation() async {
    final textController = TextEditingController();
    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Email to send the invitation'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Enter an email address to send the Google Calendar invitation'),
              TextFormField(
                controller: textController,
                decoration: const InputDecoration(
                    labelText: 'Email'
                ),
              )
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('sent'),
            ),
          ],
        );
      },
    );
    return (textController.text, result ?? false);
  }

  Future<void> _sendInviteToScheduledSpace(EmptyMeetingRange item) async {
    final (email, shouldSent) = await showShouldSentInvitation();
    print('($email, $shouldSent)');
    if (!shouldSent || email == null || email.isEmpty) return;
    bloc.add(
      GuestSchedulerRequestScheduleEvent(
        code: widget.code,
        email: email,
        data: item,
      ),
    );
  }
}
