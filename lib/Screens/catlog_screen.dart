import 'package:flutter/material.dart';
import 'package:management/Screens/confirm_screen.dart';
import 'package:management/Screens/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  final _formkey = GlobalKey<FormState>();
  String selectedCategory = 'Drinks';

  final Map<String, List<Map<String, dynamic>>> categoryItems = {
    'Drinks': List.generate(
      10,
      (index) => {
        'name': 'Drink Item ${index + 1}',
        'image': 'assets/images/drinks_icon.png',
        'size': '${200 + index * 10}ml',
        'price': 5 + index * 0.5,
        'count': 0,
      },
    ),
    'Cookies': List.generate(
      10,
      (index) => {
        'name': 'Cookie Item ${index + 1}',
        'image': 'assets/images/cookies_icon.png',
        'size': '${index + 2} pieces',
        'price': 2 + index * 0.4,
        'count': 0,
      },
    ),
    'Ice Cream': List.generate(
      10,
      (index) => {
        'name': 'Ice Cream ${index + 1}',
        'image': 'assets/images/Ice-Cream.png',
        'size': '${100 + index * 15}ml',
        'price': 3 + index * 0.6,
        'count': 0,
      },
    ),
  };

  void _submitForm() async {
    if (_formkey.currentState?.validate() ?? false) {
      final selectedItems = categoryItems.values
          .expand((items) => items)
          .where((item) => item['count'] > 0)
          .toList();

      if (selectedItems.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select at least one item')),
        );
        return;
      }

      final updatedItems = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ConfirmScreen(orderedItems: selectedItems),
        ),
      );

      if (updatedItems != null && mounted) {
        setState(() {
          for (var updatedItem in updatedItems) {
            final itemName = updatedItem['name'];
            final itemCount = updatedItem['count'];

            categoryItems.forEach((category, items) {
              for (var item in items) {
                if (item['name'] == itemName) {
                  item['count'] = itemCount;
                }
              }
            });
          }
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.orange,
          content: Text('Please fill all fields correctly'),
        ),
      );
    }
  }

  double getTotalPrice() {
    double total = 0;
    categoryItems.forEach((category, items) {
      for (var item in items) {
        if (item['count']! > 0) {
          total += (item['price'] as double) * (item['count'] as int);
        }
      }
    });
    return total;
  }

  @override
  Widget build(BuildContext context) {
    final items = categoryItems[selectedCategory]!;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Catalog Screen',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.clear();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formkey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    categoryButton('Drinks', Icons.local_drink),
                    const SizedBox(width: 10),
                    categoryButton('Cookies', Icons.cookie),
                    const SizedBox(width: 10),
                    categoryButton('Ice Cream', Icons.icecream),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Text(
                '$selectedCategory Items',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Column(
                children: items
                    .asMap()
                    .entries
                    .map((entry) => buildItemCard(entry.key, entry.value))
                    .toList(),
              ),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.orange,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Total: \$${getTotalPrice().toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            GestureDetector(
              onTap: () {
                _submitForm();
              },
              child: Text(
                'Confirm Order',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget categoryButton(String name, IconData iconData) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCategory = name;
        });
      },
      child: Container(
        height: 115,
        width: 115,
        decoration: BoxDecoration(
          color: const Color(0xFFFef3ea),
          borderRadius: BorderRadius.circular(20),
          border: selectedCategory == name
              ? Border.all(color: Colors.orange, width: 2)
              : null,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(name, style: const TextStyle(fontStyle: FontStyle.italic)),
              const SizedBox(height: 10),
              Icon(iconData, size: 60, color: Colors.orange),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildItemCard(int index, Map<String, dynamic> item) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFef3ea),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            height: 80,
            width: 80,
            decoration: BoxDecoration(
              color: Colors.orange.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                item['name'][0],
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['name'],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item['size'],
                  style: const TextStyle(fontSize: 13, color: Colors.grey),
                ),
                const SizedBox(height: 6),
                Text(
                  '\$${(item['price'] as double).toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.deepOrange,
                  ),
                ),
              ],
            ),
          ),
          item['count'] == 0
              ? ElevatedButton(
                  onPressed: () {
                    setState(() {
                      categoryItems[selectedCategory]![index]['count'] = 1;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                  child: const Text('Add to Cart'),
                )
              : Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            if (categoryItems[selectedCategory]![index]
                                    ['count'] >
                                1) {
                              categoryItems[selectedCategory]![index]
                                  ['count']--;
                            } else {
                              categoryItems[selectedCategory]![index]
                                  ['count'] = 0;
                            }
                          });
                        },
                        child: const Icon(Icons.remove, size: 18),
                      ),
                      const SizedBox(width: 6),
                      Text('${item['count']}'),
                      const SizedBox(width: 6),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            categoryItems[selectedCategory]![index]['count']++;
                          });
                        },
                        child: const Icon(Icons.add, size: 18),
                      ),
                    ],
                  ),
                ),
        ],
      ),
    );
  }
}
