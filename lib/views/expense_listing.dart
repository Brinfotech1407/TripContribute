import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quickalert/quickalert.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:trip_contribute/models/trip_grid_data.dart';
import 'package:trip_contribute/models/trip_model.dart';
import 'package:trip_contribute/services/firestore_service.dart';
import 'package:trip_contribute/user/user_bloc.dart';
import 'package:trip_contribute/user/user_event.dart';
import 'package:trip_contribute/utils/grid_notes_utils.dart';
import 'package:trip_contribute/utils/tripUtils.dart';
import 'package:trip_contribute/views/add_grid_row_screen.dart';

class ExpenseListing extends StatefulWidget {
  const ExpenseListing({Key? key, required this.tripId, required this.tripData})
      : super(key: key);
  final String tripId;
  final TripModel tripData;

  @override
  State<ExpenseListing> createState() => _ExpenseListingState();
}

class _ExpenseListingState extends State<ExpenseListing> {
  List<TripGridColumn> arrTripColumns = <TripGridColumn>[];
  List<dynamic> trips = <dynamic>[];

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
                          arrColumnList: widget.tripData.columnNames,
                          arrNotesData: trips,
                          tripMemberList: widget.tripData.tripMemberDetails!),
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
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1,
            mainAxisExtent: MediaQuery.of(context).size.height,
            mainAxisSpacing: 10,
            crossAxisSpacing: 8),
        itemBuilder: (_, int index) {
          final TripModel arrItem = arrTripList[index];
          setUpGridView(arrItem);
          return GestureDetector(
            onTap: () {},
            child: Container(
              margin: const EdgeInsets.only(left: 6, right: 6),
              child: ListTile(
                contentPadding: const EdgeInsets.all(8),
                title: Text(
                  widget.tripData.tripName,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                  ),
                ),
                subtitle: Container(
                  height: MediaQuery.of(context).size.height,
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 7, bottom: 4),
                    child: tripDataSource?.rows.isNotEmpty != null &&
                            widget.tripData.TripDetails != null
                        ? SfDataGridTheme(
                            data:
                                SfDataGridThemeData(headerColor: Colors.white),
                            child: SfDataGrid(
                              source: tripDataSource!,
                              gridLinesVisibility: GridLinesVisibility.both,
                              headerRowHeight: 45,
                              rowHeight: 50,
                              allowSwiping: true,
                              allowColumnsResizing: true,
                              controller: _controller,
                              verticalScrollPhysics:
                                  const NeverScrollableScrollPhysics(),
                              horizontalScrollPhysics:
                                  const NeverScrollableScrollPhysics(),
                              headerGridLinesVisibility:
                                  GridLinesVisibility.both,
                              tableSummaryRows: [
                                GridTableSummaryRow(
                                  showSummaryInRow: false,
                                  title: 'Total Amount:',
                                  titleColumnSpan: 3,
                                  columns: getSummaryColumn(),
                                  position: GridTableSummaryRowPosition.bottom,
                                ),
                              ],
                              columns: getGridColumns(),
                            ),
                          )
                        : const Center(
                            child: Text('No Data found'),
                          ),
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
    if (widget.tripData.TripDetails != null) {
      arrTripColumns = getColumnData(arrItem.columnNames!);
      trips
        ..clear()
        ..addAll(widget.tripData.TripDetails!.reversed);
      tripDataSource = TripDataSource(
        tripData: trips,
        sortingApplied: () {},
        arrGridTripColumn: arrTripColumns,
      );
    }
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
            color: const Color.fromRGBO(107, 105, 105, 1),
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
    if (arrGridData.isNotEmpty) {
      saveNotes(
        arrGridData: arrGridData,
        newlyAddedEntries: gridValues,
      );
    } else {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.info,
        title: 'Oops...',
        text: 'Please enter proper Details',
      );
    }
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

  List<GridSummaryColumn> getSummaryColumn() {
    final List<GridSummaryColumn> arrSummaryColumn = <GridSummaryColumn>[];
    for (int i = 0; i < arrTripColumns.length; i++) {
      final TripGridColumn arrItem = arrTripColumns[i];
      if (arrItem.isNumericColumn && arrItem.showTotal!) {
        arrSummaryColumn.add(
          GridSummaryColumn(
            name: '${arrItem}_sum',
            columnName: arrItem.name!,
            summaryType: GridSummaryType.sum,
          ),
        );
      }
    }
    return arrSummaryColumn;
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
