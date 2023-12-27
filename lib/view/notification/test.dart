//import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_notification_scheduler/firebase_notification_scheduler.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class TestNotification extends StatefulWidget {
  const TestNotification({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<TestNotification> createState() => _TestNotificationState();
}

class _TestNotificationState extends State<TestNotification> {
  ///Rapid API Key: visit https://rapidapi.com/magno-labs-magno-labs-default/api/firebase-notification-scheduler and signup for the service to obtain a key.
  ///AUTHENTICATION KEY: visit https://fns-registration.magnolabs.in after getting rapid API KEY.

  final FirebaseNotificationScheduler firebaseNotificationScheduler =
  FirebaseNotificationScheduler(
      authenticationKey: 'AAAAuxVpEe4:APA91bES_nnM0jeQQUGE2UblyHJmSwGPGT2JG-m1j-UQToaWw5cWpqaKKm9i00rnS4O08_SR5tdv9NPGyMJLTRLKyIdD4MJWAUTeNf7rCyFLIUkbNSyBzTlasSG6oEO412pduZIDz6JM',
      rapidApiKey: 'AAAAuxVpEe4:APA91bES_nnM0jeQQUGE2UblyHJmSwGPGT2JG-m1j-UQToaWw5cWpqaKKm9i00rnS4O08_SR5tdv9NPGyMJLTRLKyIdD4MJWAUTeNf7rCyFLIUkbNSyBzTlasSG6oEO412pduZIDz6JM');

  late Future<List<ScheduledNotification>> getScheduledNotificationFuture;

  @override
  void initState() {
    super.initState();
    getScheduledNotificationFuture =
        firebaseNotificationScheduler.getAllScheduledNotification();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FNS Example'),
      ),
      body: _body(),
    );
  }

  Widget _body() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(child: _scheduleNotificationWidget()),
                const SizedBox(
                  width: 10,
                ),
                Expanded(child: _getScheduledNotificationsButton()),
              ],
            ),
            const Divider(),
            const Text(
              'Your Scheduled notifications',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            _scheduledNotificationList()
          ],
        ),
      ),
    );
  }

  Widget _scheduleNotificationWidget() {
    final String _payload = {
      "registration_ids": [
        "cuzoAtRXSS2kNOKKv-VJfq:APA91bFv8fw75pMBl73mLQOHiCiOYvR45mzjJwMVKMqFq7XBq2Tx1WWSGuVV2hMufSqc1dFnG6QP74v9Y651-HEY1Zl4pgKa3hQkMHrI-qrF93mUXXEKStE723vRMo8nywDJCNnIETAo",
        "fikMQ7ElSVu-ctGrPteDF_:APA91bFmf48qFU8rJHTYhkwIk_MwZo5eLTI_R9q8ps3i5iMSuKjtBFR965pkq0N1SsK_JxSmm3emLakcIGwgDkq-pSPyLQo6HwY4W-iZydlwIN65_w5uN_9Fk531bwUguPxNPvKzYQkK"
      ],
      "notification": {
        "body": "New scheduleTime notification",
        "title": "scheduleTime Notification",
        "android_channel_id": "pushnotificationapp",
        "sound": false

      },
      "scheduleTime" : "2023-12-26T05:23:00Z"
    }.toString();
    final DateTime _now = DateTime.now().toUtc();
    final DateTime _dateTimeInUtc = _now.add(const Duration(seconds: 2));

    return ElevatedButton.icon(
        onPressed: () async {
          debugPrint('scheduling a new notification');
          await firebaseNotificationScheduler.scheduleNotification(
              payload: _payload, dateTimeInUtc: _dateTimeInUtc);
          getScheduledNotificationFuture =
              firebaseNotificationScheduler.getAllScheduledNotification();
          setState(() {});
        },
        icon: const Icon(Icons.add),
        label: const Text('Schedule for next minute'));
  }


  Widget _scheduledNotificationList() {
    return FutureBuilder(
        future: getScheduledNotificationFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
          if (snapshot.hasData) {
            List<ScheduledNotification> data =
            snapshot.data as List<ScheduledNotification>;

            if (data.isEmpty) {
              return const Center(child: Text('No scheduled notifications'));
            }

            return ListView.separated(
                separatorBuilder: (c, i) => const Divider(),
                itemCount: data.length,
                shrinkWrap: true,
                itemBuilder: (buildContext, index) {
                  ScheduledNotification item = data[index];
                  bool isQueued = item.status.contains('QUEUED') ||
                      item.status.contains('READY');
                  return ListTile(
                    title: Text('Scheduled to ' +
                        DateFormat.yMMMMd().add_jm().format(item.sendAt)),
                    subtitle: Text('Status ' + item.status),
                    trailing: isQueued
                        ? TextButton(
                      child: const Text('Cancel'),
                      onPressed: () async {
                        await firebaseNotificationScheduler
                            .cancelNotification(messageId: item.messageId);
                        firebaseNotificationScheduler
                            .getAllScheduledNotification();
                        setState(() {});
                      },
                    )
                        : const SizedBox(
                      width: 0,
                    ),
                  );
                });
          }
          if (snapshot.hasError) {
            return Text(
                "Couldn't fetch your scheduled notifications\n ERROR: ${snapshot.error}");
          }

          return const Text("No data");
        });
  }

  Widget _getScheduledNotificationsButton() {
    return ElevatedButton.icon(
      onPressed: () {
        getScheduledNotificationFuture =
            firebaseNotificationScheduler.getAllScheduledNotification();
        setState(() {});
      },
      icon: const Icon(Icons.refresh),
      label: const Text("Refresh notifications list"),
      style:
      ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.green)),
    );
  }
}