import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dialog.dart';
import 'model.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:auto_size_text/auto_size_text.dart';

enum TtsState { playing, stopped, paused, continued }

class Dashboard extends StatefulWidget {
  static int setMainSc = 1;
  static int setFirstSc = 3;
  static int setSecondSc = 2;
  static int setThirdSc = -1;

  @override
  _DashboardState createState() => _DashboardState();
}

@override
class _DashboardState extends State<Dashboard> {
  Timer _timer; // 시간 흐르게함
  String nowTime;
  String nowHour;
  String nowMin;
  String nowSec;

// 초를 HHMMSS 시간으로 표기해줌
  String formatMMSS(int seconds) {
    //int hours = (seconds / 3600).truncate();
    int hours = (seconds / 3600).truncate();
    seconds = (seconds % 3600).truncate();
    int minutes = (seconds / 60).truncate();

    String hoursStr = (hours).toString().padLeft(1, '0');
    String minutesStr = (minutes).toString().padLeft(2, '0');
    String secondsStr = (seconds % 60).toString().padLeft(2, '0');

    if (hours == 0) {
      nowMin = "$minutesStr";
      nowSec = "$secondsStr";
      return "$minutesStr:$secondsStr";
    }
    nowHour = "$hoursStr";
    nowMin = "$minutesStr";
    nowSec = "$secondsStr";
    return "$hoursStr:$minutesStr:$secondsStr";
  }

//시간 조정 하는거 보였다가 안보였다가

  bool condition = true;

// 점수 증가 +,- 기호
  String firstSign() {
    if (Dashboard.setFirstSc > 0) {
      return ('+');
    } else if (Dashboard.setFirstSc < 0) return ('');
  }

  String secSign() {
    if (Dashboard.setSecondSc > 0) {
      return ('+');
    } else if (Dashboard.setSecondSc < 0) return ('');
  }

  String thirdSign() {
    if (Dashboard.setThirdSc > 0) {
      return ('+');
    } else if (Dashboard.setThirdSc < 0) return ('');
  }

  //+5분,+1분 증가
  void _5minUp() {
    Control.time = Control.time + 300;
  }

  void _1minUp() {
    Control.time = Control.time + 60;
  }

  void _zero() {
    Control.time = 0;
  }

  void _secUp() {
    Control.time = Control.time + 5;
  }

  // 시작 또는 멈춤 버튼 클릭
  void _clickButton() {
    Control.isRunning = !Control.isRunning; //Running 일때와 running 이 아닐때
    if (Control.isRunning) {
      condition = false; //시간 수정 보이게 하기
      _start(); // 시간이 흐르게함
    } else {
      condition = true; //시간 수정 안보이게 하
      _pause();
    }
  }

// 시간 흐름. _clickButton()일시 작동함
  void _start() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (Control.time == 0) {
          _reset();
        } else {
          Control.time = Control.time - 1;
          //Control.isRunning = true;
        }
      });
    });
  }

  // 타이머 취소
  void _pause() {
    _timer?.cancel();
  }

  // 초기화
  void _reset() {
    setState(() {
      Control.isRunning = false;
      _timer?.cancel();
      //_lapTimes.clear();
      Control.time = 0;
      condition = true;
    });
  }

  // timer 종료 될때 반복 되는 동작을 취소함
  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

//htboard

  // color
  void _htColorchange() {
    setState(() {
      if (Control.htColor == Colors.red) {
        Control.htColor = Colors.blue;
      } else if (Control.htColor == Colors.blue) {
        Control.htColor = Colors.grey;
      } else if (Control.htColor == Colors.grey) {
        Control.htColor = null;
      } else {
        Control.htColor = Colors.red;
      }
    });
  }

  void _atColorchange() {
    setState(() {
      if (Control.atColor == Colors.red) {
        Control.atColor = Colors.blue;
      } else if (Control.atColor == Colors.blue) {
        Control.atColor = Colors.grey;
      } else if (Control.atColor == Colors.grey) {
        Control.atColor = null;
      } else {
        Control.atColor = Colors.red;
      }
    });
  }

