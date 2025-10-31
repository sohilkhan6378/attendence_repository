import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../controllers/attendance_controller.dart';
import '../../models/attendance_record_model.dart';

/// AttendanceLogView सभी हाज़िरी रिकॉर्ड का इतिहास दिखाती है।
class AttendanceLogView extends StatelessWidget {
  const AttendanceLogView({super.key});

  AttendanceController get _controller => Get.find<AttendanceController>();

  @override
  Widget build(BuildContext context) {
    final DateFormat formatter = DateFormat('dd MMM yyyy, hh:mm a');
    return Scaffold(
      appBar: AppBar(
        title: const Text('हाज़िरी रिपोर्ट'),
      ),
      body: Obx(
        () {
          if (_controller.records.isEmpty) {
            return Center(
              child: Text(
                'अभी तक कोई हाज़िरी रिकॉर्ड उपलब्ध नहीं है।',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            );
          }
          final List<AttendanceRecordModel> records =
              _controller.records.toList().reversed.toList();
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemBuilder: (BuildContext context, int index) {
              final AttendanceRecordModel record = records[index];
              final Color statusColor = record.status == AttendanceStatus.present
                  ? Colors.green
                  : Colors.redAccent;
              return Card(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: statusColor.withOpacity(0.12),
                    child: Icon(
                      record.method == AttendanceMethod.face
                          ? Icons.face_6
                          : record.method == AttendanceMethod.fingerprint
                              ? Icons.fingerprint
                              : Icons.edit_note,
                      color: statusColor,
                    ),
                  ),
                  title: Text(record.employeeName),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(formatter.format(record.timestamp)),
                      Text(record.note),
                    ],
                  ),
                  trailing: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      record.status == AttendanceStatus.present
                          ? 'उपस्थित'
                          : 'अनुपस्थित',
                      style: TextStyle(color: statusColor),
                    ),
                  ),
                ),
              );
            },
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemCount: records.length,
          );
        },
      ),
    );
  }
}
