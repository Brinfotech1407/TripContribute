import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:trip_contribute/models/trip_grid_data.dart';
import 'package:trip_contribute/models/trip_member_model.dart';
import 'package:trip_contribute/models/trip_model.dart';
import 'package:trip_contribute/services/firestore_service.dart';
import 'package:trip_contribute/user/user_bloc.dart';
import 'package:trip_contribute/user/user_event.dart';
import 'package:trip_contribute/utils/grid_notes_utils.dart';
import 'package:trip_contribute/utils/tripUtils.dart';
import 'package:trip_contribute/views/add_grid_row_screen.dart';

class ExpenseListing extends StatefulWidget {
  const ExpenseListing({Key? key, required this.tripId}) : super(key: key);
  final String tripId;

  @override
  State<ExpenseListing> createState() => _ExpenseListingState();
}

class _ExpenseListingState extends State<ExpenseListing> {
  List<TripGridColumn> arrTripColumns = <TripGridColumn>[];
  List<dynamic> trips = <dynamic>[];
  List<TripMemberModel> tripMemberList = <TripMemberModel>[];

  final DataGridController _controller = DataGridController();
  Map<String, ColumnResizeUpdateDetails> mapColumnReSizingMode =
      <String, ColumnResizeUpdateDetails>{};
  TripDataSource? tripDataSource;

