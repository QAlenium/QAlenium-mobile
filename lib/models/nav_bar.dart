import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:qalenium_mobile/models/company.dart';
import 'package:qalenium_mobile/models/user.dart';

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
                  'https://scontent.fymy1-1.fna.fbcdn.net/v/t39.30808-6/260441640_4562046180547256_5654548003243015098_n.jpg?_nc_cat=108&ccb=1-5&_nc_sid=09cbfe&_nc_ohc=kKxoGmiPyhwAX-qOxLC&_nc_ht=scontent.fymy1-1.fna&oh=00_AT9ip46m6rjy47oM3bk7pQfJzxFbi29hWSwOqM5g3bx1Ng&oe=62494549',
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
            onTap: () => null,
          ),
          ListTile(
            leading: const Icon(Icons.search),
            title: const Text('Continuous Quality'),
            onTap: () => null,
          ),
          ListTile(
            leading: const Icon(Icons.code),
            title: const Text('CI/CD'),
            onTap: () => null,
          ),
          ListTile(
            leading: const Icon(Icons.bug_report),
            title: const Text('Testing'),
            onTap: () => null,
          ),
          ListTile(
            leading: const Icon(Icons.message),
            title: const Text('Messaging'),
            onTap: () => null,
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.vpn_key),
            title: const Text('VPN'),
            onTap: () => null,
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () => null,
          ),
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('Notifications'),
            onTap: () => null,
          ),
          const Divider(),
          ListTile(
            title: const Text('Exit'),
            leading: const Icon(Icons.exit_to_app),
            onTap: () => null,
          ),
        ],
      ),
    );
  }
}