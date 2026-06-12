import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

import '../firebase/firebase.dart';
import '../models/user_role.dart';
import '../theme/app_theme.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({required this.onContinue, super.key});

  final ValueChanged<UserRole> onContinue;

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final AuthService _authService = AuthService();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();

  UserRole _role = UserRole.maid;
  bool _isLogin = true;
  bool _hidePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _handleAuth() async {
    setState(() => _isLoading = true);
    try {
      User? user;
      if (_isLogin) {
        user = await _authService.signInWithEmail(
          _emailController.text.trim(),
          _passwordController.text.trim(),
        );
      } else {
        user = await _authService.signUpWithEmail(
          _emailController.text.trim(),
          _passwordController.text.trim(),
        );
      }

      if (user != null) {
        Provider.of<AuthProvider>(context, listen: false).setUser(user, _role);
        widget.onContinue(_role);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Authentication failed: ${e.toString()}')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _handleGoogleSignIn() async {
    setState(() => _isLoading = true);
    try {
      User? user = await _authService.signInWithGoogle();
      if (user != null) {
        Provider.of<AuthProvider>(context, listen: false).setUser(user, _role);
        widget.onContinue(_role);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Google sign-in failed: ${e.toString()}')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 28, 20, 28),
          children: [
            const _BrandMark(),
            const SizedBox(height: 28),
            Text(
              _isLogin ? 'Welcome back' : 'Create account',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Choose the correct role so the app opens the right workflow.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.black.withValues(alpha: .6),
              ),
            ),
            const SizedBox(height: 22),
            _RoleSelector(
              selectedRole: _role,
              onChanged: (role) => setState(() => _role = role),
            ),
            const SizedBox(height: 18),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.email_outlined),
                labelText: 'Email',
                hintText: 'email@example.com',
              ),
            ),
            const SizedBox(height: 10),
            if (!_isLogin) ...[
              TextField(
                controller: _nameController,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.person_outline),
                  labelText: 'Full name',
                ),
              ),
              const SizedBox(height: 10),
            ],
            TextField(
              controller: _passwordController,
              obscureText: _hidePassword,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.lock_outline),
                labelText: 'Password',
                suffixIcon: IconButton(
                  tooltip: _hidePassword ? 'Show password' : 'Hide password',
                  onPressed: () {
                    setState(() => _hidePassword = !_hidePassword);
                  },
                  icon: Icon(
                    _hidePassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else ...[
              FilledButton.icon(
                onPressed: _handleAuth,
                icon: Icon(_isLogin ? Icons.login : Icons.person_add_alt),
                label: Text(_isLogin ? 'Login as ${_role.label}' : 'Sign up'),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: _handleGoogleSignIn,
                icon: const Icon(Icons.login),
                label: const Text('Continue with Google'),
              ),
            ],
            const SizedBox(height: 10),
            TextButton(
              onPressed: () => setState(() => _isLogin = !_isLogin),
              child: Text(
                _isLogin
                    ? 'New user? Create account'
                    : 'Already have an account? Login',
              ),
            ),
            const SizedBox(height: 22),
            const _AuthHint(),
          ],
        ),
      ),
    );
  }
}

class _BrandMark extends StatelessWidget {
  const _BrandMark();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 58,
          height: 58,
          decoration: BoxDecoration(
            color: const Color(0xFFE9F1E8),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(
            Icons.local_florist,
            color: AppTheme.seed,
            size: 30,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Sabzi Log', style: Theme.of(context).textTheme.titleLarge),
              Text(
                'Simple proof for daily purchases',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.black.withValues(alpha: .58),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _RoleSelector extends StatelessWidget {
  const _RoleSelector({required this.selectedRole, required this.onChanged});

  final UserRole selectedRole;
  final ValueChanged<UserRole> onChanged;

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<UserRole>(
      segments: const [
        ButtonSegment(
          value: UserRole.maid,
          icon: Icon(Icons.add_a_photo_outlined),
          label: Text('Buyer'),
        ),
        ButtonSegment(
          value: UserRole.owner,
          icon: Icon(Icons.verified_user_outlined),
          label: Text('Owner'),
        ),
      ],
      selected: {selectedRole},
      onSelectionChanged: (selection) => onChanged(selection.first),
    );
  }
}

class _AuthHint extends StatelessWidget {
  const _AuthHint();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF4EA),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline, color: AppTheme.seed),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Now connected to Firebase. Please ensure the Google and Email sign-in providers are enabled in your console.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.black.withValues(alpha: .65),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
