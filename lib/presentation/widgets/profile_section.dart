import 'package:flutter/material.dart';

class ProfileSection extends StatelessWidget {
  const ProfileSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(80.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 100,
              backgroundImage: AssetImage('assets/Sid Gen.png'),
            ),
            SizedBox(height: 50),
            Text("Sid", style: Theme.of(context).textTheme.displayMedium),
            SizedBox(height: 10),
            Text(
              softWrap: true,
              "Product Engineer who builds high-quality, scalable applications. My goal is to create software people will love.",
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ],
        ),
      ),
    );
  }
}
