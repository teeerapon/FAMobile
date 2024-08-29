import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:snippet_coder_utils/hex_color.dart';

// ignore: must_be_immutable
class CheckCode extends StatefulWidget {
  final oCcy = NumberFormat("#,##0.00", "th");
  final String titleName;
  final String codeAssets;
  final int brachID;
  final String brachName;
  final String? detail;
  final String ownerCode;
  late String images;
  late String imagePath_2;
  CheckCode({
    Key? key,
    required this.titleName,
    required this.codeAssets,
    required this.brachID,
    required this.brachName,
    required this.detail,
    required this.ownerCode,
    required this.images,
    required this.imagePath_2,
  }) : super(key: key);
  @override
  // ignore: library_private_types_in_public_api
  _CheckCodeState createState() => _CheckCodeState();
}

class _CheckCodeState extends State<CheckCode> {
  bool checkBox2 = false;
  bool checkBox = false;
  bool checkBox3 = false;
  var referenceController = TextEditingController();
  String referenceSetState1 = 'ชำรุดรอซ่อม';
  String referenceSetState2 = 'รอตัดชำรุด';
  String referenceSetState3 = '';
  var titleName = TextEditingController();

  @override
  Widget build(BuildContext context) {
    setState(() {
      titleName.text = widget.codeAssets;
    });
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60,
        leading: Row(children: <Widget>[
          const SizedBox(
            width: 5.0,
          ),
          IconButton(
            color: Colors.black,
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
              size: 28,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ]),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      backgroundColor: HexColor('#283B71'),
      body: assetsReported(),
    );
  }

