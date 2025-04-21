import 'package:diary_app/database/database_helper.dart';
import 'package:diary_app/database/models/entry.dart';
import 'package:diary_app/database/models/user.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProfilePage extends StatefulWidget {
  final String userEmail;

  const ProfilePage({super.key, required this.userEmail});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final dbHelper = DatabaseHelper();
  User? user;
  List<Entry> entries = [];

  @override
  void initState() {
    super.initState();
    _loadUserAndEntries();
  }

  Future<void> _loadUserAndEntries() async {
    final loadedUser = await dbHelper.getUserByEmail(widget.userEmail);
    if (loadedUser != null) {
      final userEntries = await dbHelper.getEntriesByUser(loadedUser.id!);
      setState(() {
        user = loadedUser;
        entries = userEntries;
      });
    }
  }

  Future<void> _createNewEntry() async {
    if (user == null) return;

    final now = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final newEntry = Entry(
      userId: user!.id!,
      date: now,
      title: 'New Entry',
      feeling: '😊',
      content: 'This is a new entry.',
    );
    await dbHelper.createEntry(newEntry);
    await _loadUserAndEntries();
  }

  Future<void> _deleteEntry(int id) async {
    await dbHelper.deleteEntry(id);
    await _loadUserAndEntries();
  }

  @override
  Widget build(BuildContext context) {
    if (user == null) return const Center(child: CircularProgressIndicator());

    return Scaffold(
      appBar: AppBar(title: Text('Welcome, ${user!.name}')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: entries.length,
              itemBuilder: (context, index) {
                final entry = entries[index];
                return ListTile(
                  title: Text(entry.title),
                  subtitle: Text('${entry.date} • ${entry.feeling}'),
                  onTap: () => _showEntryDialog(entry),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _deleteEntry(entry.id!),
                  ),
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: _createNewEntry,
            child: const Text('New Entry'),
          ),
        ],
      ),
    );
  }

  void _showEntryDialog(Entry entry) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(entry.title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Feeling: ${entry.feeling}'),
            const SizedBox(height: 10),
            Text(entry.content),
          ],
        ),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close'))],
      ),
    );
  }
}
