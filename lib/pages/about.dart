import 'package:flutter/material.dart';
import 'package:pomagacze/utils/constants.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('O aplikacji')),
      body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Image.asset('assets/iconTransparent.png', height: 50,),
                  const SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Pomagacze', style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(height: 5),
                      const Text('© 2022 0xdeadbeef')
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text('''
Aplikacja stworzona na konkurs HackHeroes.
Autorzy: Jakub Latuszek, Filip Latuszek, Szymon Perlicki''',
                  style: TextStyle(height: 1.4, fontSize: 15)),
              const SizedBox(height: 10),
              const Text('Niektóre grafiki pochodzą z Flaticon - www.flaticon.com',
                  style: TextStyle(height: 1.4, fontSize: 15)),
              const SizedBox(height: 30),
              OutlinedButton(
                  onPressed: () {
                    launchUrl(Uri.parse(websiteUrl), mode: LaunchMode.externalApplication);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('Strona WWW'),
                      SizedBox(width: 5),
                      Icon(Icons.open_in_new)
                    ],
                  )),
              OutlinedButton(
                  onPressed: () {
                    launchUrl(Uri.parse('https://github.com/ikcilrep/pomagacze'), mode: LaunchMode.externalApplication);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('Repozytorium GitHub'),
                      SizedBox(width: 5),
                      Icon(Icons.open_in_new)
                    ],
                  ))
            ],
          )),
    );
  }
}
