import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/upload_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'predict_model.dart';
export 'predict_model.dart';

class PredictWidget extends StatefulWidget {
  const PredictWidget({Key? key}) : super(key: key);

  @override
  _PredictWidgetState createState() => _PredictWidgetState();
}

class _PredictWidgetState extends State<PredictWidget> {
  late PredictModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _unfocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PredictModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      final selectedMedia = await selectMediaWithSourceBottomSheet(
        context: context,
        imageQuality: 100,
        allowPhoto: true,
      );
      if (selectedMedia != null &&
          selectedMedia
              .every((m) => validateFileFormat(m.storagePath, context))) {
        setState(() => _model.isDataUploading = true);
        var selectedUploadedFiles = <FFUploadedFile>[];

        try {
          selectedUploadedFiles = selectedMedia
              .map((m) => FFUploadedFile(
                    name: m.storagePath.split('/').last,
                    bytes: m.bytes,
                    height: m.dimensions?.height,
                    width: m.dimensions?.width,
                  ))
              .toList();
        } finally {
          _model.isDataUploading = false;
        }
        if (selectedUploadedFiles.length == selectedMedia.length) {
          setState(() {
            _model.uploadedLocalFile = selectedUploadedFiles.first;
          });
        } else {
          setState(() {});
          return;
        }
      }

      context.pushNamed('Progress');

      await Future.delayed(const Duration(milliseconds: 5000));

      context.pushNamed('Result');

      await Future.delayed(const Duration(milliseconds: 5000));

      context.pushNamed('Predict');
    });
  }

  @override
  void dispose() {
    _model.dispose();

    _unfocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(_unfocusNode),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [],
          ),
        ),
      ),
    );
  }
}
