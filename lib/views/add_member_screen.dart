import 'package:flutter/material.dart';
import 'package:trip_contribute/tripUtils.dart';

class AddMemberScreen extends StatefulWidget {
  const AddMemberScreen({Key? key}) : super(key: key);

  @override
  State<AddMemberScreen> createState() => _AddMemberScreenState();
}

class _AddMemberScreenState extends State<AddMemberScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _createTripNameController =
      TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  List<String> selectedList = <String>['1','2','3'];

  @override
  void initState() {
    /*Future.delayed(Duration(seconds: 1)).then((_) {
      //buildShowModalBottomSheet(context);
    });*/
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildCreateTripIconButton(context),
            Row(
              children: [
                const Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 14),
                    child: Text(
                      'Total Trip Expense',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
                const Text(
                  '6000',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  constraints: const BoxConstraints(),
                  padding: const EdgeInsets.only(right: 8),
                  onPressed: () {
                    setState(() {});
                  },
                  icon: const Icon(Icons.currency_rupee_outlined),
                ),
              ],
            ),
            const SizedBox(height: 8,),
            Expanded(
              child: ListView.builder(
                itemCount: selectedList.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    margin: const EdgeInsets.all(12),
                    elevation: 0,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        side: BorderSide(
                          color: Colors.grey,
                        )),
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(left: 10, bottom: 8),
                            child: Text(
                              'Total Expense of',
                              style: TextStyle(),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Text(
                              'Bhavika',
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              const Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  '3500',
                                  style: TextStyle(
                                      fontSize: 18, fontWeight: FontWeight.bold)
                                ),
                              ),
                              IconButton(
                                constraints: const BoxConstraints(),
                                padding: const EdgeInsets.only(right: 8),
                                onPressed: () {
                                  setState(() {});
                                },
                                icon: const Icon(Icons.currency_rupee_outlined),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      // bottomSheet: buildShowModalBottomSheet(context),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          buildShowAddMemberModalBottomSheet(context);
        },
        backgroundColor: Colors.black,
        child: IconButton(
          onPressed: () {
            setState(() {
              buildShowAddMemberModalBottomSheet(context);
            });
          },
          icon: const Icon(Icons.add),
        ),
      ),
    );
  }

  Align buildCreateTripIconButton(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: IconButton(
        padding: const EdgeInsets.only(top: 8, right: 10, bottom: 33),
        alignment: Alignment.topRight,
        onPressed: () {
          setState(() {
            buildShowCreateTripModalBottomSheet(context);
          });
        },
        icon: const Icon(Icons.check, size: 27),
      ),
    );
  }

  Future<void> buildShowAddMemberModalBottomSheet(BuildContext context) {
    return showModalBottomSheet<void>(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, void setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(
                  height: 55,
                  child: Container(
                    margin: const EdgeInsets.only(left: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        const Text(
                          'Add Trip Member',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          iconSize: 22,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                nameFormFiledView(),
                mobileNumberFormFiledView(),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 18),
                  child: GestureDetector(
                      onTap: () {},
                      child: TripUtils()
                          .bottomButtonDesignView(buttonText: 'Add')),
                )
              ],
            );
          },
        );
      },
    );
  }

  Future<void> buildShowCreateTripModalBottomSheet(BuildContext context) {
    return showModalBottomSheet<void>(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context,void setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(
                  height: 55,
                  child: Container(
                    margin: const EdgeInsets.only(left: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        const Text(
                          'Create Trip',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          iconSize: 22,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                createTripNameFormFiledView(),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 18),
                  child: GestureDetector(
                      onTap: () {},
                      child: TripUtils()
                          .bottomButtonDesignView(buttonText: 'Create Trip')),
                )
              ],
            );
          },
        );
      },
    );
  }

  InputDecoration inputDecoration({required String hintText}) {
    return InputDecoration(
        hintText: hintText,
        focusColor: Colors.black,
        fillColor: Colors.grey.shade100,
        filled: true,
        contentPadding: const EdgeInsets.only(left: 8),
        border: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey,
            width: 2.0,
          ),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey,
          ),
        ),
        disabledBorder: const OutlineInputBorder(

        ));
  }

  Widget nameFormFiledView() {
    return Padding(
      padding: const EdgeInsets.only(left: 14, right: 14, top: 20),
      child: TextFormField(
        controller: _nameController,
        autofillHints: const [AutofillHints.name],
        cursorColor: Colors.black,
        decoration: inputDecoration(hintText: 'Name'),
        validator: (String? value) {
          if (value!.isEmpty) {
            return 'Please enter your name';
          } else if (value.length <= 2) {
            return 'Please enter your name more then 2 char';
          }
          return null;
        },
        // keyboardType: TextInputType.text,
      ),
    );
  }

  Widget createTripNameFormFiledView() {
    return Padding(
      padding: const EdgeInsets.only(left: 14, right: 14, top: 20),
      child: TextFormField(
        controller: _createTripNameController,
        autofillHints:  const [AutofillHints.name],
        cursorColor: Colors.black,
        decoration: inputDecoration(hintText: 'Trip Name'),
        validator: (String? value) {
          if (value!.isEmpty) {
            return 'Please enter your Trip name';
          } else if (value.length <= 2) {
            return 'Please enter your Trip name more then 1 char';
          }
          return null;
        },
        // keyboardType: TextInputType.text,
      ),
    );
  }

  Widget mobileNumberFormFiledView() {
    return Padding(
      padding: const EdgeInsets.only(left: 14, right: 14, top: 20),
      child: TextFormField(
        controller: _phoneController,
        autofillHints: const [AutofillHints.telephoneNumber],
        cursorColor: Colors.black,
        decoration: inputDecoration(hintText: 'mobile number'),
        keyboardType: TextInputType.phone,
        validator: (String? value) {
          const Pattern pattern =
              r'^(?:\+?1[-.●]?)?\(?([0-9]{3})\)?[-.●]?([0-9]{3})[-.●]?([0-9]{4})$';
          final RegExp regex = RegExp(pattern.toString());
          if (!regex.hasMatch(value!)) {
            return 'Enter a valid phone number';
          } else {
            return null;
          }
        },
      ),
    );
  }
}
