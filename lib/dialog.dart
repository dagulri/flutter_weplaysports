import 'package:flutter/material.dart';
import 'package:flutterappweplaysports/dashboard.dart';
import 'package:numberpicker/numberpicker.dart';
import 'model.dart';


class MyDialog extends StatefulWidget {


  @override
  _MyDialogState createState() => new _MyDialogState();
}

class _MyDialogState extends State<MyDialog> {


  // 점수 증가 +,- 기호
  String mainSign(){
    if (Dashboard.setMainSc > 0) {
      return ('+');
    } else if (Dashboard.setMainSc < 0)
      return ('');
  }

  String firstSign(){
    if (Dashboard.setFirstSc > 0) {
      return ('+');
    } else if (Dashboard.setFirstSc < 0)
      return ('');
  }
  String secSign(){
    if (Dashboard.setSecondSc > 0) {
      return ('+');
    } else if (Dashboard.setSecondSc < 0)
      return ('');
  }
  String thirdSign(){
    if (Dashboard.setThirdSc > 0) {
      return ('+');
    } else if (Dashboard.setThirdSc < 0)
      return ('');
  }


  // 점수 증가를 위한 넘버 셀렉트

  Future _mainShowIntDialog() async {
    await showDialog<int>(
      context: context,
      builder: (BuildContext context, ) {
        return new NumberPickerDialog.integer(
          minValue: -10,
          maxValue: 10,
          step: 1,
          initialIntegerValue: Dashboard.setMainSc,
        );
      },
    ).then((num value) {
      if (value != null) {
        setState(() => Dashboard.setMainSc = value);
        setState(() {
        });
      }
    });
  }

  Future _fisrtShowIntDialog() async {
    await showDialog<int>(
      context: context,
      builder: (BuildContext context, ) {
        return new NumberPickerDialog.integer(
          minValue: -10,
          maxValue: 10,
          step: 1,
          initialIntegerValue: Dashboard.setFirstSc,
        );
      },
    ).then((num value) {
      if (value != null) {
        setState(() => Dashboard.setFirstSc = value);
        setState(() {
        });
      }
    });
  }

  Future _secShowIntDialog() async {
    await showDialog<int>(
      context: context,
      builder: (BuildContext context, ) {
        return new NumberPickerDialog.integer(
          minValue: -10,
          maxValue: 10,
          step: 1,
          initialIntegerValue: Dashboard.setSecondSc,
        );
      },
    ).then((num value) {
      if (value != null) {
        setState(() => Dashboard.setSecondSc = value);
        setState(() {
        });
      }
    });
  }

  Future _thirdShowIntDialog() async {
    await showDialog<int>(
      context: context,
      builder: (BuildContext context, ) {
        return new NumberPickerDialog.integer(
          minValue: -10,
          maxValue: 10,
          step: 1,
          initialIntegerValue: Dashboard.setThirdSc,
        );
      },
    ).then((num value) {
      if (value != null) {
        setState(() => Dashboard.setThirdSc = value);
        setState(() {
        });
      }
    });
  }


  final _valueList = ['en-US','ko-KR'];


