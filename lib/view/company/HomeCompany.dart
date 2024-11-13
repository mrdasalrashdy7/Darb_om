import 'package:darb/controller/Company_Controller.dart';
import 'package:darb/customfunction/logout.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeCompany extends StatelessWidget {
  final CompanyController Ccontroller = Get.put(CompanyController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Company page"),
        backgroundColor: Colors.orange,
        actions: [
          IconButton(
            onPressed: () {
              logout();
            },
            icon: Icon(Icons.exit_to_app),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.drive_eta_rounded),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.supervised_user_circle),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.analytics),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Update screen width in controller
          Ccontroller.updateScreenWidth(constraints.maxWidth);

          // Define the layout based on screen width
          return Obx(() {
            double screenWidth = Ccontroller.screenWidth.value;

            if (screenWidth > 900) {
              return _buildDesktopLayout(screenWidth);
            } else if (screenWidth > 600) {
              return _buildTabletLayout(screenWidth);
            } else {
              return _buildMobileLayout(screenWidth);
            }
          });
        },
      ),
    );
  }

  Widget _buildDesktopLayout(double screenWidth) {
    return ListView(
      children: [
        SizedBox(height: 40),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildContainer("Company", screenWidth / 3, 500),
            _buildContainer("Analytics", screenWidth / 3, 500),
            Column(
              children: [
                _buildContainer("Drivers", screenWidth / 4, 240),
                _buildContainer("Orders", screenWidth / 4, 240),
              ],
            ),
          ],
        ),
        _buildDivider(),
        _buildStatusText(),
      ],
    );
  }

  Widget _buildTabletLayout(double screenWidth) {
    return ListView(
      children: [
        SizedBox(height: 40),
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildContainer("Company", screenWidth / 2.5, 300),
                _buildContainer("Analytics", screenWidth / 2.5, 300),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildContainer("Drivers", screenWidth / 2.5, 200),
                _buildContainer("Orders", screenWidth / 2.5, 200),
              ],
            ),
          ],
        ),
        _buildDivider(),
        _buildStatusText(),
      ],
    );
  }

  Widget _buildMobileLayout(double screenWidth) {
    return ListView(
      children: [
        SizedBox(height: 20),
        Column(
          children: [
            _buildContainer("Company", screenWidth * 0.9, 200),
            SizedBox(height: 10),
            _buildContainer("Analytics", screenWidth * 0.9, 200),
            SizedBox(height: 10),
            _buildContainer("Drivers", screenWidth * 0.9, 200),
            SizedBox(height: 10),
            _buildContainer("Orders", screenWidth * 0.9, 200),
          ],
        ),
        _buildDivider(),
        _buildStatusText(),
      ],
    );
  }

  Widget _buildContainer(String text, double width, double height) {
    return Container(
      margin: EdgeInsets.all(10),
      color: Colors.orange,
      width: width,
      height: height,
      alignment: Alignment.center,
      child: Text(text, style: TextStyle(fontSize: 16, color: Colors.white)),
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 5,
      color: Colors.black,
      margin: EdgeInsets.symmetric(vertical: 20),
    );
  }

  Widget _buildStatusText() {
    return Column(
      children: [
        Text("Online drivers"),
        Text("On-road drivers"),
        Text("Ready drivers"),
      ],
    );
  }
}
