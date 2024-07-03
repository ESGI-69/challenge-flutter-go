import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:move_together_app/Provider/auth_provider.dart';
import 'package:move_together_app/router.dart';

class NavigationBarBackoffice extends StatelessWidget implements PreferredSizeWidget {
  const NavigationBarBackoffice({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('Backoffice'),
      actions: [
        TextButton(
          child: const Text('Dashboard', style: TextStyle(color: Colors.black)),
          onPressed: () => backOfficeRouter.go('/'),
        ),
        TextButton(
          child: const Text('Trip', style: TextStyle(color: Colors.black)),
          onPressed: () => backOfficeRouter.go('/trip'),
        ),
        TextButton(
          child: const Text('Logout', style: TextStyle(color: Colors.black)),
          onPressed: () async {
            final authProvider = context.read<AuthProvider>();
            await authProvider.logout();
            backOfficeRouter.go('/');
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
