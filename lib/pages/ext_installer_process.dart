import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:open_bible_ai/bible/installer/extension_installer.dart';
import 'package:open_bible_ai/bible/installer/progress_stream.dart';
import 'package:open_bible_ai/widgets/error_widget.dart';
import 'package:open_bible_ai/widgets/loaders_widget.dart';

class ExtInstallerProcess extends StatefulWidget {
  const ExtInstallerProcess({super.key});
  @override
  State<ExtInstallerProcess> createState() => _ExtInstallerProcessState();
}

class _ExtInstallerProcessState extends State<ExtInstallerProcess> {
  bool _installing = false;
  bool _hasError = false;
  String _errorMessage = "";
  ProgressStream _ps = ProgressStream(
    message: "finding extension",
    progress: 0,
    totalStages: 0,
    currentStage: 0,
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child:
            !_installing
                ? (_hasError
                    ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: NormalError(errorText: _errorMessage),
                    )
                    : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Click button to select the opbf file it will do the installations automatically",
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            _pickFile();
                          },
                          child: Text("Pick File"),
                        ),
                      ],
                    ))
                : _createInstallationProgress(),
      ),
    );
  }

  Widget _createInstallationProgress() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          NormalLoader(),
          SizedBox(height: 20),
          Text(
            "${_ps.message} , ${_ps.progress} : ${_ps.currentStage} stages out of ${_ps.totalStages}",
          ),
        ],
      ),
    );
  }

  _pickFile() async {
    try {
      if (_installing) return;
      FilePickerResult? result = await FilePicker.platform.pickFiles();
      if (result == null) return;
      if (mounted) {
        setState(() {
          _hasError = false;
          _installing = true;
        });
      }
      File file = File(result.files.single.path!);
      final installer = BibleExtensionInstaller();
      await installer.installExtension(file, (updatedStream) {
        if (mounted) {
          setState(() {
            _ps = updatedStream;
          });
        }
      });
      if (mounted) {
        setState(() {
          _installing = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Extension installed successffully")),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _hasError = true;
          _installing = false;
          _errorMessage = "There was error : $e";
        });
      }
    }
  }
}