  @override
  void dispose() {
    super.dispose();
    //Control.flutterTts.stop(); 혹시 있어야 할 수도 있음
  }



  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actions: <Widget>[
        new Container(
          padding : EdgeInsets.all(18),
          child: Center(
            child: Text (
              "Control Setting",
              style: TextStyle(fontSize: 20),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                    margin: const EdgeInsets.all(0.0),
                    padding: const EdgeInsets.all(0.0),
                    decoration: BoxDecoration(
                    color: Colors.black,
                    border: Border.all(color: Colors.white)),
                    width: MediaQuery.of(context).size.width * 0.35,
                    height: MediaQuery.of(context).size.height * 0.27,
                      child: new FlatButton(
                          onPressed:(){
                            setState((){
                              _mainShowIntDialog();
                             }
                            );
                          },
                          child: Text('${mainSign()}${Dashboard.setMainSc}',
                              style: TextStyle(color: Colors.white, fontSize: 40)),
                  ),
                ),
                //child: integerNumberPicker,
              ],
            ),

            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.all(0.0),
                  padding: const EdgeInsets.all(0.0),
                  decoration: BoxDecoration(
                      color: Colors.black,
                      border: Border.all(color: Colors.white)),
                  width: MediaQuery.of(context).size.width * 0.25,
                  height: MediaQuery.of(context).size.height * 0.09,

                  child:
                  FlatButton(
                    padding: EdgeInsets.all(0),
                    child: Text('${firstSign()}${Dashboard.setFirstSc}',
                        style: TextStyle(color: Colors.white, fontSize: 25)
                    ),
                    onPressed:(){setState((){_fisrtShowIntDialog();
                    });},
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.25,
                  height: MediaQuery.of(context).size.height * 0.09,
                  margin: const EdgeInsets.all(0.0),
                  padding: const EdgeInsets.all(0.0),
                  decoration: BoxDecoration(
                      color: Colors.black,
                      border: Border.all(color: Colors.white)),

                  child:
                  FlatButton(
                    padding: EdgeInsets.all(0),
                    child: Text('${secSign()}${Dashboard.setSecondSc}',
                        style: TextStyle(color: Colors.white, fontSize: 25)
                    ),
                    onPressed:(){setState((){_secShowIntDialog();
                    //print('value');
                    });},
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.25,
                  height: MediaQuery.of(context).size.height * 0.09,
                  margin: const EdgeInsets.all(0.0),
                  padding: const EdgeInsets.all(0.0),
                  decoration: BoxDecoration(
                      color: Colors.black,
                      border: Border.all(color: Colors.white)),

                  child:
                  FlatButton(
                    padding: EdgeInsets.all(0),
                    child: Text('${thirdSign()}${Dashboard.setThirdSc}',
                        style: TextStyle(color: Colors.white, fontSize: 25)
                    ),
                    onPressed:(){setState((){_thirdShowIntDialog();
                    //print('value');
                    });},
                  ),
                ),
              ],

            ),
          ],
        ),



        Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("Language"),
                SizedBox(
                  width: 10,
                ),
                DropdownButton(
                  value: Control.selectedValue,
                  items: _valueList.map(
                    (value){
                      return DropdownMenuItem(
                          value: value,
                          child: Text(value),
                      );
                    },
                   ).toList(),
                  onChanged: (value) {
                      setState(() {
                          Control.selectedValue = value;
                          //print (Control.selectedValue);
                        });
                      },
                ),
              ],
            ),

               Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                        new FlatButton(
                         child: new Text("Cancel"),
                         onPressed: () {
                            setState(() {
                            Navigator.pop(context);
                          });
                          },
                        ),
                        new FlatButton(
                        child: new Text("Reset"),
                            onPressed: (){
                              setState((){reSetSc();
                              //setState(() { });
                              });
                            },
                        ),
                        new FlatButton(
                        child: new Text("Save"),
                            onPressed: (){
                            setState((){Navigator.pop(context);
                            //setState(() { });
                            });
                      },
                ),
              ],
            ),
          ],
        )
      ],
    );
  }
}



void reSetSc() {
  Dashboard.setMainSc = 1;
  Dashboard.setFirstSc = 3;
  Dashboard.setSecondSc = 2;
  Dashboard.setThirdSc = -1;
  Control.selectedValue = 'en-US';
}



class reMatchDialog extends StatelessWidget {

  void _initial(){
      Control.time = 600; // 변수 , 초기값
      Control.isRunning = false; // 현재 시작
      //_timer?.cancel();
      Control.htColor = Colors.red;
      Control.atColor = Colors.blue;
      Control.htName = "team name";
      Control.atName = "team name";
      Control.htSet = 0;
      Control.atSet = 0;
      //Dashboard.setMainSc = 1;
      //Dashboard.setFirstSc = 3;
      //Dashboard.setSecondSc = 2;
      //Dashboard.setThirdSc = -1;
      Control.htSc = 0;
      Control.atSc = 0;
      Control.show = true;
  }




  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(child: Text (
        "Re Match?",
        style: TextStyle(fontSize: 20),
      ),

      ),
      actions: <Widget>[
          Row(
            //mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              new FlatButton(
                child: new Text("Cancel"),
                onPressed: () {
                   Navigator.pop(context);
                },
              ),
              new FlatButton(
                child: new Text("Ok"),
                onPressed: (){
                  _initial();
                  Navigator.pop(context);
                },
              ),
            ],
          ),

            ],
          );
    }
  }
