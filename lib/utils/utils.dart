import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:logger/screens/download_progress.dart';
import 'package:logger/theme/app_theme.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

String? _activeUpdateDownloadTaskId;
Timer? _updateDownloadWatcher;
bool _isUpdateDownloadDialogVisible = false;

String formatLogTime(String dTime) {
  if (dTime.isEmpty) return '';
  final dateTime = DateTime.parse(dTime);
  final now = DateTime.now();

  if (dateTime.year == now.year &&
      dateTime.month == now.month &&
      dateTime.day == now.day) {
    return 'Today • ${DateFormat('h:mm a').format(dateTime)}';
  }

  final yesterday = now.subtract(const Duration(days: 1));

  if (dateTime.year == yesterday.year &&
      dateTime.month == yesterday.month &&
      dateTime.day == yesterday.day) {
    return 'Yesterday • ${DateFormat('h:mm a').format(dateTime)}';
  }

  return DateFormat('dd MMM yyyy • h:mm a').format(dateTime);
}

int compareVersionCodes(String latestVersion, String currentVersion) {
  final latestParts = latestVersion.split(".").map(int.tryParse).toList();
  final currentParts = currentVersion.split(".").map(int.tryParse).toList();
  final maxLength = latestParts.length > currentParts.length
      ? latestParts.length
      : currentParts.length;

  for (var i = 0; i < maxLength; i++) {
    final latest = i < latestParts.length ? latestParts[i] ?? 0 : 0;
    final current = i < currentParts.length ? currentParts[i] ?? 0 : 0;

    if (latest != current) {
      return latest.compareTo(current);
    }
  }

  return 0;
}

