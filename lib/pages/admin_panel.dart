import 'package:flutter/material.dart';

void main() {
  runApp(AdminPanelApp());
}

class AdminPanelApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Admin Panel',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: AdminPanel(),
    );
  }
}

class AdminPanel extends StatefulWidget {
  @override
  _AdminPanelState createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  int currentPage = 0; // Tracks the current page (0 = Cities, 1 = Users)
  String? selectedRegionFilter; // For filtering cities/users by region
  String? selectedPopulationFilter; // For filtering cities by population
  String? selectedGmailFilter; // For filtering users by Gmail domain

  // Sample data for cities
  List<Map<String, String>> cities = [
    {
      'english': 'Almaty',
      'russian': 'Алматы',
      'kazakh': 'Алматы',
      'population': '1,845,000',
      'area': '682.0',
      'region': 'Almaty Region',
    },
    {
      'english': 'Nur-Sultan',
      'russian': 'Нур-Султан',
      'kazakh': 'Нур-Султан',
      'population': '1,200,000',
      'area': '710.2',
      'region': 'Nur-Sultan Region',
    },
  ];

  // Sample data for users
  List<Map<String, String>> users = [
    {
      'gmail': 'john.doe@gmail.com',
      'name': 'John',
      'surname': 'Doe',
      'region': 'Almaty Region',
    },
    {
      'gmail': 'jane.smith@yahoo.com',
      'name': 'Jane',
      'surname': 'Smith',
      'region': 'Nur-Sultan Region',
    },
  ];

  Set<int> selectedIndexes = {}; // Tracks the selected rows by index.

