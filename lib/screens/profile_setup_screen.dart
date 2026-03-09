import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/profile_provider.dart';
import '../theme/app_theme.dart';
import 'home_screen.dart';

const _avatars = [
  '🦊', '🐸', '🐱', '🐶', '🐯', '🐻',
  '🦁', '🐼', '🐨', '🐰', '🐧', '🦄',
  '🐲', '🦋', '🐬', '🐙', '🦝', '🐺',
];

class ProfileSetupScreen extends ConsumerStatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  ConsumerState<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends ConsumerState<ProfileSetupScreen> {
  final _nameController = TextEditingController();
  String _selectedAvatar = '🦊';
  bool _submitted = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _onStart() {
    setState(() => _submitted = true);
    final name = _nameController.text.trim();
    if (name.isEmpty) return;
    ref.read(profileProvider.notifier).saveProfile(name, _selectedAvatar);
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, _, _) => const HomeScreen(),
        transitionsBuilder: (_, anim, _, child) =>
            FadeTransition(opacity: anim, child: child),
        transitionDuration: const Duration(milliseconds: 600),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final nameEmpty = _submitted && _nameController.text.trim().isEmpty;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 16),

              // Title
              Text(
                'Benvenuto! 👋',
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      color: AppColors.primary,
                    ),
                textAlign: TextAlign.center,
              ).animate().fadeIn(duration: 600.ms).slideY(begin: -0.3),

              const SizedBox(height: 8),
              Text(
                "Let's set up your profile",
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                textAlign: TextAlign.center,
              ).animate().fadeIn(delay: 200.ms, duration: 500.ms),

              const SizedBox(height: 40),

              // Selected avatar preview
              Text(
                _selectedAvatar,
                style: const TextStyle(fontSize: 90),
              )
                  .animate(key: ValueKey(_selectedAvatar))
                  .scale(
                    duration: 300.ms,
                    curve: Curves.elasticOut,
                    begin: const Offset(0.5, 0.5),
                  )
                  .animate()
                  .fadeIn(delay: 300.ms, duration: 400.ms),

              const SizedBox(height: 28),

              // Name field
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "What's your name?",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ).animate().fadeIn(delay: 400.ms, duration: 400.ms),

              const SizedBox(height: 10),

              TextField(
                controller: _nameController,
                onChanged: (_) => setState(() {}),
                textCapitalization: TextCapitalization.words,
                style: const TextStyle(fontSize: 20),
                decoration: InputDecoration(
                  hintText: 'Enter your name...',
                  errorText: nameEmpty ? 'Please enter your name!' : null,
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide(
                        color: AppColors.primaryLight.withValues(alpha: 0.5),
                        width: 2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide:
                        const BorderSide(color: AppColors.primary, width: 2.5),
                  ),
                ),
              ).animate().fadeIn(delay: 500.ms, duration: 400.ms),

              const SizedBox(height: 32),

              // Avatar picker
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Pick your avatar!',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ).animate().fadeIn(delay: 600.ms, duration: 400.ms),

              const SizedBox(height: 12),

              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 6,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: _avatars.length,
                itemBuilder: (context, index) {
                  final avatar = _avatars[index];
                  final selected = avatar == _selectedAvatar;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedAvatar = avatar),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      decoration: BoxDecoration(
                        color: selected
                            ? AppColors.primary.withValues(alpha: 0.15)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: selected
                              ? AppColors.primary
                              : Colors.transparent,
                          width: 3,
                        ),
                        boxShadow: selected
                            ? [
                                BoxShadow(
                                  color:
                                      AppColors.primary.withValues(alpha: 0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                )
                              ]
                            : null,
                      ),
                      child: Center(
                        child: Text(
                          avatar,
                          style: TextStyle(
                              fontSize: selected ? 30 : 26),
                        ),
                      ),
                    ),
                  );
                },
              ).animate().fadeIn(delay: 700.ms, duration: 400.ms),

              const SizedBox(height: 40),

              // Start button
              SizedBox(
                width: double.infinity,
                height: 65,
                child: ElevatedButton(
                  onPressed: _onStart,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(22),
                    ),
                    elevation: 6,
                    shadowColor: AppColors.primary.withValues(alpha: 0.4),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _selectedAvatar,
                        style: const TextStyle(fontSize: 26),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        "Let's go!",
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ).animate().fadeIn(delay: 900.ms, duration: 400.ms),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
