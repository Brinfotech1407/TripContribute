import 'package:flutter/material.dart';
import 'package:trip_contribute/tripUtils.dart';
import 'package:trip_contribute/views/create_trip.dart';

class CreateTripDialog extends StatefulWidget {
  const CreateTripDialog({Key? key}) : super(key: key);

  @override
  State<CreateTripDialog> createState() => _CreateTripDialogState();
}

class _CreateTripDialogState extends State<CreateTripDialog> {
  final TextEditingController _nameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            createTripDialogHeaderView(),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            nameFormFiledView(),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 18),
              child: GestureDetector(
                  onTap: () {
                    if(_nameController.text.isNotEmpty) {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) {
                            return CrateTripScreen(
                                tripName: _nameController.text);
                          },
                        ),
                      );
                    }
                    _nameController.text;
                  },
                  child: TripUtils()
                      .bottomButtonDesignView(buttonText: 'Create Trip')),
            )
          ],
        ),
          ],
        ),
      ),
    );
  }

  Widget createTripDialogHeaderView() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IconButton(
            padding: EdgeInsets.zero,
            onPressed: () {},
            icon: const Icon(Icons.arrow_back_rounded)),
        const Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            'Create Trip',
            textAlign: TextAlign.left,
            style:
                TextStyle(fontSize: 16, fontWeight: FontWeight.bold, height: 1),
          ),
        ),
      ],
    );
  }


  Widget nameFormFiledView() {
    return Padding(
      padding: const EdgeInsets.only(left: 14, right: 14, top: 20),
      child: TextFormField(
        controller: _nameController,
        autofillHints: const [AutofillHints.name],
        cursorColor: Colors.black,
        decoration: inputDecoration(hintText: 'Trip Name'),
        validator: (value) {
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

}
