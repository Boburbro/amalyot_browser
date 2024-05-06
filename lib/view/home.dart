// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:amalyot_browser/models/web_model.dart';
import 'package:amalyot_browser/services/hive_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

// ignore: must_be_immutable
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var items = Get.find<HiveService>().getList();

  TextEditingController name = TextEditingController();
  TextEditingController url = TextEditingController();

  final _key = GlobalKey<FormState>();

  void delete(String id) {
    Get.defaultDialog(
      title: 'Warning!',
      middleText: "ARE  YOU  SURE  TO  DELETE  IT ?",
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () {
            setState(() {
              Get.find<HiveService>().delete(id);
              items = Get.find<HiveService>().getList();
            });
            Get.back();
          },
          child: const Text("YES"),
        ),
      ],
    );
  }

  void submit(String _id) {
    if (_key.currentState!.validate()) {
      _key.currentState!.save();
      if (_id == "") {
        Get.find<HiveService>().addNew(
          WebModel(
            id: UniqueKey().toString(),
            title: name.text,
            url: url.text,
          ),
        );
      } else {
        Get.find<HiveService>().updateWeb(
          WebModel(
            id: _id,
            title: name.text,
            url: url.text,
          ),
        );
      }
      setState(() {
        items = Get.find<HiveService>().getList();
      });
      name.text = '';
      url.text = '';
      Get.back();
    }
  }

  void add(BuildContext context, String id) {
    if (id != "") {
      final WebModel web = Get.find<HiveService>().getWeb(id);
      name.text = web.title;
      url.text = web.url;
    }
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (ctx) {
        return Container(
          height: 600,
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _key,
            child: Column(
              children: [
                const SizedBox(height: 20),
                TextFormField(
                  controller: name,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Enter the name of web site",
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter a name";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: url,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Enter the url of web site",
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter a url";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton(
                      onPressed: () => Get.back(),
                      child: Text(
                        "CANCEL",
                        style: TextStyle(color: Colors.red[900]),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () => submit(id),
                      child: const Text("SAVE"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          add(context, '');
        },
        child: const Icon(Icons.add),
      ),
      body: items.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "It is empty",
                  ),
                  LottieBuilder.asset("assets/animation.json"),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: items.length,
              itemBuilder: (ctx, index) {
                return Card(
                  child: ListTile(
                    onTap: () =>
                        Get.toNamed("/web", arguments: items[index].url),
                    title: Text(items[index].title),
                    subtitle: Text(items[index].url),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () => add(context, items[index].id),
                          icon: const Icon(
                            Icons.edit_rounded,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            delete(items[index].id);
                          },
                          icon: Icon(
                            Icons.delete_forever_rounded,
                            color: Colors.red[900],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
