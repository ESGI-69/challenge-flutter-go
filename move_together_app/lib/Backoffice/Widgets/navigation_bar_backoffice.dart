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
          child: Text('Dashboard', style: TextStyle(color: Theme.of(context).primaryColor)),
          onPressed: () => backOfficeRouter.replaceNamed('dashboard'),
        ),
        TextButton(
          child: Text('Trip', style: TextStyle(color: Theme.of(context).primaryColor)),
          onPressed: () => backOfficeRouter.replaceNamed('trip'),
        ),
        TextButton(
          child: Text('Logs', style: TextStyle(color: Theme.of(context).primaryColor)),
          onPressed: () => backOfficeRouter.replaceNamed('logs'),
        ),
        TextButton(
          child: Text('Users', style: TextStyle(color: Theme.of(context).primaryColor)),
          onPressed: () => backOfficeRouter.replaceNamed('users'),
        ),
        TextButton(
          child: Text('Logout', style: TextStyle(color: Theme.of(context).primaryColor)),
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
