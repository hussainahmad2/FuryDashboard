import 'package:flutter/material.dart';

class DownlinesScreen extends StatelessWidget {
  const DownlinesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[900],
              border: Border(
                bottom: BorderSide(color: Colors.grey[800]!, width: 1),
              ),
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  backgroundColor: Colors.blue,
                  child: Icon(Icons.people, color: Colors.white),
                ),
                const SizedBox(width: 16),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your Network',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    Text(
                      '12 active downlines',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
                const Spacer(),
                Chip(
                  backgroundColor: Colors.green[900],
                  label: const Text(
                    '+3 new',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 12,
              itemBuilder: (context, index) {
                final names = [
                  'Alex Johnson',
                  'Maria Garcia',
                  'James Smith',
                  'Sarah Williams',
                  'Robert Brown',
                  'Lisa Miller',
                  'Michael Davis',
                  'Jennifer Wilson',
                  'Thomas Moore',
                  'Emily Taylor',
                  'Daniel Anderson',
                  'Jessica Thomas',
                ];
                final levels = ['Level 1', 'Level 2', 'Level 3'];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor:
                        Colors.primaries[index % Colors.primaries.length],
                    child: Text(
                      names[index].split(' ').map((n) => n[0]).join(),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  title: Text(
                    names[index],
                    style: const TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    levels[index % levels.length],
                    style: const TextStyle(color: Colors.grey),
                  ),
                  trailing: const Icon(Icons.more_vert, color: Colors.grey),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
