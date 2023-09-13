import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_task/LoginDetail/Model/loginDataModel.dart';
import 'package:flutter_task/LoginDetail/Service/loginDataService.dart';
import 'package:flutter_task/Util/palette.dart';
import 'package:flutter_task/Util/sizing.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';

class LoginDetailPage extends StatefulWidget {
  const LoginDetailPage({super.key});

  @override
  State<LoginDetailPage> createState() => _LoginDetailPageState();
}

class _LoginDetailPageState extends State<LoginDetailPage> {
  LoginService service = LoginService();
  List<LoginData> loginDetail = [];
  final DateFormat modifiedDateFormat = DateFormat('hh:mm a');

  final DateFormat dateAloneFormat = DateFormat('yyyy-MM-dd');

  getData() async {
    var res = await service.getLoginData();
    setState(() {
      loginDetail = res;
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          body: Stack(
            fit: StackFit.expand,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            children: [
              Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                    color: primaryColor,
                  )),
              Positioned(
                top: Sizing.height(60, 65),
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                    color: blackColor,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(25.0),
                      topLeft: Radius.circular(25.0),
                    ),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          top: Sizing.height(15, 65),
                        ),
                        child: const TabBar(
                          indicatorColor: whiteColor,
                          tabs: [
                            Tab(text: 'Today'),
                            Tab(text: 'Yesterday'),
                            Tab(text: 'Other'),
                          ],
                        ),
                      ),
                      Expanded(
                        child: TabBarView(
                          children: [
                            getTodayData(loginDetail),
                            getYesterdayData(loginDetail),
                            getOtherData(loginDetail),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Stack(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                children: [
                  Positioned(
                      top: Sizing.height(-25, -26),
                      right: Sizing.width(-5, -6),
                      child: Container(
                        height: Sizing.height(80, 90),
                        width: Sizing.width(40, 50),
                        decoration: const ShapeDecoration(
                            shape: CircleBorder(),
                            color: Color.fromARGB(61, 174, 160, 201)),
                      )),
                  Positioned(
                      top: Sizing.height(10, 15),
                      child: IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(
                            Icons.arrow_back_ios,
                            color: whiteColor,
                          )))
                ],
              ),
              Positioned(
                top: Sizing.height(50, 52),
                left: Sizing.width(55, 60),
                child: Container(
                  height: Sizing.height(25, 26),
                  width: Sizing.width(35, 36),
                  decoration: BoxDecoration(
                      color: Colors.blue[400],
                      borderRadius: BorderRadius.circular(3)),
                  child: Center(
                    child: Text(
                      'Last Login',
                      style: TextStyle(
                          color: whiteColor, fontSize: Sizing.height(13, 15)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  getTodayData(List<LoginData> data) {
    List<LoginData> particularData = [];
    var res = data.where((element) =>
        dateAloneFormat.format(DateTime.parse(element.dateTime ?? '')) ==
        dateAloneFormat.format(DateTime.now()));
    if (res.isNotEmpty) {
      particularData = res.toList();

      return ListView.builder(
          shrinkWrap: true,
          itemCount: particularData.length,
          itemBuilder: (context, index) {
            return Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    5,
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromARGB(5, 158, 158, 158),
                      blurRadius: 1,
                    ),
                  ]),
              margin: EdgeInsets.symmetric(
                  horizontal: Sizing.width(10, 12),
                  vertical: Sizing.height(7, 8)),
              child: Card(
                color: const Color.fromARGB(2, 0, 0, 0),
                child: ListTile(
                  title: Text(
                    modifiedDateFormat.format(
                        DateTime.parse(particularData[index].dateTime ?? '')),
                    style: const TextStyle(color: whiteColor),
                  ),
                  subtitle: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'IP: ${particularData[index].iPAddress}',
                        style: const TextStyle(color: whiteColor),
                      ),
                      Text(
                        '${particularData[index].address}',
                        style: const TextStyle(color: whiteColor),
                      )
                    ],
                  ),
                  trailing: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: QrImageView(
                      backgroundColor: whiteColor,
                      data: particularData[index].qrData,
                      size: Sizing.height(50, 53),
                      embeddedImageStyle: const QrEmbeddedImageStyle(),
                    ),
                  ),
                ),
              ),
            );
          });
    } else {
      return const Center(
          child: Text('No data', style: TextStyle(color: whiteColor)));
    }
  }

