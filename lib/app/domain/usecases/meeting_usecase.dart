import 'package:calendar_scheduler_mobile/app/domain/entities/meeting_range.dart';
import 'package:calendar_scheduler_mobile/app/infra/repositories/constants.dart';

class MeetingUsecase {
  final MeetingRange range;
  
  const MeetingUsecase(this.range);
  
  String generateGuestUrl() {
    final buffer = StringBuffer(apiUrl)
      ..write('/guest/')
      ..write(range.code);
    return buffer.toString();
  }
}