  @override
  void initState() {
    tripDataSource = TripDataSource(
      tripData: trips,
      arrGridTripColumn: arrTripColumns,
      sortingApplied: () {},
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<TripModel>>(
        stream: DatabaseManager().listenTripsData(),
        builder:
            (BuildContext context, AsyncSnapshot<List<TripModel>> snapshot) {
          return Scaffold(
            body: getGridView(snapshot.data ?? []),
            floatingActionButton: FloatingActionButton(
              onPressed: () {},
              backgroundColor: Colors.black,
              child: IconButton(
                onPressed: () async {
                  final Map<String, dynamic>? gridValues =
                      await Navigator.of(context).push(
                    MaterialPageRoute<Map<String, dynamic>>(
                      builder: (_) => AddGridRowScreen(
                          arrColumnList: arrTripColumns,
                          arrNotesData: trips,
                          tripMemberList: tripMemberList),
                    ),
                  );

                  saveGridNotes(gridValues);
                },
                icon: const Icon(Icons.add),
              ),
            ),
          );
        });
  }

  Widget getGridView(List<TripModel> arrTripList) {
    if (arrTripList.isNotEmpty) {
      return GridView.builder(
        itemCount: 1,
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1,
            mainAxisExtent: 250,
            mainAxisSpacing: 10,
            crossAxisSpacing: 8),
        itemBuilder: (_, int index) {
          final TripModel arrItem = arrTripList[index];
          if (arrItem.tripMemberDetails!.isNotEmpty) {
            tripMemberList
              ..clear()
              ..addAll(arrItem.tripMemberDetails!);
          }
          setUpGridView(arrItem);
          return GestureDetector(
            onTap: () {},
            child: Container(
              margin: const EdgeInsets.only(left: 6, right: 6),
              child: ListTile(
                contentPadding: const EdgeInsets.all(8),
                title: Text(
                  arrItem.tripName,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                  ),
                ),
                subtitle: Container(
                  height: MediaQuery.of(context).size.height,
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 7, bottom: 4),
                    child: tripDataSource != null
                        ? SfDataGrid(
                            source: tripDataSource!,
                            gridLinesVisibility: GridLinesVisibility.both,
                            headerRowHeight: 45,
                            rowHeight: 50,
                            controller: _controller,
                            verticalScrollPhysics:
                                const NeverScrollableScrollPhysics(),
                            horizontalScrollPhysics:
                                const NeverScrollableScrollPhysics(),
                            headerGridLinesVisibility: GridLinesVisibility.both,
                            columns: getGridColumns(),
                          )
                        : Container(),
                  ),
                ),
              ),
            ),
          );
        },
      );
    } else {
      return Container(
        height: 0,
        width: 0,
      );
    }
  }

  void setUpGridView(TripModel arrItem) {
    arrTripColumns = getColumnData(arrItem.columnNames!);
    trips
      ..clear()
      ..addAll(arrItem.TripDetails!.reversed);
    tripDataSource = TripDataSource(
      tripData: trips,
      sortingApplied: () {},
      arrGridTripColumn: arrTripColumns,
    );
  }

  List<TripGridColumn> getColumnData(List<TripGridColumn> gridColumns) {
    arrTripColumns.clear();

    if (gridColumns.isNotEmpty) {
      final List<TripGridColumn> arrTempColumnList = <TripGridColumn>[
        TripGridColumn(
          name: 'no',
          columnType: 'Free Text',
        ),
        ...gridColumns
      ];
      arrTripColumns.addAll(arrTempColumnList);
      return arrTripColumns;
    } else {
      return <TripGridColumn>[];
    }
  }

  List<GridColumn> getGridColumns() {
    final List<GridColumn> arrColumnList = <GridColumn>[];

    for (int i = 0; i < arrTripColumns.length; i++) {
      final TripGridColumn column = arrTripColumns[i];
      final String alphabet = getAlphabet(column.name!, i);
      final double columnWidth = getColumnWidth(column.name!, column);
      final String columnDisplay =
          getColumnDisplayName(alphabet, column.name ?? '', column);

      arrColumnList.add(
        GridColumn(
          columnName: column.name ?? '',
          width: columnWidth,
          label: Container(
            padding: const EdgeInsets.all(2),
            color: Colors.blue.shade400,
            alignment: Alignment.center,
            child: Text(
              columnDisplay,
              softWrap: true,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
      );
    }
    return arrColumnList;
  }

  String getAlphabet(String column, int i) {
    return TripUtils.getAlphabetsList()[i];
  }

  double getColumnWidth(String column, TripGridColumn gridColumn) {
    if (gridColumn.isNoColumn) {
      return 40;
    }
    return mapColumnReSizingMode.containsKey(column.toLowerCase())
        ? mapColumnReSizingMode[column.toLowerCase()]!.width
        : 90;
  }

  String getColumnDisplayName(
      String alphabet, String column, TripGridColumn gridColumn) {
    if (gridColumn.isNoColumn) {
      return ' ';
    }
    return '$alphabet : ${column.toUpperCase()}';
  }

  void saveGridNotes(Map<String, dynamic>? gridValues) {
    final List<dynamic> arrGridData = trips..add(gridValues);

    saveNotes(
      arrGridData: arrGridData,
      newlyAddedEntries: gridValues,
    );
  }

  void saveNotes({
    String additionalNotes = '',
    List<dynamic>? arrGridData,
    Map<String, dynamic>? newlyAddedEntries,
  }) {
    if (newlyAddedEntries != null) {
      context.read<UserBloc>().add(UpdateExpenseRowData(
            tripId: widget.tripId,
            tripExpenseDetails: newlyAddedEntries,
          ));
    }
  }
}

class TripDataSource extends DataGridSource {
  /// Creates the notes data source class with required details.
  TripDataSource({
    required List<dynamic> tripData,
    required List<TripGridColumn>? arrGridTripColumn,
    required VoidCallback? sortingApplied,
  }) {
    this.sortingApplied = sortingApplied;
    _tripData.clear();
    for (int i = 0; i < tripData.length; i++) {
      final dynamic arrItem = tripData[i];
      final int counter = tripData.length - i;
      _tripData.add(
        DataGridRow(
          cells: generateCells(arrItem, arrGridTripColumn, counter),
        ),
      );
    }
    _arrGridNotesColumn!.addAll(arrGridTripColumn!);
  }

  final List<DataGridRow> _tripData = <DataGridRow>[];
  VoidCallback? sortingApplied;
  final List<TripGridColumn>? _arrGridNotesColumn = <TripGridColumn>[];

  List<DataGridCell<dynamic>> generateCells(
    dynamic e,
    List<TripGridColumn>? arrGridTripColumn,
    int counter,
  ) {
    final List<DataGridCell> arrDataGridCell = <DataGridCell>[];

    for (final TripGridColumn key in arrGridTripColumn ?? <TripGridColumn>[]) {
      arrDataGridCell.add(
        DataGridCell<dynamic>(
          columnName: key.name!,
          value: getValueFromKey(e, key.name!, counter, key),
        ),
      );
    }

    return arrDataGridCell;
  }

  dynamic getValueFromKey(
    dynamic e,
    String key,
    int counter,
    TripGridColumn columnData,
  ) {
    print('getValueFromKey ${e}');
    if (columnData.isNumericColumn) {
      return e[key] != null ? double.parse(e[key] as String) : 0;
    }

    return e[key] != null ? e[key] as String : '';
  }

  @override
  List<DataGridRow> get rows => _tripData;

  /*@override
  void performSorting(List<DataGridRow> rows) {
    super.performSorting(rows);
    sortingApplied?.call();
  }*/

  @override
  Widget? buildTableSummaryCellWidget(
    GridTableSummaryRow summaryRow,
    GridSummaryColumn? summaryColumn,
    RowColumnIndex rowColumnIndex,
    String summaryValue,
  ) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(4),
      child: Text(summaryValue),
    );
  }

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((DataGridCell e) {
      return Container(
        padding: const EdgeInsets.all(4),
        alignment: Alignment.center,
        child: Text(
          e.value.toString(),
          style: const TextStyle(
            color: Colors.blue,
          ),
        ),
      );
    }).toList());
  }
}