import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trip_contribute/tripUtils.dart';
import 'package:trip_contribute/user/user_bloc.dart';
import 'package:trip_contribute/user/user_event.dart';
import 'package:trip_contribute/user/user_state.dart';

class AddMemberScreen extends StatefulWidget {
  const AddMemberScreen(
      {Key? key,
      required this.tripName,
      required this.userName,
      required this.userMno})
      : super(key: key);
  final String tripName;
  final String userName;
  final String userMno;

  @override
  State<AddMemberScreen> createState() => _AddMemberScreenState();
}

class _AddMemberScreenState extends State<AddMemberScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _createTripNameController =
      TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  List<String> selectedMemberNameList = <String>[];
  List<String> selectedMemberMnoList = <String>[];

  @override
  void initState() {
    selectedMemberNameList.add(widget.userName);
    selectedMemberMnoList.add(widget.userMno);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocListener<UserBloc, UserState>(
          listener: (BuildContext context, Object? state) {
        /*    if (state is ) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(const SnackBar(content: Text('Users added!')));
            }*/
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              buildHeaderView(context),
              Flexible(
                child: ListView.builder(
                  itemCount: selectedMemberNameList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      height: 140,
                      child: Card(
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
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                selectedMemberNameList[index],
                                style: const TextStyle(fontSize: 17),
                              ),
                          Row(
                            children: [
                              Expanded(
                                  child: Text(
                                      selectedMemberMnoList[index]
                                          .substring(3))),
                              IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.delete),
                              ),
                            ],
                          ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
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

  Row buildHeaderView(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 10, bottom: 10),
            child: Text(
              widget.tripName,
              style: const TextStyle(fontSize: 22),
            ),
          ),
        ),
        buildCreateTripIconButton(context),
      ],
    );
  }

  Align buildCreateTripIconButton(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: IconButton(
        padding: const EdgeInsets.only(top: 8, right: 10, bottom: 33),
        alignment: Alignment.topRight,
        onPressed: () {
          context.read<UserBloc>().add(AddMemberDetails(
            tripName: widget.tripName ,
            tripMemberName: selectedMemberNameList.first,
            tripMemberMno: selectedMemberMnoList.first,
          ));
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
                      if (_nameController.text.isNotEmpty &&
                          _phoneController.text.isNotEmpty) {
                        setState(() {
                          selectedMemberMnoList.add(_phoneController.text);
                          selectedMemberNameList.add(_nameController.text);
                          _nameController.clear();
                          _phoneController.clear();
                          Navigator.pop(context);
                        });

                        print(selectedMemberMnoList);
                        print(selectedMemberNameList);
                      }
                    },
                    child:
                        TripUtils().bottomButtonDesignView(buttonText: 'Add')),
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
        onSubmitted: (String value) {
          setState(() {
            selectedMemberNameList.add(value);
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
        onSubmitted: (String value) {
          setState(() {
            selectedMemberNameList.add(value);
            _phoneController.clear();
          });
        },
      ),
    );
  }

  Widget _buildLoading() => const Center(child: CircularProgressIndicator());
}
