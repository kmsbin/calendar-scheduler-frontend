import 'package:bloc/bloc.dart';
import 'package:calendar_scheduler_mobile/app/domain/entities/empty_meeting_range.dart';
import 'package:calendar_scheduler_mobile/app/domain/entities/event_invitation.dart';
import 'package:calendar_scheduler_mobile/app/domain/repositories/meeting_repository.dart';
import 'package:calendar_scheduler_mobile/app/infra/exceptions/meeting_range_exception.dart';
import 'package:calendar_scheduler_mobile/injector.dart';
import 'package:flutter/foundation.dart';
import 'guest_scheduler.events.dart';

class GuestSchedulerBloc extends Bloc<GuestSchedulerEvent, GuestSchedulerState> {
  final meetingRepository = getIt.get<MeetingRepository>();

  GuestSchedulerBloc() : super(GuestSchedulerEmptyState()) {
    on(_fetchListEvents);
    on(_sentGuestInvitation);
  }

  Future<void> _fetchListEvents(GuestSchedulerRequestMeetingsEvent event, Emitter<GuestSchedulerState> emit) async {
    try {
      emit(GuestSchedulerLoadingState());
      final events = await meetingRepository.getEmptyMeetingRange(event.code, event.date);
      emit(GuestSchedulerSuccessGetListState(events, event.date));
    } on MeetingRangeException catch(e) {
      emit(GuestSchedulerErrorState(e.message));
    } catch(_) {
      debugPrint('Erro desconhecido $_');
      emit(GuestSchedulerErrorState('Something wents wrong'));
    }
  }

  Future<void> _sentGuestInvitation(GuestSchedulerRequestScheduleEvent event, Emitter<GuestSchedulerState> emit) async {
    try {
      print('_sentGuestInvitation');
      await meetingRepository.sentEventInvitation(
        event.code, 
        EventInvitation(
          email: event.email, 
          date: event.data.startDate,
        ),
      );
      emit(GuestSchedulerSuccessCreateInvitationState());
      add(GuestSchedulerRequestMeetingsEvent(event.code, event.data.startDate));
    } catch (_) {
      emit(GuestSchedulerErrorState('Something wents wrong'));
    }
  }
}