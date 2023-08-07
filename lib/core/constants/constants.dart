import 'package:flutter/material.dart';
import 'package:reddit/meta/features/feed/screens/feed_screen.dart';
import 'package:reddit/meta/features/post/screens/add_post_screen.dart';

class Constants {
  static const iconPath = 'assets/images/icon.png';
  static const logoPath = 'assets/images/logo.png';
  static const googlePath = 'assets/images/google.png';

  static const bannerDefault =
      "https://preview.redd.it/k0ozkhhjubh31.jpg?width=2400&format=pjpg&auto=webp&s=6d44bf6a3a98bee16d1a70697b919fbd53a97796";
  static const avatarDefault =
      'https://external-preview.redd.it/5kh5OreeLd85QsqYO1Xz_4XSLYwZntfjqou-8fyBFoE.png?auto=webp&s=dbdabd04c399ce9c761ff899f5d38656d1de87c2';
  static const tabWidgets = [
    FeedScreen(),
    AddPostScreen(),
  ];
  static const IconData up =
      IconData(0xe800, fontFamily: 'myFont', fontPackage: null);
  static const IconData down =
      IconData(0xe801, fontFamily: 'myFont', fontPackage: null);

  static const awardsPath = 'assets/images/awards';

  static const awards = {
    'ally': '${Constants.awardsPath}/ally.png',
    'argentium': '${Constants.awardsPath}/argentium.png',
    'cake': '${Constants.awardsPath}/cake.png',
    'dissapoint': '${Constants.awardsPath}/dissapoint.png',
    'facepalm': '${Constants.awardsPath}/facepalm.png',
    'goat': '${Constants.awardsPath}/goat.png',
    'gold': '${Constants.awardsPath}/gold.png',
    'heartwarming': '${Constants.awardsPath}/heartwarming.png',
    'original': '${Constants.awardsPath}/original.png',
    'platinum': '${Constants.awardsPath}/platinum.png',
    'plusone': '${Constants.awardsPath}/plusone.png',
    'superheart': '${Constants.awardsPath}/superheart.png',
    'ternion': '${Constants.awardsPath}/ternion.png',
    'thankyou': '${Constants.awardsPath}/thankyou.png',
    'wholesome': '${Constants.awardsPath}/wholesome.png',
  };
}
