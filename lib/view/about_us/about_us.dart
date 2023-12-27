import 'package:flutter/material.dart';

class AboutUs extends StatefulWidget {
  const AboutUs({Key? key}) : super(key: key);

  @override
  State<AboutUs> createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 30,),
            Text("About Us",
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w600
              ),
            ),
            SizedBox(height: 10,),
            Text("The Firebase Cloud Messaging console has an option to send messages at a specific time, but the API does not. There is nothing Flutter specific about this, so I recommend checking some of these questions where the topic was covered before:",
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 15,
              ),
            ),
            SizedBox(height: 30,),
            Text("Privacy Policy",
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w600
              ),
            ),
            SizedBox(height: 10,),
            Text("The Firebase Cloud Messaging console has an option to send messages at a specific time, but the API does not. There is nothing Flutter specific about this, so I recommend checking some of these questions where the topic was covered before:",
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 15,
              ),
            ),
            SizedBox(height: 30,),
            Text("Trams & Conditions",
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w600
              ),
            ),
            SizedBox(height: 10,),
            Text("The Firebase Cloud Messaging console has an option to send messages at a specific time, but the API does not. There is nothing Flutter specific about this, so I recommend checking some of these questions where the topic was covered before:",
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 15,
              ),
            )
          ],
        ),
      ),
    );
  }
}
