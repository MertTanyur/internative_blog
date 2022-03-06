import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:image_picker/image_picker.dart';
import 'package:internative_blog/splash_screen.dart';
import 'package:provider/provider.dart';
import '../state/account_controller.dart';
import 'package:flutter/material.dart';

import '../state/auth_controller.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import '../widget_generating_functions/widget_generator_functions.dart';
import 'package:hive/hive.dart';
import '../local_storage/storage.dart';
import '../screens/register.dart';

final ImagePicker _picker = ImagePicker();

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  /// Determine the current position of the device.
  ///
  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.
  Position? currentPosition;

  Future<LatLng> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    Position p = await Geolocator.getCurrentPosition();
    currentPosition = p;
    var ll = LatLng(currentPosition!.latitude, currentPosition!.longitude);

    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(
        CameraUpdate.newCameraPosition(CameraPosition(target: ll, zoom: 200)));
    if (ll != null) {
      context
          .read<AccountController>()
          .setLocation(ll.longitude.toString(), ll.latitude.toString());
    }
    return ll;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        Expanded(
          flex: 4,
          child: Row(
            children: [
              Spacer(),
              Expanded(
                flex: 2,
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.grey,
                      shape: BoxShape.circle,
                      image: context.watch<AccountController>().image != null
                          ? DecorationImage(
                              image: NetworkImage(
                                  context.watch<AccountController>().image!))
                          : null),
                  child: Stack(fit: StackFit.expand, children: [
                    Positioned(
                      bottom: 50,
                      right: 30,
                      child: IconButton(
                        icon: const Icon(
                          Icons.camera_alt_rounded,
                          size: 40,
                        ),
                        onPressed: () async {
                          await blogDialog(context);
                          Future.delayed(Duration(milliseconds: 300));
                          blogBottomSheet(context, size);
                        },
                      ),
                    )
                  ]),
                ),
              ),
              Spacer(),
            ],
          ),
        ),
        Expanded(
          flex: 4,
          child: Container(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: GoogleMap(
                  myLocationEnabled: true,
                  mapType: MapType.hybrid,
                  initialCameraPosition: _kGooglePlex,
                  onMapCreated: (GoogleMapController controller) async {
                    _controller.complete(controller);
                    await _determinePosition();
                  },
                ),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      color: Theme.of(context).colorScheme.primary,
                      width: 1.2,
                    ),
                  ),
                  child: Row(children: const [
                    Icon(Icons.login),
                    Expanded(
                      child: Center(
                        child: Text('Save'),
                      ),
                    )
                  ]),
                  onPressed: () {
                    var controller = context.read<AccountController>();

                    if (controller.latitude != null &&
                        controller.longtitude != null &&
                        controller.image != null) {
                      context.read<AccountController>().accountUpdate();
                    } else {
                      showError(context, 'Missing Fields',
                          'Please select a photo and allow location services');
                    }
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(elevation: 0),
                  child: Row(children: const [
                    Icon(Icons.logout),
                    Expanded(
                      child: Center(
                        child: Text('Log out'),
                      ),
                    )
                  ]),
                  onPressed: () {
                    Box<Credentials> credBox =
                        Hive.box<Credentials>('credentials');

                    credBox.clear();
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        Register.id, (Route<dynamic> route) => false);
                  },
                ),
              ),
            ],
          ),
        ),
        Spacer(),
      ],
    );
  }

  Future<dynamic> blogDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: ((context) => AlertDialog(
              content: IntrinsicWidth(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ElevatedButton(
                        style: ButtonStyle(
                            elevation: MaterialStateProperty.all(0)),
                        child: Stack(children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Icon(Icons.camera_alt_rounded),
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              'Camera',
                            ),
                          )
                        ]),
                        onPressed: () async {
                          final XFile? photo = await _picker.pickImage(
                              source: ImageSource.camera);
                          if (photo != null) {
                            context
                                .read<AccountController>()
                                .setImageFile(photo);
                            print('image file setted');
                          }
                          Navigator.pop(context);
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      OutlinedButton(
                        child: Stack(children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Icon(Icons.photo_library_outlined),
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              'Gallery',
                            ),
                          )
                        ]),
                        onPressed: () async {
                          final XFile? image = await _picker.pickImage(
                              source: ImageSource.gallery);
                          if (image != null) {
                            context
                                .read<AccountController>()
                                .setImageFile(image);
                            print('image file setted');
                          }
                          Navigator.pop(context);
                        },
                      ),
                    ]),
              ),
              title: const Center(child: Text('Select an image')),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              backgroundColor: Colors.white,
            )));
  }

  PersistentBottomSheetController<dynamic> blogBottomSheet(
      BuildContext context, Size size) {
    return showBottomSheet(
        elevation: 15,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        context: context,
        builder: (context) => Container(
              height: size.height * 3 / 5,
              width: size.width,
              child: Column(children: [
                Expanded(
                    flex: 7,
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: LayoutBuilder(builder: (context, constraints) {
                        final side =
                            min(constraints.maxHeight, constraints.maxWidth);
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            height: side,
                            width: side,
                            decoration: const BoxDecoration(
                              color: Color(0xffC4C9D2),
                            ),
                            child: Image.file(
                              File(context
                                  .read<AccountController>()
                                  .imageFile!
                                  .path),
                              fit: BoxFit.fill,
                            ),
                          ),
                        );
                      }),
                    )),
                Expanded(
                  flex: 2,
                  child: Container(
                    child: Row(children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: ElevatedButton(
                            child: const Text('Select'),
                            onPressed: () async {
                              context.read<AccountController>().uploadImage();
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: OutlinedButton(
                            child: const Text('Remove'),
                            onPressed: () {
                              context
                                  .read<AccountController>()
                                  .removeImageFile();
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ),
                    ]),
                  ),
                ),
              ]),
            ));
  }
}
