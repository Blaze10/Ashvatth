import 'package:Ashvatth/widgets/input_form_field.dart';
import 'package:flutter/material.dart';

class UserInfoFormPage extends StatefulWidget {
  static const routeName = 'userInfoFormPage';
  final String relationship;

  UserInfoFormPage({@required this.relationship});

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
  TabController tabController;
  @override
  Widget build(BuildContext context) {
    tabController = TabController(length: tabs.length, vsync: this);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Add ${widget.relationship}'),
      ),
      body: SafeArea(
        child: Column(
          children: [
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InputFormField(
              labelText: 'First Name',
              controller: null,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InputFormField(
              labelText: 'Middle Name',
              controller: null,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InputFormField(
              labelText: 'Last Name',
              controller: null,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InputFormField(
              labelText: 'Father\'s Name',
              controller: null,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InputFormField(
              labelText: 'Mother\'s Name',
              controller: null,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InputFormField(
              labelText: 'Mobile No.',
              controller: null,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InputFormField(
              labelText: 'Place of Birth',
              controller: null,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InputFormField(
              labelText: 'Notes',
              controller: null,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InputFormField(
              labelText: 'Place of Birth',
              controller: null,
            ),
          ),
          Padding(padding: const EdgeInsets.all(8.0), child: Text('Gender')),
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView(
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
                  RadioListTile(
                    groupValue: gender,
                    onChanged: (_) {
                      setState(() {
                        gender = _;
                      });
                    },
                    title: Text("Other"),
                    value: Gender.other,
                  )
                ],
              )),
          Center(
            child: Container(
              child: FlatButton(
                color: Color(0xFFF0CC8D),
                child: Text(
                  'Next',
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      .copyWith(fontSize: 18),
                ),
                onPressed: () {
                  tabController.animateTo(tabController.index + 1);
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(2)),
              ),
              width: MediaQuery.of(context).size.width * .8,
            ),
          )
        ],
      ),
    );
  }

  Widget contactForm() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InputFormField(
              labelText: 'Permanant Address',
              controller: null,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InputFormField(
              labelText: 'Current Address',
              controller: null,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InputFormField(
              labelText: 'Phone Number',
              controller: null,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InputFormField(
              labelText: 'Mobile Number',
              controller: null,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InputFormField(
              labelText: 'Personal Email ID',
              controller: null,
            ),
          ),
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                  alignment: Alignment.centerRight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      FlatButton(
                        child: Text('Linked IN'),
                        onPressed: () {},
                      ),
                      FlatButton(
                        child: Text('Facebook'),
                        onPressed: () {},
                      )
                    ],
                  ))),
          Center(
            child: Container(
              child: FlatButton(
                color: Color(0xFFF0CC8D),
                child: Text(
                  'Next',
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      .copyWith(fontSize: 18),
                ),
                onPressed: () {
                  tabController.animateTo(tabController.index + 1);
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(2)),
              ),
              width: MediaQuery.of(context).size.width * 0.9,
            ),
          )
        ],
      ),
    );
  }

  Widget educationForm() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InputFormField(
              labelText: 'Qualification',
              controller: null,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InputFormField(
              labelText: 'University',
              controller: null,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InputFormField(
              labelText: 'School',
              controller: null,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InputFormField(
              labelText: 'Grant',
              controller: null,
            ),
          ),
          Center(
            child: Container(
              child: FlatButton(
                color: Color(0xFFF0CC8D),
                child: Text(
                  'Next',
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      .copyWith(fontSize: 18),
                ),
                onPressed: () {
                  tabController.animateTo(tabController.index + 1);
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(2)),
              ),
              width: MediaQuery.of(context).size.width * 0.9,
            ),
          )
        ],
      ),
    );
  }

  Widget occupationForm() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InputFormField(
              labelText: 'Company Name',
              controller: null,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InputFormField(
              labelText: 'Service line',
              controller: null,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InputFormField(
              labelText: 'Office Email',
              controller: null,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InputFormField(
              labelText: 'Other Details',
              controller: null,
            ),
          ),
          Center(
            child: Container(
              child: FlatButton(
                color: Color(0xFFF0CC8D),
                child: Text(
                  'Next',
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      .copyWith(fontSize: 18),
                ),
                onPressed: () {
                  tabController.animateTo(tabController.index + 1);
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(2)),
              ),
              width: MediaQuery.of(context).size.width * 0.9,
            ),
          )
        ],
      ),
    );
  }

  Widget otherDetailsForm() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InputFormField(
              labelText: 'Hobbies',
              controller: null,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InputFormField(
              labelText: 'Personal Interest',
              controller: null,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InputFormField(
              labelText: 'Special Awards',
              controller: null,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InputFormField(
              labelText: 'Personal Interest & Involvement',
              controller: null,
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
                onPressed: () {},
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(2)),
              ),
              width: MediaQuery.of(context).size.width * 0.9,
            ),
          )
        ],
      ),
    );
  }

  Gender gender = Gender.other;
}

enum Gender { male, female, other }
