part of 'upload_real_time_bloc.dart';

@immutable
sealed class UploadRealTimeState {}

final class UploadRealTimeInitial extends UploadRealTimeState {}

class UploadRealTimeLoadState extends UploadRealTimeState {
  final ref;

  UploadRealTimeLoadState(this.ref);
}
