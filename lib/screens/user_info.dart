import 'package:Ashvatth/widgets/input_form_field.dart';
import 'package:flutter/material.dart';

class UserInfoFormPage extends StatefulWidget {
  static const routeName = 'userInfoFormPage';

  @override
  _UserInfoFormPageState createState() => _UserInfoFormPageState();
}

class _UserInfoFormPageState extends State<UserInfoFormPage>
    with TickerProviderStateMixin {
  List<String> tabs = [
    "info",
    "contact",
    "education",
    "occupation",
    "other",
  ];
  TabController tabController;
  @override
  Widget build(BuildContext context) {
    tabController = TabController(length: tabs.length, vsync: this);

    return Scaffold(
      appBar: AppBar(
        title: Text('Add new relative'),
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
                          child: Text(name),
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
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InputFormField(
              labelText: 'Middle Name',
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InputFormField(
              labelText: 'Last Name',
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InputFormField(
              labelText: 'Father\'s Name',
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InputFormField(
              labelText: 'Mother\'s Name',
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InputFormField(
              labelText: 'Mobile No.',
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InputFormField(
              labelText: 'Place of Birth',
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InputFormField(
              labelText: 'Notes',
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InputFormField(
              labelText: 'Place of Birth',
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
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InputFormField(
              labelText: 'Current Address',
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InputFormField(
              labelText: 'Phone Number',
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InputFormField(
              labelText: 'Mobile Number',
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InputFormField(
              labelText: 'Personal Email ID',
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
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InputFormField(
              labelText: 'University',
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InputFormField(
              labelText: 'School',
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InputFormField(
              labelText: 'Grant',
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
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InputFormField(
              labelText: 'Service line',
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InputFormField(
              labelText: 'Office Email',
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InputFormField(
              labelText: 'Other Details',
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
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InputFormField(
              labelText: 'Personal Interest',
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InputFormField(
              labelText: 'Special Awards',
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InputFormField(
              labelText: 'Personal Interest & Involvement',
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
