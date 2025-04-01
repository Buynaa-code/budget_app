import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/locale_provider.dart';
import '../app/app_localizations.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translate('profile')),
        actions: [
          // Language Switcher
          PopupMenuButton<String>(
            icon: const Icon(Icons.language),
            onSelected: (String value) {
              Provider.of<LocaleProvider>(context, listen: false)
                  .setLocale(Locale(value));
            },
            itemBuilder: (BuildContext context) => [
              PopupMenuItem<String>(
                value: 'en',
                child: Text(AppLocalizations.of(context).translate('english')),
              ),
              PopupMenuItem<String>(
                value: 'mn',
                child:
                    Text(AppLocalizations.of(context).translate('mongolian')),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Header
            Center(
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 50,
                    child: Icon(Icons.person, size: 50),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    user?.email ?? '',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            // Settings Section
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.language),
                    title: Text(
                        AppLocalizations.of(context).translate('language')),
                    trailing: DropdownButton<String>(
                      value: Provider.of<LocaleProvider>(context)
                          .locale
                          .languageCode,
                      onChanged: (String? value) {
                        if (value != null) {
                          Provider.of<LocaleProvider>(context, listen: false)
                              .setLocale(Locale(value));
                        }
                      },
                      items: [
                        DropdownMenuItem(
                          value: 'en',
                          child: Text(AppLocalizations.of(context)
                              .translate('english')),
                        ),
                        DropdownMenuItem(
                          value: 'mn',
                          child: Text(AppLocalizations.of(context)
                              .translate('mongolian')),
                        ),
                      ],
                    ),
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.logout),
                    title:
                        Text(AppLocalizations.of(context).translate('logout')),
                    onTap: () {
                      Provider.of<AuthProvider>(context, listen: false)
                          .logout();
                      Navigator.pushReplacementNamed(context, '/');
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
