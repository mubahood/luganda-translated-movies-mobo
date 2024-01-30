import 'dart:async';
import 'dart:io';

import 'package:audio_session/audio_session.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart' as gt;
import 'package:image_picker/image_picker.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../models/FarmerQuestion.dart';
import '../../models/RespondModel.dart';
import '../../utils/CustomTheme.dart';
import '../../utils/Utilities.dart';
import 'VoiceRecordScreen.dart';

class FarmerQuestionAnswerCreateScreen extends StatefulWidget {
  FarmerQuestion item;

  FarmerQuestionAnswerCreateScreen(
    this.item, {
    Key? key,
  }) : super(key: key);

  @override
  FarmerQuestionAnswerCreateScreenState createState() =>
      FarmerQuestionAnswerCreateScreenState();
}

class FarmerQuestionAnswerCreateScreenState
    extends State<FarmerQuestionAnswerCreateScreen>
    with SingleTickerProviderStateMixin {
  var initFuture;
  final _fKey = GlobalKey<FormBuilderState>();
  bool is_loading = false;
  String error_message = "";

  Future<bool> init_form() async {
    is_loading = false;

    return true;
  }

  @override
  void initState() {
    super.initState();

    init();
    initFuture = init_form();
  }

  Future<void> _initializeExample() async {
    await playerModule.closePlayer();
    await playerModule.openPlayer();
    await playerModule.setSubscriptionDuration(const Duration(milliseconds: 10));
    await recorderModule.setSubscriptionDuration(const Duration(milliseconds: 10));
    await initializeDateFormatting();
    await setCodec(_codec);
  }

  Future<void> setCodec(Codec codec) async {
    setState(() {
      _codec = codec;
    });
  }

  Future<void> init() async {
    await openTheRecorder();
    _initializeExample();

    final session = await AudioSession.instance;
    await session.configure(AudioSessionConfiguration(
      avAudioSessionCategory: AVAudioSessionCategory.playAndRecord,
      avAudioSessionCategoryOptions:
          AVAudioSessionCategoryOptions.allowBluetooth |
              AVAudioSessionCategoryOptions.defaultToSpeaker,
      avAudioSessionMode: AVAudioSessionMode.spokenAudio,
      avAudioSessionRouteSharingPolicy:
          AVAudioSessionRouteSharingPolicy.defaultPolicy,
      avAudioSessionSetActiveOptions: AVAudioSessionSetActiveOptions.none,
      androidAudioAttributes: const AndroidAudioAttributes(
        contentType: AndroidAudioContentType.speech,
        flags: AndroidAudioFlags.none,
        usage: AndroidAudioUsage.voiceCommunication,
      ),
      androidAudioFocusGainType: AndroidAudioFocusGainType.gain,
      androidWillPauseWhenDucked: true,
    ));
  }

  Future<void> openTheRecorder() async {
    if (!kIsWeb) {
      var status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        throw RecordingPermissionException('Microphone permission not granted');
      }
    }
    await recorderModule.openRecorder();

    if (!await recorderModule.isEncoderSupported(_codec) && kIsWeb) {
      _codec = Codec.opusWebM;
    }
  }

  @override
  Widget build(BuildContext context) {
    _keyboardVisible = MediaQuery.of(context).viewInsets.bottom != 0;
    return Scaffold(
      appBar: AppBar(
        title: FxText.titleLarge(
          "Answering a question",
          color: Colors.white,
          fontWeight: 700,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: CustomTheme.primary,
      ),
      body: FutureBuilder(
          future: initFuture,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            return FormBuilder(
              key: _fKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Divider(
                    color: CustomTheme.primary,
                    thickness: 1,
                    height: 0,
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Container(
                        padding: const EdgeInsets.only(
                          left: 15,
                          top: 0,
                          right: 15,
                        ),
                        child: Column(
                          children: [
                            const SizedBox(height: 10),
                            error_message.isEmpty
                                ? const SizedBox()
                                : FxContainer(
                                    margin: const EdgeInsets.only(bottom: 10),
                                    color: Colors.red.shade50,
                                    child: Text(
                                      error_message,
                                    ),
                                  ),
                            FxContainer(
                              bordered: true,
                              color: Colors.grey.shade100,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  FxText.bodyLarge(
                                    "Question",
                                    fontWeight: 700,
                                    color: Colors.black,
                                  ),
                                  const Divider(),
                                  FxText.bodyLarge(
                                    widget.item.body,
                                    color: Colors.black,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            FormBuilderTextField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: const BorderSide(
                                    color: CustomTheme.primary,
                                    width: 2,
                                  ),
                                ),
                                labelText: "Answer",
                                labelStyle: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700,
                                ),
                                helperText: "Type your answer here.",
                              ),
                              minLines: 5,
                              maxLines: 5,
                              textCapitalization: TextCapitalization.words,
                              name: "answer",
                              onChanged: (x) {},
                            ),
                            const SizedBox(height: 25),
                            Flex(
                              direction: Axis.horizontal,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: path.isNotEmpty &&
                                          !recorderModule.isRecording
                                      ? FxContainer(
                                          bordered: true,
                                          borderColor: Colors.grey.shade600,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  if (!playerModule.isPlaying) {
                                                    startPlayer();
                                                  } else {
                                                    stopPlayer();
                                                  }
                                                },
                                                child: Icon(
                                                  !playerModule.isPlaying
                                                      ? FeatherIcons.play
                                                      : FeatherIcons.stopCircle,
                                                  size: 50,
                                                  color: !playerModule.isPlaying
                                                      ? CustomTheme.primary
                                                      : Colors.red,
                                                ),
                                              ),
                                              const SizedBox(height: 20),
                                              FxText.titleLarge(
                                                !playerModule.isPlaying
                                                    ? "PLAY\nAUDIO"
                                                    : "STOP\nRPLAYING",
                                                fontWeight: 700,
                                                color: Colors.black,
                                                textAlign: TextAlign.center,
                                                height: 1,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    FeatherIcons.trash2,
                                                    size: 16,
                                                    color: Colors.red.shade600,
                                                  ),
                                                  const SizedBox(width: 5),
                                                  FxButton.text(
                                                    padding: EdgeInsets.zero,
                                                    onPressed: () {
                                                      path = "";
                                                      setState(() {});
                                                    },
                                                    child: FxText.bodyMedium(
                                                      "Delete",
                                                      color:
                                                          Colors.red.shade800,
                                                      fontWeight: 700,
                                                    ),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        )
                                      : FxContainer(
                                          bordered: true,
                                          onTap: () {
                                            if (!recorderModule.isRecording) {
                                              startRecording();
                                            } else {
                                              stopRecorder();
                                            }
                                          },
                                          borderColor: Colors.grey.shade600,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Icon(
                                                !recorderModule.isRecording
                                                    ? FeatherIcons.mic
                                                    : FeatherIcons.stopCircle,
                                                size: 50,
                                                color: Colors.red.shade800,
                                              ),
                                              const SizedBox(height: 20),
                                              FxText.titleLarge(
                                                !recorderModule.isRecording
                                                    ? "RECORD\nAUDIO"
                                                    : "STOP\nRECORDING",
                                                fontWeight: 700,
                                                color: Colors.black,
                                                textAlign: TextAlign.center,
                                                height: 1,
                                              ),
                                              !recorderModule.isRecording
                                                  ? const SizedBox()
                                                  : Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        const SizedBox(height: 10),
                                                        FxText.bodyMedium(
                                                          _recorderTxt,
                                                          color: Colors.red,
                                                          fontWeight: 700,
                                                        ),
                                                      ],
                                                    ),
                                            ],
                                          ),
                                        ),
                                ),
                                const SizedBox(width: 15),
                                Expanded(
                                  flex: 1,
                                  child: imagePath.isNotEmpty
                                      ? FxContainer(
                                          paddingAll: 5,
                                          bordered: true,
                                          borderColor: Colors.grey.shade600,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Image.file(
                                                File(imagePath),
                                                fit: BoxFit.fitWidth,
                                                width: gt.Get.width / 3.1,
                                                height: gt.Get.width / 3.1,
                                              ),
                                              FxButton.text(
                                                padding: EdgeInsets.zero,
                                                onPressed: () {
                                                  imagePath = "";
                                                  setState(() {});
                                                },
                                                child: Center(
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(
                                                        FeatherIcons.trash2,
                                                        size: 16,
                                                        color:
                                                            Colors.red.shade600,
                                                      ),
                                                      const SizedBox(width: 5),
                                                      FxText.bodyMedium(
                                                        "Delete",
                                                        color:
                                                            Colors.red.shade800,
                                                        fontWeight: 700,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      : FxContainer(
                                          onTap: () {
                                            _show_bottom_sheet_photo();
                                          },
                                          bordered: true,
                                          borderColor: Colors.grey.shade600,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              const Icon(
                                                FeatherIcons.camera,
                                                size: 50,
                                                color: CustomTheme.primary,
                                              ),
                                              const SizedBox(height: 20),
                                              FxText.titleLarge(
                                                "ATTACH\nPHOTO",
                                                fontWeight: 700,
                                                color: Colors.black,
                                                textAlign: TextAlign.center,
                                                height: 1,
                                              ),
                                            ],
                                          ),
                                        ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  const Divider(
                    height: 1,
                  ),
                  _keyboardVisible
                      ? const SizedBox()
                      : FxContainer(
                          color: Colors.white,
                          borderRadiusAll: 0,
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 15),
                          child: is_loading
                              ? const Center(
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.0,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        CustomTheme.primary),
                                  ),
                                )
                              : FxButton(
                                  padding: const EdgeInsets.only(
                                    top: 20,
                                    bottom: 20,
                                  ),
                                  borderRadiusAll: 12,
                                  onPressed: () {
                                    submit_form();
                                  },
                                  block: true,
                                  backgroundColor: CustomTheme.primary,
                                  child: FxText.titleLarge(
                                    'SUBMIT ANSWER',
                                    color: Colors.white,
                                    fontWeight: 700,
                                  )))
                ],
              ),
            );
          }),
    );
  }

  bool _keyboardVisible = false;
  Codec _codec = Codec.aacMP4;
  FlutterSoundPlayer playerModule = FlutterSoundPlayer();
  FlutterSoundRecorder recorderModule = FlutterSoundRecorder();

  submit_form() async {
    String answer = _fKey.currentState!.fields['answer']!.value;

    if (answer.isEmpty) {
      if (imagePath.isEmpty && path.isEmpty) {
        Utils.toast2('Please enter question or attach photo or record audio');
        return;
      }
    }

    if (!_fKey.currentState!.validate()) {
      Utils.toast('Fix some errors first.', color: Colors.red.shade700);
      return;
    }
    setState(() {
      error_message = "";
      is_loading = true;
    });

    Map<String, dynamic> formDataMap = {
      'body': answer,
      'question_id': widget.item.id,
    };
    if (path.length > 2) {
      formDataMap['audio'] = await MultipartFile.fromFile(path, filename: path);
    }
    if (imagePath.length > 2) {
      formDataMap['imagePath'] =
          await MultipartFile.fromFile(imagePath, filename: path);
    }

    RespondModel resp = RespondModel(
        await Utils.http_post('farmer-answers-create', formDataMap));
    await FarmerQuestion.getOnlineItems();
    setState(() {
      error_message = "";
      is_loading = false;
    });

    if (resp.code != 1) {
      Utils.toast2(resp.message,
          background_color: Colors.red.shade700, is_long: true);
      return;
    }
    Utils.toast2(resp.message, is_long: true);
    Navigator.pop(context);

    return;
  }

  String path = "";
  StreamSubscription? _recorderSubscription;
  StreamSubscription? _playerSubscription;
  StreamSubscription? _recordingDataSubscription;
  String _recorderTxt = '00:00:00';
  final String _playerTxt = '00:00:00';
  double? _dbLevel;

  void startRecording() async {
    try {
      // Request Microphone permission if needed
      if (!kIsWeb) {
        var status = await Permission.microphone.request();
        if (status != PermissionStatus.granted) {
          Utils.toast2('Microphone permission not granted');
          return;
        }
      }

      if (!kIsWeb) {
        var tempDir = await getTemporaryDirectory();
        path = '${tempDir.path}/flutter_sound${ext[_codec.index]}';
      } else {
        path = '_flutter_sound${ext[_codec.index]}';
      }

      await recorderModule.startRecorder(
        toFile: path,
        codec: _codec,
        bitRate: 8000,
        numChannels: 1,
        sampleRate: (_codec == Codec.pcm16) ? tSTREAMSAMPLERATE : tSAMPLERATE,
      );
      recorderModule.logger.d('startRecorder');

      _recorderSubscription = recorderModule.onProgress!.listen((e) {
        var date = DateTime.fromMillisecondsSinceEpoch(
            e.duration.inMilliseconds,
            isUtc: true);
        var txt = DateFormat('mm:ss:SS', 'en_GB').format(date);

        setState(() {
          _recorderTxt = txt.substring(0, 8);
          _dbLevel = e.decibels;
        });
      });

      setState(() {
        _isRecording = true;
        _path[_codec.index] = path;
      });
    } on Exception catch (err) {
      Utils.toast2('startRecorder error: $err');
      setState(() {
        stopRecorder();
        _isRecording = false;
        /*cancelRecordingDataSubscription();
        cancelRecorderSubscriptions();*/
      });
    }
  }

  Future<bool> fileExists(String path) async {
    return await File(path).exists();
  }

  Future<void> startPlayer() async {
    try {
      Uint8List? dataBuffer;
      String? audioFilePath;
      var codec = _codec;

      if (kIsWeb || await fileExists(_path[codec.index]!)) {
        audioFilePath = _path[codec.index];
      }

      await playerModule.startPlayer(
          fromURI: audioFilePath,
          codec: codec,
          sampleRate: tSTREAMSAMPLERATE,
          whenFinished: () {
            playerModule.logger.d('Play finished');
            setState(() {});
          });

      setState(() {});
      playerModule.logger.d('<--- startPlayer');
    } on Exception catch (err) {
      playerModule.logger.e('error: $err');
    }
  }

  Future<void> stopPlayer() async {
    try {
      await playerModule.stopPlayer();
      playerModule.logger.d('stopPlayer');
      if (_playerSubscription != null) {
        await _playerSubscription!.cancel();
        _playerSubscription = null;
      }
    } on Exception catch (err) {
      playerModule.logger.d('error: $err');
    }
    setState(() {});
  }

  void stopRecorder() async {
    try {
      await recorderModule.stopRecorder();
      recorderModule.logger.d('stopRecorder');
/*      cancelRecorderSubscriptions();
      cancelRecordingDataSubscription();*/
    } on Exception catch (err) {
      recorderModule.logger.d('stopRecorder error: $err');
    }
    setState(() {
      _isRecording = false;
    });
  }

  final List<String?> _path = [
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
  ];
  bool _isRecording = false;

  Future<void> _show_bottom_sheet_photo() async {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext buildContext) {
          return Container(
            color: Colors.transparent,
            child: Container(
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16))),
              child: Padding(
                padding: FxSpacing.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListTile(
                      onTap: () => {do_pick_image("camera")},
                      dense: false,
                      leading: const Icon(Icons.camera_alt,
                          color: CustomTheme.primary),
                      title: FxText.bodyLarge("Use Camera", fontWeight: 600),
                    ),
                    ListTile(
                        dense: false,
                        onTap: () => {do_pick_image("gallery")},
                        leading: const Icon(Icons.photo_library_sharp,
                            color: CustomTheme.primary),
                        title: FxText.bodyLarge("Pick from Gallery",
                            fontWeight: 600)),
                  ],
                ),
              ),
            ),
          );
        });
  }

  String imagePath = "";

  do_pick_image(String source) async {
    Navigator.pop(context);

    final ImagePicker picker = ImagePicker();
    if (source == "camera") {

    }
  }
}