  Widget assetsReported() {
    double screenWidth = MediaQuery.of(context).size.width;
    List<dynamic> listImage = [widget.images, widget.imagePath_2];
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 3.8,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.white, Colors.white]),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(100),
                bottomRight: Radius.circular(100),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 50, right: 50, top: 35),
                  child: Align(
                    alignment: Alignment.center,
                    child: Image.asset(
                      "assets/images/purethai.png",
                      // width: 250,
                      // height: 180,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding:
                const EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
            child: Card(
              elevation: 4.0,
              margin:
                  const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16))),
              color: const Color.fromRGBO(255, 255, 255, 1),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // เพิ่มรูปภาพใน Card
                    SizedBox(
                      width: double.maxFinite,
                      child: GridView.builder(
                        shrinkWrap: true,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, // จำนวนคอลัมน์ในแต่ละแถว
                          crossAxisSpacing: 8.0,
                          mainAxisSpacing: 8.0,
                          childAspectRatio:
                              1.0, // อัตราส่วนระหว่างความกว้างกับความสูงของแต่ละรูปภาพ
                        ),
                        itemCount: listImage.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ClipRRect(
                            borderRadius:
                                BorderRadius.circular(10.0), // มุมโค้งของรูปภาพ
                            child: Image.network(
                              (listImage[index]?.isNotEmpty ?? false)
                                  ? listImage[index]
                                  : 'assets/images/ATT_220300020.png',
                              fit: BoxFit.cover,
                              // ปรับขนาดรูปภาพให้เต็มพื้นที่ที่กำหนด
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.grey[
                                      200], // แสดงพื้นหลังสีเทาในกรณีที่โหลดรูปภาพไม่สำเร็จ
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.broken_image,
                                        color: Colors.grey[400],
                                      ),
                                      Text(
                                        'No Image',
                                        style: TextStyle(
                                          color: Colors.grey[400],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 8.0, left: 8.0, right: 8.0),
                      child: Text(
                        widget.codeAssets,
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            //fontStyle: FontStyle.italic,
                            fontSize: screenWidth * 0.05,
                            color: Colors.black),
                      ),
                    ),
                    const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                      child: Divider(
                        color: Colors.black,
                        thickness: 2,
                        height: 10,
                      ),
                    ),
                    ListTile(
                      title: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(
                              width: 280,
                              child: Text(widget.titleName,
                                  style: TextStyle(
                                      fontSize: screenWidth * 0.043,
                                      fontWeight: FontWeight.w500,
                                      color: const Color.fromRGBO(
                                          13, 209, 13, 1))),
                            ),
                            const SizedBox(height: 8),
                            Text('รหัสทรัพย์สิน : ${widget.codeAssets}',
                                style: TextStyle(
                                    fontSize: screenWidth * 0.043,
                                    fontWeight: FontWeight.w500,
                                    color: HexColor('#EAC435'))),
                            const SizedBox(height: 8),
                            Text(
                              'ผู้ถือครองทรัพย์สิน :  ${widget.ownerCode}',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  //fontStyle: FontStyle.italic,
                                  fontSize: screenWidth * 0.043,
                                  color: Colors.black),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'สาขา : ${widget.brachName} (${widget.brachID})',
                              style: TextStyle(
                                  fontSize: screenWidth * 0.043,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black),
                            ),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Text(
                                'สถานะล่าสุด :  ${widget.detail ?? 'ยังไม่ได้ระบุสถานะภาพ'}',
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    //fontStyle: FontStyle.italic,
                                    fontSize: screenWidth * 0.043,
                                    color: Colors.black),
                              ),
                            ),
                            const SizedBox(height: 8),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.only(left: 35, top: 30, right: 25),
          //   child: Column(
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: [
          //       TextField(
          //         readOnly: true,
          //         controller: titleName,
          //         style: const TextStyle(
          //           color: Colors.white,
          //           fontSize: 30,
          //           fontWeight: FontWeight.w500,
          //         ),
          //         decoration: const InputDecoration(
          //           border: InputBorder.none,
          //           focusedBorder: InputBorder.none,
          //           enabledBorder: InputBorder.none,
          //           errorBorder: InputBorder.none,
          //           disabledBorder: InputBorder.none,
          //         ),
          //       ),
          //       const SizedBox(
          //         height: 10,
          //       ),
          //       const Divider(
          //         color: Colors.white,
          //         thickness: 1,
          //         height: 20,
          //       ),
          //       const SizedBox(
          //         height: 10,
          //       ),
          //       Text(
          //         widget.titleName,
          //         style: const TextStyle(
          //             fontWeight: FontWeight.w500,
          //             //fontStyle: FontStyle.italic,
          //             fontSize: 18,
          //             color: Colors.white),
          //       ),
          //       const SizedBox(
          //         height: 10,
          //       ),
          //       Text(
          //         'สาขาที่อยู่ของทรัพย์สิน :  ${widget.brachName} (${widget.brachID})',
          //         style: const TextStyle(
          //             fontWeight: FontWeight.w500,
          //             //fontStyle: FontStyle.italic,
          //             fontSize: 18,
          //             color: Colors.white),
          //       ),
          //       const SizedBox(
          //         height: 10,
          //       ),
          //       Text(
          //         'ผู้ถือครองทรัพย์สิน :  ${widget.ownerCode}',
          //         style: const TextStyle(
          //             fontWeight: FontWeight.w500,
          //             //fontStyle: FontStyle.italic,
          //             fontSize: 18,
          //             color: Colors.white),
          //       ),
          //       const SizedBox(
          //         height: 10,
          //       ),
          //       SingleChildScrollView(
          //         scrollDirection: Axis.horizontal,
          //         child: Text(
          //           'สถานะปัจจุบัน :  ${widget.detail ?? 'ยังไม่ได้ระบุสถานะภาพ'}',
          //           style: const TextStyle(
          //               fontWeight: FontWeight.w500,
          //               //fontStyle: FontStyle.italic,
          //               fontSize: 18,
          //               color: Colors.white),
          //         ),
          //       ),
          //       const SizedBox(
          //         height: 10,
          //       ),
          //       const SizedBox(
          //         height: 10,
          //       ),
          //       const Divider(
          //         color: Colors.white,
          //         thickness: 1,
          //         height: 20,
          //       ),
          //       CarouselSlider(
          //         options: CarouselOptions(
          //           height: 250.0,
          //           viewportFraction: 1,
          //           autoPlay: true,
          //         ),
          //         items: [
          //           Image.network(
          //             widget.images, // this image doesn't exist
          //             fit: BoxFit.cover,
          //             errorBuilder: (BuildContext context, Object exception,
          //                 StackTrace? stackTrace) {
          //               return Image.asset(
          //                 "assets/images/ATT_220300020.png",
          //                 fit: BoxFit.cover,
          //               );
          //             },
          //           ),
          //           Image.network(
          //             widget.imagePath_2, // this image doesn't exist
          //             fit: BoxFit.cover,
          //             errorBuilder: (BuildContext context, Object exception,
          //                 StackTrace? stackTrace) {
          //               return Image.asset(
          //                 "assets/images/ATT_220300020.png",
          //                 fit: BoxFit.cover,
          //               );
          //             },
          //           ),
          //         ].map((i) {
          //           return i;
          //         }).toList(),
          //       ),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }
}
