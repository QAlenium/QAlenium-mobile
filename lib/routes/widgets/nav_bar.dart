import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:qalenium_mobile/models/company.dart';
import 'package:qalenium_mobile/models/user.dart';
import 'package:qalenium_mobile/routes/drawer_menu/favorites.dart';
import 'package:qalenium_mobile/routes/drawer_menu/settings.dart';
import 'package:qalenium_mobile/routes/pre_login/companies.dart';

class NavBar extends StatelessWidget {
  const NavBar({Key? key, required this.flexSchemeData, required this.user,
    required this.company}) : super(key: key);

  final FlexSchemeData flexSchemeData;
  final User user;
  final Company company;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text('id: ' + user.userId.toString()),
            accountEmail: Text(user.email),
            currentAccountPicture: CircleAvatar(
              child: ClipOval(
                child: Image.network(
                  company.logo,
                  fit: BoxFit.cover,
                  width: 90,
                  height: 90,
                ),
              ),
            ),
            decoration: const BoxDecoration(
              color: Colors.blue,
              image: DecorationImage(
                  fit: BoxFit.fill,
                  image: NetworkImage('https://oflutter.com/wp-content/uploads/2021/02/profile-bg3.jpg')
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.favorite),
            title: const Text('Favorites'),
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => FavoritesRoute(
                        flexSchemeData: flexSchemeData,
                        company: company,
                        user: user)
                )
            ),
          ),
          if (company.continuousQualityUrl.isNotEmpty) ListTile(
            leading: const Icon(Icons.search),
            title: const Text('Continuous Quality'),
            onTap: () => Navigator.pop(context),
          ),
          if (company.ciCdUrl.isNotEmpty) ListTile(
            leading: const Icon(Icons.code),
            title: const Text('CI/CD'),
            onTap: () => Navigator.pop(context),
          ),
          if (company.testingUrl.isNotEmpty) ListTile(
            leading: const Icon(Icons.bug_report),
            title: const Text('Testing'),
            onTap: () => Navigator.pop(context),
          ),
          if (company.messagingUrl.isNotEmpty) ListTile(
            leading: const Icon(Icons.message),
            title: const Text('Messaging'),
            onTap: () => Navigator.pop(context),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.vpn_key),
            title: const Text('VPN'),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () =>
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            SettingsRoute(
                              flexSchemeData: flexSchemeData,
                              company: company,
                              user: user,
                            )
                    )
                ),
          ),
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('Notifications'),
            onTap: () => Navigator.pop(context),
          ),
          const Divider(),
          ListTile(
              title: const Text('Exit'),
              leading: const Icon(Icons.exit_to_app),
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CompaniesRoute(
                          flexSchemeData: flexSchemeData)
                  )
              ),
          ),
        ],
      ),
    );
  }
}