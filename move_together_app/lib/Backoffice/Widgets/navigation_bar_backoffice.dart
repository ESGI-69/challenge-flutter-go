import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:move_together_app/Provider/auth_provider.dart';
import 'package:move_together_app/router.dart';
import 'package:go_router/go_router.dart';

class NavigationBarBackoffice extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text('Backoffice'),
      actions: [
        TextButton(
          child: Text('Dashboard', style: TextStyle(color: Colors.black)),
          onPressed: () => backOfficeRouter.go('/'),
        ),
        TextButton(
          child: Text('Trip', style: TextStyle(color: Colors.black)),
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
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
