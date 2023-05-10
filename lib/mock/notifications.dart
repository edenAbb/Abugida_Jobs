import 'package:et_job/models/notification.dart';

class SNotifications{
  Notifications getNotifications(){
    List<JNotification> notifications = [];
    for(int x = 0; x < 20; x++){
      notifications.add(sampleNotification(x));
    }
    return Notifications.fromNotification(notifications);
  }

  JNotification sampleNotification(int x){
    return  x % 2 == 0 ? getAcceptanceNtfs() : getMoneyNtfs();
  }

  JNotification getAcceptanceNtfs(){
    return  JNotification(id: "hello",title: "Application is Accepted",
        body: "Your application is accepted, we will notify soon",
        date: "Today", type: 1, status: 1);
  }
  JNotification getMoneyNtfs(){
    return  JNotification(id: "hello",title: "Received Money",
        body: "You Received 3.5k Birr From Z-K Group",
        date: "Today", type: 2, status: 1);
  }

}