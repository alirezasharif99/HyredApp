import 'package:flutter/material.dart';

import './components/bottomBar.dart';

class SearchFiltersScreen extends StatefulWidget {
  @override
  _SearchFiltersScreenState createState() => _SearchFiltersScreenState();
}

class _SearchFiltersScreenState extends State<SearchFiltersScreen> {
  String selectedJobType = 'Full-time';
  double sliderValue = 1.0; // Initial value for the slider

  List<String> locations = ['Canada', 'United States', 'Europe']; // Replace with your locations
  List<String> industries = ['Software', 'Finance', 'Pharmaceuticals']; // Replace with your industries
  String selectedLocation = 'Canada';
  String selectedIndustry = 'Software';

  final salaryRanges = [
    '\$0-\$20,000',
    '\$20,000-\$40,000',
    '\$40,000-\$60,000',
    '\$60,000-\$80,000',
    '\$80,000-\$100,000',
    '\$100,000+',
  ];


  // Function to handle slider changing state
  void updateSliderValue(double newValue) {
    setState(() {
      sliderValue = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const BottomBar(index: 1),
      appBar: AppBar(
        title: const Text('Job Filters'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            DropdownButtonFormField(
              value: selectedIndustry,
              items: industries.map((industry) {
                return DropdownMenuItem(
                  value: industry,
                  child: Text(industry),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  selectedIndustry = newValue!;
                });
              },
              decoration: const InputDecoration(
                labelText: 'Industry',
                hintText: 'Select industry',
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField(
              value: selectedLocation,
              items: locations.map((location) {
                return DropdownMenuItem(
                  value: location,
                  child: Text(location),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  selectedLocation = newValue!;
                });
              },
              decoration: const InputDecoration(
                labelText: 'Location',
                hintText: 'Select location',
              ),
            ),
            const SizedBox(height: 32),
            // You can replace the following with a custom range slider
            const Text('Salary Range', style: TextStyle(fontSize: 16)),
            Slider(
              min: 0,
              max: salaryRanges.length.toDouble() - 1.0,
              divisions: salaryRanges.length - 1,
              label: 'Salary Range',
              onChanged: updateSliderValue,
              thumbColor: Colors.green[700],
              activeColor: Colors.green[700],
              value: sliderValue,
            ),
            Text(salaryRanges[sliderValue.toInt()]),
            const SizedBox(height: 16),
            const Text('Job Type', style: TextStyle(fontSize: 16)),
            ToggleButtons(
              selectedBorderColor: Colors.green[700],
              fillColor: Colors.green[500],
              color: Colors.black,
              selectedColor: Colors.white,
              isSelected: ['Full-time', 'Part-time', 'Remote']
                  .map((e) => e == selectedJobType)
                  .toList(),
              onPressed: (int index) {
                setState(() {
                  selectedJobType = ['Full-time', 'Part-time', 'Remote'][index];
                });
              },
              children: const <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text('Full-time'),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text('Part-time'),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text('Remote'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