// team name

  TextEditingController _c;
  TextEditingController _d;


  void changHtName() {
    showDialog(
        child: SimpleDialog(
          children: <Widget>[
            new TextField(
              textAlign: TextAlign.center,
              decoration: new InputDecoration(hintText: "Team name?"),
              controller: _c,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new FlatButton(
                  child: new Text("Cancel"),
                  onPressed: () {
                    Navigator.pop(context); //popup close
                  },
                ),
                new FlatButton(
                  child: new Text("Save"),
                  onPressed: () {
                    setState(() {
                      if (this._c.text.isEmpty) {
                        Control.htName = "team name";
                      } else
                        Control.htName = _c.text;
                    });
                    Navigator.pop(context);
                  },
                ),
              ],
            )
          ],
        ),
        context: context); // 없으면 안됨 왜 있는지 모르겠음
  }

  void changAtName() {
    showDialog(
        child: SimpleDialog(
          children: <Widget>[
            new TextField(
              textAlign: TextAlign.center,
              decoration: new InputDecoration(hintText: "Team name?"),
              controller: _d,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new FlatButton(
                  child: new Text("Cancel"),
                  onPressed: () {
                    Navigator.pop(context); //popup close
                  },
                ),
                new FlatButton(
                  child: new Text("Save"),
                  onPressed: () {
                    setState(() {
                      if (this._d.text.isEmpty) {
                        Control.atName = "team name";
                      } else
                        Control.atName = _d.text;
                    });
                    Navigator.pop(context);
                  },
                ),
              ],
            )
          ],
        ),
        context: context); // 없으면 안됨 왜 있는지 모르겠음
  }

  @override
  initState() {
    _c = new TextEditingController();
    _d = new TextEditingController(); // 팀 이름 변경을 위함
    super.initState();
    initTts(); // for TTS
  } // 이거 없으면 save 안됨/ 공부 해야 겠음

  // set score

  void _uphtSet() {
    setState(() {
      Control.htSet = Control.htSet + 1;
    });
  }

  void _downhtSet() {
    setState(() {
      Control.htSet = Control.htSet - 1;
    });
  }

  void _upatSet() {
    setState(() {
      Control.atSet = Control.atSet + 1;
    });
  }

  void _downatSet() {
    setState(() {
      Control.atSet = Control.atSet - 1;
    });
  }

  void _upHtScMain() {
    setState(() {
      Control.htSc = Control.htSc + Dashboard.setMainSc;
      //temphtSc = htSc;
    });
  }

  void _upHtScFirst() {
    setState(() {
      Control.htSc = Control.htSc + Dashboard.setFirstSc;
      //temphtSc = htSc;
    });
  }

  void _upHtScSecond() {
    setState(() {
      Control.htSc = Control.htSc + Dashboard.setSecondSc;
      //temphtSc = htSc;
    });
  }

  void _upHtScThird() {
    setState(() {
      Control.htSc = Control.htSc + Dashboard.setThirdSc;
      //temphtSc = htSc;
    });
  }

  void _upatScMain() {
    setState(() {
      Control.atSc = Control.atSc + Dashboard.setMainSc;
      //tempatSc = atSc;
    });
  }

  void _upatScFirst() {
    setState(() {
      Control.atSc = Control.atSc + Dashboard.setFirstSc;
      //tempatSc = atSc;
    });
  }

  void _upatScSecond() {
    setState(() {
      Control.atSc = Control.atSc + Dashboard.setSecondSc;
      //tempatSc = atSc;
    });
  }

  void _upatScThird() {
    setState(() {
      Control.atSc = Control.atSc + Dashboard.setThirdSc;
      //tempatSc = atSc;
    });
  }

  // setboard
  // 불리언 if 를 통해서 homeboard, awyboard 위치를 바꿔

  bool show = true;

  void _switch() {
    setState(() {
      if (show == false) {
        show = true;
      } else {
        show = false;
      }
    });
  }

// 소리 나게 만들기

  static AudioCache player = AudioCache();

  void endPlay() {
    player.play('end.mp3');
  }

  void startPlay() {
    player.play('start.mp3');
  }

  void faulPlay() {
    player.play('faul.m4a');
  }