void checkUpdate(BuildContext context) async {
  if (!context.mounted) return;

  try {
    final response = await http.get(
      Uri.parse(
        "https://api.github.com/repos/SoumadeepChoudhury/sabzilog/releases",
      ),
      headers: {"User-Agent": "Flutter-DoIt-App"},
    );

    String url = "";
    String latest_version_code = "";
    if (response.statusCode == 200) {
      // var data = List<Map<String, dynamic>>.from(jsonDecode(response.body));
      var data = jsonDecode(response.body) as List<dynamic>;
      if (data.isNotEmpty) {
        var latestRelease = data[0] as Map<String, dynamic>;
        final tagName = latestRelease["tag_name"].toString();
        latest_version_code = tagName.startsWith("v")
            ? tagName.substring(1)
            : tagName;
        print("LVC: " + latest_version_code);
        String path =
            (await getExternalStorageDirectory())?.path ??
            "/storage/emulated/0/Download";
        await _deleteOldUpdateApks(path, latest_version_code);
        File file = File("$path/app-release-v$latest_version_code.apk");

        final info = await PackageInfo.fromPlatform();
        String current_version_code = info.version;
        print("CVC: " + current_version_code);

        //Compare the two version code and if the latest is greater then print it.
        if (compareVersionCodes(latest_version_code, current_version_code) >
            0) {
          final assets = latestRelease["assets"] as List<dynamic>? ?? [];
          final apkAsset = assets.cast<Map<String, dynamic>?>().firstWhere(
            (asset) => asset?["name"].toString().endsWith(".apk") ?? false,
            orElse: () => null,
          );
          url =
              apkAsset?["browser_download_url"]?.toString() ??
              "https://github.com/SoumadeepChoudhury/sabzilog/releases/download/v$latest_version_code/app-release.apk";

          final existingLatestDownload = await _getExistingUpdateDownloadTask(
            latest_version_code,
          );
          if (existingLatestDownload != null) {
            if (existingLatestDownload.status == DownloadTaskStatus.complete &&
                await file.exists()) {
              _activeUpdateDownloadTaskId = existingLatestDownload.taskId;
              if (!context.mounted) return;
              _showUpdateDownloadDialog(context, existingLatestDownload.taskId);
              return;
            }

            if (existingLatestDownload.status == DownloadTaskStatus.running ||
                existingLatestDownload.status == DownloadTaskStatus.enqueued ||
                existingLatestDownload.status == DownloadTaskStatus.paused) {
              _activeUpdateDownloadTaskId = existingLatestDownload.taskId;
              if (!context.mounted) return;
              _watchUpdateDownload(context, existingLatestDownload.taskId);
              _showUpdateDownloadDialog(context, existingLatestDownload.taskId);
              return;
            }
          }

          if (await file.exists()) {
            try {
              await file.delete();
            } on FileSystemException catch (_) {
              print("Can't delete the file");
            }
          }

          if (!context.mounted) return;
          showDialog(
            context: context,
            barrierDismissible: false,
            barrierColor: Colors.black.withValues(alpha: .65),
            builder: (dialogContext) {
              return Dialog(
                backgroundColor: Colors.transparent,
                elevation: 0,
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(28),
                    color: AppTheme.page,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: .15),
                        blurRadius: 30,
                        offset: const Offset(0, 12),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Hero Icon
                      Container(
                        width: 84,
                        height: 84,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppTheme.seed.withValues(alpha: .12),
                        ),
                        child: Icon(
                          Icons.rocket_launch_rounded,
                          size: 42,
                          color: AppTheme.seed,
                        ),
                      ),

                      const SizedBox(height: 20),

                      Text(
                        'Update Available',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(
                              fontWeight: FontWeight.w900,
                              color: AppTheme.ink,
                            ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        'A faster and more reliable version of SabziLog is ready to install.',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.ink.withValues(alpha: .7),
                          height: 1.5,
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Version Card
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 16,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: Colors.black.withValues(alpha: .05),
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  Text(
                                    current_version_code,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Current',
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            Icon(
                              Icons.arrow_forward_rounded,
                              color: AppTheme.seed,
                            ),

                            Expanded(
                              child: Column(
                                children: [
                                  Text(
                                    latest_version_code,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                          color: AppTheme.seed,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Latest',
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Feature Chips
                      Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _UpdateFeatureChip(
                            icon: Icons.speed_rounded,
                            label: 'Performance',
                          ),
                          _UpdateFeatureChip(
                            icon: Icons.bug_report_outlined,
                            label: 'Bug Fixes',
                          ),
                          _UpdateFeatureChip(
                            icon: Icons.security_outlined,
                            label: 'Security',
                          ),
                        ],
                      ),

                      const SizedBox(height: 28),

                      // Download Button
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: FilledButton.icon(
                          icon: const Icon(Icons.download_rounded),
                          label: const Text(
                            'Download Update',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                          style: FilledButton.styleFrom(
                            backgroundColor: AppTheme.seed,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          onPressed: () async {
                            Navigator.pop(dialogContext);

                            String? taskId = await downloadAndInstallAPK(
                              url,
                              latest_version_code,
                              context,
                            );

                            if (!context.mounted) return;

                            _showUpdateDownloadDialog(context, taskId);
                          },
                        ),
                      ),

                      const SizedBox(height: 8),

                      TextButton(
                        onPressed: () => Navigator.pop(dialogContext),
                        child: Text(
                          'Maybe Later',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }
      }
    }
  } catch (e) {
    print(
      "Failed to connect to GitHub API. Check your internet connection. $e",
    );
    return;
  }
}

class _UpdateFeatureChip extends StatelessWidget {
  const _UpdateFeatureChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.seed.withValues(alpha: .08),
        borderRadius: BorderRadius.circular(99),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppTheme.seed),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: AppTheme.seed,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

Future<String?> downloadAndInstallAPK(
  String apkUrl,
  String version,
  BuildContext context,
) async {
  final savePath =
      (await getExternalStorageDirectory())?.path ??
      (await getApplicationDocumentsDirectory()).path;
  final fileName = "app-release-v$version.apk";
  final notificationPermission = await Permission.notification.request();

  try {
    // Track download completion
    FlutterDownloader.registerCallback(MyDownloader.downloadCallback);

    // Start downloading
    String? taskId = await FlutterDownloader.enqueue(
      url: apkUrl,
      savedDir: savePath,
      fileName: fileName,
      showNotification: notificationPermission.isGranted,
      openFileFromNotification: notificationPermission.isGranted,
    );

    _activeUpdateDownloadTaskId = taskId;
    if (taskId != null && context.mounted) {
      _watchUpdateDownload(context, taskId);
    }

    return taskId;
  } catch (e) {
    print("Failed to start update download.");
    return null;
  }
}

void _showUpdateDownloadDialog(BuildContext context, String? taskId) {
  if (!context.mounted || taskId == null || _isUpdateDownloadDialogVisible) {
    return;
  }

  _isUpdateDownloadDialogVisible = true;
  showDialog(
    context: context,
    barrierColor: Colors.black.withValues(alpha: 0.7),
    barrierDismissible: true,
    builder: (context) => DownloadProgressDialog(taskId: taskId),
  ).whenComplete(() {
    _isUpdateDownloadDialogVisible = false;
  });
}

void _watchUpdateDownload(BuildContext context, String taskId) {
  _updateDownloadWatcher?.cancel();
  _updateDownloadWatcher = Timer.periodic(const Duration(seconds: 1), (
    timer,
  ) async {
    if (!context.mounted) {
      timer.cancel();
      return;
    }

    final tasks = await FlutterDownloader.loadTasks();
    final task = tasks?.cast<DownloadTask?>().firstWhere(
      (task) => task?.taskId == taskId,
      orElse: () => null,
    );

    if (!context.mounted || task == null) {
      if (!context.mounted) timer.cancel();
      return;
    }

    if (task.status == DownloadTaskStatus.complete) {
      timer.cancel();
      _activeUpdateDownloadTaskId = task.taskId;
      _showUpdateDownloadDialog(context, task.taskId);
      return;
    }

    if (task.status == DownloadTaskStatus.failed ||
        task.status == DownloadTaskStatus.canceled) {
      timer.cancel();
      if (_activeUpdateDownloadTaskId == task.taskId) {
        _activeUpdateDownloadTaskId = null;
      }
    }
  });
}

Future<DownloadTask?> _getExistingUpdateDownloadTask(String version) async {
  final tasks = await FlutterDownloader.loadTasks();
  final fileName = 'app-release-v$version.apk';
  final matchingTasks =
      tasks
          ?.where((task) => task.filename == fileName)
          .toList()
          .reversed
          .toList() ??
      [];

  for (final task in matchingTasks) {
    if (task.status == DownloadTaskStatus.running ||
        task.status == DownloadTaskStatus.enqueued ||
        task.status == DownloadTaskStatus.paused) {
      return task;
    }
  }

  for (final task in matchingTasks) {
    if (task.status == DownloadTaskStatus.complete) {
      return task;
    }
  }

  return matchingTasks.isEmpty ? null : matchingTasks.first;
}

Future<void> _deleteOldUpdateApks(
  String directoryPath,
  String latestVersion,
) async {
  final directory = Directory(directoryPath);
  if (!await directory.exists()) return;

  final latestFileName = 'app-release-v$latestVersion.apk';
  await for (final entity in directory.list()) {
    if (entity is! File) continue;

    final fileName = entity.uri.pathSegments.isEmpty
        ? ''
        : entity.uri.pathSegments.last;
    final isUpdateApk =
        fileName.startsWith('app-release-v') && fileName.endsWith('.apk');
    if (!isUpdateApk || fileName == latestFileName) continue;

    try {
      await entity.delete();
    } on FileSystemException catch (_) {
      print("Can't delete old update file");
    }
  }
}

class MyDownloader {
  @pragma('vm:entry-point')
  static void downloadCallback(String id, int status, int progress) async {
    print("$status -> $progress");
    if (progress == 100) {
      print("Downlaod completed");
      // String? filePath = await getDownloadPath();
      // print(filePath);
      // if (filePath != null) {
      // File file = File(
      //     "/storage/emulated/0/Android/data/com.example.xpens-debug/files/");
      // try {
      //   OpenFilex.open(file.path);
      // } catch (e) {
      //   print("Can't open file");
      // }
      // }
    }
  }
}
