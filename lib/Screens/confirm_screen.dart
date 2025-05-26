import 'package:flutter/material.dart';

class ConfirmScreen extends StatefulWidget {
  final List<Map<String, dynamic>> orderedItems;

  const ConfirmScreen({super.key, required this.orderedItems});

  @override
  State<ConfirmScreen> createState() => _ConfirmScreenState();
}

class _ConfirmScreenState extends State<ConfirmScreen> {
  late List<Map<String, dynamic>> updatedItems;

  @override
  void initState() {
    super.initState();
    // Copy the items list to modify locally
    updatedItems = List<Map<String, dynamic>>.from(widget.orderedItems);
  }

  double getTotalPrice() {
    double total = 0;
    for (var item in updatedItems) {
      total += item['price'] * item['count'];
    }
    return total;
  }

  int getItemCount() {
    int count = 0;
    for (var item in updatedItems) {
      count += item['count'] as int;
    }
    return count;
  }

  void _removeItem(int index) {
    setState(() {
      updatedItems[index]['count'] = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final nonZeroItems = updatedItems.where((item) => item['count'] > 0).toList();

    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, updatedItems);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Confirm Your Order'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context, updatedItems);
            },
          ),
        ),
        body: nonZeroItems.isEmpty
            ? const Center(
                child: Text("No items selected"),
              )
            : ListView.builder(
                itemCount: nonZeroItems.length,
                itemBuilder: (context, index) {
                  final item = nonZeroItems[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.orange.shade100,
                        child: Text(
                          item['name'][0],
                          style: const TextStyle(color: Colors.orange),
                        ),
                      ),
                      title: Text(item['name']),
                      subtitle: Text('${item['count']} x ₹${item['price']}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          final originalIndex = updatedItems.indexWhere(
                            (element) => element['name'] == item['name'],
                          );
                          _removeItem(originalIndex);
                        },
                      ),
                    ),
                  );
                },
              ),
        bottomNavigationBar: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.orange,
            border: Border(
              top: BorderSide(color: Colors.grey.shade300),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 4),
                  Text(
                    'Total: ₹${getTotalPrice().toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Totel Items: ${getItemCount()}',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                onPressed: () {
                  Navigator.pop(context, updatedItems);
                },
                child: const Text(
                  'CONFIRM',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
