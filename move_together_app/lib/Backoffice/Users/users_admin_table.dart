import 'package:flutter/material.dart';
import 'package:move_together_app/core/models/user.dart';

Map<Role, String> roleToString = {
  Role.ADMIN: 'ADMIN',
  Role.USER: 'USER',
};

class UsersTable extends StatelessWidget {
  final List<User> users;
  final Function changeUserRole;

  const UsersTable({
    super.key,
    required this.users,
    required this.changeUserRole,
  });

  @override
  Widget build(BuildContext context) {
    return Table(
      border: TableBorder.all(
          color: const Color(0xFF81C784),
          width: 2,
          borderRadius: const BorderRadius.all(Radius.elliptical(10, 10))),
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: [
        const TableRow(
          decoration: BoxDecoration(
            color: Color(0xFFB9F6CA),
          ),
          children: [
            TableCell(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.person),
                      SizedBox(width: 8),
                      Text(
                        'Name',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF263238),
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            TableCell(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.person,
                        color: Color(0xFF55C0A8),
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Role',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF263238),
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            TableCell(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.call_to_action,
                        color: Color(0xFF55C0A8),
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Actions',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF263238),
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        for (final user in users)
          TableRow(
            children: [
              TableCell(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      user.name,
                      style: const TextStyle(
                        color: Color(0xFF263238),
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
              TableCell(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      roleToString[user.role] ?? 'Unknown',
                      style: const TextStyle(
                        color: Color(0xFF263238),
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
              TableCell(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (user.name != "admin") // Conditional check
                          TextButton(
                            onPressed: () => changeUserRole(user),
                            child: Text(
                              user.role == Role.ADMIN
                                  ? 'Make User'
                                  : 'Make Admin',
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
      ],
    );
  }
}
