import 'package:flutter/material.dart';
import 'package:app_usage/app_usage.dart';

  class app_usage extends StatefulWidget {
    @override
    _app_usageState createState() => _app_usageState();

  }
  
  class _app_usageState extends State<app_usage> {

    List<AppUsageInfo> _infos = [];
    List<AppUsageInfo> final_infos = [];

    @override
    void initState() {
      super.initState();
    }

    void getUsageStats() async {
      try {
        DateTime endDate = new DateTime.now();
        DateTime startDate = endDate.subtract(Duration(hours: 24));
        List<AppUsageInfo> infoList = await AppUsage.getAppUsage(startDate, endDate);

        for(var i in infoList){
          if(i.packageName.contains("twitter") || i.packageName.contains("youtube") || i.packageName.contains("chrome") || i.packageName.contains("messaging") || i.packageName.contains("insta") || i.packageName.contains("facebook")){
            final_infos.add(i);
          }
        }
        setState(() {
          _infos = final_infos;
        });

        for (var info in infoList) {
          print(info.toString());
        }
      } on AppUsageException catch (exception) {
        print(exception);
      }
    }

    @override
    Widget build(BuildContext context) {
      return MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            title: const Text('App Usage Example'),
            backgroundColor: Colors.green,
          ),
          body: ListView.builder(
              itemCount: _infos.length,
              itemBuilder: (context, index) {
                return ListTile(
                    title: Text(_infos[index].appName),
                    trailing: Text(_infos[index].usage.inHours.toString()+' Hrs '+(_infos[index].usage.inMinutes%60).toString()+'mins'));
              }),
          floatingActionButton: FloatingActionButton(
              onPressed: getUsageStats, child: Icon(Icons.file_download)),
        ),
      );
    }
  }
  
  
