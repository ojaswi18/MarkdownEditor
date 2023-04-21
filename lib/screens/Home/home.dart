import 'package:meproject/services/auth.dart';
import "package:flutter/material.dart";
import 'package:meproject/services/theme.dart';
import 'package:provider/provider.dart';
import 'package:switch_button/switch_button.dart';
import 'package:path_provider/path_provider.dart';
import 'package:meproject/screens/Home/profile.dart';
import 'package:meproject/screens/Home/files.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:share_plus/share_plus.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController _textEditingController = TextEditingController();
  final AuthServices _auth = AuthServices();
  bool isSwitch = true;
  final FirebaseStorage storage = FirebaseStorage.instance;
  final storageRef = FirebaseStorage.instance;

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ThemeModel themeNotifier, child) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Home Page"),
          backgroundColor: isSwitch ? Colors.brown[400] : Colors.grey[400],
          actions: [
            SwitchButton(
              value: themeNotifier.isDark ? false : true,
              onToggle: (value) {
                themeNotifier.isDark
                    ? themeNotifier.isDark = false
                    : themeNotifier.isDark = true;
                isSwitch = !isSwitch;
              },
              activeColor: isSwitch ? Colors.brown : Colors.grey,
              child: const Text(""),
            ),
            IconButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) => Wrap(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.person_outlined),
                        title: const Text('Profile'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    Profile(isSwitch: isSwitch)),
                          );
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.open_in_new),
                        title: const Text('Open'),
                        onTap: () async {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            },
                          );
                           List<dynamic> files = await loadfilesWithContext(context);
                          Navigator.pop(context); 
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    Files(files: files, isSwitch: isSwitch)),
                          );
                        },
                      ),
                      ListTile(
                          leading: const Icon(Icons.share),
                          title: const Text('Share'),
                          onTap: () async {
                            Navigator.of(context).pop();
                            onShare( _textEditingController.text);
                          },),
                      ListTile(
                          leading: const Icon(Icons.save),
                          title: const Text('Save'),
                          onTap: () async {
                            Navigator.of(context).pop();
                            onSave(context, _textEditingController.text);
                          }),
                      ListTile(
                        leading: const Icon(Icons.person),
                        title: const Text('Logout'),
                        onTap: () async {
                          Navigator.of(context).pop();
                          await _auth.signOut();
                        },
                      ),
                    ],
                  ),
                );
              },
              icon: const Icon(Icons.list),
            ),
          ],
        ),
        body: Container(
          color: isSwitch ? Colors.brown[100] : Colors.grey[600],
          child: Column(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    controller: _textEditingController,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: const InputDecoration(
                      hintText: 'Enter markdown text here...',
                    ),
                    onChanged: (String markdownText) {
                      setState(() {});
                    },
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    child: RichText(
                      text: _parseMarkdownText(_textEditingController.text),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Future<List<dynamic>> loadfilesWithContext(BuildContext context) async {
    return await loadfiles();
  }

  Future<void> onSave(BuildContext context, String formattedText) async {
    final fileNameController = TextEditingController();
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Save File'),
        content: TextField(
          controller: fileNameController,
          decoration: const InputDecoration(
            hintText: 'Enter a file name',
          ),
        ),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: const Text('Save'),
            onPressed: () async {
              final fileName = fileNameController.text.trim();
              Navigator.of(context).pop(fileName);

              if (fileName.isNotEmpty) {
                final directory = await getApplicationDocumentsDirectory();
                File textFile = File('${directory.path}/$fileName.txt');

                await textFile.writeAsString(formattedText.toString());
                final storageRef = FirebaseStorage.instance
                    .ref()
                    .child('${directory.path}/$fileName.txt');
                final uploadTask = storageRef.putFile(textFile);
                await uploadTask.whenComplete(() => print("saved"));
              }
            },
          ),
        ],
      ),
    );
  }

  Future<List> loadfiles() async {
    List<Map> files = [];
    final directory = await getApplicationDocumentsDirectory();
    final ListResult result =
        await storageRef.ref().child('${directory.path}').listAll();
    final List<Reference> allFiles = result.items;
    await Future.forEach(allFiles, (Reference file) async {
      final String fileUrl = await file.getDownloadURL();
      final metadata = await file.getMetadata();
      final lastModified = metadata.updated!.toIso8601String();

      files.add({
        "name": file.name,
        "url": fileUrl,
        "path": file.fullPath,
        "lastModified": lastModified,
      });
    });
    return files;
  }
void onShare(String text) {
  if (text.isNotEmpty) {
    Share.share(text);
  }
}
}
TextSpan _parseMarkdownText(String markdownText) {
  List<TextSpan> textSpans = [];
  RegExp boldRegex = RegExp(r'\*\*(.*?)\*\*');
  RegExp italicRegex = RegExp(r'_(.*?)_');
  RegExp headingRegex = RegExp(r'^\s*#+\s*(.*)$');
  RegExp tableRegex = RegExp(r'^\|(.+)\| *$');
  RegExp listItemRegex = RegExp(r'^\s*-\s*(.*)$');

  List<String> lines = markdownText.split('\n');
  for (String line in lines) {
    List<TextSpan> lineSpans = [];
    if (headingRegex.hasMatch(line)) {
      String headingText = headingRegex.firstMatch(line)!.group(1).toString();
      int level = line.indexOf('#') + 1;
      TextStyle style = TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 24 - (level * 2),
      );
      TextSpan headingSpan = TextSpan(
        text: headingText,
        style: style,
      );
      lineSpans.add(headingSpan);
    } else if (tableRegex.hasMatch(line)) {
      List<String> cells = tableRegex.firstMatch(line)!.group(1)!.split('|');
      cells.removeAt(0);
      if (cells.isNotEmpty) {
        cells.removeLast();
      }

      List<TextSpan> rowSpans = cells.map((cell) {
        return TextSpan(text: cell.trim() + '\t\t');
      }).toList();
      for (String cell in cells) {
        rowSpans.add(TextSpan(text: cell.trim() + '\t\t'));
      }
      textSpans.add(TextSpan(children: rowSpans));
      textSpans.add(TextSpan(text: '\n'));
    } else if (listItemRegex.hasMatch(line)) {
      String listItemText = listItemRegex.firstMatch(line)!.group(1).toString();
      TextSpan listItemSpan = TextSpan(
        text: '• ' + listItemText,
        style: const TextStyle(fontSize: 18),
      );
      lineSpans.add(listItemSpan);
    } else {
      List<String> words = line.split(' ');
      for (String word in words) {
        if (boldRegex.hasMatch(word)) {
          String boldText = boldRegex.firstMatch(word)!.group(1).toString();

          TextSpan boldSpan = TextSpan(
            text: boldText,
            style: const TextStyle(fontWeight: FontWeight.bold),
          );
          lineSpans.add(boldSpan);
        } else if (italicRegex.hasMatch(word)) {
          String italicText = italicRegex.firstMatch(word)!.group(1).toString();
          TextSpan italicSpan = TextSpan(
            text: italicText,
            style: const TextStyle(fontStyle: FontStyle.italic),
          );
          lineSpans.add(italicSpan);
        } else {
          TextSpan textSpan = TextSpan(text: word);
          lineSpans.add(textSpan);
        }
        lineSpans.add(const TextSpan(text: ' '));
      }
    }
    textSpans.addAll(lineSpans);
    textSpans.add(const TextSpan(text: '\n'));
  }

  return TextSpan(children: textSpans);
}
