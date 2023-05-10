import 'package:et_job/models/job.dart';
import 'package:et_job/models/notification.dart';

class NotificationState{}
class NotificationInit extends NotificationState{}

class LoadingNotification extends NotificationState{}
class NotificationLoaded extends NotificationState{
  final Notifications notification;
  NotificationLoaded({required this.notification});
}
class NotificationLoadingFailed extends NotificationState{
  final String error;
  NotificationLoadingFailed({required this.error});
}

class UpdatingNotification extends NotificationState{}
class NotificationUpdatedSuccessfully extends NotificationState{}
class NotificationUpdatingFailed extends NotificationState{
  final String error;
  NotificationUpdatingFailed({required this.error});
}

class RemovingNotification extends NotificationState{}
class NotificationRemovedSuccessfully extends NotificationState{}
class RemovingNotificationFailed extends NotificationState{
  final String error;
  RemovingNotificationFailed({required this.error});
}
