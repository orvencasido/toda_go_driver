import 'package:flutter/material.dart';
import 'package:toda_go_driver/features/dashboard/screens/account_screen.dart';

/// AccountTab is the shell shown in the bottom nav.
/// It immediately pushes AccountScreen as a full screen so the back button works.
class AccountTab extends StatefulWidget {
  const AccountTab({super.key});

  @override
  State<AccountTab> createState() => _AccountTabState();
}

class _AccountTabState extends State<AccountTab> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return const AccountScreen();
  }
}
