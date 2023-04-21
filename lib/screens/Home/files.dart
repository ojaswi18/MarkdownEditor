import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Files extends StatefulWidget {
  final List<dynamic>? files;
  final bool isSwitch;
  const Files({super.key, required this.files, required this.isSwitch});

  @override
  State<Files> createState() => _FilesState();
}

class _FilesState extends State<Files> {
  String _searchQuery = "";
  String _sortValue = "name";
  List<Map> sortedFiles = [];
  List<dynamic> sortedFilesnew = [];

  void _sortItemsByName(List<dynamic> sortedFiles) {
    setState(() {
      sortedFiles.sort((a, b) => a['name'].compareTo(b['name']));
    });
  }

  void _sortItemsByRecent(List<dynamic> sortedFiles) {
    setState(() {
      sortedFiles
          .sort((a, b) => b['lastModified'].compareTo(a['lastModified']));
    });
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> sortedFiles = [...widget.files!];

    return Scaffold(
      backgroundColor: widget.isSwitch ? Colors.brown[100] : Colors.grey[600],
      appBar: AppBar(
        backgroundColor: widget.isSwitch ? Colors.brown : Colors.grey,
        title: const Text("list"),
        actions: [
          DropdownButton<String>(
            value: _sortValue,
            items: [
              DropdownMenuItem<String>(
                value: "name",
                onTap: () {
                  _sortItemsByName(sortedFiles);
                  sortedFilesnew = sortedFiles;
                },
                child: const Text("Sort by name"),
              ),
              DropdownMenuItem<String>(
                value: "recent",
                onTap: () {
                  _sortItemsByRecent(sortedFiles);
                  sortedFilesnew = sortedFiles;
                },
                child: const Text("Sort by recent"),
              ),
            ],
            onChanged: (value) {
              setState(() {
                _sortValue = value!;
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase();
                });
              },
              decoration: InputDecoration(
                hintText: "Search",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: sortedFiles.length,
              itemBuilder: (BuildContext context, int index) {
                if (sortedFilesnew.isEmpty) {
                  sortedFilesnew = sortedFiles;
                }
                var name = sortedFilesnew[index]["name"];
                var url = sortedFilesnew[index]["url"];
                if (_searchQuery.isEmpty ||
                    (name != null &&
                        name.toString().toLowerCase().contains(_searchQuery)) ||
                    (url != null &&
                        url.toString().toLowerCase().contains(_searchQuery))) {
                  return ListTile(
                    title: Column(
                      children: [
                        Container(
                          alignment: Alignment.topLeft,
                          child: Text(
                            name?.toString() ?? "",
                            textAlign: TextAlign.left,
                          ),
                        ),

                        GestureDetector(
                          onTap: () async {
                            if (url != null) {
                              print("start");
                              await launchUrl(Uri.parse(url));
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("File downloaded!"),
                                ),
                              );
                              print("end");
                            } else {
                              print("error");
                            }
                          },
                          child: Text(
                            url?.toString() ?? "",
                            style: const TextStyle(
                              decoration: TextDecoration.underline,
                              color: Colors.blue,
                            ),
                          ),
                        ),
//                         GestureDetector(
//   onTap: () async {
//     if (url != null && await canLaunch(Uri.parse(url).toString())) {
//       await launch(Uri.parse(url).toString());
//       print("hello");
//       // Handle download action here, for example:
//       // Show a snackbar to indicate that the file is being downloaded
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Downloading file...')),
//       );
//     }
//   },
//   child: Text(
//     url?.toString() ?? "",
//     style: const TextStyle(
//       decoration: TextDecoration.underline,
//       color: Colors.blue,
//     ),
//   ),
// ),
                      ],
                    ),
                  );
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
