import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart';
import 'package:trip_contribute/models/okdone_state.dart';

part 'serializers.g.dart';

@SerializersFor(<Type>[
  OkDoneState,
])
// serializers used by the app
// serializers used by the app
final Serializers serializers =
    (_$serializers.toBuilder()..addPlugin(StandardJsonPlugin())).build();
