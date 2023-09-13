import 'package:flutter/material.dart';
import 'package:flutter_task/LoginDetail/Model/loginDataModel.dart';
import 'package:flutter_task/LoginDetail/Service/loginDataService.dart';
import 'package:flutter_task/Util/hive_helper.dart';
import 'package:flutter_task/Util/page_router.dart';
import 'package:flutter_task/Util/palette.dart';
import 'package:flutter_task/Util/sizing.dart';
import 'package:intl/intl.dart' as intl;
import 'package:qr_flutter/qr_flutter.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String currentIP = '';
  String _currentAddress = '';
  String postalCode = '';
  String randomNumber = '';
  LoginService service = LoginService();
  List<LoginData> loginDetail = [];
  String lastlogin = '-';
  List<DateTime> dateTimes = [];
  DateTime? mostRecentDateTime;
  final intl.DateFormat modifiedDateFormat =
      intl.DateFormat('yyyy-MM-dd hh:mm a');

  getData() async {
    var res = await service.getLoginData();
    setState(() {
      if (res.isNotEmpty) {
        res.forEach((element) {
          dateTimes.add(DateTime.parse(element.dateTime ?? ''));
        });
        mostRecentDateTime = dateTimes.reduce((currentMax, element) {
          return currentMax.isBefore(element) ? element : currentMax;
        });
      }

      loginDetail = res;
      lastlogin = mostRecentDateTime == null
          ? ''
          : modifiedDateFormat
              .format(DateTime.parse(mostRecentDateTime.toString()));
      currentIP = HiveHelper().getCurrentIP();
      _currentAddress = HiveHelper().getCurrentLocation();
      postalCode = HiveHelper().getCurrentPostalCode();
      randomNumber = '1$postalCode${currentIP.split('.').first}';
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
          Stack(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            children: [
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
                ),
              ),
              Positioned(
                bottom: Sizing.height(150, 155),
                left: Sizing.width(30, 32),
                child: Container(
                  height: Sizing.height(35, 36),
                  width: Sizing.width(90, 95),
                  decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.white, width: 2)),
                  child: InkWell(
                      onTap: () async {
                        Navigator.of(context).pushNamed(
                          PageRouter.loginDtailPage,
                        );
                      },
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: Sizing.width(3, 4),
                              vertical: Sizing.height(2, 2)),
                          child: Text(
                            'Last login at $lastlogin',
                            style: const TextStyle(
                                color: whiteColor, fontWeight: FontWeight.bold),
                          ),
                        ),
                      )),
                ),
              ),
              Positioned(
                bottom: Sizing.height(100, 105),
                left: Sizing.width(30, 32),
                child: Container(
                  height: Sizing.height(35, 36),
                  width: Sizing.width(90, 95),
                  decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(5)),
                  child: InkWell(
                      onTap: () async {
                        LoginData logindata = LoginData(
                            dateTime: DateTime.now().toString(),
                            iPAddress: currentIP,
                            address: _currentAddress,
                            qrData: "$_currentAddress , $currentIP");

                        await service.updateLoginData(logindata);
                        getData();
                      },
                      child: const Center(
                        child: Text(
                          'SAVE',
                          style: TextStyle(
                              color: whiteColor, fontWeight: FontWeight.bold),
                        ),
                      )),
                ),
              ),
              Positioned(
                bottom: Sizing.height(200, 205),
                left: Sizing.width(30, 32),
                child: Container(
                  decoration: const BoxDecoration(boxShadow: [
                    BoxShadow(
                      color: Color.fromARGB(5, 158, 158, 158),
                      blurRadius: 1,
                    ),
                  ]),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CustomPaint(
                      size: Size(Sizing.width(80, 100),
                          Sizing.height(100, 110)), // Adjust the size as needed
                      painter: SlantPainter(MyCustomObject(randomNumber)),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: Sizing.height(290, 300),
                left: Sizing.width(45, 50),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: QrImageView(
                    backgroundColor: whiteColor,
                    data: "$_currentAddress , $currentIP",
                    size: Sizing.height(100, 110),
                    embeddedImageStyle: const QrEmbeddedImageStyle(),
                  ),
                ),
              ),
            ],
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
                left: Sizing.width(145, 150),
                top: Sizing.height(10, 15),
                child: InkWell(
                  onTap: () {
                    HiveHelper().saveLoginStatus(false);
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        PageRouter.loginPage, (Route<dynamic> route) => false);
                  },
                  child: const Text(
                    'Logout',
                    style: TextStyle(color: whiteColor),
                  ),
                ),
              )
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
                  'PLUGIN',
                  style: TextStyle(
                      color: whiteColor, fontSize: Sizing.height(13, 15)),
                ),
              ),
            ),
          ),
        ],
      ),
    ));
  }
}

class MyCustomObject {
  final String num;

  MyCustomObject(this.num);
}

class SlantPainter extends CustomPainter {
  final MyCustomObject myObject;

  SlantPainter(this.myObject);

  @override
  void paint(Canvas canvas, Size size) {
    String text1 = myObject.num;
    final paint = Paint();

    // first half
    paint.color = Colors.black;
    final path1 = Path()
      ..moveTo(0, size.height)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height)
      ..close();
    canvas.drawPath(path1, paint);

    // second half
    paint.color = primaryColor;
    final path2 = Path()
      ..moveTo(0, size.height)
      ..lineTo(0, 0)
      ..lineTo(size.width, 0)
      ..close();
    canvas.drawPath(path2, paint);

    // Draw text on the canvas
    final textPainter1 = TextPainter(
      text: const TextSpan(
        text: 'Generated number',
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter1.layout();
    textPainter1.paint(
      canvas,
      Offset(size.width / 6, size.height / 4),
    );

    final textPainter2 = TextPainter(
      text: TextSpan(
        text: text1,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter2.layout();
    textPainter2.paint(
      canvas,
      Offset(size.width / 4, size.height / 2),
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
