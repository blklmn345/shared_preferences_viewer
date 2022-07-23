import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesView extends StatefulWidget {
  const SharedPreferencesView({Key? key}) : super(key: key);

  @override
  State<SharedPreferencesView> createState() => _SharedPreferencesViewState();
}

class _SharedPreferencesViewState extends State<SharedPreferencesView> {
  Future<SharedPreferences>? _future;

  @override
  void initState() {
    super.initState();
    _future = SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('SharedPreferencesViewer'),
          actions: [
            PopupMenuButton(
              icon: const Icon(Icons.more_vert),
              itemBuilder: (context) {
                return <PopupMenuEntry>[
                  PopupMenuItem(
                    child: Row(
                      children: const [
                        Icon(
                          Icons.refresh,
                          color: Colors.grey,
                        ),
                        SizedBox(width: 4),
                        Text('Reload'),
                      ],
                    ),
                    onTap: () => _reload(),
                  ),
                  const PopupMenuDivider(),
                  PopupMenuItem(
                    child: Row(
                      children: const [
                        Icon(Icons.delete, color: Colors.red),
                        SizedBox(width: 4),
                        Text(
                          'Delete All',
                          style: TextStyle(color: Colors.red),
                        ),
                      ],
                    ),
                    onTap: () {
                      SharedPreferences.getInstance()
                          .then((value) => value.clear());
                      _reload();
                    },
                  ),
                ];
              },
            ),
          ],
        ),
        body: FutureBuilder<SharedPreferences>(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error?.toString() ?? ''),
              );
            }

            final sharedPreference = snapshot.data!;

            final keys = sharedPreference.getKeys().toList(growable: false);

            if (keys.isEmpty) {
              return const Center(
                child: Text('Empty'),
              );
            }

            keys.sort((a, b) => a.compareTo(b));

            final primaryColor = Theme.of(context).primaryColor;

            return ListView.builder(
              itemCount: keys.length,
              itemBuilder: (context, index) {
                final key = keys[index];
                final value = sharedPreference.get(key);

                final typeString = value.runtimeType.toString();

                return Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      title: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                key,
                                style: const TextStyle(
                                  fontStyle: FontStyle.italic,
                                  fontSize: 20,
                                ),
                              ),
                              const Spacer(),
                              PopupMenuButton(
                                icon: const Icon(Icons.more_vert),
                                itemBuilder: (context) {
                                  return <PopupMenuEntry>[
                                    PopupMenuItem(
                                      child: Row(
                                        children: const [
                                          Icon(Icons.copy),
                                          SizedBox(width: 4),
                                          Text('Copy Value'),
                                        ],
                                      ),
                                      onTap: () {
                                        Clipboard.setData(ClipboardData(
                                          text: value.toString(),
                                        ));

                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content:
                                                Text('Value copied : $value'),
                                          ),
                                        );
                                      },
                                    ),
                                    PopupMenuItem(
                                      child: Row(
                                        children: const [
                                          Icon(Icons.copy),
                                          SizedBox(width: 4),
                                          Text('Copy Key'),
                                        ],
                                      ),
                                      onTap: () {
                                        Clipboard.setData(ClipboardData(
                                          text: key,
                                        ));

                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text('Key copied : $key'),
                                          ),
                                        );
                                      },
                                    ),
                                    const PopupMenuDivider(),
                                    PopupMenuItem(
                                      child: Row(
                                        children: const [
                                          Icon(Icons.delete, color: Colors.red),
                                          SizedBox(width: 4),
                                          Text(
                                            'Delete',
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        ],
                                      ),
                                      onTap: () {
                                        sharedPreference.remove(key);

                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content:
                                                Text('Data deleted. key: $key'),
                                          ),
                                        );

                                        _reload();
                                      },
                                    ),
                                  ];
                                },
                              ),
                            ],
                          ),
                          const Divider(),
                        ],
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: primaryColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              typeString,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          const SizedBox(height: 18),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Text(
                                  value.toString(),
                                  style: TextStyle(
                                    color: primaryColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      );
    });
  }

  void _reload() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      _future = sharedPreferences.reload().then((value) => sharedPreferences);
    });
  }
}
