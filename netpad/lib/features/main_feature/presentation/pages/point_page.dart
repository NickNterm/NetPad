import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:netpad/features/main_feature/domain/entities/point_data.dart';
import 'package:netpad/features/main_feature/domain/entities/project.dart';
import 'package:netpad/features/main_feature/presentation/bloc/point_data/point_data_bloc.dart';
import 'package:netpad/features/main_feature/presentation/components/divider/custom_divider.dart';
import 'package:netpad/injection/dependency_injection.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class PointPage extends StatefulWidget {
  const PointPage({
    super.key,
    required this.project,
    this.pointData,
  });

  final Project project;
  final PointData? pointData;
  @override
  State<PointPage> createState() => _PointPageState();
}

class _PointPageState extends State<PointPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController antennaTypeController = TextEditingController();
  final TextEditingController antennaHeightController = TextEditingController();
  final TextEditingController startTimeController = TextEditingController();
  final TextEditingController endTimeController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  final List<String> images = [];

  final picker = ImagePicker();

  late StreamSubscription listener;

  @override
  initState() {
    super.initState();
    if (widget.pointData != null) {
      nameController.text = widget.pointData!.name;
      antennaTypeController.text = widget.pointData!.antennaType;
      antennaHeightController.text = widget.pointData!.antennaHeight.toString();
      startTimeController.text = widget.pointData!.startTime;
      endTimeController.text = widget.pointData!.endTime;
      notesController.text = widget.pointData!.notes;
      images.addAll(widget.pointData!.images);
    }
  }

  Future getImageFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    final dir = await getApplicationDocumentsDirectory();
    String path = dir.path;

    setState(() {
      if (pickedFile != null) {
        String fullPath =
            '$path/pointImage_${DateTime.now().millisecondsSinceEpoch}.${pickedFile.path.split('.').last}';
        pickedFile.saveTo(fullPath);
        images.add(fullPath);
      }
    });
  }

  Future getImageFromCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    final dir = await getApplicationDocumentsDirectory();
    String path = dir.path;

    setState(() {
      if (pickedFile != null) {
        String fullPath =
            '$path/pointImage_${DateTime.now().millisecondsSinceEpoch}.${pickedFile.path.split('.').last}';
        pickedFile.saveTo(fullPath);
        images.add(fullPath);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          iconSize: 35,
          icon: const Icon(
            Icons.keyboard_arrow_left_rounded,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Visibility(
            visible: widget.pointData != null,
            child: IconButton(
              iconSize: 27,
              icon: const Icon(
                Icons.delete_rounded,
              ),
              onPressed: () {
                sl<PointDataBloc>().add(
                  DeletePointEvent(
                    widget.pointData!.id,
                    widget.project,
                  ),
                );
                Navigator.pop(context);
              },
            ),
          ),
        ],
        title: Text(widget.pointData == null ? 'New Point' : "Edit Point"),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 8),
                EntryWidget(
                  controller: nameController,
                  label: 'Name',
                  icon: Icons.abc_rounded,
                ),
                EntryWidget(
                  controller: antennaTypeController,
                  label: 'Antenna Type',
                  icon: Icons.settings_input_antenna_rounded,
                ),
                EntryWidget(
                  controller: antennaHeightController,
                  label: 'Antenna Height',
                  keyboardType: TextInputType.number,
                  icon: Icons.height_rounded,
                ),
                EntryWidget(
                  controller: startTimeController,
                  label: 'Start Time',
                  keyboardType: TextInputType.datetime,
                  icon: Icons.hourglass_top_rounded,
                  buttonText: 'Set Now',
                  onButtonPressed: () {
                    setState(() {
                      DateFormat dateFormat = DateFormat('HH:mm dd/MM/yyyy');
                      String text = dateFormat.format(DateTime.now());
                      startTimeController.text = text;
                    });
                  },
                ),
                EntryWidget(
                  controller: endTimeController,
                  label: 'End Time',
                  keyboardType: TextInputType.datetime,
                  icon: Icons.hourglass_bottom_rounded,
                  buttonText: 'Set Now',
                  onButtonPressed: () {
                    setState(() {
                      DateFormat dateFormat = DateFormat('HH:mm dd/MM/yyyy');
                      String text = dateFormat.format(DateTime.now());
                      endTimeController.text = text;
                    });
                  },
                ),
                EntryWidget(
                  controller: notesController,
                  label: 'Notes',
                  icon: Icons.summarize_rounded,
                ),
                const SizedBox(height: 8),
                const CustomDivider(),
                const SizedBox(height: 8),
                const Text(
                  'Images',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                    ),
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: images.length + 1,
                    itemBuilder: (BuildContext context, int index) {
                      if (index == images.length) {
                        return GestureDetector(
                          onTap: () async {
                            showModalBottomSheet(
                              context: context,
                              clipBehavior: Clip.antiAlias,
                              builder: (context) => BottomSheet(
                                enableDrag: false,
                                onClosing: () {},
                                builder: (BuildContext context) {
                                  return Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const SizedBox(height: 15),
                                      Container(
                                        width: 50,
                                        height: 5,
                                        decoration: BoxDecoration(
                                          color: Colors.grey[300],
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                      const SizedBox(height: 15),
                                      ListTile(
                                        leading: const Icon(
                                          Icons.camera_alt_rounded,
                                          size: 30,
                                        ),
                                        title: const Text(
                                          'Camera',
                                          style: TextStyle(
                                            fontSize: 20,
                                          ),
                                        ),
                                        onTap: () async {
                                          Navigator.pop(context);
                                          final status =
                                              await Permission.camera.request();
                                          if (status.isGranted) {
                                            getImageFromCamera();
                                          }
                                        },
                                      ),
                                      ListTile(
                                        leading: const Icon(
                                          Icons.photo_rounded,
                                          size: 30,
                                        ),
                                        title: const Text(
                                          'Gallery',
                                          style: TextStyle(
                                            fontSize: 20,
                                          ),
                                        ),
                                        onTap: () async {
                                          Navigator.pop(context);
                                          final status = await Permission
                                              .storage
                                              .request();
                                          if (status.isGranted) {
                                            getImageFromGallery();
                                          }
                                        },
                                      ),
                                      const SizedBox(height: 15),
                                    ],
                                  );
                                },
                              ),
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.add_rounded,
                              size: 50,
                              color: Colors.grey,
                            ),
                          ),
                        );
                      } else {
                        return Stack(
                          fit: StackFit.expand,
                          children: [
                            Container(
                              margin: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.file(
                                  File(images[index]),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Positioned(
                              top: 0,
                              right: 0,
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    images.removeAt(index);
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.grey[400],
                                  ),
                                  padding: const EdgeInsets.all(4),
                                  child: Icon(
                                    Icons.close_rounded,
                                    size: 20,
                                    color: Colors.grey[800],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                    },
                  ),
                ),
                const SizedBox(height: 90),
              ],
            ),
          ),
          Positioned(
            bottom: 30,
            left: 30,
            right: 30,
            child: GestureDetector(
              onTap: () {
                if (nameController.text.isEmpty ||
                    antennaTypeController.text.isEmpty ||
                    antennaHeightController.text.isEmpty ||
                    startTimeController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      behavior: SnackBarBehavior.floating,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      backgroundColor: Colors.red.shade300,
                      margin: const EdgeInsets.only(
                          bottom: 100, left: 30, right: 30),
                      content: const Text('Please fill all the fields'),
                    ),
                  );
                } else {
                  double height = 0;
                  try {
                    height = double.parse(antennaHeightController.text);
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        behavior: SnackBarBehavior.floating,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        backgroundColor: Colors.red.shade300,
                        margin: const EdgeInsets.only(
                            bottom: 100, left: 30, right: 30),
                        content: const Text('Please enter a valid height'),
                      ),
                    );
                    return;
                  }
                  listener = sl<PointDataBloc>().stream.listen(
                    (state) {
                      if (state is PointDataLoaded) {
                        listener.cancel();
                        Navigator.pop(context);
                      }
                    },
                  );
                  if (widget.pointData != null) {
                    sl<PointDataBloc>().add(
                      EditPointEvent(
                        PointData(
                          id: widget.pointData!.id,
                          name: nameController.text,
                          antennaType: antennaTypeController.text,
                          startTime: startTimeController.text,
                          endTime: endTimeController.text,
                          images: images,
                          notes: notesController.text,
                          antennaHeight: height,
                        ),
                      ),
                    );
                  } else {
                    sl<PointDataBloc>().add(
                      CreatePointEvent(
                        PointData(
                          id: 0,
                          name: nameController.text,
                          antennaType: antennaTypeController.text,
                          startTime: startTimeController.text,
                          endTime: endTimeController.text,
                          images: images,
                          notes: notesController.text,
                          antennaHeight: height,
                        ),
                        widget.project,
                      ),
                    );
                  }
                }
              },
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.cyan,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Center(
                  child: Text(
                    'Submit',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class EntryWidget extends StatelessWidget {
  const EntryWidget({
    super.key,
    required this.controller,
    required this.icon,
    required this.label,
    this.buttonText,
    this.onButtonPressed,
    this.keyboardType = TextInputType.text,
  });
  final TextEditingController controller;
  final TextInputType keyboardType;
  final IconData icon;
  final String label;

  final Function()? onButtonPressed;
  final String? buttonText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey[200],
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  minLines: 1,
                  maxLines: 10,
                  keyboardType: keyboardType,
                  decoration: InputDecoration(
                    fillColor: Colors.grey[200],
                    labelText: label,
                    filled: true,
                    border: InputBorder.none,
                    prefixIcon: Icon(icon),
                  ),
                ),
              ),
              Visibility(
                visible: buttonText != null,
                child: GestureDetector(
                  onTap: onButtonPressed,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      buttonText ?? '',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.cyan,
                      ),
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
}
