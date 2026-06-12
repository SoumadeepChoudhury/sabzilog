import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:logger/theme/app_theme.dart';
import 'package:permission_handler/permission_handler.dart';

class DownloadProgressDialog extends StatefulWidget {
  final String? taskId;

  const DownloadProgressDialog({super.key, required this.taskId});

  @override
  State<DownloadProgressDialog> createState() => _DownloadProgressDialogState();
}

class _DownloadProgressDialogState extends State<DownloadProgressDialog> {
  double _progress = 0.0;
  DownloadTaskStatus? _status;
  Timer? _progressTimer;
  bool _isOpeningInstaller = false;

  @override
  void initState() {
    super.initState();
    if (widget.taskId == null) {
      _status = DownloadTaskStatus.failed;
    } else {
      _startProgressTracking();
    }
  }

  @override
  void dispose() {
    _progressTimer?.cancel();
    super.dispose();
  }

  void _startProgressTracking() {
    _refreshProgress();
    _progressTimer = Timer.periodic(const Duration(milliseconds: 700), (_) {
      _refreshProgress();
    });
  }

  Future<void> _refreshProgress() async {
    if (widget.taskId == null) return;

    final tasks = await FlutterDownloader.loadTasks();
    final task = tasks?.cast<DownloadTask?>().firstWhere(
      (task) => task?.taskId == widget.taskId,
      orElse: () => null,
    );

    if (!mounted || task == null) return;

    final progress = task.progress < 0 ? 0 : task.progress.clamp(0, 100);
    setState(() {
      _progress = progress / 100;
      _status = task.status;
    });

    if (task.status == DownloadTaskStatus.complete ||
        task.status == DownloadTaskStatus.failed ||
        task.status == DownloadTaskStatus.canceled) {
      _progressTimer?.cancel();
    }
  }

  Future<void> _openInstaller() async {
    if (widget.taskId == null || _isOpeningInstaller) return;

    setState(() {
      _isOpeningInstaller = true;
    });

    try {
      final installPermission = await Permission.requestInstallPackages
          .request();
      if (!installPermission.isGranted) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                "Please allow app installs to continue the update.",
              ),
            ),
          );
        }
        return;
      }

      await FlutterDownloader.open(taskId: widget.taskId!);
    } finally {
      if (mounted) {
        setState(() {
          _isOpeningInstaller = false;
        });
      }
    }
  }

  String get _statusText {
    if (_status == DownloadTaskStatus.complete) return "Download complete";
    if (_status == DownloadTaskStatus.failed) return "Download failed";
    if (_status == DownloadTaskStatus.canceled) return "Download canceled";
    if (_status == DownloadTaskStatus.paused) return "Download paused";
    if (_status == DownloadTaskStatus.enqueued) return "Waiting to start";
    return "Downloading update";
  }

  @override
  Widget build(BuildContext context) {
    final isComplete = _status == DownloadTaskStatus.complete;
    final isFinished =
        _status == DownloadTaskStatus.complete ||
        _status == DownloadTaskStatus.failed ||
        _status == DownloadTaskStatus.canceled;

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppTheme.page,
          borderRadius: BorderRadius.circular(28),
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
            /// Hero Icon
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isComplete
                    ? Colors.green.withValues(alpha: .12)
                    : _status == DownloadTaskStatus.failed
                    ? Colors.red.withValues(alpha: .12)
                    : AppTheme.seed.withValues(alpha: .12),
              ),
              child: Icon(
                isComplete
                    ? Icons.check_circle_rounded
                    : _status == DownloadTaskStatus.failed
                    ? Icons.error_rounded
                    : Icons.download_rounded,
                size: 46,
                color: isComplete
                    ? Colors.green
                    : _status == DownloadTaskStatus.failed
                    ? Colors.red
                    : AppTheme.seed,
              ),
            ),

            const SizedBox(height: 20),

            /// Title
            Text(
              _statusText,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w900,
                color: AppTheme.ink,
              ),
            ),

            const SizedBox(height: 24),

            /// Progress Card
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: Colors.black.withValues(alpha: .05)),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(Icons.downloading_rounded, size: 18),
                      const SizedBox(width: 8),
                      const Text(
                        'Download Progress',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                      const Spacer(),
                      Text(
                        "${(_progress * 100).toStringAsFixed(0)}%",
                        style: TextStyle(
                          color: AppTheme.seed,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  ClipRRect(
                    borderRadius: BorderRadius.circular(999),
                    child: LinearProgressIndicator(
                      minHeight: 10,
                      value: widget.taskId == null && !isFinished
                          ? null
                          : _progress,
                      backgroundColor: Colors.grey.shade200,
                      valueColor: AlwaysStoppedAnimation(
                        isComplete
                            ? Colors.green
                            : _status == DownloadTaskStatus.failed
                            ? Colors.red
                            : AppTheme.seed,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            /// Info Message
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppTheme.seed.withValues(alpha: .08),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.info_outline, size: 18, color: AppTheme.seed),

                  const SizedBox(width: 10),

                  Expanded(
                    child: Text(
                      isComplete
                          ? "Download completed successfully. Tap Install Update to continue."
                          : _status == DownloadTaskStatus.failed
                          ? "Something went wrong while downloading the update. Please try again."
                          : _status == DownloadTaskStatus.canceled
                          ? "The download was canceled."
                          : "Please keep SabziLog open while the update downloads.",
                      style: TextStyle(
                        color: AppTheme.ink.withValues(alpha: .75),
                        height: 1.5,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            /// Action Button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: FilledButton.icon(
                icon: _isOpeningInstaller
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Icon(
                        isComplete
                            ? Icons.install_mobile_rounded
                            : isFinished
                            ? Icons.close_rounded
                            : Icons.cancel_outlined,
                      ),
                label: Text(
                  _isOpeningInstaller
                      ? "OPENING..."
                      : isComplete
                      ? "INSTALL UPDATE"
                      : isFinished
                      ? "CLOSE"
                      : "CANCEL DOWNLOAD",
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                style: FilledButton.styleFrom(
                  backgroundColor: isComplete
                      ? AppTheme.seed
                      : isFinished
                      ? Colors.grey.shade700
                      : Colors.red.shade400,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: _isOpeningInstaller
                    ? null
                    : isComplete
                    ? _openInstaller
                    : isFinished
                    ? () => Navigator.pop(context)
                    : () {
                        if (widget.taskId != null) {
                          FlutterDownloader.cancel(taskId: widget.taskId!);
                        }
                        Navigator.pop(context);
                      },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
