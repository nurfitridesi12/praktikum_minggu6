import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../notifiers/study_notifier.dart';

class StudyProgressScreen extends ConsumerWidget {
  const StudyProgressScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final study = ref.watch(studyProvider);
    
    // Cek apakah sudah selesai (5/5)
    final isCompleted = study.currentProgress == study.totalProgress;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F5FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8F5FF),
        elevation: 0,
        title: const Text(
          'Study Progress',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const SizedBox(height: 30),

              // Icon - berubah jadi hijau kalau selesai
              Icon(
                isCompleted 
                    ? Icons.check_circle_outline 
                    : (study.isFavorite ? Icons.center_focus_strong : Icons.school),
                size: 60,
                color: isCompleted 
                    ? Colors.green 
                    : (study.isFavorite ? Colors.teal : Colors.red),
              ),
              const SizedBox(height: 20),

              // Subject Name
              Text(
                study.subject,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 10),

              // Session Label
              const Text(
                'Sesi belajar hari ini',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 15),

              // Progress Counter
              Text(
                '${study.currentProgress}/${study.totalProgress}',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: isCompleted ? Colors.green : Colors.black87,
                ),
              ),
              const SizedBox(height: 15),

              // Progress Bar - berubah jadi hijau kalau selesai
              Column(
                children: [
                  LinearProgressIndicator(
                    value: study.currentProgress / study.totalProgress,
                    backgroundColor: Colors.purple.shade100,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      isCompleted ? Colors.green : Colors.purple.shade700,
                    ),
                    minHeight: 8,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    isCompleted 
                        ? '100% - Selesai! 🎉' 
                        : '${study.progressPercentage}% - ${study.progressStatus}',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isCompleted ? Colors.green : Colors.purple.shade700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // +/- Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildCircleButton(
                    icon: Icons.remove,
                    onPressed: study.currentProgress > 0
                        ? () => ref
                            .read(studyProvider.notifier)
                            .decrementProgress()
                        : null,
                    color: isCompleted ? Colors.green.shade100 : Colors.purple.shade100,
                    isCompleted: isCompleted,
                  ),
                  const SizedBox(width: 20),
                  _buildCircleButton(
                    icon: Icons.add,
                    onPressed: study.currentProgress < study.totalProgress
                        ? () => ref
                            .read(studyProvider.notifier)
                            .incrementProgress()
                        : null,
                    color: isCompleted ? Colors.green.shade100 : Colors.purple.shade100,
                    isCompleted: isCompleted,
                  ),
                ],
              ),
              const SizedBox(height: 15),

              // Reset Button
              OutlinedButton(
                onPressed: () =>
                    ref.read(studyProvider.notifier).resetProgress(),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 30, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  side: BorderSide(
                    color: isCompleted ? Colors.green.shade300 : Colors.purple.shade300,
                  ),
                ),
                child: Text(
                  'Reset',
                  style: TextStyle(
                    color: isCompleted ? Colors.green.shade700 : Colors.purple.shade700,
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Reset All Button
              OutlinedButton(
                onPressed: () =>
                    ref.read(studyProvider.notifier).resetAll(),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 30, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  side: BorderSide(
                    color: isCompleted ? Colors.green.shade300 : Colors.purple.shade300,
                  ),
                ),
                child: Text(
                  'Reset All',
                  style: TextStyle(
                    color: isCompleted ? Colors.green.shade700 : Colors.purple.shade700,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Divider
              const Divider(),
              const SizedBox(height: 5),

              // Favorite Section
              ListTile(
                title: const Text("Favorite"),
                subtitle: Text(
                  study.isFavorite
                      ? " Progress difavoritkan"
                      : " Belum difavoritkan",
                ),
                trailing: IconButton(
                  onPressed: () {
                    ref.read(studyProvider.notifier).toggleFavorite();
                  },
                  icon: Icon(
                    study.isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: study.isFavorite ? Colors.red : Colors.grey,
                  ),
                ),
              ),
              const Divider(),

              // Focus Mode Section
              SwitchListTile(
                title: const Text("Focus Mode"),
                subtitle: Text(
                  study.focusMode
                      ? " Focus Mode Aktif"
                      : " Focus Mode Tidak Aktif",
                ),
                value: study.focusMode,
                onChanged: (_) {
                  ref.read(studyProvider.notifier).toggleFocus();
                },
                activeColor: isCompleted ? Colors.green : Colors.purple.shade700,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCircleButton({
    required IconData icon,
    required VoidCallback? onPressed,
    required Color color,
    required bool isCompleted,
  }) {
    return Material(
      color: color,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onPressed,
        customBorder: const CircleBorder(),
        child: Container(
          width: 45,
          height: 45,
          alignment: Alignment.center,
          child: Icon(
            icon,
            color: onPressed != null 
                ? (isCompleted ? Colors.green.shade700 : Colors.purple.shade700) 
                : Colors.grey,
            size: 22,
          ),
        ),
      ),
    );
  }
}