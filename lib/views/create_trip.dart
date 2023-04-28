import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quickalert/quickalert.dart';
import 'package:trip_contribute/models/trip_grid_data.dart';
import 'package:trip_contribute/models/trip_member_model.dart';
import 'package:trip_contribute/services/preference_service.dart';
import 'package:trip_contribute/tripUtils.dart';
import 'package:trip_contribute/user/user_bloc.dart';
import 'package:trip_contribute/user/user_event.dart';
import 'package:trip_contribute/user/user_state.dart';
import 'package:trip_contribute/views/add_member_screen.dart';
import 'package:uuid/uuid.dart';

class CrateTripScreen extends StatefulWidget {
  CrateTripScreen({Key? key, this.userName}) : super(key: key);
  final String? userName;

  @override
  State<CrateTripScreen> createState() => _CrateTripScreenState();
}

class _CrateTripScreenState extends State<CrateTripScreen> {
  final TextEditingController _createTripNameController =
      TextEditingController();
  List<String> tripNameList = <String>[];
  List<String> addMemberList = <String>[];
  String tripUserName = '';
  String tripUserMno = '';

  final FirebaseAuth auth = FirebaseAuth.instance;
  final CollectionReference<Map<String, dynamic>> ref =
      FirebaseFirestore.instance.collection('Trip');
  final PreferenceService _preferenceService = PreferenceService();

  @override
  void initState() {
    super.initState();
    BlocProvider.of<UserBloc>(context).add(GetUserData());
  }

  @override
  void dispose() {
    _createTripNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final DateTime date = DateTime.now();
    final String formattedDate = '${date.day}-${date.month}-${date.year}';

    List<MaterialColor> colors = [
      Colors.grey,
      Colors.lightGreen,
      Colors.cyan,
      Colors.green,
      Colors.yellow,
    ];
    return Scaffold(
      body: SafeArea(
        child: BlocListener<UserBloc, UserState>(
          listener: (BuildContext context, UserState state) {
            if (state is PreferenceServiceInit) {
              tripUserName =
                  _preferenceService.getString(PreferenceService.User_Name) ??
                      '';
              tripUserMno = _preferenceService
                      .getString(PreferenceService.User_PhoneNo) ??
                  '';
            }
          },
          child: BlocBuilder<UserBloc, UserState>(
            builder: (BuildContext context, UserState state) {
              if (state is GetTripMemberData) {
                tripNameList.add(state.tripMemberData.tripName);
                return Column(
                  children: [
                    Align(
                        alignment: Alignment.centerLeft,
                        child: createTripHeaderView()),
                    Card(
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
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10, bottom: 8),
                                    child: Text(
                                      state.tripMemberData.tripName,
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
                            Container(
                              height: 60,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  /* Flexible(
                                    child: ListView.builder(
                                      itemCount:
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        final String? memberName = state
                                            .tripMemberData
                                            .tripMemberDetails
                                            ?.last
                                            .tripMemberName![index];
                                        return Row(
                                          children: [
                                            Container(
                                              color: colors[index],
                                              margin: const EdgeInsets.all(8),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(6.0),
                                                child: Text(memberName!),
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                  ),*/
                                  IconButton(
                                    constraints: const BoxConstraints(),
                                    padding: const EdgeInsets.only(right: 8),
                                    onPressed: () {},
                                    icon: const Icon(Icons.add),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              } else if (state is GetSingleUser) {
                return Column(
                  children: [
                    Align(
                        alignment: Alignment.centerLeft,
                        child: createTripHeaderView()),
                    if (tripNameList.isNotEmpty) ...<Widget>[
                      Expanded(
                        child: ListView.builder(
                          itemCount: tripNameList.length,
                          itemBuilder: (BuildContext context, int index) {
                            final String tripName = tripNameList[index];
                            return Card(
                              margin: const EdgeInsets.all(12),
                              elevation: 0,
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8)),
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
                                          child: Padding(
                                            padding: EdgeInsets.all(6.0),
                                            child: Text(state.userData.name),
                                          ),
                                        ),
                                        IconButton(
                                          constraints: const BoxConstraints(),
                                          padding:
                                              const EdgeInsets.only(right: 8),
                                          onPressed: () {
                                            print('tripUserName $tripUserName');

                                            Navigator.of(context).push(
                                              MaterialPageRoute<List<String>>(
                                                builder: (_) => AddMemberScreen(
                                                  tripName: tripNameList.last,
                                                  userMno:
                                                      tripUserMno.substring(3),
                                                  userName: tripUserName,
                                                ),
                                              ),
                                            );
                                          },
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
              } else if (state is UserLoading) {
                return _buildLoading();
              } else {
                return const Center(child: Text('no trip(s) found!'));
              }
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _createTripNameController.text = '';
          buildShowCreateTripModalBottomSheet(context);
        },
        backgroundColor: Colors.black,
        child: IconButton(
          onPressed: () {
            _createTripNameController.text = '';
            buildShowCreateTripModalBottomSheet(context);
          },
          icon: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildLoading() => const Center(child: CircularProgressIndicator());

  Padding createTripHeaderView({String? userName}) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, top: 10, bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 6, left: 8.0, top: 8.0),
            child: Text(
              'Hello',
              textAlign: TextAlign.left,
              style: TextStyle(
                  fontSize: 16, fontWeight: FontWeight.bold, height: 1),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              userName ?? 'Bhavika',
              textAlign: TextAlign.left,
              style: const TextStyle(
                  fontSize: 16, fontWeight: FontWeight.bold, height: 1),
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
                          _createTripNameController.clear();
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
                        if (_createTripNameController.text.isNotEmpty) {
                          tripNameList.add(_createTripNameController.text);
                          print('tripUserName $tripUserName');
                          final TripGridColumn itemToInsert = TripGridColumn(
                            name: '',
                            columnType: 'Free Text',
                            isRequired: true,
                            showAutoSuggestion: true,
                          );

                          context.read<UserBloc>().add(AddMemberDetails(
                                tripName: _createTripNameController.text,
                                id: const Uuid().v4(),
                                tripMemberDetails:
                                    TripMemberModel('908776677', 'abc'),
                                tripGridColumnDetails: itemToInsert,
                              ));

                          Navigator.of(context)
                              .pushReplacement(MaterialPageRoute<List<String>>(
                                  builder: (_) => AddMemberScreen(
                                        tripName: tripNameList.last,
                                        userMno: tripUserMno, //.stringsub(3),
                                        userName: tripUserName,
                                      )));
                          _createTripNameController.clear();
                          //Navigator.pop(context);
                        } else {
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
          ),
        ),
        disabledBorder: const OutlineInputBorder());
  }
}
