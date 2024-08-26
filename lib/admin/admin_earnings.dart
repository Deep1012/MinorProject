import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class AdminEarnings extends StatefulWidget {
  const AdminEarnings({Key? key}) : super(key: key);

  @override
  _AdminEarningsState createState() => _AdminEarningsState();
}

class _AdminEarningsState extends State<AdminEarnings> {
  DateTime _selectedMonth = DateTime.now();
  DateTime _selectedDate = DateTime.now();
  List<_ChartData> _monthlyEarnings = [];
  double _dailyEarnings = 0.0;

  @override
  void initState() {
    super.initState();
    _fetchMonthlyEarnings();
  }

  Future<void> _fetchMonthlyEarnings() async {
    DateTime startOfMonth = DateTime(_selectedMonth.year, _selectedMonth.month, 1);
    DateTime endOfMonth = DateTime(_selectedMonth.year, _selectedMonth.month + 1, 0, 23, 59, 59);

    Timestamp startTimestamp = Timestamp.fromDate(startOfMonth);
    Timestamp endTimestamp = Timestamp.fromDate(endOfMonth);

    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection("CompletedOrders")
        .where('date', isGreaterThanOrEqualTo: startTimestamp)
        .where('date', isLessThanOrEqualTo: endTimestamp)
        .get();

    // Prepare data for weekly breakdown
    List<_ChartData> data = _prepareWeeklyData(snapshot);

    setState(() {
      _monthlyEarnings = data;
    });
  }

  List<_ChartData> _prepareWeeklyData(QuerySnapshot snapshot) {
    List<_ChartData> data = [];
    double week1Earnings = 0.0;
    double week2Earnings = 0.0;
    double week3Earnings = 0.0;
    double week4Earnings = 0.0;

    for (var doc in snapshot.docs) {
      DateTime date = (doc['date'] as Timestamp).toDate();
      double total = (doc['total'] as double);

      int weekNumber = ((date.day - 1) / 7).floor() + 1;
      switch (weekNumber) {
        case 1:
          week1Earnings += total;
          break;
        case 2:
          week2Earnings += total;
          break;
        case 3:
          week3Earnings += total;
          break;
        case 4:
          week4Earnings += total;
          break;
      }
    }

    data.add(_ChartData('Week 1', week1Earnings));
    data.add(_ChartData('Week 2', week2Earnings));
    data.add(_ChartData('Week 3', week3Earnings));
    data.add(_ChartData('Week 4', week4Earnings));

    return data;
  }

  Future<void> _fetchDailyEarnings(DateTime date) async {
    DateTime startOfDay = DateTime(date.year, date.month, date.day, 0, 0, 0);
    DateTime endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);

    Timestamp startTimestamp = Timestamp.fromDate(startOfDay);
    Timestamp endTimestamp = Timestamp.fromDate(endOfDay);

    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection("CompletedOrders")
        .where('date', isGreaterThanOrEqualTo: startTimestamp)
        .where('date', isLessThanOrEqualTo: endTimestamp)
        .get();

    double earnings = 0.0;
    for (var doc in snapshot.docs) {
      earnings += (doc['total'] as double);
    }

    setState(() {
      _dailyEarnings = earnings;
    });
  }

  void _selectMonth() async {
    DateTime now = DateTime.now();
    DateTime firstDayOfMonth = DateTime(now.year, now.month);
    DateTime lastDayOfMonth = DateTime(now.year, now.month + 1, 0);

    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: _selectedMonth,
      firstDate: firstDayOfMonth,
      lastDate: lastDayOfMonth,
    );

    if (selectedDate != null) {
      setState(() {
        _selectedMonth = DateTime(selectedDate.year, selectedDate.month);
        _fetchMonthlyEarnings();
      });
    }
  }

  void _selectDate() async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (selectedDate != null) {
      setState(() {
        _selectedDate = selectedDate;
        _fetchDailyEarnings(_selectedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Earnings'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: _selectMonth,
                    child: const Text('Select Month'),
                  ),
                  ElevatedButton(
                    onPressed: _selectDate,
                    child: const Text('Select Date'),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 300,
              child: SfCartesianChart(
                primaryXAxis: CategoryAxis(title: AxisTitle(text: 'Weeks')),
                primaryYAxis: NumericAxis(
                  title: AxisTitle(text: 'Earnings'),
                  minimum: 0,
                  maximum: 5000,
                  interval: 500,
                ),
                series: <ChartSeries>[
                  ColumnSeries<_ChartData, String>(
                    dataSource: _monthlyEarnings,
                    xValueMapper: (_ChartData data, _) => data.label,
                    yValueMapper: (_ChartData data, _) => data.total,
                    name: 'Earnings',
                    color: Colors.blue,
                  ),
                ],
                tooltipBehavior: TooltipBehavior(enable: true),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Daily Earnings for ${DateFormat.yMd().format(_selectedDate)}: ₹${_dailyEarnings.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChartData {
  _ChartData(this.label, this.total);

  final String label;
  final double total;
}
