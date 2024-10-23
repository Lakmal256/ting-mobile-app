import 'package:app/screens/screens.dart';
import 'package:app/themes/themes.dart';
import 'package:app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;

class SupportComplainsScreen extends StatelessWidget {
  const SupportComplainsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
          backgroundColor: AppColors.kMainBlue,
          centerTitle: false,
          leading: IconButton(
              onPressed: () => context.pop(),
              icon: const Icon(Icons.navigate_before,
                  color: Colors.white, size: 35)),
          title: const CustomTextWidget(
              text: 'Support & Complains',
              fontSize: 20,
              fontWeight: FontWeight.bold)),
      backgroundColor: AppColors.kMainBlue,
      body: Stack(
        children: [
          Container(
            height: media.height,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  const AddComplaintButton(),
                  const SizedBox(height: 10),
                  const ViewRequestsButtons(),
                  const SizedBox(height: 30),
                  const CustomTextWidget(
                      text: 'Open Requests',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.kBlue3),
                  const SizedBox(height: 15),
                  Expanded(
                      flex: 0,
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: 7,
                        itemBuilder: (context, index) => const Card(
                          color: AppColors.kBlue1,
                          child: Padding(
                            padding: EdgeInsets.all(12),
                            child: Row(
                              children: [
                                SizedBox(width: 10),
                                Expanded(
                                    child: CustomTextWidget(
                                        text: 'Sample Request ',
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold))
                              ],
                            ),
                          ),
                        ),
                      )),
                  const SizedBox(height: 20), // Adjust spacing as needed
                  const SafeArea(child: SizedBox.shrink())
                ])),
          ),
          const Positioned(
            bottom: 0.0,
            right: 0.0,
            child: ContactSupportButton(),
          ),
        ],
      ),
    );
  }
}

class ViewRequestsButtons extends StatelessWidget {
  const ViewRequestsButtons({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: AppColors.kBlue1),
      child: TextButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const OrderAndSupportScreen(
                          title: "Support & Complains",
                          tabIndex: 1,
                        )));
          },
          child: const FittedBox(
            fit: BoxFit.scaleDown,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Icon(Icons.history, color: Colors.white),
                  SizedBox(width: 5),
                  CustomTextWidget(
                      text: 'Completed Requests',
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ],
              ),
            ),
          )),
    );
  }
}

class AddComplaintButton extends StatelessWidget {
  const AddComplaintButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: LinearGradient(colors: [
            AppColors.kMainOranage.withOpacity(0.3),
            AppColors.kMainPink.withOpacity(0.3)
          ])),
      child: TextButton(
          onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const OrderAndSupportScreen(
                        title: "Past Orders",
                        tabIndex: 0,
                      ))),
          child: const FittedBox(
            fit: BoxFit.scaleDown,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Icon(Icons.add_rounded, color: Colors.white),
                  SizedBox(width: 5),
                  CustomTextWidget(
                      text: 'Add New Complaint',
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ],
              ),
            ),
          )),
    );
  }
}

class ContactSupportButton extends StatelessWidget {
  const ContactSupportButton({super.key});

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;

    return Padding(
      padding: EdgeInsets.only(bottom: media.height * 0.13),
      child: Container(
        width: media.width * 0.5,
        height: 50,
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(50),
              bottomLeft: Radius.circular(50),
            ),
            gradient: LinearGradient(colors: [
              AppColors.kMainOranage.withOpacity(0.3),
              AppColors.kMainPink.withOpacity(0.3)
            ])),
        child: TextButton(
            onPressed: () {
              url_launcher.launchUrl(Uri(
                scheme: 'tel',
                path: '0771085889',
              ));
            },
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Image.asset(AssestPath.customerServiceIconPath,
                        width: 26, height: 26),
                    // const Icon(Icons.add_rounded, color: Colors.white),
                    const SizedBox(width: 10),
                    const CustomTextWidget(
                        text: 'Contact Support  Hotline',
                        fontSize: 12,
                        fontWeight: FontWeight.bold),
                  ],
                ),
              ),
            )),
      ),
    );
  }
}
