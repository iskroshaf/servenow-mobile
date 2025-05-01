import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:servenow_mobile/services/tasker_e_statement.dart';

class EStatement extends StatefulWidget {
  final bool showLeadingIcon;

  const EStatement({super.key, this.showLeadingIcon = true});

  @override
  State<EStatement> createState() => _EStatementState();
}

class _EStatementState extends State<EStatement> {
  List<dynamic> data = [];
  Map<String, dynamic> monthlyReleasedAmounts = {};
  List<dynamic> yearlyReleasedAmounts = [];

  dynamic tobeReleased = 0;
  dynamic releasedthisyear = 0;
  dynamic releasedAll = 0;

  List<double> barHeightsMonth =
      List.generate(12, (_) => 0.0);

  Future<void> _loadTaskerEStatement() async {
    try {
      var response = await TaskerEStatement().getEStatement();
      if (response['statusCode'] == 200) {
        setState(() {
          data = response['data'];
          monthlyReleasedAmounts = response['monthlyReleasedAmounts'];
          yearlyReleasedAmounts = response['yearlyReleasedAmounts'];


          barHeightsMonth = List.generate(12, (index) {
            return (monthlyReleasedAmounts[index.toString()] ?? 0.0).toDouble();
          });

          tobeReleased = response['tobeReleased'];
          releasedthisyear = response['releasedthisyear'];
          releasedAll = response['releasedAll'];
        });
      } else {
        print('Failed to load booking list: ${response['statusCode']}');
      }
    } catch (e) {
      print('Error occurred: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _loadTaskerEStatement();
  }

  final List<double> barHeightsYear = [
    5.0,
    10.0,
    7.0,
    12.0,
    9.0,
    15.0,
    8.0,
    11.0,
    6.0,
    14.0,
    10.0,
    13.0,
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          backgroundColor: const Color.fromRGBO(24, 52, 92, 1),
          centerTitle: true,
          elevation: 0,
          title: const Text(
            'e-Statement',
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Inter',
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: widget.showLeadingIcon
              ? IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              : null,
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(7.5)),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Released Amount',
                            style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 13,
                                fontWeight: FontWeight.normal,
                                color: Colors.grey.shade800),
                          ),
                          Text(
                            '(~) RM $tobeReleased',
                            style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.orange.shade600),
                          ),
                           Text(
                            'Pending Payouts',
                            style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 11,
                                fontWeight: FontWeight.normal,
                                color: Colors.grey.shade700),
                          ),
                        ],
                      ),
                      // Spacer(),
                      // ElevatedButton(
                      //   onPressed: () {
                      //     Navigator.pushNamed(context, '/e_statement_list');
                      //   },
                      //   style: ElevatedButton.styleFrom(
                      //     elevation:
                      //         2, // Adjust this value to control shadow intensity
                      //     backgroundColor: Colors.white,
                      //     padding: const EdgeInsets.symmetric(
                      //         vertical: 12, horizontal: 20),
                      //     shape: RoundedRectangleBorder(
                      //       borderRadius: BorderRadius.circular(8.0),
                      //     ),
                      //     shadowColor: Colors.grey.withOpacity(
                      //         0.5), // Shadow color and transparency
                      //   ).copyWith(
                      //     overlayColor:
                      //         WidgetStateProperty.all(Colors.transparent),
                      //   ),
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.center,
                      //     children: [
                      //       Text(
                      //         'e-Statement List',
                      //         style: TextStyle(
                      //           fontFamily: 'Inter',
                      //           fontSize: 12,
                      //           fontWeight: FontWeight.bold,
                      //           color: Colors.grey.shade600,
                      //         ),
                      //       ),
                      //       SizedBox(width: 10),
                      //       FaIcon(
                      //         FontAwesomeIcons.solidEye,
                      //         color: Colors.blue,
                      //         size: 14,
                      //       ),
                      //     ],
                      //   ),
                      // ),
                    ],
                  )),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(7.5)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Total Earnings',
                              style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 13,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.grey.shade800),
                            ),
                            Text(
                              'RM $releasedthisyear',
                              style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green.shade600),
                            ),
                            Text(
                              'Yearly Amount Earned',
                              style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 11,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.grey.shade600),
                            ),
                          ],
                        )),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(7.5)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Total Earnings',
                              style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 13,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.grey.shade800),
                            ),
                            Text(
                              'RM $releasedAll',
                              style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red.shade600),
                            ),
                            Text(
                              'All Amount Earned',
                              style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 11,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.grey.shade600),
                            ),
                          ],
                        )),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Container(
                    width: 500,
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(7.5),
                    ),
                    child: Column(
                      children: [
                        Center(
                          child: Text(
                            'Monthly Earnings',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 13,
                              fontWeight: FontWeight.normal,
                              color: Colors.grey.shade800,
                            ),
                          ),
                        ),
                        SizedBox(height: 5),
                        Center(
                          child: Text(
                            'Released Amount (RM)',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.cyan,
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        SizedBox(
                          height: 140,
                          child: BarChart(
                            BarChartData(
                              alignment: BarChartAlignment.spaceAround,
                              barTouchData: BarTouchData(enabled: false),
                              titlesData: FlTitlesData(
                                leftTitles: AxisTitles(
                                  axisNameWidget: SizedBox(
                                    child: Text(
                                      'Amount (RM)',
                                      style: TextStyle(
                                        color: Colors.grey.shade800,
                                        fontFamily: 'Inter',
                                        fontSize: 12,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    reservedSize: 35,
                                    getTitlesWidget: (value, meta) {
                                      return Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Text(
                                          value.toInt().toString(),
                                          style: TextStyle(
                                            fontFamily: 'Inter',
                                            fontSize: 12,
                                            color: Colors.grey.shade600,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    reservedSize: 30,
                                    getTitlesWidget: (value, meta) {
                                      final months = [
                                        'Jan',
                                        'Feb',
                                        'Mar',
                                        'Apr',
                                        'May',
                                        'Jun',
                                        'Jul',
                                        'Aug',
                                        'Sep',
                                        'Oct',
                                        'Nov',
                                        'Dec'
                                      ];
                                      return Text(
                                        months[value.toInt()],
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: 12,
                                          color: Colors.grey.shade800,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                topTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                                rightTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                              ),
                              borderData: FlBorderData(show: false),
                              gridData: FlGridData(
                                getDrawingHorizontalLine: (value) {
                                  return FlLine(
                                    color: Colors.grey.shade300,
                                    strokeWidth: 1,
                                  );
                                },
                                drawVerticalLine: false,
                              ),
                              barGroups: List.generate(12, (index) {
                                return BarChartGroupData(
                                  x: index,
                                  barRods: [
                                    BarChartRodData(
                                      borderRadius: BorderRadius.zero,
                                      borderSide: BorderSide(
                                          width: 1, color: Colors.cyan),
                                      width: 15,
                                      fromY: 0,
                                      toY: barHeightsMonth[index],
                                      color: Colors.cyan.withOpacity(0.75),
                                    ),
                                  ],
                                );
                              }),
                            ),
                          ),
                        ),
                        Text(
                          'Month',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 12,
                            fontWeight: FontWeight.normal,
                            color: Colors.grey.shade800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Container(
                    width: 500,
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(7.5),
                    ),
                    child: Column(
                      children: [
                        Center(
                          child: Text(
                            'Yearly Earnings',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 13,
                              fontWeight: FontWeight.normal,
                              color: Colors.grey.shade800,
                            ),
                          ),
                        ),
                        SizedBox(height: 5),
                        Center(
                          child: Text(
                            'Released Amount (RM)',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.indigoAccent,
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        SizedBox(
                          height: 140,
                          child: BarChart(
                            BarChartData(
                              alignment: BarChartAlignment.spaceAround,
                              barTouchData: BarTouchData(enabled: false),
                              titlesData: FlTitlesData(
                                leftTitles: AxisTitles(
                                  axisNameWidget: SizedBox(
                                    child: Text(
                                      'Amount (RM)',
                                      style: TextStyle(
                                        color: Colors.grey.shade800,
                                        fontFamily: 'Inter',
                                        fontSize: 12,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    reservedSize: 35,
                                    getTitlesWidget: (value, meta) {
                                      return Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Text(
                                          value.toInt().toString(),
                                          style: TextStyle(
                                            fontFamily: 'Inter',
                                            fontSize: 12,
                                            color: Colors.grey.shade600,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    reservedSize: 30,
                                    getTitlesWidget: (value, meta) {
                                      final months = [
                                        'Jan',
                                        'Feb',
                                        'Mar',
                                        'Apr',
                                        'May',
                                        'Jun',
                                        'Jul',
                                        'Aug',
                                        'Sep',
                                        'Oct',
                                        'Nov',
                                        'Dec'
                                      ];
                                      return Text(
                                        months[value.toInt()],
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: 12,
                                          color: Colors.grey.shade800,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                topTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                                rightTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                              ),
                              borderData: FlBorderData(show: false),
                              gridData: FlGridData(
                                getDrawingHorizontalLine: (value) {
                                  return FlLine(
                                    color: Colors.grey.shade300,
                                    strokeWidth: 1,
                                  );
                                },
                                drawVerticalLine: false,
                              ),
                              barGroups: List.generate(12, (index) {
                                return BarChartGroupData(
                                  x: index,
                                  barRods: [
                                    BarChartRodData(
                                        borderRadius: BorderRadius.zero,
                                        borderSide: BorderSide(
                                            width: 1,
                                            color: Colors.indigoAccent),
                                        width: 15,
                                        fromY: 0,
                                        toY: barHeightsYear[index],
                                        color: Colors.indigoAccent
                                            .withOpacity(0.75)),
                                  ],
                                );
                              }),
                            ),
                          ),
                        ),
                        Text(
                          'Year',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 12,
                            fontWeight: FontWeight.normal,
                            color: Colors.grey.shade800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
            ],
          ),
        ));
  }
}
