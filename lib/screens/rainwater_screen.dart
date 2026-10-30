import 'package:flutter/material.dart';

class RainwaterScreen extends StatelessWidget {
  const RainwaterScreen({super.key});

  static const tips = [
    ('Install rooftop collection', 'Use gutters and downpipes to direct roof runoff into a covered storage tank.'),
    ('Filter before storage', 'Use a leaf screen and first-flush diverter to keep debris out of the tank.'),
    ('Keep tanks covered', 'A secure lid helps prevent contamination and mosquito breeding.'),
    ('Recharge groundwater', 'Where locally permitted and professionally designed, direct suitable runoff to a recharge pit.'),
    ('Use stored rainwater wisely', 'Use appropriately treated and tested water for suitable non-drinking purposes.'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Rainwater awareness')),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          const Icon(Icons.water, size: 72, color: Color(0xFF087E8B)),
          Text('Save the rain, secure the future.',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text('Rainwater harvesting collects and stores rainfall for later use or helps replenish groundwater.'),
          const SizedBox(height: 18),
          ...tips.map((tip) => Card(
            child: ListTile(
              leading: const Icon(Icons.check_circle_outline, color: Color(0xFF087E8B)),
              title: Text(tip.$1, style: const TextStyle(fontWeight: FontWeight.w600)),
              subtitle: Text(tip.$2),
            ),
          )),
          const SizedBox(height: 10),
          const Text('Important: Drinking water requires appropriate treatment and regular quality testing. Follow local regulations and consult a qualified professional for recharge structures.',
              style: TextStyle(fontSize: 12, color: Colors.black54)),
        ],
      ),
    );
  }
}
