import 'package:Ashvatth/Providers/onboarding_provider.dart';
import 'package:Ashvatth/screens/user_home.dart';
import 'package:Ashvatth/widgets/top_logo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegistrationComplete extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<OnboardingProvier>(context, listen: false);
    return WillPopScope(
      onWillPop: () async => false,
      child: SafeArea(
        child: Scaffold(
          body: Padding(
            padding: EdgeInsets.symmetric(
              vertical: MediaQuery.of(context).size.height * 0.15,
              horizontal: MediaQuery.of(context).size.width * 0.1,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TopLogo(),
                SizedBox(height: 16),
                Padding(
                  padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      if (provider.firstName != null &&
                          provider.lastName != null)
                        Text(
                          'Great! Welcome \n${provider.firstName} ${provider.lastName}',
                          style: Theme.of(context).textTheme.headline1,
                        ),
                      if (provider.firstName == null ||
                          provider.lastName == null)
                        Text(
                          'Great! Welcome',
                          style: Theme.of(context).textTheme.headline1,
                        ),
                      SizedBox(height: 8),
                      Text(
                        'Ashvatth will help you map \nyour family tree and explore \nyour family branch in this \nworld family.',
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: FractionalOffset.bottomCenter,
                    child: RaisedButton(
                      child: Text(
                        'Start Using',
                        style: TextStyle(fontSize: 18, fontFamily: 'Laila'),
                      ),
                      onPressed: () {
                        Navigator.of(context).push(
                          CupertinoPageRoute(
                              builder: (ctx) => UserHomeScreen()),
                        );
                      },
                      padding: const EdgeInsets.symmetric(
                        horizontal: 50,
                        vertical: 12,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
