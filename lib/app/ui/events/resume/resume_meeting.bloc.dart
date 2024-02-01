
import 'package:bloc/bloc.dart';
import 'package:calendar_scheduler_mobile/app/domain/repositories/meeting_repository.dart';
import 'package:calendar_scheduler_mobile/injector.dart';
import 'package:flutter/cupertino.dart';

import 'resume_meeting.events.dart';

class ResumeEventBloc extends Bloc<ResumeEvent, ResumeState> {
  final meetingRepository = getIt.get<MeetingRepository>();

  ResumeEventBloc() : super(EmptyResumeState()) {
    on(_fetchData);
  }

  Future<void> _fetchData(ResumeEvent event, Emitter<ResumeState> emit) async {
    try {
      emit(LoadingResumeState());
      final meeting = await meetingRepository.getMeeting();
      if (meeting != null) {
        return emit(FilledResumeState(meeting));
      }
      emit(EmptyResumeState());
    } catch(e) {
      debugPrint('Erro ao buscar ');
      emit(EmptyResumeState());
    }
  }
}