// TTS 점수, 시간 알려주기

  FlutterTts flutterTts;
  double volume = 1.0;
  double pitch = 1.0;
  double rate = 0.5;

  String _newVoiceText;

  TtsState ttsState = TtsState.stopped;
  get isPlaying => ttsState == TtsState.playing;
  get isStopped => ttsState == TtsState.stopped;
  get isPaused => ttsState == TtsState.paused;
  get isContinued => ttsState == TtsState.continued;

  initTts() {
    flutterTts = FlutterTts();


    flutterTts.setStartHandler(() {
      setState(() {
        ttsState = TtsState.playing;
      });
    });

    flutterTts.setCompletionHandler(() {
      setState(() {
        ttsState = TtsState.stopped;
      });
    });

    flutterTts.setCancelHandler(() {
      setState(() {
        ttsState = TtsState.stopped;
      });
    });

    flutterTts.setErrorHandler((msg) {
      setState(() {
        //print("error: $msg");
        ttsState = TtsState.stopped;
      });
    });
  }

  Future _speakScore() async {
    if (Control.selectedValue == 'ko-KR') {
      _newVoiceText = '${Control.htSc}대${Control.atSc}';
    } else if (Control.selectedValue == 'en-US') {
      _newVoiceText = '${Control.htSc}to${Control.atSc}';
    }

    //_newVoiceText = '${Control.htSc}to${Control.atSc}';

    await flutterTts.setLanguage(Control.selectedValue);
    await flutterTts.setVolume(volume);
    await flutterTts.setSpeechRate(rate);
    await flutterTts.setPitch(pitch);

    if (_newVoiceText != null) {
      if (_newVoiceText.isNotEmpty) {
        //var result = await flutterTts.speak(_newVoiceText);
        var result = await flutterTts.speak(_newVoiceText);
        //print(_newVoiceText);
        if (result == 1) setState(() => ttsState = TtsState.playing);
      }
    }
  }

  Future _speakTime() async {
    if (Control.selectedValue == 'ko-KR') {
      _newVoiceText = '${nowMin}분${nowSec}초 남았습니다.';
    } else if (Control.selectedValue == 'en-US') {
      _newVoiceText = '${nowMin}minutes${nowSec}seconds left';
    }

    //_newVoiceText = nowTime;

    await flutterTts.setLanguage(Control.selectedValue);
    await flutterTts.setVolume(volume);
    await flutterTts.setSpeechRate(rate);
    await flutterTts.setPitch(pitch);

    if (_newVoiceText != null) {
      if (_newVoiceText.isNotEmpty) {
        //var result = await flutterTts.speak(_newVoiceText);
        var result = await flutterTts.speak(_newVoiceText);
        //print(_newVoiceText);
        if (result == 1) setState(() => ttsState = TtsState.playing);
      }
    }
  }


  Material Timeboard(String formatMMSS) {
    return Material(
        color: Colors.black,
        //elevation: 14.0, 모르겠음 지우지 말것
        //shadowColor: Color(0x802196F3),
        //borderRadius: BorderRadius.circular(12.0),
        child: Center(
          child: Container(
            margin: const EdgeInsets.all(0.0),
            padding: const EdgeInsets.all(0.0),
            width: MediaQuery.of(context).size.width * 0.90,
            height: MediaQuery.of(context).size.height * 0.08,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    // time up
                    Visibility(
                      visible: condition,
                      child: Container(
                        margin: const EdgeInsets.all(0.0),
                        padding: const EdgeInsets.all(0.0),
                        width: MediaQuery.of(context).size.width * 0.08,
                        height: MediaQuery.of(context).size.height * 0.08,
                        child: FlatButton(
                          padding: EdgeInsets.all(0),
                          child:
                          Text(
                            '+5',
                            style: TextStyle(
                              color: Colors.white,),
                          ),
                          onPressed: () => setState(() {
                            _5minUp();
                          }),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: condition,
                      child: Container(
                        margin: const EdgeInsets.all(0.0),
                        padding: const EdgeInsets.all(0.0),
                        width: MediaQuery.of(context).size.width * 0.08,
                        height: MediaQuery.of(context).size.height * 0.08,
                        child: FlatButton(
                          padding: EdgeInsets.all(0),
                          child: Text('+1',
                              style: TextStyle(
                                color: Colors.white,
                              )),
                          onPressed: () => setState(() {
                            _1minUp();
                          }),
                        ),
                      ),
                    ),

                    Visibility(
                      visible: condition,
                      child: Container(
                        margin: const EdgeInsets.all(0.0),
                        padding: const EdgeInsets.all(0.0),
                        width: MediaQuery.of(context).size.width * 0.08,
                        height: MediaQuery.of(context).size.height * 0.08,
                        child: FlatButton(
                          padding: EdgeInsets.all(0),
                          child: Text('+0.5',
                              style: TextStyle(
                                color: Colors.white,
                              )),
                          onPressed: () => setState(() {
                            _secUp();
                          }),
                        ),
                      ),
                    ),

                    Visibility(
                      visible: condition,
                      child: Container(
                        margin: const EdgeInsets.all(0.0),
                        padding: const EdgeInsets.all(0.0),
                        width: MediaQuery.of(context).size.width * 0.08,
                        height: MediaQuery.of(context).size.height * 0.08,
                        child: FlatButton(
                          padding: EdgeInsets.all(0),
                          child: Text('0',
                              style: TextStyle(
                                color: Colors.white,
                              )),
                          onPressed: () => setState(() {
                            _zero();
                          }),
                        ),
                      ),
                    ),

                    Container(
                      margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                      padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                      width: MediaQuery.of(context).size.width * 0.35,
                      height: MediaQuery.of(context).size.height * 0.08,
                      alignment: Alignment.center,
                      child: AutoSizeText(
                        formatMMSS,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 100.0,
                        ),
                        maxLines: 1,
                      ),
                    ),

                    Container(
                      margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                      width: MediaQuery.of(context).size.width * 0.20,
                      height: MediaQuery.of(context).size.height * 0.08,
                      alignment: Alignment.center,
                      child: FlatButton(
                        //color: new Color(color),
                        onPressed: () => setState(() {
                          _clickButton();
                        }),
                        child: Control.isRunning
                            ? Icon(
                                Icons.stop,
                                size: 50,
                                color: Colors.white,
                              )
                            : Icon(
                                Icons.play_arrow,
                                size: 50,
                                color: Colors.white,
                              ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }

  Material rotateTimeboard(String formatMMSS) {
    return Material(
        color: Colors.black,
        //elevation: 14.0, 모르겠음 지우지 말것
        //shadowColor: Color(0x802196F3),
        //borderRadius: BorderRadius.circular(12.0),
        child: Center(
          child: Container(
            margin: const EdgeInsets.all(0.0),
            padding: const EdgeInsets.all(0.0),
            width: MediaQuery.of(context).size.width * 0.98, //0.90
            height: MediaQuery.of(context).size.height * 0.15, //0.08
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    // time up
                    Visibility(
                      visible: condition,
                      child: Container(
                        margin: const EdgeInsets.fromLTRB(0,0,0,0),
                        padding: const EdgeInsets.all(0.0),
                        width: MediaQuery.of(context).size.width * 0.04, //0.08
                        height: MediaQuery.of(context).size.height * 0.15, //0.08
                        child: FlatButton(
                          padding: EdgeInsets.fromLTRB(0,0,0,0),
                          child: Text('+5',
                              style: TextStyle(
                                color: Colors.white,
                              )),
                          onPressed: () => setState(() {
                            _5minUp();
                          }),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: condition,
                      child: Container(
                        margin: const EdgeInsets.all(0.0),
                        padding: const EdgeInsets.all(0.0),
                        width: MediaQuery.of(context).size.width * 0.04, //0.08
                        height: MediaQuery.of(context).size.height * 0.15, //0.08
                        child: FlatButton(
                          padding: EdgeInsets.all(0),
                          child: Text('+1',
                              style: TextStyle(
                                color: Colors.white,
                              )),
                          onPressed: () => setState(() {
                            _1minUp();
                          }),
                        ),
                      ),
                    ),

                    Visibility(
                      visible: condition,
                      child: Container(
                        margin: const EdgeInsets.all(0.0),
                        padding: const EdgeInsets.all(0.0),
                        width: MediaQuery.of(context).size.width * 0.04, //0.08
                        height: MediaQuery.of(context).size.height * 0.15, //0.08
                        child: FlatButton(
                          padding: EdgeInsets.all(0),
                          child: Text('+0.5',
                              style: TextStyle(
                                color: Colors.white,
                              )),
                          onPressed: () => setState(() {
                            _secUp();
                          }),
                        ),
                      ),
                    ),

                    Visibility(
                      visible: condition,
                      child: Container(
                        margin: const EdgeInsets.all(0.0),
                        padding: const EdgeInsets.all(0.0),
                        width: MediaQuery.of(context).size.width * 0.04, //0.08
                        height: MediaQuery.of(context).size.height * 0.15, //0.08
                        child: FlatButton(
                          padding: EdgeInsets.all(0),
                          child: Text('0',
                              style: TextStyle(
                                color: Colors.white,
                              )),
                          onPressed: () => setState(() {
                            _zero();
                          }),
                        ),
                      ),
                    ),

                    Container(
                      margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                      padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                      width: MediaQuery.of(context).size.width * 0.225, //0.35
                      height: MediaQuery.of(context).size.height * 0.15, //0.08
                      alignment: Alignment.center,
                      child: AutoSizeText(
                        formatMMSS,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 100.0,
                        ),
                        maxLines: 1,
                      ),
                    ),

                    Container(
                      margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                      width: MediaQuery.of(context).size.width * 0.10, //0.20
                      height: MediaQuery.of(context).size.height * 0.15, //0.08
                      alignment: Alignment.center,
                      child: FlatButton(
                        //color: new Color(color),
                        onPressed: () => setState(() {
                          _clickButton();
                        }),
                        child: Control.isRunning
                            ? Icon(
                          Icons.stop,
                          size: 50,
                          color: Colors.white,
                        )
                            : Icon(
                          Icons.play_arrow,
                          size: 50,
                          color: Colors.white,
                        ),
                      ),
                    ),

                    Visibility(
                      visible: condition,
                      child: Container(
                        margin: const EdgeInsets.all(0.0),
                        padding: const EdgeInsets.all(0.0),
                        width: MediaQuery.of(context).size.width * 0.07, //0.08
                        height: MediaQuery.of(context).size.height * 0.15, //0.08
                        child: FlatButton(
                          //color: new Color(color),
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (_) {
                                  return reMatchDialog();
                                }).then((_) => setState(() {}));
                          },
                          //onPressed: _initial,
                          child: Icon(
                            Icons.refresh,
                            size: 30,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),

                    Visibility(
                      visible: condition,
                      child: Container(
                        margin: const EdgeInsets.all(0.0),
                        padding: const EdgeInsets.all(0.0),
                        width: MediaQuery.of(context).size.width * 0.07, //0.08
                        height: MediaQuery.of(context).size.height * 0.15, //0.08
                        child: FlatButton(
                          //color: new Color(color),
                          onPressed: _switch,
                          child: Icon(
                            Icons.loop,
                            size: 30,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),

                    Visibility(
                      visible: condition,
                      child: Container(
                        margin: const EdgeInsets.all(0.0),
                        padding: const EdgeInsets.all(0.0),
                        width: MediaQuery.of(context).size.width * 0.07, //0.08
                        height: MediaQuery.of(context).size.height * 0.15, //0.08
                        child: FlatButton(
                          child: Icon(
                            Icons.settings,
                            size: 30,
                            color: Colors.white,
                          ),
                          //color: new Color(color),
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return MyDialog();
                                }).then((_) => setState(() {}));
                          },
                        ),
                      ),
                    ),

                  ],
                ),
              ],
            ),
          ),
        ));
  }


  Material homeTeamBoard() {
    return Material(
      color: Colors.black,
      //elevation: 14.0, 모르겠음 지우지 말것
      //shadowColor: Color(0x802196F3),
      //borderRadius: BorderRadius.circular(12.0),
      child: Container(
          child: Padding(
        padding: const EdgeInsets.all(8.0), // 모르겠음
            child: Column(mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.all(0.0),
                padding: const EdgeInsets.all(0.0),
                decoration: BoxDecoration(
                    color: Control.htColor,
                    border: Border.all(color: Colors.white)),
                width: MediaQuery.of(context).size.width * 0.35,
                height: MediaQuery.of(context).size.height * 0.05,
                alignment: Alignment.center,
                child: InkWell(
                  onTap: () => _htColorchange(),
                  child: Text(
                    "team color",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(0.0),
                padding: const EdgeInsets.all(0.0),
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.white)),
                width: MediaQuery.of(context).size.width * 0.55,
                height: MediaQuery.of(context).size.height * 0.05,
                alignment: Alignment.center,
                child: InkWell(
                  onTap: changHtName,
                  child: Text(
                    '${Control.htName}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.all(0.0),
                    padding: const EdgeInsets.all(0.0),
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.white)),
                    width: MediaQuery.of(context).size.width * 0.20,
                    height: MediaQuery.of(context).size.height * 0.24,
                    alignment: Alignment.center,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        FlatButton(
                          onPressed: _uphtSet,
                          child: Icon(
                            Icons.arrow_drop_up,
                            size: 30,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          "Set",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                          ),
                        ),
                        Text(
                          '${Control.htSet}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30.0,
                          ),
                        ),
                        FlatButton(
                          onPressed: _downhtSet,
                          child: Icon(
                            Icons.arrow_drop_down,
                            size: 30,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(0.0),
                    padding: const EdgeInsets.all(0.0),
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.white)),
                    width: MediaQuery.of(context).size.width * 0.45,
                    height: MediaQuery.of(context).size.height * 0.24,
                    //color: Colors.red,
                    alignment: Alignment.center,
                    child: FlatButton(
                      onPressed: _upHtScMain,
                      child: Text(
                        '${Control.htSc}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 120.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.all(0.0),
                    padding: const EdgeInsets.all(0.0),
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.white)),
                    width: MediaQuery.of(context).size.width * 0.25,
                    height: MediaQuery.of(context).size.height * 0.08,
                    //color: Colors.blue[600],
                    child: FlatButton(
                      padding: EdgeInsets.all(0),
                      child: Text('${firstSign()}${Dashboard.setFirstSc}',
                          style: TextStyle(color: Colors.white, fontSize: 30)),
                      onPressed: _upHtScFirst,
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.25,
                    height: MediaQuery.of(context).size.height * 0.08,
                    margin: const EdgeInsets.all(0.0),
                    padding: const EdgeInsets.all(0.0),
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.white)),
                    //color: Colors.blue[600],
                    child: FlatButton(
                      padding: EdgeInsets.all(0),
                      child: Text('${secSign()}${Dashboard.setSecondSc}',
                          style: TextStyle(color: Colors.white, fontSize: 30)),
                      onPressed: _upHtScSecond,
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.25,
                    height: MediaQuery.of(context).size.height * 0.08,
                    margin: const EdgeInsets.all(0.0),
                    padding: const EdgeInsets.all(0.0),
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.white)),
                    //color: Colors.blue[600],
                    child: FlatButton(
                      padding: EdgeInsets.all(0),
                      child: Text('${thirdSign()}${Dashboard.setThirdSc}',
                          style: TextStyle(color: Colors.white, fontSize: 30)),
                      onPressed: _upHtScThird,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ]),
      )),
    );
  }


  Material rotateHomeTeamBoard() {
    return Material(
      color: Colors.black,
      //elevation: 14.0, 모르겠음 지우지 말것
      //shadowColor: Color(0x802196F3),
      //borderRadius: BorderRadius.circular(12.0),
      child: Container(
          child: Padding(
            padding: const EdgeInsets.all(8.0), // 모르겠음
            child: Column(mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.all(0.0),
                        padding: const EdgeInsets.all(0.0),
                        decoration: BoxDecoration(
                            color: Control.htColor,
                            border: Border.all(color: Colors.white)),
                        width: MediaQuery.of(context).size.width * 0.20, //0.35
                        height: MediaQuery.of(context).size.height * 0.08,
                        alignment: Alignment.center,
                        child: InkWell(
                          onTap: () => _htColorchange(),
                          child: Text(
                            "team color",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.all(0.0),
                        padding: const EdgeInsets.all(0.0),
                        decoration:
                        BoxDecoration(border: Border.all(color: Colors.white)),
                        width: MediaQuery.of(context).size.width * 0.27, //0.55
                        height: MediaQuery.of(context).size.height * 0.08,
                        alignment: Alignment.center,
                        child: InkWell(
                          onTap: changHtName,
                          child: Text(
                            '${Control.htName}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Container(
                            margin: const EdgeInsets.all(0.0),
                            padding: const EdgeInsets.all(0.0),
                            decoration:
                            BoxDecoration(border: Border.all(color: Colors.white)),
                            width: MediaQuery.of(context).size.width * 0.10, //20
                            height: MediaQuery.of(context).size.height * 0.42, //0.27
                            alignment: Alignment.center,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                FlatButton(
                                  onPressed: _uphtSet,
                                  child: Icon(
                                    Icons.arrow_drop_up,
                                    size: 30,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  "Set",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20.0,
                                  ),
                                ),
                                Text(
                                  '${Control.htSet}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 30.0,
                                  ),
                                ),
                                FlatButton(
                                  onPressed: _downhtSet,
                                  child: Icon(
                                    Icons.arrow_drop_down,
                                    size: 30,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.all(0.0),
                            padding: const EdgeInsets.all(0.0),
                            decoration:
                            BoxDecoration(border: Border.all(color: Colors.white)),
                            width: MediaQuery.of(context).size.width * 0.25, //0.45
                            height: MediaQuery.of(context).size.height * 0.42, //0.27
                            alignment: Alignment.center,
                            child: FlatButton(
                              onPressed: _upHtScMain,
                              child: Text(
                                '${Control.htSc}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 120.0,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            margin: const EdgeInsets.all(0.0),
                            padding: const EdgeInsets.all(0.0),
                            decoration:
                            BoxDecoration(border: Border.all(color: Colors.white)),
                            width: MediaQuery.of(context).size.width * 0.12, //0.25
                            height: MediaQuery.of(context).size.height * 0.14, //0.09
                            child: FlatButton(
                              padding: EdgeInsets.all(0),
                              child: Text('${firstSign()}${Dashboard.setFirstSc}',
                                  style: TextStyle(color: Colors.white, fontSize: 30)),
                              onPressed: _upHtScFirst,
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.12, //0.25
                            height: MediaQuery.of(context).size.height * 0.14, //0.09
                            margin: const EdgeInsets.all(0.0),
                            padding: const EdgeInsets.all(0.0),
                            decoration:
                            BoxDecoration(border: Border.all(color: Colors.white)),
                            child: FlatButton(
                              padding: EdgeInsets.all(0),
                              child: Text('${secSign()}${Dashboard.setSecondSc}',
                                  style: TextStyle(color: Colors.white, fontSize: 30)),
                              onPressed: _upHtScSecond,
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.12, //0.25
                            height: MediaQuery.of(context).size.height * 0.14, //0.09
                            margin: const EdgeInsets.all(0.0),
                            padding: const EdgeInsets.all(0.0),
                            decoration:
                            BoxDecoration(border: Border.all(color: Colors.white)),
                            child: FlatButton(
                              padding: EdgeInsets.all(0),
                              child: Text('${thirdSign()}${Dashboard.setThirdSc}',
                                  style: TextStyle(color: Colors.white, fontSize: 30)),
                              onPressed: _upHtScThird,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ]),
          )),
    );
  }


  Material setBoard() {
    return Material(
      color: Colors.black,
      child: Visibility(
          visible: condition,
          child: Container(
            //width: MediaQuery.of(context).size.width * 0.12, //0.25
            height: MediaQuery.of(context).size.height * 0.05, //0.09
            margin: const EdgeInsets.all(0.0),
            padding: const EdgeInsets.all(0.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // set up
                FlatButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (_) {
                          return reMatchDialog();
                        }).then((_) => setState(() {}));
                  },
                  child: Icon(
                    Icons.refresh,
                    size: 30,
                    color: Colors.white,
                  ),
                ),
                FlatButton(
                  onPressed: _switch,
                  child: Icon(
                    Icons.loop,
                    size: 30,
                    color: Colors.white,
                  ),
                ),
                FlatButton(
                  child: Icon(
                    Icons.settings,
                    size: 30,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return MyDialog();
                        }).then((_) => setState(() {}));
                  },
                ),
              ],
            ),
          )),
    );
  }

  Material awayTeamBoard() {
    return Material(
      color: Colors.black,
      //elevation: 14.0, 모르겠음 지우지 말것
      //shadowColor: Color(0x802196F3),
      //borderRadius: BorderRadius.circular(12.0),

      child: Container(
          child: Padding(
        padding: const EdgeInsets.all(8.0), // 모르겠음
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: <
            Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.all(0.0),
                padding: const EdgeInsets.all(0.0),
                decoration: BoxDecoration(
                    color: Control.atColor,
                    border: Border.all(color: Colors.white)),
                width: MediaQuery.of(context).size.width * 0.35,
                height: MediaQuery.of(context).size.height * 0.05,
                alignment: Alignment.center,
                child: InkWell(
                  onTap: () => _atColorchange(),
                  child: Text(
                    "team color",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(0.0),
                padding: const EdgeInsets.all(0.0),
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.white)),
                width: MediaQuery.of(context).size.width * 0.55,
                height: MediaQuery.of(context).size.height * 0.05,
                alignment: Alignment.center,
                child: InkWell(
                  onTap: changAtName,
                  child: Text(
                    '${Control.atName}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.all(0.0),
                    padding: const EdgeInsets.all(0.0),
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.white)),
                    width: MediaQuery.of(context).size.width * 0.20,
                    height: MediaQuery.of(context).size.height * 0.24,
                    alignment: Alignment.center,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,

                      children: <Widget>[
                        FlatButton(
                          onPressed: _upatSet,
                          child: Icon(
                            Icons.arrow_drop_up,
                            size: 30,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          "Set",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                          ),
                        ),
                        Text(
                          '${Control.atSet}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30.0,
                          ),
                        ),
                        FlatButton(
                          onPressed: _downatSet,
                          child: Icon(
                            Icons.arrow_drop_down,
                            size: 30,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(0.0),
                    padding: const EdgeInsets.all(0.0),
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.white)),
                    width: MediaQuery.of(context).size.width * 0.45,
                    height: MediaQuery.of(context).size.height * 0.24,
                    alignment: Alignment.center,
                    child: FlatButton(
                      onPressed: _upatScMain,
                      child: Text(
                        '${Control.atSc}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 120,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.all(0.0),
                    padding: const EdgeInsets.all(0.0),
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.white)),
                    width: MediaQuery.of(context).size.width * 0.25,
                    height: MediaQuery.of(context).size.height * 0.08,
                    child: FlatButton(
                      padding: EdgeInsets.all(0),
                      child: Text('${firstSign()}${Dashboard.setFirstSc}',
                          style: TextStyle(color: Colors.white, fontSize: 30)),
                      onPressed: _upatScFirst,
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.25,
                    height: MediaQuery.of(context).size.height * 0.08,
                    margin: const EdgeInsets.all(0.0),
                    padding: const EdgeInsets.all(0.0),
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.white)),
                    child: FlatButton(
                      padding: EdgeInsets.all(0),
                      child: Text('${secSign()}${Dashboard.setSecondSc}',
                          style: TextStyle(color: Colors.white, fontSize: 30)),
                      onPressed: _upatScSecond,
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.25,
                    height: MediaQuery.of(context).size.height * 0.08,
                    margin: const EdgeInsets.all(0.0),
                    padding: const EdgeInsets.all(0.0),
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.white)),
                    child: FlatButton(
                      padding: EdgeInsets.all(0),
                      child: Text('${thirdSign()}${Dashboard.setThirdSc}',
                          style: TextStyle(color: Colors.white, fontSize: 30)),
                      onPressed: _upatScThird,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ]),
      )),
    );
  }


  Material rotateAwayTeamBoard() {
    return Material(
      color: Colors.black,
      child: Container(
          child: Padding(
            padding: const EdgeInsets.all(8.0), // 모르겠음
            child: Column(mainAxisAlignment: MainAxisAlignment.start, children: <
                Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.all(0.0),
                    padding: const EdgeInsets.all(0.0),
                    decoration: BoxDecoration(
                        color: Control.atColor,
                        border: Border.all(color: Colors.white)),
                    width: MediaQuery.of(context).size.width * 0.20, //0.35
                    height: MediaQuery.of(context).size.height * 0.08,
                    alignment: Alignment.center,
                    child: InkWell(
                      onTap: () => _atColorchange(),
                      child: Text(
                        "team color",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(0.0),
                    padding: const EdgeInsets.all(0.0),
                    decoration:
                    BoxDecoration(border: Border.all(color: Colors.white)),
                    width: MediaQuery.of(context).size.width * 0.27, //0.55
                    height: MediaQuery.of(context).size.height * 0.08,
                    alignment: Alignment.center,
                    child: InkWell(
                      onTap: changAtName,
                      child: Text(
                        '${Control.atName}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.all(0.0),
                        padding: const EdgeInsets.all(0.0),
                        decoration:
                        BoxDecoration(border: Border.all(color: Colors.white)),
                        width: MediaQuery.of(context).size.width * 0.10, //.20
                        height: MediaQuery.of(context).size.height * 0.42,
                        alignment: Alignment.center,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            FlatButton(
                              onPressed: _upatSet,
                              child: Icon(
                                Icons.arrow_drop_up,
                                size: 30,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              "Set",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                              ),
                            ),
                            Text(
                              '${Control.atSet}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 30.0,
                              ),
                            ),
                            FlatButton(
                              onPressed: _downatSet,
                              child: Icon(
                                Icons.arrow_drop_down,
                                size: 30,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.all(0.0),
                        padding: const EdgeInsets.all(0.0),
                        decoration:
                        BoxDecoration(border: Border.all(color: Colors.white)),
                        width: MediaQuery.of(context).size.width * 0.25, //0.45
                        height: MediaQuery.of(context).size.height * 0.42,
                        alignment: Alignment.center,
                        child: FlatButton(
                          onPressed: _upatScMain,
                          child: Text(
                            '${Control.atSc}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 120,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.all(0.0),
                        padding: const EdgeInsets.all(0.0),
                        decoration:
                        BoxDecoration(border: Border.all(color: Colors.white)),
                        width: MediaQuery.of(context).size.width * 0.12, //0.25
                        height: MediaQuery.of(context).size.height * 0.14,
                        child: FlatButton(
                          padding: EdgeInsets.all(0),
                          child: Text('${firstSign()}${Dashboard.setFirstSc}',
                              style: TextStyle(color: Colors.white, fontSize: 30)),
                          onPressed: _upatScFirst,
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.12, //0.25
                        height: MediaQuery.of(context).size.height * 0.14,
                        margin: const EdgeInsets.all(0.0),
                        padding: const EdgeInsets.all(0.0),
                        decoration:
                        BoxDecoration(border: Border.all(color: Colors.white)),
                        child: FlatButton(
                          padding: EdgeInsets.all(0),
                          child: Text('${secSign()}${Dashboard.setSecondSc}',
                              style: TextStyle(color: Colors.white, fontSize: 30)),
                          onPressed: _upatScSecond,
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.12, //0.25
                        height: MediaQuery.of(context).size.height * 0.14,
                        margin: const EdgeInsets.all(0.0),
                        padding: const EdgeInsets.all(0.0),
                        decoration:
                        BoxDecoration(border: Border.all(color: Colors.white)),
                        child: FlatButton(
                          padding: EdgeInsets.all(0),
                          child: Text('${thirdSign()}${Dashboard.setThirdSc}',
                              style: TextStyle(color: Colors.white, fontSize: 30)),
                          onPressed: _upatScThird,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ]),
          )),
    );
  }


  Material soundBoard() {
    return Material(
        color: Colors.black,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width * 0.18,
              height: MediaQuery.of(context).size.height * 0.07,
              margin: const EdgeInsets.all(0.0),
              padding: const EdgeInsets.all(0.0),
              child: FlatButton(
                onPressed: () => faulPlay(),
                child: Icon(
                  Icons.volume_up,
                  size: 20,
                  color: Colors.white,
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.18,
              height: MediaQuery.of(context).size.height * 0.07,
              margin: const EdgeInsets.all(0.0),
              padding: const EdgeInsets.all(0.0),
              child: FlatButton(
                onPressed: _speakTime,
                child: AutoSizeText('Time',
                    maxLines: 1,
                    style: TextStyle(color: Colors.white, fontSize: 20)),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.18,
              height: MediaQuery.of(context).size.height * 0.07,
              margin: const EdgeInsets.all(0.0),
              padding: const EdgeInsets.all(0.0),
              child: FlatButton(
                onPressed: _speakScore,
                child: AutoSizeText('Score',
                    maxLines: 1,
                    style: TextStyle(color: Colors.white, fontSize: 20)),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.18,
              height: MediaQuery.of(context).size.height * 0.07,
              margin: const EdgeInsets.all(0.0),
              padding: const EdgeInsets.all(0.0),
              child: FlatButton(
                onPressed: () => startPlay(),
                child: AutoSizeText('Start',
                    maxLines: 1,
                    style: TextStyle(color: Colors.white, fontSize: 20)),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.18,
              height: MediaQuery.of(context).size.height * 0.07,
              margin: const EdgeInsets.all(0.0),
              padding: const EdgeInsets.all(0.0),
              child: FlatButton(
                onPressed: () => endPlay(),
                child: AutoSizeText('End',
                    maxLines: 1,
                    style: TextStyle(color: Colors.white, fontSize: 20)),
              ),
            ),
          ],
        ));
  }


  @override


  Widget build(BuildContext context) {
    Orientation orientation = MediaQuery.of(context).orientation;
    if (orientation == Orientation.portrait) {
      return Scaffold(
          appBar: AppBar(
              title: Center(
                child: Text('We play sports'),
              ),
             ),
        body: SingleChildScrollView(
          //padding: EdgeInsets.symmetric(horizontal: 2.0, vertical: 2.0),
          child: Column(
            children: <Widget>[
              Timeboard(formatMMSS(Control.time)),
              if (show == true) homeTeamBoard() else awayTeamBoard(),
              setBoard(),
              if (show == true) awayTeamBoard() else homeTeamBoard(),
              soundBoard(),
              Container(
                height: 200,
                color: Colors.black,
              ),
            ],
          ),
        ),
      );
    } else {
      return Scaffold(
        body: SingleChildScrollView(
          //padding: EdgeInsets.symmetric(horizontal: 2.0, vertical: 2.0),
          child: Column(
            children: <Widget>[
              // 로테이트 모드 빈칸 여
              Container(
                height: MediaQuery.of(context).size.height * 0.07,
                color: Colors.black,
              ),
             rotateTimeboard(formatMMSS(Control.time)),
              if (show == true)
                Container(
                  color: Colors.black,
                  child: Row(
                    children: <Widget>[
                      rotateHomeTeamBoard(),
                      rotateAwayTeamBoard(),
                    ],
                  ),
                )
              else
                Container(
                  color: Colors.black,
                  child: Row(
                    children: <Widget>[
                      rotateAwayTeamBoard(),
                      rotateHomeTeamBoard(),
                    ],
                  ),
                ),
              //setBoard(),
              //if (show == true) awayTeamBoard()
              //else homeTeamBoard(),
                Container(
                height: MediaQuery.of(context).size.height * 0.01,
                color: Colors.black,
                ),
              soundBoard(),
              Container( //for banner
                height: 200,
                color: Colors.black,
              ),
            ],
          ),
        ),
      );
    }
  }
}
