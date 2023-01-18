import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trip_contribute/blocs/ok_done_bloc/ok_done_bloc.dart';

extension BlocExtensions on BuildContext {
  OkDoneBloc get okDoneBloc => BlocProvider.of<OkDoneBloc>(this);
}
