
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() => runApp(const MaterialApp(
  debugShowCheckedModeBanner: false,
  home: RainHome(),
));

class RainHome extends StatefulWidget {
  const RainHome({super.key});
  @override
  State<RainHome> createState() => _RainHomeState();
}

class _RainHomeState extends State<RainHome> {
  DateTime? date;
  final water = TextEditingController();
  List<Map<String, String>> records = [];

  Future<void> pickDate() async {
    final d = await showDatePicker(
      context: context, initialDate: DateTime.now(),
      firstDate: DateTime(2020), lastDate: DateTime.now());
    if (d != null) setState(() => date = d);
  }

  void addRecord() {
    if (date == null || water.text.isEmpty ||
        double.tryParse(water.text) == null ||
        double.parse(water.text) <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter valid details')));
      return;
    }
    setState(() {
      records.add({
        'date': DateFormat('dd-MM-yyyy').format(date!),
        'water': water.text,
      });
      date = null;
      water.clear();
    });
  }

  @override
  void dispose() {
    water.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffeef6ff),
      appBar: AppBar(
        title: const Text('Rain Water Collection'),
        centerTitle: true,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity, height: 145,
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [
                  Color(0xff1976D2), Color(0xff42A5F5)]),
                borderRadius: BorderRadius.circular(20)),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.water_drop, size: 75,
                      color: Colors.white),
                  SizedBox(height: 8),
                  Text('Save Water, Save Life',
                    style: TextStyle(color: Colors.white,
                      fontSize: 19, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const SizedBox(height: 22),
            const Text('Add New Record',
              style: TextStyle(fontSize: 20,
                  fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            InkWell(
              onTap: pickDate,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: Colors.white,
                  borderRadius: BorderRadius.circular(12)),
                child: Row(children: [
                  const Icon(Icons.calendar_month,
                      color: Colors.blue),
                  const SizedBox(width: 12),
                  Text(date == null ? 'Select Collection Date'
                    : DateFormat('dd MMM yyyy').format(date!)),
                  const Spacer(),
                  const Icon(Icons.arrow_drop_down),
                ]),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: water,
              keyboardType: const TextInputType.numberWithOptions(
                  decimal: true),
              decoration: InputDecoration(
                labelText: 'Water Collected (Litres)',
                prefixIcon: const Icon(Icons.water_drop),
                filled: true, fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12))),
            ),
            const SizedBox(height: 15),
            SizedBox(
              width: double.infinity, height: 48,
              child: ElevatedButton.icon(
                onPressed: addRecord,
                icon: const Icon(Icons.add),
                label: const Text('Add Record'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white),
              ),
            ),
            const SizedBox(height: 22),
            const Text('Collection History',
              style: TextStyle(fontSize: 20,
                  fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Expanded(
              child: records.isEmpty
                ? const Center(child: Text('No records available'))
                : ListView.builder(
                    itemCount: records.length,
                    itemBuilder: (context, i) => Card(
                      color: Colors.white,
                      child: ListTile(
                        leading: const Icon(Icons.water_drop,
                            color: Colors.blue),
                        title: Text(records[i]['date']!),
                        subtitle: Text(
                            '${records[i]['water']} Litres'),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete,
                              color: Colors.red),
                          onPressed: () => setState(
                              () => records.removeAt(i)),
                        ),
                      ),
                    ),
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
