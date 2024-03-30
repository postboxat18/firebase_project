import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:meta/meta.dart';

part 'upload_real_time_event.dart';
part 'upload_real_time_state.dart';

class UploadRealTimeBloc extends Bloc<UploadRealTimeEvent, UploadRealTimeState> {
  UploadRealTimeBloc() : super(UploadRealTimeInitial()) {
    on<UploadRealTimeLoadEvent>(uploadRealTimeLoadEvent);
  }

  FutureOr<void> uploadRealTimeLoadEvent(UploadRealTimeLoadEvent event, Emitter<UploadRealTimeState> emit) {
    var ref=FirebaseDatabase.instance.ref('users/-NcCLog_VvKTY1x7Wef4');
    emit(UploadRealTimeLoadState(ref));
  }
}