  // Add City
  void _addCity() {
    showDialog(
      context: context,
      builder: (context) {
        final TextEditingController englishController = TextEditingController();
        final TextEditingController russianController = TextEditingController();
        final TextEditingController kazakhController = TextEditingController();
        final TextEditingController populationController = TextEditingController();
        final TextEditingController areaController = TextEditingController();
        final TextEditingController regionController = TextEditingController();

        return AlertDialog(
          title: Text('Add New City'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(controller: englishController, decoration: InputDecoration(labelText: 'City Name (English)')),
                TextField(controller: russianController, decoration: InputDecoration(labelText: 'City Name (Russian)')),
                TextField(controller: kazakhController, decoration: InputDecoration(labelText: 'City Name (Kazakh)')),
                TextField(controller: populationController, decoration: InputDecoration(labelText: 'Population')),
                TextField(controller: areaController, decoration: InputDecoration(labelText: 'Area in Sq. Km')),
                TextField(controller: regionController, decoration: InputDecoration(labelText: 'Region')),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            ElevatedButton(
              child: Text('Add'),
              onPressed: () {
                setState(() {
                  cities.add({
                    'english': englishController.text,
                    'russian': russianController.text,
                    'kazakh': kazakhController.text,
                    'population': populationController.text,
                    'area': areaController.text,
                    'region': regionController.text,
                  });
                });
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  // Add User
  void _addUser() {
    showDialog(
      context: context,
      builder: (context) {
        final TextEditingController gmailController = TextEditingController();
        final TextEditingController nameController = TextEditingController();
        final TextEditingController surnameController = TextEditingController();
        final TextEditingController regionController = TextEditingController();

        return AlertDialog(
          title: Text('Add New User'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(controller: gmailController, decoration: InputDecoration(labelText: 'Gmail')),
                TextField(controller: nameController, decoration: InputDecoration(labelText: 'Name')),
                TextField(controller: surnameController, decoration: InputDecoration(labelText: 'Surname')),
                TextField(controller: regionController, decoration: InputDecoration(labelText: 'Region')),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            ElevatedButton(
              child: Text('Add'),
              onPressed: () {
                setState(() {
                  users.add({
                    'gmail': gmailController.text,
                    'name': nameController.text,
                    'surname': surnameController.text,
                    'region': regionController.text,
                  });
                });
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  // Filtered data based on active filters
  List<Map<String, String>> getFilteredData() {
    if (currentPage == 0) {
      return cities.where((city) {
        if (selectedRegionFilter != null && selectedRegionFilter!.isNotEmpty) {
          return city['region'] == selectedRegionFilter;
        }
        if (selectedPopulationFilter == '> 1,000,000' && int.parse(city['population']!.replaceAll(',', '')) <= 1000000) {
          return false;
        }
        if (selectedPopulationFilter == '< 1,000,000' && int.parse(city['population']!.replaceAll(',', '')) > 1000000) {
          return false;
        }
        return true;
      }).toList();
    } else {
      return users.where((user) {
        if (selectedRegionFilter != null && selectedRegionFilter!.isNotEmpty) {
          return user['region'] == selectedRegionFilter;
        }
        if (selectedGmailFilter != null && selectedGmailFilter!.isNotEmpty) {
          return user['gmail']!.contains(selectedGmailFilter!);
        }
        return true;
      }).toList();
    }
  }

  // Data Table Widget
  Widget _buildDataTable() {
    List<Map<String, String>> data = getFilteredData();
    List<DataColumn> columns = currentPage == 0
        ? [
            DataColumn(label: Text('Select')),
            DataColumn(label: Text('City Name (English)')),
            DataColumn(label: Text('City Name (Russian)')),
            DataColumn(label: Text('City Name (Kazakh)')),
            DataColumn(label: Text('Population')),
            DataColumn(label: Text('Area')),
            DataColumn(label: Text('Region')),
          ]
        : [
            DataColumn(label: Text('Select')),
            DataColumn(label: Text('Gmail')),
            DataColumn(label: Text('Name')),
            DataColumn(label: Text('Surname')),
            DataColumn(label: Text('Region')),
          ];

    return DataTable(
      columns: columns,
      rows: data.asMap().entries.map((entry) {
        int index = entry.key;
        Map<String, String> item = entry.value;
        return DataRow(
          selected: selectedIndexes.contains(index),
          onSelectChanged: (bool? selected) {
            setState(() {
              if (selected == true) {
                selectedIndexes.add(index);
              } else {
                selectedIndexes.remove(index);
              }
            });
          },
          cells: item.values
              .map((value) => DataCell(Text(value)))
              .toList()
              .cast<DataCell>()
              ..insert(
                0,
                DataCell(
                  Checkbox(
                    value: selectedIndexes.contains(index),
                    onChanged: (bool? selected) {
                      setState(() {
                        if (selected == true) {
                          selectedIndexes.add(index);
                        } else {
                          selectedIndexes.remove(index);
                        }
                      });
                    },
                  ),
                ),
              ),
        );
      }).toList(),
    );
  }

  // Filter Panel
  Widget _buildFilters() {
    // Get a list of unique regions from the cities
    Set<String> availableRegions = _getAvailableRegions();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'FILTER',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        if (currentPage == 0) ...[
          ExpansionTile(
            title: Text('By Region'),
            children: availableRegions.map((region) {
              return CheckboxListTile(
                title: Text(region),
                value: selectedRegionFilter == region,
                onChanged: (val) {
                  setState(() {
                    selectedRegionFilter = val! ? region : null;
                  });
                },
              );
            }).toList(),
          ),
          ExpansionTile(
            title: Text('By Population'),
            children: [
              CheckboxListTile(
                title: Text('More than 1,000,000'),
                value: selectedPopulationFilter == '> 1,000,000',
                onChanged: (val) {
                  setState(() {
                    selectedPopulationFilter = val! ? '> 1,000,000' : null;
                  });
                },
              ),
              CheckboxListTile(
                title: Text('Less than 1,000,000'),
                value: selectedPopulationFilter == '< 1,000,000',
                onChanged: (val) {
                  setState(() {
                    selectedPopulationFilter = val! ? '< 1,000,000' : null;
                  });
                },
              ),
            ],
          ),
        ],
        if (currentPage == 1) ...[
          ExpansionTile(
            title: Text('By Region'),
            children: availableRegions.map((region) {
              return CheckboxListTile(
                title: Text(region),
                value: selectedRegionFilter == region,
                onChanged: (val) {
                  setState(() {
                    selectedRegionFilter = val! ? region : null;
                  });
                },
              );
            }).toList(),
          ),
          ExpansionTile(
            title: Text('By Gmail'),
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Filter by Gmail Domain'),
                onChanged: (value) {
                  setState(() {
                    selectedGmailFilter = value.isEmpty ? null : value;
                  });
                },
              ),
            ],
          ),
        ],
      ],
    );
  }

  // Extract unique regions from data
  Set<String> _getAvailableRegions() {
    Set<String> availableRegions = {};
    if (currentPage == 0) {
      cities.forEach((city) {
        availableRegions.add(city['region']!);
      });
    } else {
      users.forEach((user) {
        availableRegions.add(user['region']!);
      });
    }
    return availableRegions;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Panel'),
        backgroundColor: Colors.teal,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.teal),
              child: Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              title: Text('Cities'),
              onTap: () {
                setState(() {
                  currentPage = 0;
                  selectedIndexes.clear();
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Users'),
              onTap: () {
                setState(() {
                  currentPage = 1;
                  selectedIndexes.clear();
                });
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: Row(
        children: [
          // Main Table View
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                elevation: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            currentPage == 0 ? 'City List' : 'User List',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Row(
                            children: [
                              ElevatedButton(
                                onPressed: currentPage == 0 ? _addCity : _addUser,
                                child: Text(currentPage == 0 ? 'Add City' : 'Add User'),
                              ),
                              SizedBox(width: 8),
                              ElevatedButton(
                                onPressed: selectedIndexes.isEmpty
                                    ? null
                                    : () {
                                        setState(() {
                                          if (currentPage == 0) {
                                            cities = cities.asMap().entries
                                                .where((entry) => !selectedIndexes.contains(entry.key))
                                                .map((entry) => entry.value)
                                                .toList();
                                          } else {
                                            users = users.asMap().entries
                                                .where((entry) => !selectedIndexes.contains(entry.key))
                                                .map((entry) => entry.value)
                                                .toList();
                                          }
                                          selectedIndexes.clear();
                                        });
                                      },
                                child: Text('Delete Selected'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: _buildDataTable(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Filter Panel
          Container(
            width: 250,
            color: Colors.grey[200],
            child: _buildFilters(),
          ),
        ],
      ),
    );
  }
}
