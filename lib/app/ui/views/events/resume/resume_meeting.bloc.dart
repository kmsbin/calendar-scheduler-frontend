
import 'package:bloc/bloc.dart';
import 'package:calendar_scheduler_mobile/app/domain/repositories/meeting_repository.dart';
import 'package:calendar_scheduler_mobile/app/infra/exceptions/meeting.dart';
import 'package:calendar_scheduler_mobile/injector.dart';
import 'package:flutter/cupertino.dart';

import 'resume_meeting.events.dart';

class ResumeEventBloc extends Bloc<ResumeEvent, ResumeState> {
  final meetingRepository = getIt.get<MeetingRepository>();

  ResumeEventBloc([super.initialState = const EmptyResumeState()]) {
    on(_fetchData);
  }

  Future<void> _fetchData(ResumeEvent event, Emitter<ResumeState> emit) async {
    try {
      emit(const LoadingResumeState());
      final meeting = await meetingRepository.getMeeting();
      if (meeting != null) {
        return emit(FilledResumeState(meeting));
      }
      emit(const EmptyResumeState());
    } on MeetingNotFoundedException {
      emit(const EmptyResumeState());
    } catch(e,s ) {
      debugPrint('Erro ao buscar $e, $s');
      emit(const EmptyResumeState());
    }
  }
}