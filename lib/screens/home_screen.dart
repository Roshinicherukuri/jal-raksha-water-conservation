import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../services/water_service.dart';
import 'rainwater_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _service = WaterService();
  final _litres = TextEditingController();
  final _activity = TextEditingController(text: 'General use');
  bool _saving = false;

  Future<void> _addUsage() async {
    final amount = double.tryParse(_litres.text.trim());
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter a valid amount of water in litres.')),
      );
      return;
    }
    setState(() => _saving = true);
    try {
      await _service.addUsage(amount, _activity.text.trim().isEmpty ? 'General use' : _activity.text.trim());
      _litres.clear();
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Water usage saved. Keep conserving!')),
      );
    } catch (_) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not save usage. Check Firestore setup.')),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  void dispose() {
    _litres.dispose();
    _activity.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jal Raksha 💧'),
        actions: [
          IconButton(
            tooltip: 'Sign out',
            onPressed: () => FirebaseAuth.instance.signOut(),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          Text('Hello, ${user?.email?.split('@').first ?? 'Water saver'}!',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          const Text('Track your water use and build better daily habits.'),
          const SizedBox(height: 22),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('Log water consumption', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 14),
                TextField(controller: _activity, decoration: const InputDecoration(
                  labelText: 'Activity', hintText: 'e.g. Shower, cooking, laundry')),
                const SizedBox(height: 12),
                TextField(controller: _litres, keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(labelText: 'Amount used', suffixText: 'litres')),
                const SizedBox(height: 14),
                SizedBox(width: double.infinity, child: FilledButton.icon(
                  onPressed: _saving ? null : _addUsage,
                  icon: const Icon(Icons.add),
                  label: Text(_saving ? 'Saving...' : 'Save usage'),
                )),
              ]),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('Today’s water usage', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                StreamBuilder<double>(
                  stream: _service.todayTotal(),
                  builder: (context, snapshot) {
                    final total = snapshot.data ?? 0;
                    return Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                      Text(total.toStringAsFixed(1), style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        color: const Color(0xFF087E8B), fontWeight: FontWeight.bold)),
                      const SizedBox(width: 8),
                      const Padding(padding: EdgeInsets.only(bottom: 9), child: Text('litres')),
                    ]);
                  },
                ),
                const SizedBox(height: 12),
                const Text('Recent entries', style: TextStyle(fontWeight: FontWeight.w600)),
                StreamBuilder<List<Map<String, dynamic>>>(
                  stream: _service.recentUsage(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) return const Text('Unable to load entries.');
                    if (!snapshot.hasData) return const LinearProgressIndicator();
                    if (snapshot.data!.isEmpty) return const Text('No entries yet. Add your first usage above.');
                    return Column(children: snapshot.data!.map((entry) => ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.water_drop_outlined),
                      title: Text(entry['activity']?.toString() ?? 'Water use'),
                      trailing: Text('${(entry['litres'] as num).toStringAsFixed(1)} L'),
                    )).toList());
                  },
                ),
              ]),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: ListTile(
              leading: const Icon(Icons.umbrella, color: Color(0xFF087E8B), size: 34),
              title: const Text('Rainwater harvesting'),
              subtitle: const Text('Learn simple ways to collect and save rainwater.'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RainwaterScreen())),
            ),
          ),
        ],
      ),
    );
  }
}
