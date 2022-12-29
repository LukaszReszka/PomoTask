import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TimeSettingsDrawer extends StatelessWidget {
  const TimeSettingsDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          _getDrawerHeader(context),
          Table(
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              columnWidths: const {
                0: FractionColumnWidth(0.35),
                1: FractionColumnWidth(0.5),
                2: FractionColumnWidth(0.15),
              },
              children: [
                _getTableRow('Pomodoro', 25),
                _getSpacingRow(),
                _getTableRow('Short break', 5),
                _getSpacingRow(),
                _getTableRow('Long break', 15),
              ])
        ],
      ),
    );
  }

  DrawerHeader _getDrawerHeader(BuildContext context) {
    return DrawerHeader(
      decoration: const BoxDecoration(
        color: Color(0xffea7066),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 0,
            child: Image.asset(
              'assets/images/tomato.png',
              height: 100,
            ),
          ),
          Positioned(
            bottom: 0.0,
            left: 0.0,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                ),
                const Text(
                  "Time Settings",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  TableRow _getTableRow(String what, int defaultVal) {
    return TableRow(
      children: [
        TableCell(
          child: Text(
            '   $what:',
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
        ),
        // SizedBox(
        TableCell(
          child: SizedBox(
            height: 25,
            child: TextField(
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^[1-9]+[0-9]*$')),
                LengthLimitingTextInputFormatter(2)
              ],
              decoration: const InputDecoration(border: OutlineInputBorder()),
              controller: TextEditingController()..text = defaultVal.toString(),
            ),
          ),
        ),
        const TableCell(
          child: Text(
            '   min',
            style: TextStyle(
              fontSize: 15,
            ),
          ),
        ),
      ],
    );
  }

  TableRow _getSpacingRow() {
    return const TableRow(children: [
      SizedBox(height: 10),
      SizedBox(height: 10),
      SizedBox(height: 10),
    ]);
  }
}
