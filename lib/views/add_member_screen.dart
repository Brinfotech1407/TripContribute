import 'package:flutter/material.dart';
import 'package:trip_contribute/tripUtils.dart';

class AddMemberScreen extends StatefulWidget {
  const AddMemberScreen({Key? key, required this.tripName}) : super(key: key);
  final String tripName;

  @override
  State<AddMemberScreen> createState() => _AddMemberScreenState();
}

class _AddMemberScreenState extends State<AddMemberScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _createTripNameController =
      TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  List<String> memberList = <String>[];

  @override
  void initState() {
    memberList.add(widget.tripName);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
              Expanded(
                child: Padding(
                    padding: const EdgeInsets.only(
                        left: 10, bottom: 10),
                    child: Text(
                      widget.tripName,
                      style: const TextStyle(fontSize: 22),
                    ),
                  ),
              ),
                buildCreateTripIconButton(context),
              ],
            ),
            Expanded(
              child: ListView.builder(
                itemCount: memberList.length,
                itemBuilder: (BuildContext context, int index) {
                  final String selactedMemeber = memberList[index];
                  return Card(
                    margin: const EdgeInsets.all(12),
                    elevation: 0,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        side: BorderSide(
                          width: 1,
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
                           Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                              selactedMemeber.toString(),
                              style: const TextStyle(fontSize: 18),
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
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
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
          Navigator.pop(context);
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
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: Column(
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
                        onTap: () {

                        },
                        child: TripUtils()
                            .bottomButtonDesignView(buttonText: 'Add')),
                  )
                ],
              ),
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
          borderSide: BorderSide(width: 1, color: Colors.grey),
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
            width: 1.0,
          ),
        ),
        disabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(width: 1, color: Colors.black),
        ));
  }

  Widget nameFormFiledView() {
    return Padding(
      padding: const EdgeInsets.only(left: 14, right: 14, top: 20),
      child: TextField(
        controller: _nameController,
        autofillHints: const [AutofillHints.name],
        cursorColor: Colors.black,
        decoration: inputDecoration(hintText: 'Name'),
      onSubmitted:(String value) {
          setState(() {
            memberList.add(value);
            _nameController.clear();
          });
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
        autofillHints: const [AutofillHints.name],
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
      child: TextField(
        controller: _phoneController,
        autofillHints: const [AutofillHints.telephoneNumber],
        cursorColor: Colors.black,
        decoration: inputDecoration(hintText: 'mobile number'),
        keyboardType: TextInputType.phone,
        onSubmitted:(String value) {
          setState(() {
            memberList.add(value);
            _phoneController.clear();
          });
        },
      ),
    );
  }
}
