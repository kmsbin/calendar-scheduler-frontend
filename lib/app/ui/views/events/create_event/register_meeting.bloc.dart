import 'package:calendar_scheduler_mobile/app/domain/repositories/meeting_repository.dart';
import 'package:calendar_scheduler_mobile/app/infra/exceptions/meeting.dart';
import 'package:calendar_scheduler_mobile/injector.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'register_meeting.events.dart';

export 'register_meeting.events.dart';

class RegisterMeetingBloc extends Bloc<RegisterMeetingEvent, RegisterMeetingState> {
  final meetingRepository = getIt.get<MeetingRepository>();

  RegisterMeetingBloc() : super(const EmptyMeetingState()) {
    on(_sendMeetingRange);
  }

  Future<void> _sendMeetingRange(SendMeetingEvent event, Emitter<RegisterMeetingState> emit) async {
    try {
      emit(const LoadingMeetingState());
      final url = await meetingRepository.registerMeetingRange(event.range);
      emit(RedirectMeetingState(url));
    } on MeetingException catch (e) {
      emit(ErrorMeetingState(e.message));
      debugPrint('Erro ao registrar um range $e');
    } catch (e) {
      emit(const ErrorMeetingState('Something gets wrong'));
      debugPrint('Erro ao registrar um range $e');
    }
  }
}
