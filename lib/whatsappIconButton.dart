import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';




class WhatsAppNavigateButton extends StatefulWidget {
  const WhatsAppNavigateButton({super.key});

  @override
  State<WhatsAppNavigateButton> createState() => _WhatsAppNavigateButtonState();
}

// 2. Creating the State for our widget
class _WhatsAppNavigateButtonState extends State<WhatsAppNavigateButton> {
  // 3. The logic to navigate to WhatsApp
  Future<void> _navigateToWhatsApp() async {
    final Uri whatsappUrl = Uri.parse('https://api.whatsapp.com/send?phone=7223077806&text=Hello!');


    if (await canLaunchUrl(whatsappUrl)) {
      await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication);
    } else {

      debugPrint("Could not launch WhatsApp.");
    }
  }


  @override
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: _navigateToWhatsApp,
      backgroundColor: Colors.brown,
      tooltip: 'Contact on WhatsApp',
      child: Icon(
        FontAwesomeIcons.whatsapp,
        color: Colors.green,
      ),
    );
  }
}