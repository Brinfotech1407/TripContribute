import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quickalert/quickalert.dart';
import 'package:trip_contribute/tripUtils.dart';
import 'package:trip_contribute/user/user_bloc.dart';
import 'package:trip_contribute/user/user_state.dart';
import 'package:trip_contribute/views/add_member_screen.dart';

class CrateTripScreen extends StatefulWidget {
  CrateTripScreen({Key? key,  this.tripName}) : super(key: key);
  final String? tripName;

  @override
  State<CrateTripScreen> createState() => _CrateTripScreenState();
}

class _CrateTripScreenState extends State<CrateTripScreen> {
  final TextEditingController _createTripNameController = TextEditingController();
  List<String> selectedList = <String>[];
  List<String> addMemberList = <String>[];
   String userName = '';
   String userMno = '';

  @override
  void initState() {
    super.initState();
  }
  @override
  void dispose() {
    _createTripNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final DateTime date = DateTime.now();
    final String formattedDate = "${date.day}-${date.month}-${date.year}";

    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<UserBloc, UserState>(
          builder: (BuildContext context, UserState state) {
            if (state is GetSingleUser) {
              userName =state.userData.name;
              userMno =state.userData.mobileNo;
              return Column(
                children: [
                  Align(
                      alignment: Alignment.centerLeft,
                      child: createTripHeaderView(
                          userName: state.userData.name)),
                  if(selectedList.isNotEmpty)...<Widget>[
                    Expanded(
                      child: ListView.builder(
                        itemCount: selectedList.length,
                        itemBuilder: (BuildContext context, int index) {
                          final String tripName = selectedList[index];
                          return Card(
                            margin: const EdgeInsets.all(12),
                            elevation: 0,
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(8)),
                                side: BorderSide(
                                  color: Colors.grey,
                                )),
                            child: Padding(
                              padding: const EdgeInsets.all(14),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 10, bottom: 8),
                                          child: Text(
                                            tripName,
                                            style: const TextStyle(),
                                          ),
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: Text(
                                          formattedDate,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        color: Colors.yellowAccent,
                                        child:  Padding(
                                          padding: EdgeInsets.all(6.0),
                                          child: Text(state.userData.name),
                                        ),
                                      ),
                                      IconButton(
                                        constraints: const BoxConstraints(),
                                        padding: const EdgeInsets.only(right: 8),
                                        onPressed: () {},
                                        icon: const Icon(Icons.add),
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
                ],
              );
              }else if (state is UserLoading) {
              return _buildLoading();
               }else {
              return const Text('data not fetched!');
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _createTripNameController.dispose();
          buildShowCreateTripModalBottomSheet(context);
        },
        backgroundColor: Colors.black,
        child: IconButton(
          onPressed: () {
            buildShowCreateTripModalBottomSheet(context);
          },
          icon: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildLoading() => const Center(child: CircularProgressIndicator());
  Padding createTripHeaderView({required String userName}) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, top: 10, bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:  [
          const Padding(
            padding: EdgeInsets.only(bottom: 6,left: 8.0,top: 8.0),
            child:  Text(
              'Hello',
              textAlign: TextAlign.left,
              style:
                  TextStyle(fontSize: 16, fontWeight: FontWeight.bold, height: 1),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              userName,
              textAlign: TextAlign.left,
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, height: 1),
            ),
          ),
        ],
      ),
    );
  }
  Future<void> buildShowCreateTripModalBottomSheet(BuildContext context) {
    return showModalBottomSheet<void>(
     isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return  Padding(
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
                    onTap: () {
                      setState(() {
                        if(_createTripNameController.text.isNotEmpty) {
                          selectedList.add(_createTripNameController.text);
                           Navigator.of(context).push(
                              MaterialPageRoute<List<String>>(
                                  builder: (_) =>
                                      AddMemberScreen(tripName:_createTripNameController.text,
                                      userMno: userMno,userName: userName,)));
                        }else{
                          QuickAlert.show(
                            context: context,
                            type: QuickAlertType.warning,
                            title: 'Oops...',
                            text:
                            'You forgot to enter the Trip Name. Please enter the Trip Name to continue.',
                          );
                        }
                      });
                      _createTripNameController.text;
                    },
                    child: TripUtils()
                        .bottomButtonDesignView(buttonText: 'Create Trip')),
              )
            ],
          ),
        );
      },
    );
  }
  Widget createTripNameFormFiledView() {
    return Padding(
      padding: const EdgeInsets.only(left: 14, right: 14, top: 20),
      child: TextField(
        controller: _createTripNameController,
        autofillHints: const [AutofillHints.name],
        cursorColor: Colors.black,
        decoration: inputDecoration(hintText: 'Trip Name'),
         keyboardType: TextInputType.text,
      ),
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
        ));
  }
}
