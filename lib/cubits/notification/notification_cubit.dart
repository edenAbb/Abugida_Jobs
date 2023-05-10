
import 'package:et_job/models/data.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/job.dart';
import '../../repository/notification.dart';
import 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState>{
  NotificationRepository notificationRepository;
  NotificationCubit({required this.notificationRepository})  : super(NotificationInit());
  Future<void> loadNotification(DataTar dataTar) async {
    emit(LoadingNotification());
    try{
      var notification = await notificationRepository.loadNotifications();
      emit(NotificationLoaded(notification: notification));
    }catch(e){
      emit(NotificationLoadingFailed(error: e.toString()));
    }
  }

  Future<void> updateNotification(String notificationId) async {
    emit(UpdatingNotification());
    try{
      await notificationRepository.updateNotification(notificationId);
      emit(NotificationUpdatedSuccessfully());
    }catch(e){
      emit(NotificationUpdatingFailed(error: e.toString()));
    }
  }
}