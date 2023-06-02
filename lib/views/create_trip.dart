import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quickalert/quickalert.dart';
import 'package:trip_contribute/models/trip_grid_data.dart';
import 'package:trip_contribute/models/trip_member_model.dart';
import 'package:trip_contribute/models/trip_model.dart';
import 'package:trip_contribute/services/firestore_service.dart';
import 'package:trip_contribute/services/preference_service.dart';
import 'package:trip_contribute/user/user_bloc.dart';
import 'package:trip_contribute/user/user_event.dart';
import 'package:trip_contribute/user/user_state.dart';
import 'package:trip_contribute/utils/tripUtils.dart';
import 'package:trip_contribute/views/expense_listing.dart';
import 'package:trip_contribute/views/member/add_member_screen.dart';
import 'package:uuid/uuid.dart';

class CrateTripScreen extends StatefulWidget {
  const CrateTripScreen({Key? key, this.userName}) : super(key: key);
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
  String tripId = '';

  final PreferenceService _preferenceService = PreferenceService();
  List<TripMemberModel> arrMemberIDListNotifier = <TripMemberModel>[];
  List<TripGridColumn> arrGridTripColumn = <TripGridColumn>[];

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
          child: Padding(
              padding: const EdgeInsets.all(8),
              child: StreamBuilder<List<TripModel>>(
                  builder: (BuildContext context,
                      AsyncSnapshot<List<TripModel>> snapshot) {
                    if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          createTripHeaderView(
                              userName: snapshot.data!.first.tripMemberDetails!
                                  .first.tripMemberName),
                          Flexible(
                            child: ListView.builder(
                              itemCount: snapshot.data!.length,
                              key: const PageStorageKey(
                                  '' /*here put the your list unique id */),
                              keyboardDismissBehavior:
                                  ScrollViewKeyboardDismissBehavior.onDrag,
                              itemBuilder: (BuildContext context, int index) {
                                final TripModel tripData =
                                    snapshot.data![index];

                                tripId = tripData.tripId;

                                return GestureDetector(
                                  onTap: () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute<List<String>>(
                                            builder: (_) => ExpenseListing(
                                                  tripId: tripData.tripId,
                                                  tripData: tripData,
                                                )));
                                  },
                                  child: Card(
                                    margin: const EdgeInsets.all(12),
                                    elevation: 0,
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8)),
                                        side: BorderSide(
                                          color: Colors.grey,
                                        )),
                                    child: Container(
                                      margin: const EdgeInsets.all(10),
                                      padding: const EdgeInsets.only(left: 4),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(tripData.tripName,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20)),
                                          Container(
                                            height: 40,
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Flexible(
                                                  child: ListView.builder(
                                                    shrinkWrap: true,
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    itemCount: tripData
                                                        .tripMemberDetails!
                                                        .length,
                                                    itemBuilder:
                                                        (BuildContext context,
                                                            int index) {
                                                      final TripMemberModel
                                                          memberName =
                                                          tripData.tripMemberDetails![
                                                              index];
                                                      return Container(
                                                        height: 40,
                                                        width: 40,
                                                        margin: const EdgeInsets
                                                            .only(right: 5),
                                                        decoration: BoxDecoration(
                                                            shape:
                                                                BoxShape.circle,
                                                            border: Border.all(
                                                                color: Colors
                                                                    .grey
                                                                    .shade700)),
                                                        child: Center(
                                                          child: Text(
                                                              memberName
                                                                  .tripMemberName!
                                                                  .substring(
                                                                      0, 1)
                                                                  .toUpperCase(),
                                                              style: TextStyle(
                                                                color: Color((math.Random().nextDouble() *
                                                                            0xFFFFFF)
                                                                        .toInt())
                                                                    .withOpacity(
                                                                        1.0),
                                                              )),
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      );
                    } else if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return TripUtils().buildLoading();
                    } else {
                      return const Center(child: Text('no trip(s) found!'));
                    }
                  },
                  stream: DatabaseManager().listenTripsData())),
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


  Padding createTripHeaderView({String? userName}) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, top: 10, bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
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
              userName ?? 'Trip Name',
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
                          _createTripNameController.clear();
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
                        if (_createTripNameController.text.isNotEmpty) {
                          tripId = tripUserId();
                          tripNameList.add(_createTripNameController.text);
                          addTripColumn();
                          addMemberName();

                          context.read<UserBloc>().add(CreateTripData(
                                tripName: _createTripNameController.text,
                                id: tripId,
                                tripMemberDetails: arrMemberIDListNotifier,
                                tripGridColumnDetails: arrGridTripColumn,
                              ));
                          Navigator.pop(context);

                          Navigator.of(context)
                              .push(MaterialPageRoute<List<String>>(
                                  builder: (_) => AddMemberScreen(
                                        tripName: tripNameList.last,
                                        userMno: tripUserMno,
                                        userName: tripUserName,
                                        tripId: tripId,
                                      )));
                          _createTripNameController.clear();
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

  String tripUserId() => const Uuid().v4();

  void addTripColumn() {
    final TripGridColumn itemName = TripGridColumn(
      name: 'Name',
      columnType: 'Free Text',
      isRequired: true,
    );

    final TripGridColumn itemDescription = TripGridColumn(
      name: 'Description',
      columnType: 'Free Text',
      isRequired: true,
      showAutoSuggestion: true,
    );

    final TripGridColumn itemAmount = TripGridColumn(
      name: 'Amount',
      columnType: 'Numeric',
      isRequired: true,
      showTotal: true,
    );
    arrGridTripColumn
      ..add(itemName)
      ..add(itemDescription)
      ..add(itemAmount);
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
        disabledBorder: const OutlineInputBorder());
  }

  void addMemberName() {
    final TripMemberModel itemName = TripMemberModel(tripUserName, tripUserMno);
    arrMemberIDListNotifier.add(itemName);
  }
}
