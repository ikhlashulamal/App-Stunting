

import 'package:flutter/material.dart';
import 'package:stunting/colors.dart';
import 'package:stunting/home_screen.dart';

class WelcomeScreeen extends StatelessWidget {
  const WelcomeScreeen({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: colors.whiteClr,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Stunting \nPada Balita',
            textAlign: TextAlign.center,
            style: TextStyle(
            fontSize: 50,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
            wordSpacing: 1,
            ),
          ),
          Image.asset('assets/dokter.png',
            fit: BoxFit.cover,
            scale: 0.7,
          ),
          const Text('Untuk Indonesia\nStunting',
            textAlign: TextAlign.center,
            style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 60),
          InkWell(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder:
              (context) => HomeScreen(),));
            },
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: colors.grnClr,
                shape: BoxShape.circle,
                boxShadow: const [BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6,
                  spreadRadius: 4,
                  ),
                ],
              ),
              child: const Text('Go', style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
