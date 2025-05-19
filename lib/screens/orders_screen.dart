import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orders = [
      _Order(
        id: '#AH-2023-001',
        date: DateTime.now().subtract(const Duration(days: 2)),
        status: 'Delivered',
        items: 3,
        total: 149.97,
        itemsList: [
          'Neon Tetra (x6)',
          'Java Fern',
          'Aquarium Heater 100W',
        ],
      ),
      _Order(
        id: '#AH-2023-002',
        date: DateTime.now().subtract(const Duration(days: 10)),
        status: 'Shipped',
        items: 5,
        total: 89.95,
        itemsList: [
          'Betta Fish',
          'Betta Food',
          'Water Conditioner',
          'Test Strips',
          'Fish Net',
        ],
      ),
      _Order(
        id: '#AH-2023-003',
        date: DateTime.now().subtract(const Duration(days: 25)),
        status: 'Delivered',
        items: 2,
        total: 34.98,
        itemsList: [
          'Guppy (x4)',
          'Aquarium Plants Bundle',
        ],
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Orders'),
      ),
      body: orders.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: orders.length,
              itemBuilder: (context, index) {
                return _buildOrderCard(context, orders[index]);
              },
            ),
    );
  }

  Widget _buildOrderCard(BuildContext context, _Order order) {
    final theme = Theme.of(context);
    final dateFormat = DateFormat('MMM dd, yyyy');

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ExpansionTile(
        title: Text('Order ${order.id}', style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(dateFormat.format(order.date)),
        trailing: _buildStatusChip(order.status),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              children: [
                ...order.itemsList.map((item) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          const Icon(Icons.circle, size: 6, color: Colors.grey),
                          const SizedBox(width: 8),
                          Expanded(child: Text(item)),
                        ],
                      ),
                    )),
                const Divider(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${order.items} ${order.items == 1 ? 'item' : 'items'}' 
                      ' • ${order.status}',
                      style: theme.textTheme.bodySmall,
                    ),
                    Text(
                      '\$${order.total.toStringAsFixed(2)}',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          // Track order
                        },
                        child: const Text('Track Order'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // Reorder
                        },
                        child: const Text('Reorder'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color backgroundColor;
    Color textColor;
    
    switch (status.toLowerCase()) {
      case 'delivered':
        backgroundColor = Colors.green.shade100;
        textColor = Colors.green.shade800;
        break;
      case 'shipped':
        backgroundColor = Colors.blue.shade100;
        textColor = Colors.blue.shade800;
        break;
      case 'processing':
        backgroundColor = Colors.orange.shade100;
        textColor = Colors.orange.shade800;
        break;
      default:
        backgroundColor = Colors.grey.shade200;
        textColor = Colors.grey.shade800;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_bag_outlined,
            size: 80,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'No Orders Yet',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your orders will appear here',
            style: TextStyle(color: Colors.grey.shade600),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              // Navigate to shop
            },
            child: const Text('Start Shopping'),
          ),
        ],
      ),
    );
  }
}

class _Order {
  final String id;
  final DateTime date;
  final String status;
  final int items;
  final double total;
  final List<String> itemsList;

  _Order({
    required this.id,
    required this.date,
    required this.status,
    required this.items,
    required this.total,
    required this.itemsList,
  });
}