  getYesterdayData(List<LoginData> data) {
    List<LoginData> particularData = [];

    var res = data.where((element) =>
        DateTime.parse(dateAloneFormat.format(DateTime.now()))
                .subtract(const Duration(days: 1))
                .year ==
            DateTime.parse(dateAloneFormat.format(DateTime.parse(element.dateTime ?? '')))
                .year &&
        DateTime.parse(dateAloneFormat.format(DateTime.now()))
                .subtract(const Duration(days: 1))
                .month ==
            DateTime.parse(dateAloneFormat.format(DateTime.parse(element.dateTime ?? '')))
                .month &&
        DateTime.parse(dateAloneFormat.format(DateTime.now()))
                .subtract(const Duration(days: 1))
                .day ==
            DateTime.parse(dateAloneFormat
                    .format(DateTime.parse(element.dateTime ?? '')))
                .day);
    if (res.isNotEmpty) {
      particularData = res.toList();

      return ListView.builder(
          shrinkWrap: true,
          itemCount: particularData.length,
          itemBuilder: (context, index) {
            return Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    5,
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromARGB(5, 158, 158, 158),
                      blurRadius: 1,
                    ),
                  ]),
              margin: EdgeInsets.symmetric(
                  horizontal: Sizing.width(10, 12),
                  vertical: Sizing.height(7, 8)),
              child: Card(
                color: const Color.fromARGB(2, 0, 0, 0),
                child: ListTile(
                  title: Text(
                    modifiedDateFormat.format(
                        DateTime.parse(particularData[index].dateTime ?? '')),
                    style: const TextStyle(color: whiteColor),
                  ),
                  subtitle: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'IP: ${particularData[index].iPAddress}',
                        style: const TextStyle(color: whiteColor),
                      ),
                      Text(
                        '${particularData[index].address}',
                        style: const TextStyle(color: whiteColor),
                      )
                    ],
                  ),
                   trailing: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: QrImageView(
                      backgroundColor: whiteColor,
                      data: particularData[index].qrData,
                      size: Sizing.height(50, 53),
                      embeddedImageStyle: const QrEmbeddedImageStyle(),
                    ),
                  ),
                ),
              ),
            );
          });
    } else {
      return const Center(
          child: Text('No data', style: TextStyle(color: whiteColor)));
    }
  }

  getOtherData(List<LoginData> data) {
    List<LoginData> particularData = [];

    var res = data.where((element) =>
        dateAloneFormat.format(DateTime.parse(element.dateTime ?? '')) !=
            dateAloneFormat.format(DateTime.now()) &&
        DateTime.parse(dateAloneFormat.format(DateTime.now()))
                .subtract(const Duration(days: 1))
                .year !=
            DateTime.parse(dateAloneFormat.format(DateTime.parse(element.dateTime ?? '')))
                .year &&
        DateTime.parse(dateAloneFormat.format(DateTime.now()))
                .subtract(const Duration(days: 1))
                .month !=
            DateTime.parse(dateAloneFormat.format(DateTime.parse(element.dateTime ?? '')))
                .month &&
        DateTime.parse(dateAloneFormat.format(DateTime.now()))
                .subtract(const Duration(days: 1))
                .day !=
            DateTime.parse(
                    dateAloneFormat.format(DateTime.parse(element.dateTime ?? '')))
                .day);
    if (res.isNotEmpty) {
      particularData = res.toList();

      return ListView.builder(
          shrinkWrap: true,
          itemCount: particularData.length,
          itemBuilder: (context, index) {
            return Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    5,
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromARGB(5, 158, 158, 158),
                      blurRadius: 1,
                    ),
                  ]),
              margin: EdgeInsets.symmetric(
                  horizontal: Sizing.width(10, 12),
                  vertical: Sizing.height(7, 8)),
              child: Card(
                color: const Color.fromARGB(2, 0, 0, 0),
                child: ListTile(
                  title: Text(
                    modifiedDateFormat.format(
                        DateTime.parse(particularData[index].dateTime ?? '')),
                    style: const TextStyle(color: whiteColor),
                  ),
                  subtitle: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'IP: ${particularData[index].iPAddress}',
                        style: const TextStyle(color: whiteColor),
                      ),
                      Text(
                        '${particularData[index].address}',
                        style: const TextStyle(color: whiteColor),
                      )
                    ],
                  ),
                   trailing: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: QrImageView(
                      backgroundColor: whiteColor,
                      data: particularData[index].qrData,
                      size: Sizing.height(50, 53),
                      embeddedImageStyle: const QrEmbeddedImageStyle(),
                    ),
                  ),
                ),
              ),
            );
          });
    } else {
      return const Center(
          child: Text('No data', style: TextStyle(color: whiteColor)));
    }
  }
}
