import 'package:Ashvatth/screens/family_members.dart';
import 'package:Ashvatth/widgets/input_form_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FamilySearch extends StatefulWidget {
  @override
  _FamilySearchState createState() => _FamilySearchState();
}

class _FamilySearchState extends State<FamilySearch> {
  var formKey = GlobalKey<FormState>();
  var firstNameController = TextEditingController();
  var currentCityController = TextEditingController();
  var birthPlaceController = TextEditingController();
  var bloodGroupController = TextEditingController();
  var specializationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Family Search'),
        ),
        body: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
              child: Column(
                children: <Widget>[
                  InputFormField(
                    controller: firstNameController,
                    isInlineBorder: true,
                    suffixWidget: Icon(Icons.filter_list),
                    labelText: 'First Name',
                    keyboardType: TextInputType.text,
                  ),
                  SizedBox(height: 8),
                  InputFormField(
                    controller: currentCityController,
                    isInlineBorder: true,
                    suffixWidget: Icon(Icons.filter_list),
                    labelText: 'Current City',
                    keyboardType: TextInputType.text,
                  ),
                  SizedBox(height: 8),
                  InputFormField(
                    controller: birthPlaceController,
                    isInlineBorder: true,
                    suffixWidget: Icon(Icons.filter_list),
                    labelText: 'Birth Place',
                    keyboardType: TextInputType.text,
                  ),
                  SizedBox(height: 8),
                  InputFormField(
                    controller: bloodGroupController,
                    isInlineBorder: true,
                    suffixWidget: Icon(Icons.filter_list),
                    labelText: 'Blood Group',
                    keyboardType: TextInputType.text,
                  ),
                  SizedBox(height: 8),
                  InputFormField(
                    controller: specializationController,
                    isInlineBorder: true,
                    suffixWidget: Icon(Icons.filter_list),
                    labelText: 'Specialization',
                    keyboardType: TextInputType.text,
                  ),
                  SizedBox(height: 16),
                  SizedBox(
                    width: double.maxFinite,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 32),
                      child: RaisedButton(
                        child: Text('Search'),
                        onPressed: () {
                          _onSearch();
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _onSearch() {
    var firstName = firstNameController.text.trim().toLowerCase();
    var city = currentCityController.text.trim().toLowerCase();
    var birthPlace = birthPlaceController.text.trim().toLowerCase();
    var bloodGroup = bloodGroupController.text.trim().toLowerCase();
    var specialization = specializationController.text.trim().toLowerCase();

    if (firstName == '' &&
        city == '' &&
        birthPlace == '' &&
        bloodGroup == '' &&
        specialization == '') {
      return;
    }

    Navigator.of(context).push(CupertinoPageRoute(
        builder: (ctx) => FamilyMembersScreen(
              isSearch: true,
              searchBirthPlace: birthPlace,
              searchBoodGroup: bloodGroup,
              searchCity: city,
              searchName: firstName,
              searchSpecialization: specialization,
            )));
  }
}
