import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// --- 1. STATE CLASS (Immutable) ---
class StudyState {
  final int sessions;
  final int target;
  final bool isFavorite;
  final bool isFocusMode;
  final String subject;
  final int studyMinutes;

  StudyState({
    required this.sessions,
    required this.target,
    required this.isFavorite,
    required this.isFocusMode,
    required this.subject,
    required this.studyMinutes,
  });

  factory StudyState.initial() {
    return StudyState(
      sessions: 0,
      target: 5,
      isFavorite: false,
      isFocusMode: false,
      subject: "pemrograman mobile",
      studyMinutes: 0,
    );
  }

  StudyState copyWith({
    int? sessions,
    int? target,
    bool? isFavorite,
    bool? isFocusMode,
    String? subject,
    int? studyMinutes,
  }) {
    return StudyState(
      sessions: sessions ?? this.sessions,
      target: target ?? this.target,
      isFavorite: isFavorite ?? this.isFavorite,
      isFocusMode: isFocusMode ?? this.isFocusMode,
      subject: subject ?? this.subject,
      studyMinutes: studyMinutes ?? this.studyMinutes,
    );
  }
}

// --- 2. STATE NOTIFIER ---
class StudyNotifier extends StateNotifier<StudyState> {
  StudyNotifier() : super(StudyState.initial());

  void increment() {
    if (state.sessions < state.target) {
      state = state.copyWith(
        sessions: state.sessions + 1,
        studyMinutes: state.studyMinutes + 25,
      );
    }
  }

  void decrement() {
    if (state.sessions > 0) {
      state = state.copyWith(
        sessions: state.sessions - 1,
        studyMinutes: state.studyMinutes > 0 ? state.studyMinutes - 25 : 0,
      );
    }
  }

  void reset() {
    state = state.copyWith(sessions: 0, studyMinutes: 0);
  }

  void resetAll() {
    state = StudyState.initial();
  }

  void toggleFavorite() {
    state = state.copyWith(isFavorite: !state.isFavorite);
  }

  void toggleFocusMode() {
    state = state.copyWith(isFocusMode: !state.isFocusMode);
  }
}

// --- 3. PROVIDERS ---
final subjectProvider = Provider<String>((ref) => "pemrograman mobile");

final studyProvider =
    StateNotifierProvider<StudyNotifier, StudyState>((ref) {
  return StudyNotifier();
});

// --- 4. MAIN APP ---
void main() {
  runApp(
    const ProviderScope(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: HomePage(),
      ),
    ),
  );
}

// --- 5. UI WIDGETS ---
class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subject = ref.watch(subjectProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F5FF),
      appBar: AppBar(
        title: const Text("Study Progress"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProgressSection(subject: subject),
            const SizedBox(height: 30),
            const Divider(),
            const SettingsSection(),
          ],
        ),
      ),
    );
  }
}

class ProgressSection extends ConsumerWidget {
  final String subject;
  const ProgressSection({super.key, required this.subject});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(studyProvider);
    final notifier = ref.read(studyProvider.notifier);

    double progress = state.target == 0 ? 0 : state.sessions / state.target;
    int percentage = (progress * 100).round();

    String statusText = "0% - Belum Mulai";
    if (percentage > 0 && percentage < 100) {
      statusText = "$percentage% - Sedang Berjalan";
    } else if (percentage >= 100) {
      statusText = "100% - Selesai! Hebat!";
    }

    return Column(
      children: [
        const SizedBox(height: 20),
        Icon(
          state.isFocusMode ? Icons.center_focus_strong : Icons.school,
          size: 60,
          color: state.isFocusMode ? Colors.teal : Colors.red,
        ),
        const SizedBox(height: 10),
        Text(
          subject,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 5),
        const Text("Sesi belajar hari ini", style: TextStyle(fontSize: 16)),
        const SizedBox(height: 10),
        Text(
          "${state.sessions}/${state.target}",
          style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: Colors.purple.shade100,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.purple.shade800),
          minHeight: 10,
        ),
        const SizedBox(height: 10),
        Text(
          statusText,
          style: TextStyle(
            color: Colors.purple.shade800,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FloatingActionButton(
              onPressed: () => notifier.decrement(),
              backgroundColor: Colors.purple.shade200,
              child: Icon(Icons.remove, color: Colors.purple.shade900),
            ),
            const SizedBox(width: 20),
            FloatingActionButton(
              onPressed: () => notifier.increment(),
              backgroundColor: Colors.purple.shade200,
              child: Icon(Icons.add, color: Colors.purple.shade900),
            ),
          ],
        ),
        const SizedBox(height: 15),
        OutlinedButton(
          onPressed: () => notifier.reset(),
          child: const Text("Reset"),
        ),
        const SizedBox(height: 10),
        OutlinedButton(
          onPressed: () => notifier.resetAll(),
          child: const Text("Reset All"),
        ),
      ],
    );
  }
}

class SettingsSection extends ConsumerWidget {
  const SettingsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(studyProvider);
    final notifier = ref.read(studyProvider.notifier);

    return Column(
      children: [
        ListTile(
          title: const Text("Favorite"),
          subtitle: Text(
            state.isFavorite ? "Progress difavoritkan" : "Belum difavoritkan",
          ),
          trailing: IconButton(
            icon: Icon(
              state.isFavorite ? Icons.favorite : Icons.favorite_border,
              color: state.isFavorite ? Colors.red : null,
            ),
            onPressed: () => notifier.toggleFavorite(),
          ),
        ),
        ListTile(
          title: const Text("Focus Mode"),
          subtitle: Text(
            state.isFocusMode
                ? "Focus Mode Aktif"
                : "Focus Mode Tidak Aktif",
          ),
          trailing: Switch(
            value: state.isFocusMode,
            activeColor: Colors.purple,
            onChanged: (val) => notifier.toggleFocusMode(),
          ),
        ),
      ],
    );
  }
}