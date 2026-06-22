import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:basic_hoven_website/google_map_widget.dart';
import 'package:common/common.dart';

const String whatsappMsg = 'Hello I would like to order a cake';

class LocationPage extends StatelessWidget {
  const LocationPage({super.key});

  Future<void> _openMap(BuildContext context) async {
    if (await canLaunchUrl(Uri.parse(hovenMapLink))) {
      await launchUrl(Uri.parse(hovenMapLink));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not launch maps')),
      );
    }
  }

  Future<void> _launchWhatsApp(BuildContext context) async {
    const url = 'https://wa.me/+91$contactNumber?text=$whatsappMsg';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not launch WhatsApp')),
      );
    }
  }

  Future<void> _makePhoneCall(BuildContext context) async {
    const url = 'tel:+91$contactNumber';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not make phone call')),
      );
    }
  }

  Future<void> _sendEmail(BuildContext context) async {
    const url = 'mailto:$email';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not launch email client')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: MediaQuery.of(context).size.height*.3,
              child: Stack(
                children: [
                  MiniMapResponsive(),
                  Positioned(
                    bottom: 16,
                    right: 16,
                    child: FloatingActionButton(
                      onPressed: () => _openMap(context),
                      child: const Icon(Icons.navigation),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Visit Us',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 16),
                    ListTile(
                      leading: Icon(
                        Icons.location_on,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      title: const Text(address),
                      subtitle: const Text('$city ,$pincode'),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () => _openMap(context),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.directions),
                          SizedBox(width: 8),
                          Text('Get Directions'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
             Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                  child: _buildContactCard(context),
                ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
              child: _buildWhatsAppButton(context),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildContactCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ListTile(
              leading: Icon(
                Icons.phone,
                color: Theme.of(context).colorScheme.primary,
              ),
              title: const Text('Phone'),
              subtitle: const Text('+91 $contactNumber'),
              trailing: IconButton(
                icon: const Icon(Icons.call),
                onPressed: () => _makePhoneCall(context),
              ),
            ),
            const Divider(),
            ListTile(
              leading: Icon(
                Icons.email,
                color: Theme.of(context).colorScheme.primary,
              ),
              title: const Text('Email'),
              subtitle: const Text(email),
              trailing: IconButton(
                icon: const Icon(Icons.email),
                onPressed: () => _sendEmail(context),
              ),
            ),
            const Divider(),
            ListTile(
              leading: Icon(
                Icons.location_on,
                color: Theme.of(context).colorScheme.primary,
              ),
              title: const Text('Address'),
              subtitle: const Text(fullAddress),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildWhatsAppButton(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Message us on WhatsApp',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () => _launchWhatsApp(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF25D366),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.chat),
              SizedBox(width: 12),
              Text('Open WhatsApp'),
            ],
          ),
        ),
      ],
    );
  }
}