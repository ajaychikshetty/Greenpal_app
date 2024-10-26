import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../../core/models/report.dart';
import '../../core/utils/app_colors.dart';
import '../../core/utils/geo_locator.dart'; // Assuming this handles reverse geocoding

class LocationInput extends StatefulWidget {
  const LocationInput({super.key, required this.onSelectLocation});
  final void Function(Location pickedLocation) onSelectLocation;

  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  Location? location;
  var findingLocation = false;

  Future<void> _getCurrentLocation() async {
    setState(() {
      findingLocation = true;
    });

    try {
      // Fetch the current position
      await GeolocationService.determinePosition(); // Assuming this handles permission requests
      Position locationData = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      final double lat = locationData.latitude;
      final double lng = locationData.longitude;

      // Reverse geocode to get address
      final address = await GeolocationService.reverseGeocode(locationData);
      print("Address From Reverse Geocode: $address");

      final formattedAddress = [
        if (address.name != null) address.name,
        if (address.subLocality != null) address.subLocality,
        if (address.locality != null) address.locality,
        if (address.administrativeArea != null) address.administrativeArea,
        if (address.country != null) address.country,
        if (address.postalCode != null) address.postalCode,
      ].where((part) => part != null).join(', ');

      setState(() {
        location = Location(
          lat: lat.toString(),
          lon: lng.toString(),
          formattedAddress: formattedAddress,
        );
        findingLocation = false;
      });

      widget.onSelectLocation(location!);
    } catch (error) {
      setState(() {
        findingLocation = false;
      });
      print('Error getting location: $error');
      // Handle the error (e.g., show a message to the user)
    }
  }

  String get locationImage {
    if (location == null) {
      return '';
    }
    // Corrected URL for Google Maps Static API
    // return "https://maps.googleapis.com/maps/api/staticmap?center=$lat,$lng&zoom=16&size=600x300&maptype=roadmap&markers=color:red%7Clabel:I%7C$lat,$lng&key=AIzaSyB7VZLnFBTbPZkWnlvKsa5chOctCRqA4ms";
    return"https://maps.googleapis.com/maps/api/staticmap?center=19.2617737,73.1247391&zoom=16&size=600x300&maptype=roadmap&markers=color:red%7Clabel:I%7C19.2617737,73.1247391&key=AIzaSyB7VZLnFBTbPZkWnlvKsa5chOctCRqA4ms";
  }

  @override
  Widget build(BuildContext context) {
    Widget previewContent = Text(
      "No Chosen Location",
      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
            color: TColors.primaryGreen,
          ),
    );

    if (findingLocation) {
      previewContent = const Center(
        child: CircularProgressIndicator(
          color: TColors.black,
        ),
      );
    }

    if (location != null) {
      previewContent = Image.network(
        locationImage,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 5,
        ),
        Text(
          location?.formattedAddress.toString() ??
              "Your location will appear here...",
          maxLines: null,
          style: Theme.of(context)
              .textTheme
              .bodyMedium!
              .copyWith(color: TColors.black),
          textAlign: TextAlign.start,
        ),
        const SizedBox(
          height: 5,
        ),
        Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          width: double.infinity,
          height: 130,
          child: previewContent,
        ),
        const SizedBox(
          height: 20,
        ),
        Center(
          child: ElevatedButton.icon(
            onPressed: _getCurrentLocation,
            style: ElevatedButton.styleFrom(
              backgroundColor: TColors.primaryGreen,
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 10,
              ),
            ),
            label: Text(
              "Get Location",
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: TColors.white,
                    fontWeight: FontWeight.w400,
                  ),
            ),
            icon: const Icon(Icons.location_on_outlined),
          ),
        ),
      ],
    );
  }
}
