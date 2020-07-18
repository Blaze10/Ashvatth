import 'dart:io';

import 'package:Ashvatth/pickers/image_picker.dart';
import 'package:Ashvatth/services/common_service.dart';
import 'package:Ashvatth/widgets/input_form_field.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class UserInfoFormPage extends StatefulWidget {
  static const routeName = 'userInfoFormPage';
  final String relationship;

  // if edit mode
  final bool isEdit;
  final bool selfEdit;

  UserInfoFormPage({
    this.relationship,
    this.isEdit = false,
    this.selfEdit = false,
  });

  @override
  _UserInfoFormPageState createState() => _UserInfoFormPageState();
}

class _UserInfoFormPageState extends State<UserInfoFormPage>
    with TickerProviderStateMixin {
  List<String> tabs = [
    "Info",
    "Contact",
    "Education",
    "Occupation",
    "Other",
  ];
  File profileImage;
  String profileImageUrl;
  TabController tabController;
  DateTime birthDate, aniversaryDate, deathDate;
  CommonService _commonService = CommonService();
  var db = Firestore.instance;
  var auth = FirebaseAuth.instance;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var showLoader = false;
  DateFormat df = DateFormat('dd/MM/yyyy');

  // form keys
  var infoFormKey = GlobalKey<FormState>();
  var contactFormKey = GlobalKey<FormState>();
  var educationFormKey = GlobalKey<FormState>();
  var occupationFormKey = GlobalKey<FormState>();
  var otherFormKey = GlobalKey<FormState>();

  // info form controllers
  var firstNameController = TextEditingController();
  var middleNameController = TextEditingController();
  var lastNameController = TextEditingController();
  var fatherNameController = TextEditingController();
  var motherNameController = TextEditingController();
  var oldSurnameController = TextEditingController();
  var birthDateController = TextEditingController();
  var birthPlaceController = TextEditingController();
  var notesController = TextEditingController();
  Gender gender = Gender.male;
  bool isAlive = true;
  bool isMarried = false;
  var aniversaryDateController = TextEditingController();
  var deathDateController = TextEditingController();
  var bloodGroupController = TextEditingController();

  // contact form controllers
  var permanentAddressController = TextEditingController();
  var currentAddressController = TextEditingController();
  var phoneNumberController = TextEditingController();
  var contactController = TextEditingController();
  var personalEmailController = TextEditingController();
  var facebookProfileUrlController = TextEditingController();
  var linkdenProfileUrlController = TextEditingController();

  // education form controllers
  var qualificationController = TextEditingController();
  var universityController = TextEditingController();
  var schoolController = TextEditingController();
  var grantController = TextEditingController();

  // occupation form controllers
  var companyNameController = TextEditingController();
  var serviceLineController = TextEditingController();
  var officeEmailController = TextEditingController();
  var otherDetailsController = TextEditingController();

  // other form controllers
  var hobbiesController = TextEditingController();
  var personalInterestController = TextEditingController();
  var specialAwardsController = TextEditingController();
  var sociaInterestController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if ((widget.relationship != null) && !widget.isEdit) {
      _helpPatchTextFields();
    }
    if (widget.isEdit) {
      _getMemberInfo();
    } else {
      // assign gender automatically

      if (widget.relationship != null && widget.relationship == 'Father' ||
          widget.relationship.toString().indexOf('Brother') != -1 ||
          widget.relationship.toString().indexOf('Son') != -1 ||
          widget.relationship.toString().indexOf('Husband') != -1) {
        setState(() {
          gender = Gender.male;
        });
      } else {
        setState(() {
          gender = Gender.female;
          print('Assigned gender');
        });
      }

      // assign marital status automatically based on relationship
      if (widget.relationship == 'Father' ||
          widget.relationship == 'Mother' ||
          widget.relationship == 'Wife') {
        setState(() {
          isMarried = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    tabController = TabController(length: tabs.length, vsync: this);
    String relation = widget.relationship ?? '';
    if (relation.indexOf('Brother') != -1) {
      relation = 'Brother';
    }
    if (relation.indexOf('Sister') != -1) {
      relation = 'Sister';
    }
    if (relation.indexOf('Son') != -1) {
      relation = 'Son';
    }
    if (relation.indexOf('Daughter') != -1) {
      relation = 'Daughter';
    }
    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: !widget.selfEdit
              ? Text('${widget.isEdit ? 'View' : 'Add'} $relation')
              : Text('Edit Profile'),
        ),
        body: Column(
          children: [
            if (showLoader) LinearProgressIndicator(),
            Flexible(
              flex: 10,
              child: TabBarView(
                physics: NeverScrollableScrollPhysics(),
                children: [
                  infoForm(),
                  contactForm(),
                  educationForm(),
                  occupationForm(),
                  otherDetailsForm(),
                ],
                controller: tabController,
              ),
            ),
            Flexible(
              flex: 1,
              child: TabBar(
                isScrollable: true,
                controller: tabController,
                labelColor: Theme.of(context).primaryColor,
                unselectedLabelColor: Colors.grey,
                tabs: tabs
                    .map((name) => new Tab(
                          child: Text(
                            name,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                        ))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget infoForm() {
    return SingleChildScrollView(
      child: Form(
        key: infoFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: UserImagePicker(
                  imagePickedFn: _pickedImage,
                  displayImage: _profileImage(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InputFormField(
                labelText: 'First Name',
                controller: firstNameController,
                isInlineBorder: true,
                isRequired: true,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InputFormField(
                labelText: 'Middle Name',
                controller: middleNameController,
                isInlineBorder: true,
                isRequired: true,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InputFormField(
                labelText: 'Mother\'s Name',
                controller: motherNameController,
                isInlineBorder: true,
                isRequired: true,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InputFormField(
                labelText: 'Last Name',
                controller: lastNameController,
                isInlineBorder: true,
                isRequired: true,
              ),
            ),
            if (widget.relationship == null && widget.selfEdit)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Gender',
                  style: Theme.of(context).textTheme.subtitle1.copyWith(
                        fontSize: 22,
                      ),
                ),
              ),
            if (widget.relationship == null && widget.selfEdit)
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView(
                    primary: false,
                    shrinkWrap: true,
                    children: [
                      RadioListTile(
                        groupValue: gender,
                        onChanged: (_) {
                          setState(() {
                            gender = _;
                          });
                        },
                        title: Text("Male"),
                        value: Gender.male,
                      ),
                      RadioListTile(
                        groupValue: gender,
                        onChanged: (_) {
                          setState(() {
                            gender = _;
                          });
                        },
                        title: Text("Female"),
                        value: Gender.female,
                      ),
                      // RadioListTile(
                      //   groupValue: gender,
                      //   onChanged: (_) {
                      //     setState(() {
                      //       gender = _;
                      //     });
                      //   },
                      //   title: Text("Other"),
                      //   value: Gender.other,
                      // ),
                    ],
                  )),
            if (widget.selfEdit ||
                (widget.relationship != null &&
                    widget.relationship != 'Mother' &&
                    widget.relationship != 'Wife' &&
                    widget.relationship != 'Father'))
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Flexible(
                        child: Text(
                      'Married ?',
                      style: Theme.of(context)
                          .textTheme
                          .subtitle1
                          .copyWith(fontSize: 22),
                    )),
                    Flexible(
                      child: Switch(
                        onChanged: _onChangeIsMarried,
                        value: isMarried,
                        activeColor: Theme.of(context).accentColor,
                      ),
                    ),
                  ],
                ),
              ),
            if ((widget.selfEdit && (gender == Gender.female && isMarried)) ||
                (gender == Gender.female && isMarried))
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: InputFormField(
                  labelText: 'Father\'s Name',
                  controller: fatherNameController,
                  isInlineBorder: true,
                  isRequired: true,
                ),
              ),
            if ((widget.selfEdit && gender == Gender.female && isMarried) ||
                (gender == Gender.female && isMarried))
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: InputFormField(
                  labelText: 'Old Surname',
                  controller: oldSurnameController,
                  isInlineBorder: true,
                  isRequired: true,
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InputFormField(
                labelText: 'Date of Birth',
                controller: birthDateController,
                isInlineBorder: true,
                suffixWidget: Icon(
                  Icons.date_range,
                  color: Theme.of(context).primaryColor,
                ),
                isDate: true,
                onTapFunction: () {
                  _onTapInput(birthDateController);
                },
                isDisabled: true,
                // onTapFunction: _onTapInput(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InputFormField(
                labelText: 'Place of Birth',
                controller: birthPlaceController,
                isInlineBorder: true,
              ),
            ),
            // commenting gender
            // Divider(
            //   color: Colors.grey,
            // ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Flexible(
                      child: Text(
                    'Is Alive ?',
                    style: Theme.of(context)
                        .textTheme
                        .subtitle1
                        .copyWith(fontSize: 22),
                  )),
                  Flexible(
                    child: Switch(
                      value: isAlive,
                      onChanged: _changeIsAlive,
                      activeColor: Theme.of(context).accentColor,
                    ),
                  ),
                ],
              ),
            ),
            if (!isAlive)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: InputFormField(
                  labelText: 'Death Date',
                  controller: deathDateController,
                  isInlineBorder: true,
                  isDate: true,
                  isDisabled: true,
                  suffixWidget: Icon(
                    Icons.date_range,
                    color: Theme.of(context).primaryColor,
                  ),
                  onTapFunction: () {
                    _onTapInput(deathDateController);
                  },
                ),
              ),
            if (isMarried)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: InputFormField(
                  labelText: 'Anniversary Date',
                  isInlineBorder: true,
                  controller: aniversaryDateController,
                  suffixWidget: Icon(
                    Icons.date_range,
                    color: Theme.of(context).primaryColor,
                  ),
                  isDate: true,
                  isDisabled: true,
                  onTapFunction: () {
                    _onTapInput(aniversaryDateController);
                  },
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InputFormField(
                labelText: 'Blood Group',
                isInlineBorder: true,
                controller: bloodGroupController,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InputFormField(
                labelText: 'Notes',
                isMultiline: true,
                controller: notesController,
                isInlineBorder: true,
              ),
            ),

            Center(
              child: Container(
                child: FlatButton(
                  color: Color(0xFFF0CC8D),
                  child: Text(
                    'Save',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        .copyWith(fontSize: 18),
                  ),
                  onPressed: showLoader
                      ? null
                      : () {
                          // tabController.animateTo(tabController.index + 1);
                          _submitInfoForm();
                        },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(2)),
                ),
                width: MediaQuery.of(context).size.width * .8,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget contactForm() {
    return SingleChildScrollView(
      child: Form(
        key: contactFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InputFormField(
                isInlineBorder: true,
                labelText: 'Permanant Address',
                isMultiline: true,
                controller: permanentAddressController,
                keyboardType: TextInputType.multiline,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InputFormField(
                isInlineBorder: true,
                labelText: 'Current Address',
                isMultiline: true,
                controller: currentAddressController,
                keyboardType: TextInputType.multiline,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InputFormField(
                isInlineBorder: true,
                labelText: 'Phone Number',
                controller: phoneNumberController,
                keyboardType: TextInputType.phone,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InputFormField(
                isInlineBorder: true,
                labelText: 'Mobile Number',
                controller: contactController,
                keyboardType: TextInputType.phone,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InputFormField(
                isInlineBorder: true,
                labelText: 'Personal Email ID',
                controller: personalEmailController,
                keyboardType: TextInputType.emailAddress,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InputFormField(
                isInlineBorder: true,
                labelText: 'Facebook Profile URL',
                controller: facebookProfileUrlController,
                keyboardType: TextInputType.url,
                suffixWidget: Icon(
                  FontAwesomeIcons.facebook,
                  color: Theme.of(context).accentColor,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InputFormField(
                isInlineBorder: true,
                labelText: 'Linkedin Profile URL',
                controller: linkdenProfileUrlController,
                keyboardType: TextInputType.url,
                suffixWidget: Icon(
                  FontAwesomeIcons.linkedin,
                  color: Theme.of(context).accentColor,
                ),
              ),
            ),
            // Padding(
            //     padding: const EdgeInsets.all(8.0),
            //     child: Container(
            //         alignment: Alignment.centerRight,
            //         child: Row(
            //           mainAxisAlignment: MainAxisAlignment.end,
            //           children: [
            //             IconButton(
            //               icon: Icon(
            //                 FontAwesomeIcons.facebook,
            //                 color: Theme.of(context).accentColor,
            //               ),
            //               onPressed: () {},
            //             ),
            //             IconButton(
            //               icon: Icon(FontAwesomeIcons.linkedin),
            //               color: Theme.of(context).accentColor,
            //               onPressed: () {},
            //             )
            //           ],
            //         ))),
            Center(
              child: Container(
                child: FlatButton(
                  color: Color(0xFFF0CC8D),
                  child: Text(
                    'Save',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        .copyWith(fontSize: 18),
                  ),
                  onPressed: showLoader
                      ? null
                      : () {
                          // tabController.animateTo(tabController.index + 1);
                          _submitContactForm();
                        },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(2)),
                ),
                width: MediaQuery.of(context).size.width * 0.9,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget educationForm() {
    return SingleChildScrollView(
      child: Form(
        key: educationFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InputFormField(
                isInlineBorder: true,
                labelText: 'Qualification',
                controller: qualificationController,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InputFormField(
                isInlineBorder: true,
                labelText: 'University',
                controller: universityController,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InputFormField(
                isInlineBorder: true,
                labelText: 'School',
                controller: schoolController,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InputFormField(
                isInlineBorder: true,
                labelText: 'Grant',
                controller: grantController,
              ),
            ),
            Center(
              child: Container(
                child: FlatButton(
                  color: Color(0xFFF0CC8D),
                  child: Text(
                    'Save',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        .copyWith(fontSize: 18),
                  ),
                  onPressed: showLoader
                      ? null
                      : () {
                          // tabController.animateTo(tabController.index + 1);
                          _submitEducationForm();
                        },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(2)),
                ),
                width: MediaQuery.of(context).size.width * 0.9,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget occupationForm() {
    return SingleChildScrollView(
      child: Form(
        key: occupationFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InputFormField(
                isInlineBorder: true,
                labelText: 'Company Name',
                controller: companyNameController,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InputFormField(
                isInlineBorder: true,
                labelText: 'Service line',
                controller: serviceLineController,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InputFormField(
                isInlineBorder: true,
                labelText: 'Office Email',
                controller: officeEmailController,
                keyboardType: TextInputType.emailAddress,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InputFormField(
                isInlineBorder: true,
                labelText: 'Other Details',
                controller: otherDetailsController,
                isMultiline: true,
              ),
            ),
            Center(
              child: Container(
                child: FlatButton(
                  color: Color(0xFFF0CC8D),
                  child: Text(
                    'Save',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        .copyWith(fontSize: 18),
                  ),
                  onPressed: showLoader
                      ? null
                      : () {
                          // tabController.animateTo(tabController.index + 1);
                          _submitOccupationForm();
                        },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                width: MediaQuery.of(context).size.width * 0.9,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget otherDetailsForm() {
    return SingleChildScrollView(
      child: Form(
        key: otherFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InputFormField(
                isInlineBorder: true,
                labelText: 'Hobbies',
                controller: hobbiesController,
                isMultiline: true,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InputFormField(
                isInlineBorder: true,
                labelText: 'Personal Interest',
                controller: personalInterestController,
                isMultiline: true,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InputFormField(
                isInlineBorder: true,
                labelText: 'Special Awards',
                controller: specialAwardsController,
                isMultiline: true,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InputFormField(
                isInlineBorder: true,
                labelText: 'Social Interest & Involvement',
                controller: sociaInterestController,
                isMultiline: true,
              ),
            ),
            Center(
              child: Container(
                child: FlatButton(
                  color: Color(0xFFF0CC8D),
                  child: Text(
                    'Save',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        .copyWith(fontSize: 18),
                  ),
                  onPressed: showLoader
                      ? null
                      : () {
                          _submitOtherForm();
                        },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(2)),
                ),
                width: MediaQuery.of(context).size.width * 0.9,
              ),
            )
          ],
        ),
      ),
    );
  }

  // change alive status
  _changeIsAlive(bool val) {
    setState(() {
      isAlive = val;
    });
  }

  // On tapinpu
  _onTapInput(TextEditingController controller) {
    // print('On Tap called');
    _commonService.pickDate(context: context).then((value) {
      // birth date
      if (controller == birthDateController) {
        birthDate = value;
        birthDateController.text = df.format(value);
      }

      // aniver
      if (controller == aniversaryDateController) {
        aniversaryDate = value;
        aniversaryDateController.text = df.format(value);
      }

      if (controller == deathDateController) {
        deathDate = value;
        deathDateController.text = df.format(value);
      }
    });
  }

  // hide show loader
  _hideShowLoader(bool value) {
    setState(() {
      showLoader = value;
    });
  }

  // submit info form
  _submitInfoForm() async {
    try {
      if (infoFormKey.currentState.validate()) {
        FocusScope.of(context).unfocus();
        String selectedGender = (gender.index == 0) ? 'Male' : 'Female';

        _hideShowLoader(true);

        // get userid
        var userId = (await auth.currentUser()).uid;

        // upload image
        // String profileImageUrl;
        if (profileImage != null) {
          var storageRef;

          if (widget.selfEdit) {
            storageRef = FirebaseStorage.instance
                .ref()
                .child('user_profile')
                .child(userId + '.jpg');
          } else {
            storageRef = FirebaseStorage.instance
                .ref()
                .child('added-members')
                .child(userId)
                .child(widget.relationship + '.jpg');
          }

          await storageRef.putFile(profileImage).onComplete;
          profileImageUrl = await storageRef.getDownloadURL();
        }

        var docRef = (await db
            .document('users/$userId/addedMembers/${widget.relationship}')
            .get());

        if (widget.selfEdit) {
          docRef = (await db.document('users/$userId').get());
        }

        var infoData = {
          'relation': widget.relationship,
          'firstName': firstNameController.text.trim() ?? '',
          'middleName': middleNameController.text.trim() ?? '',
          'lastName': lastNameController.text.trim() ?? '',
          'fatherName': fatherNameController.text.trim() ?? '',
          'motherName': motherNameController.text.trim() ?? '',
          'oldSurname': oldSurnameController.text.trim() ?? '',
          'dateOfBirth': birthDate ?? '',
          'birthPlace': birthPlaceController.text.trim() ?? '',
          'notes': notesController.text.trim() ?? '',
          'gender': selectedGender,
          'isAlive': isAlive,
          'deathDate': deathDate ?? '',
          'isMarried': isMarried,
          'aniversarryDate': aniversaryDate ?? '',
          'bloodGroup': bloodGroupController.text.trim() ?? '',
          'profileImageUrl': profileImageUrl != null
              ? profileImageUrl
              : 'https://firebasestorage.googleapis.com/v0/b/ashvathh-53ab3.appspot.com/o/placeholder.jpg?alt=media&token=45822c63-70af-43f4-83f8-9c9550e9b97b',
          'whenModified': Timestamp.now(),
        };

        if (!docRef.exists) {
          await db
              .document('users/$userId/addedMembers/${widget.relationship}')
              .setData({
            ...infoData,
            'whenCreated': Timestamp.now(),
          });
        } else {
          if (widget.selfEdit) {
            await db.document('users/$userId').updateData(infoData);
          } else {
            await db
                .document('users/$userId/addedMembers/${widget.relationship}')
                .updateData(infoData);
          }
        }

        _hideShowLoader(false);
        _commonService.showToastMessages(
          scaffoldKey: scaffoldKey,
          context: context,
          message: 'Saved successfully',
        );
      }
    } catch (err) {
      _hideShowLoader(false);
      print(err.toString());
      _commonService.showToastMessages(
        scaffoldKey: scaffoldKey,
        context: context,
        message: 'Some error occured, Please try again later',
        isError: true,
      );
    }
  }

  // submit contact form
  _submitContactForm() async {
    try {
      if (contactFormKey.currentState.validate()) {
        FocusScope.of(context).unfocus();
        _hideShowLoader(true);

        // get userid
        var userId = (await auth.currentUser()).uid;

        var docRef = (await db
            .document('users/$userId/addedMembers/${widget.relationship}')
            .get());

        if (widget.selfEdit) {
          docRef = (await db.document('users/$userId').get());
        }

        var infoData = {
          'permanentAddress': permanentAddressController.text.trim() ?? '',
          'currentAddress': currentAddressController.text.trim() ?? '',
          'phone': phoneNumberController.text.trim() ?? '',
          'contact': contactController.text.trim() ?? '',
          'personalEmail': personalEmailController.text.trim() ?? '',
          'facebookProfileUrl': facebookProfileUrlController.text.trim() ?? '',
          'linkedinProfileUrl': linkdenProfileUrlController.text.trim() ?? '',
          'whenModified': Timestamp.now(),
        };

        if (!docRef.exists) {
          await db
              .document('users/$userId/addedMembers/${widget.relationship}')
              .setData({
            ...infoData,
            'whenCreated': Timestamp.now(),
          });
        } else {
          if (widget.selfEdit) {
            await db.document('users/$userId').updateData(infoData);
          } else {
            await db
                .document('users/$userId/addedMembers/${widget.relationship}')
                .updateData(infoData);
          }
        }

        _hideShowLoader(false);
        _commonService.showToastMessages(
          scaffoldKey: scaffoldKey,
          context: context,
          message: 'Saved successfully',
        );
      }
    } catch (err) {
      _hideShowLoader(false);
      print(err.toString());
      _commonService.showToastMessages(
        scaffoldKey: scaffoldKey,
        context: context,
        message: 'Some error occured, Please try again later',
        isError: true,
      );
    }
  }

  _submitEducationForm() async {
    try {
      if (educationFormKey.currentState.validate()) {
        FocusScope.of(context).unfocus();
        _hideShowLoader(true);

        // get userid
        var userId = (await auth.currentUser()).uid;

        var docRef = (await db
            .document('users/$userId/addedMembers/${widget.relationship}')
            .get());

        if (widget.selfEdit) {
          docRef = (await db.document('users/$userId').get());
        }

        var educationData = {
          'qualification': qualificationController.text.trim() ?? '',
          'university': universityController.text.trim() ?? '',
          'school': schoolController.text.trim() ?? '',
          'grant': grantController.text.trim() ?? '',
          'whenModified': Timestamp.now(),
        };

        if (!docRef.exists) {
          await db
              .document('users/$userId/addedMembers/${widget.relationship}')
              .setData({
            ...educationData,
            'whenCreated': Timestamp.now(),
          });
        } else {
          if (widget.selfEdit) {
            await db.document('users/$userId').updateData(educationData);
          } else {
            await db
                .document('users/$userId/addedMembers/${widget.relationship}')
                .updateData(educationData);
          }
        }

        _hideShowLoader(false);
        _commonService.showToastMessages(
          scaffoldKey: scaffoldKey,
          context: context,
          message: 'Saved successfully',
        );
      }
    } catch (err) {
      _hideShowLoader(false);
      print(err.toString());
      _commonService.showToastMessages(
        scaffoldKey: scaffoldKey,
        context: context,
        message: 'Some error occured, Please try again later',
        isError: true,
      );
    }
  }

  _submitOccupationForm() async {
    try {
      if (occupationFormKey.currentState.validate()) {
        FocusScope.of(context).unfocus();
        _hideShowLoader(true);

        // get userid
        var userId = (await auth.currentUser()).uid;

        var docRef = (await db
            .document('users/$userId/addedMembers/${widget.relationship}')
            .get());

        if (widget.selfEdit) {
          docRef = (await db.document('users/$userId').get());
        }

        var occupationData = {
          'companyName': companyNameController.text.trim() ?? '',
          'serviceLine': serviceLineController.text.trim() ?? '',
          'officeEmail': officeEmailController.text.trim() ?? '',
          'otherDetails': otherDetailsController.text.trim() ?? '',
          'whenModified': Timestamp.now(),
        };

        if (!docRef.exists) {
          await db
              .document('users/$userId/addedMembers/${widget.relationship}')
              .setData({
            ...occupationData,
            'whenCreated': Timestamp.now(),
          });
        } else {
          if (widget.selfEdit) {
            await db.document('users/$userId').updateData(occupationData);
          } else {
            await db
                .document('users/$userId/addedMembers/${widget.relationship}')
                .updateData(occupationData);
          }
        }

        _hideShowLoader(false);
        _commonService.showToastMessages(
          scaffoldKey: scaffoldKey,
          context: context,
          message: 'Saved successfully',
        );
      }
    } catch (err) {
      _hideShowLoader(false);
      print(err.toString());
      _commonService.showToastMessages(
        scaffoldKey: scaffoldKey,
        context: context,
        message: 'Some error occured, Please try again later',
        isError: true,
      );
    }
  }

  _submitOtherForm() async {
    try {
      if (otherFormKey.currentState.validate()) {
        FocusScope.of(context).unfocus();
        _hideShowLoader(true);

        // get userid
        var userId = (await auth.currentUser()).uid;

        var docRef = (await db
            .document('users/$userId/addedMembers/${widget.relationship}')
            .get());

        if (widget.selfEdit) {
          docRef = (await db.document('users/$userId').get());
        }

        var otherData = {
          'hobbies': hobbiesController.text.trim() ?? '',
          'personalInterests': personalInterestController.text.trim() ?? '',
          'specialAwards': specialAwardsController.text.trim() ?? '',
          'socialInterests': sociaInterestController.text.trim() ?? '',
          'whenModified': Timestamp.now(),
        };

        if (!docRef.exists) {
          await db
              .document('users/$userId/addedMembers/${widget.relationship}')
              .setData({
            ...otherData,
            'whenCreated': Timestamp.now(),
          });
        } else {
          if (widget.selfEdit) {
            await db.document('users/$userId').updateData(otherData);
          } else {
            await db
                .document('users/$userId/addedMembers/${widget.relationship}')
                .updateData(otherData);
          }
        }

        _hideShowLoader(false);
        _commonService.showToastMessages(
          scaffoldKey: scaffoldKey,
          context: context,
          message: 'Saved successfully',
        );
      }
    } catch (err) {
      _hideShowLoader(false);
      print(err.toString());
      _commonService.showToastMessages(
        scaffoldKey: scaffoldKey,
        context: context,
        message: 'Some error occured, Please try again later',
        isError: true,
      );
    }
  }

  void _pickedImage(File image) {
    setState(() {
      profileImage = image;
    });
  }

  Widget _profileImage() {
    return Container(
      width: MediaQuery.of(context).size.height * 0.26,
      height: MediaQuery.of(context).size.height * 0.26,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            image: profileImage == null
                ? profileImageUrl == null
                    ? CachedNetworkImageProvider(
                        'https://firebasestorage.googleapis.com/v0/b/ashvathh-53ab3.appspot.com/o/placeholder.jpg?alt=media&token=45822c63-70af-43f4-83f8-9c9550e9b97b')
                    : CachedNetworkImageProvider(
                        profileImageUrl,
                      )
                : FileImage(profileImage),
            fit: BoxFit.fill,
          )),
    );
  }

  // get member info
  _getMemberInfo() {
    Future.delayed(Duration.zero, () async {
      try {
        _hideShowLoader(true);
        var userId = (await FirebaseAuth.instance.currentUser()).uid;

        DocumentSnapshot userRef;

        if (widget.selfEdit) {
          userRef = (await Firestore.instance.document('users/$userId').get());
        } else {
          userRef = (await Firestore.instance
              .document('users/$userId/addedMembers/${widget.relationship}')
              .get());
        }

        Map<String, dynamic> userData = Map<String, dynamic>();
        if (userRef.exists) {
          userData = userRef.data;

          // assign marital status automatically
          if (userData['isMarried'] != null && userData['isMarried']) {
            setState(() {
              isMarried = userData['isMarried'];
            });
          }
        } else {
          // assign gender automatically

          if (widget.relationship == 'Father' ||
              widget.relationship == 'Brother' ||
              widget.relationship == 'Son' ||
              widget.relationship == 'Husband') {
            setState(() {
              gender = Gender.male;
            });
          } else {
            setState(() {
              gender = Gender.female;
              print('Assigned gender');
            });
          }

          // assign marital status automatically based on relationship
          if (widget.relationship == 'Father' ||
              widget.relationship == 'Mother' ||
              widget.relationship == 'Wife' ||
              widget.relationship == 'Husband') {
            setState(() {
              isMarried = true;
            });
          }
        }

        print(userData.toString());

        if (userData != null) {
          setState(() {
            // info data
            firstNameController.text = userData['firstName'] ?? '';
            middleNameController.text = userData['middleName'] ?? '';
            lastNameController.text = userData['lastName'] ?? '';
            fatherNameController.text = userData['fatherName'] ?? '';
            motherNameController.text = userData['motherName'] ?? '';
            oldSurnameController.text = userData['oldSurname'] ?? '';
            birthDateController.text = (userData['dateOfBirth'] != null &&
                    userData['dateOfBirth'] != '')
                ? '${df.format(userData['dateOfBirth'].toDate()).toString()}'
                : '' ?? '';
            birthPlaceController.text = userData['birthPlace'] ?? '';
            notesController.text = userData['notes'] ?? '';
            isAlive = userData['isAlive'] ?? true;
            birthDate = (userData['dateOfBirth'] != null &&
                    userData['dateOfBirth'] != '')
                ? userData['dateOfBirth'].toDate()
                : null ?? null;
            deathDate =
                (userData['deathDate'] != null && userData['deathDate'] != '')
                    ? userData['deathDate'].toDate()
                    : null ?? null;
            aniversaryDate = (userData['aniversaryDate'] != null &&
                    userData['aniversaryDate'] != '')
                ? userData['aniversaryDate'].toDate()
                : null ?? null;
            aniversaryDateController.text = (userData['aniversarryDate'] !=
                        null &&
                    userData['aniversarryDate'] != '')
                ? '${df.format(userData['aniversarryDate'].toDate()).toString()}'
                : '' ?? '';
            deathDateController.text =
                (userData['deathDate'] != null && userData['deathDate'] != '')
                    ? '${df.format(userData['deathDate'].toDate()).toString()}'
                    : '' ?? '';
            bloodGroupController.text = userData['bloodGroup'] ?? '';
            profileImageUrl = userData['profileImageUrl'] ??
                'https://firebasestorage.googleapis.com/v0/b/ashvathh-53ab3.appspot.com/o/placeholder.jpg?alt=media&token=45822c63-70af-43f4-83f8-9c9550e9b97b';
            gender = userData['gender'] == 'Male' ? Gender.male : Gender.female;

            // contact data
            permanentAddressController.text =
                userData['permanentAddress'] ?? '';
            currentAddressController.text = userData['currentAddress'] ?? '';
            phoneNumberController.text = userData['phone'] ?? '';
            contactController.text = userData['contact'] ?? '';
            personalEmailController.text = userData['personalEmail'] ?? '';
            facebookProfileUrlController.text =
                userData['facebookProfileUrl'] ?? '';
            linkdenProfileUrlController.text =
                userData['linkedinProfileUrl'] ?? '';

            // education data
            qualificationController.text = userData['qualification'] ?? '';
            universityController.text = userData['university'] ?? '';
            schoolController.text = userData['school'] ?? '';
            grantController.text = userData['grant'] ?? '';

            // occupation data
            companyNameController.text = userData['companyName'] ?? '';
            serviceLineController.text = userData['serviceLine'] ?? '';
            officeEmailController.text = userData['officeEmail'] ?? '';
            otherDetailsController.text = userData['otherDetails'] ?? '';

            // other data
            hobbiesController.text = userData['hobbies'] ?? '';
            personalInterestController.text =
                userData['personalInterests'] ?? '';
            specialAwardsController.text = userData['specialAwards'] ?? '';
            sociaInterestController.text = userData['socialInterests'] ?? '';
          });
        }
        _hideShowLoader(false);
      } catch (err) {
        print('Error getting member info');
        print(err.toString());
        _hideShowLoader(false);
      }
    });
  }

  // help patch text fields
  _helpPatchTextFields() {
    try {
      if (widget.relationship == null) {
        return;
      }

      final db = Firestore.instance;

      Future.delayed(Duration.zero, () async {
        _hideShowLoader(true);

        // get current user info
        String userId = (await FirebaseAuth.instance.currentUser()).uid;

        var userRef = (await db.document('users/$userId').get());

        var userData = {"id": userRef.documentID, ...userRef.data};

        String switchCaseString = widget.relationship;

        if (switchCaseString.indexOf('Sister') != -1) {
          switchCaseString = 'Sister';
        }

        if (switchCaseString.indexOf('Brother') != -1) {
          switchCaseString = 'Brother';
        }

        if (switchCaseString.indexOf('Son') != -1) {
          switchCaseString = 'Son';
        }

        if (switchCaseString.indexOf('Daughter') != -1) {
          switchCaseString = 'Daughter';
        }

        switch (switchCaseString) {
          case 'Wife':
            setState(() {
              middleNameController.text = userData['firstName'] ?? '';
              lastNameController.text = userData['lastName'] ?? '';
              aniversaryDate = (userData['aniversaryDate'] != null &&
                      userData['aniversaryDate'] != '')
                  ? userData['aniversaryDate'].toDate()
                  : null ?? null;
              aniversaryDateController.text = (userData['aniversarryDate'] !=
                          null &&
                      userData['aniversarryDate'] != '')
                  ? '${df.format(userData['aniversarryDate'].toDate()).toString()}'
                  : '' ?? '';
            });

            break;
          case 'Brother':
            setState(() {
              middleNameController.text = userData['middleName'] ?? '';
              lastNameController.text = userData['lastName'] ?? '';
            });

            break;
          case 'Sister':
            setState(() {
              middleNameController.text = userData['middleName'] ?? '';
              lastNameController.text = userData['lastName'] ?? '';
            });

            break;
          case 'Mother':
            setState(() {
              middleNameController.text = userData['middleName'] ?? '';
              lastNameController.text = userData['lastName'] ?? '';
            });

            // check if father's docs exists
            var docRef =
                (await db.document('users/$userId/addedMembers/Father').get());

            if (docRef.exists) {
              var docData = docRef.data;
              setState(() {
                aniversaryDate = (docData['aniversaryDate'] != null &&
                        docData['aniversaryDate'] != '')
                    ? docData['aniversaryDate'].toDate()
                    : null ?? null;
                aniversaryDateController.text = (docData['aniversarryDate'] !=
                            null &&
                        docData['aniversarryDate'] != '')
                    ? '${df.format(docData['aniversarryDate'].toDate()).toString()}'
                    : '' ?? '';
              });
            }

            break;
          case 'Father':
            setState(() {
              firstNameController.text = userData['middleName'] ?? '';
              lastNameController.text = userData['lastName'] ?? '';
            });

            // check if mother's docs exists
            var docRef =
                (await db.document('users/$userId/addedMembers/Mother').get());

            if (docRef.exists) {
              var docData = docRef.data;
              setState(() {
                aniversaryDate = (docData['aniversaryDate'] != null &&
                        docData['aniversaryDate'] != '')
                    ? docData['aniversaryDate'].toDate()
                    : null ?? null;
                aniversaryDateController.text = (docData['aniversarryDate'] !=
                            null &&
                        docData['aniversarryDate'] != '')
                    ? '${df.format(docData['aniversarryDate'].toDate()).toString()}'
                    : '' ?? '';
              });
            }

            break;
          case 'Son':
            setState(() {
              middleNameController.text = userData['firstName'] ?? '';
              lastNameController.text = userData['lastName'] ?? '';
            });

            break;
          case 'Daughter':
            setState(() {
              middleNameController.text = userData['firstName'] ?? '';
              lastNameController.text = userData['lastName'] ?? '';
            });

            break;
          default:
            break;
        }

        _hideShowLoader(false);
      });
    } catch (err) {
      print(err.toString());
      print('Error help patching text fields');
    }
  }

  _onChangeIsMarried(bool value) {
    setState(() {
      isMarried = value;
    });
  }
}

enum Gender { male, female, other }
