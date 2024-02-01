import 'package:calendar_scheduler_mobile/app/domain/entities/meeting_range.dart';
import 'package:calendar_scheduler_mobile/app/domain/repositories/meeting_repository.dart';
import 'package:calendar_scheduler_mobile/injector.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

sealed class RegisterMeetingEvent {}
final class LoadingMeetingEvent extends RegisterMeetingEvent {}
final class SendMeetingEvent extends LoadingMeetingEvent {
  final MeetingRange range;
  SendMeetingEvent(this.range);
}

sealed class RegisterMeetingState {}
final class EmptyMeetingState extends RegisterMeetingState {}
final class LoadingMeetingState extends RegisterMeetingState {}
final class SuccessMeetingState extends RegisterMeetingState {}

class RegisterMeetingBloc extends Bloc<RegisterMeetingEvent, RegisterMeetingState> {
  final meetingRepository = getIt.get<MeetingRepository>();

  RegisterMeetingBloc() : super(EmptyMeetingState()) {
    on(_sendMeetingRange);
  }

  Future<void> _sendMeetingRange(SendMeetingEvent event, Emitter<RegisterMeetingState> emit) async {
    try {
      emit(LoadingMeetingState());
      await meetingRepository.registerMeetingRange(event.range);
      emit(SuccessMeetingState());
    } catch (e) {
      debugPrint('Erro ao registrar um range $e');
    }
  }
}