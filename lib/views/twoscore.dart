import 'dart:async';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:provider/provider.dart';
import 'package:test/common/helper.dart';
import 'package:test/main.dart';
import 'package:test/provider/setting_provider.dart';
import 'package:test/views/widget/CheckboxButton.dart';

class TwoScoreScreen extends StatefulWidget {
  const TwoScoreScreen({Key? key}) : super(key: key);

  @override
  _TwoScoreScreenState createState() => _TwoScoreScreenState();
}

class _TwoScoreScreenState extends State<TwoScoreScreen> {
  late int _point=0;
  TextEditingController player1=new TextEditingController(text: 'Player 1');
  TextEditingController player2=new TextEditingController(text: 'Player 2');
  List<int> mark=[0,0];
  List<List<int>> result=[];
  List<int> finalResult=[0,0];
  bool isServeLeft=true,lastServeLeft=true, isEnd=false,isStart=false;
  late int bestOfNumber;
  late Timer _timer;
  int currentRound=0;
  late DateTime? _dateTime;
  bool isfirst=true,allDisable=false;
  @override
  void initState() {
    super.initState();
    setState(() {
      result.add([]);
      result.add([]);
    });
    _dateTime = DateTime.now();
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      _dateTime = _dateTime?.add(const Duration(seconds: 1));
      if (mounted) {
        setState(() {});
      }
    });
  }
  void checkCurrentRound(bool winnerByTwo){
    if(mark.any((element) => element>=_point)){
      if(winnerByTwo){
        if((mark[0]-mark[1]).abs()>=2){
          setState(() {
            isEnd=true;
          });
          // setState(() {
          //   if(mark[0]>mark[1]){
          //     finalResult[0]++;
          //   }else{
          //     finalResult[1]++;
          //   }
          //   result[0].add(mark[0]);
          //   result[1].add(mark[1]);
          //   currentRound++;
          //   mark=[0,0];
          //   if(finalResult.any((element) => element>=bestOfNumber)){
          //      isEnd=true;
          //      showVictoryDialog(finalResult[0]>=bestOfNumber?player1.text:player2.text);
          //   }
          // });
        }else{
          setState(() {
            isEnd=false;
          });
        }
      }else{
        setState(() {
          isEnd=true;
        });
      }
    }
  }
  void increase(int index, bool winnerServe, bool winnerByTwo){
    setState(() {
      lastServeLeft=isServeLeft;
      if(winnerServe){
        if(index==0){
          isServeLeft=true;
        }
        else{
          isServeLeft=false;
        }
      }
      else{
        if(index==0){
          isServeLeft=false;
        }
        else{
          isServeLeft=true;
        }
      }
      mark[index]++;
      checkCurrentRound(winnerByTwo);
    });
  }
  void decrease(int index, bool winnerServe, bool winnerByTwo){
    setState(() {
      isServeLeft=lastServeLeft;
      if(mark[index]!=0)
      {
        mark[index]--;
      }

    });
    checkCurrentRound(winnerByTwo);
  }

  getCurrentDate(DateTime? datetime) {
    var date =
        datetime != null ? datetime.toString() : DateTime.now().toString();
    var dateParse = DateTime.parse(date);
    var formattedDate =
        "${dateParse.hour}:${dateParse.minute}:${dateParse.second}";
    return formattedDate.toString();
  } 
  @override
  Widget build(BuildContext context) {
    SettingProvider settingProvider =
        Provider.of<SettingProvider>(context, listen: true);
    if(isfirst){
      setState(() {
        bestOfNumber=settingProvider.bestOfNumber;
        isfirst=false;
        _point=settingProvider.points;
      });
    }
    
    return Scaffold(
      resizeToAvoidBottomInset : false,
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: Container(),
          title: const Text("Scoreboard"),
          centerTitle: true,
        ),
        bottomNavigationBar: Container(
          height: 100,
          width: double.infinity,
          padding: const EdgeInsets.only(bottom: 50,right: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                style: TextButton.styleFrom(
                    textStyle: const TextStyle(
                        color: Color.fromARGB(255, 110, 198, 210),
                        fontSize: 20)),
                child: const Text('Home'),
                onPressed: () {
                  Navigator.pop(context);     
                },
              ),
              TextButton(
                style: TextButton.styleFrom(
                    textStyle: const TextStyle(
                        color: Color.fromARGB(255, 110, 198, 210),
                        fontSize: 20)),
                child: const Text('Reset'),
                onPressed: () {
                  setState(() {
                      allDisable=false;
                      isEnd=false;
                      isStart=false;
                      mark=[0,0];
                      result[0]=[];
                      result[1]=[];
                      finalResult=[0,0];
                      isServeLeft=true;
                      bestOfNumber=settingProvider.bestOfNumber;
                      currentRound=0;
                  });
                },
              ),
              TextButton(
                style: TextButton.styleFrom(
                    textStyle: const TextStyle(
                        color: Color.fromARGB(255, 110, 198, 210),
                        fontSize: 20)),
                child: Text('End Game', style:isEnd ?const TextStyle(): const TextStyle(
                        color:Colors.grey)),
                onPressed: () {
                  if(isEnd){
                    setState(() {
                      if(mark[0]>mark[1]){
                          finalResult[0]++;
                      }else{
                        finalResult[1]++;
                      }
                      // isStart=false;
                      result[0].add(mark[0]);
                      result[1].add(mark[1]);
                      currentRound++;
                      mark=[0,0];
                      allDisable=true;
                      if(finalResult.any((element) => element==(bestOfNumber-2).abs())){
                        showVictoryDialog(finalResult[0]==bestOfNumber?player1.text:player2.text);
                      }
                    });
                  }
                },
              ),
            ],
          )
        ),
        body: SingleChildScrollView(
          child: InkWell(
            onTap: (){
              FocusScope.of(context).requestFocus(new FocusNode());
            },
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(children: [
                const SizedBox(
                  height: 20,
                ),
                Align(
                    alignment: Alignment.center,
                    child: Text(
                      getCurrentDate(_dateTime),
                      style: const TextStyle(color: Colors.blue, fontSize: 30),
                    )),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  width: double.infinity,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.red.shade400, width: 3),
                      borderRadius: BorderRadius.circular(3.0),
                      color: const Color(0xFF9AEAFF)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Match Title:', style: TextStyle(fontSize: 15,fontWeight: FontWeight.w700, height: 0.7),),
                          const SizedBox(width: 15,),
                          Text(settingProvider.title, style: const TextStyle(fontSize: 20,fontWeight: FontWeight.w700, height: 0.7,color: Colors.red),),
                        ],
                      ),
                      const SizedBox(height: 20,),
                      Text("Best of: ${settingProvider.bestOfNumber}", style: TextStyle(fontSize: 15,fontWeight: FontWeight.w700, height: 0.7),),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  width: double.infinity,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.blue.shade900, width: 5),
                      borderRadius: BorderRadius.circular(3.0),
                      color: const Color(0xFF84F184)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.3,
                            child: TextField(
                              readOnly: allDisable?true:false,
                              controller: player1,
                              style: TextStyle(fontSize: 20,),
                              textAlign: TextAlign.center,
                              onChanged: (value) {
                                setState(() {
                                });
                              },
                              maxLength: 30,
                              maxLines: 1,
                              decoration: const InputDecoration(
                                fillColor: Colors.white,
                                isDense: true,
                                counter: Offstage(),
                                border: OutlineInputBorder(),  
                                hintStyle: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 25),
                                    contentPadding:EdgeInsets.only(left: 10, top: 5, bottom: 5),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20,),
                          Text(mark[0].toString(), style: const TextStyle(fontSize: 25,fontWeight: FontWeight.w700, height: 0.7,color: Colors.red),),
                          const SizedBox(height: 20,),
                          SizedBox(
                            width: 60,
                            height: 60,
                            child: Stack(
                              children: [
                                InkWell(
                                  onTap: (){
                                    if(allDisable){
                                      return;
                                    }
                                    if(!isStart){
                                      setState(() {
                                      isServeLeft=true;
                                    });
                                    }
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.all(5),
                                    width: 50,
                                    height: 50,
                                  ),
                                ),
                               !isServeLeft?Container(): Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey, width: 2),
                                      borderRadius: BorderRadius.circular(60),
                                      color: const Color(0xFF2f2f2f)),
                                  child: const Align(
                                    alignment: Alignment.center,
                                    child: Text(')', style: TextStyle(fontSize: 30,fontWeight: FontWeight.w700, height: 1,color: Colors.white),)),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20,),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: (){
                                    if(allDisable){
                                      return;
                                    }
                                    isStart=true;
                                    increase(0,settingProvider.winnerServe, settingProvider.winnerByTwo);
                                },
                                child: Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey, width: 2),
                                      borderRadius: BorderRadius.circular(60),
                                      color: const Color(0xFF05AF8F)),
                                  child: const Align(
                                    alignment: Alignment.center,
                                    child: Text('+', style: TextStyle(fontSize: 30,fontWeight: FontWeight.w700, height: 1,color: Colors.white),)),
                                ),
                              ),
                              const SizedBox(width: 10,),
                              InkWell(
                                onTap: (){
                                    if(allDisable){
                                      return;
                                    }
                                    decrease(0,settingProvider.winnerServe,settingProvider.winnerByTwo);
                                },
                                child: Container(
                                  width: 50,
                                  height: 50,
                                  margin: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey, width: 2),
                                      borderRadius: BorderRadius.circular(60),
                                      color: const Color(0xFFFC4242)),
                                  child: const Align(
                                    alignment: Alignment.center,
                                    child: Text('-', style: TextStyle(fontSize: 30,fontWeight: FontWeight.w700, height: 1,color: Colors.white),)),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                      Container(
                        width: 2,
                        height: 250,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(3.0),
                            color: Colors.grey),
                      ),
                      Column(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.3,
                            child: TextField(
                              readOnly: allDisable?true:false,
                              controller: player2,
                              style: TextStyle(fontSize: 20,),
                              textAlign: TextAlign.center,
                              onChanged: (value) {
                                setState(() {
                                });
                              },
                              maxLength: 30,
                              maxLines: 1,
                              decoration: const InputDecoration(
                                fillColor: Colors.white,
                                isDense: true,
                                counter: Offstage(),
                                border: OutlineInputBorder(),  
                                hintStyle: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 25),
                                    contentPadding:EdgeInsets.only(left: 10, top: 5, bottom: 5),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20,),
                          Text(mark[1].toString(), style: const TextStyle(fontSize: 25,fontWeight: FontWeight.w700, height: 0.7,color: Colors.red),),
                          const SizedBox(height: 20,),
                          Container(
                            width: 60,
                            height: 60,
                            child: Stack(
                              children: [
                                InkWell(
                                  onTap: (){
                                    if(allDisable){
                                      return;
                                    }
                                    if(!isStart){
                                      setState(() {
                                      isServeLeft=false;
                                    });
                                    }
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.all(5),
                                    width: 50,
                                    height: 50,
                                    // decoration: BoxDecoration(
                                    //     border: Border.all(color: Colors.grey, width: 2),
                                    //     borderRadius: BorderRadius.circular(3.0),
                                    //     color: const Color(0xFFFFFFFF)),
                                  ),
                                ),
                                isServeLeft?Container():Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey, width: 2),
                                      borderRadius: BorderRadius.circular(60),
                                      color: const Color(0xFF2f2f2f)),
                                  child: const Align(
                                    alignment: Alignment.center,
                                    child: Text('(', style: TextStyle(fontSize: 30,fontWeight: FontWeight.w700, height: 1,color: Colors.white),)),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20,),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: (){
                                    if(allDisable){
                                      return;
                                    }
                                    decrease(1,settingProvider.winnerServe,settingProvider.winnerByTwo);
                                },
                                child: Container(
                                  width: 50,
                                  height: 50,
                                  margin: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey, width: 2),
                                      borderRadius: BorderRadius.circular(60),
                                      color: const Color(0xFFFC4242)),
                                  child: const Align(
                                    alignment: Alignment.center,
                                    child: Text('-', style: TextStyle(fontSize: 30,fontWeight: FontWeight.w700, height: 1,color: Colors.white),)),
                                ),
                              ),
                              const SizedBox(width: 10,),
                              InkWell(
                                onTap: (){
                                    if(allDisable){
                                      return;
                                    }
                                    isStart=true;
                                    increase(1,settingProvider.winnerServe,settingProvider.winnerByTwo);
                                },
                                child: Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey, width: 2),
                                      borderRadius: BorderRadius.circular(60),
                                      color: const Color(0xFF05AF8F)),
                                  child: const Align(
                                    alignment: Alignment.center,
                                    child: Text('+', style: TextStyle(fontSize: 30,fontWeight: FontWeight.w700, height: 1,color: Colors.white),)),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  padding: const EdgeInsets.all(20),
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3.0),
                      color: const Color(0xFF84F184)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Text(player1.text, style: const TextStyle(fontSize: 15,fontWeight: FontWeight.w700, height: 0.7),),
                          const SizedBox(height: 50,),
                          Text(player2.text, style: const TextStyle(fontSize: 15,fontWeight: FontWeight.w700, height: 0.7),),
                        ],
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: Column(
                            children: [
                                SizedBox(
                                  height: 40.0,
                                  child: ListView.builder(
                                  itemCount: result[0].length,
                                  scrollDirection: Axis.horizontal,
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  primary: false,
                                  itemBuilder: (BuildContext context, int index){
                                      return Container(
                                        margin: const EdgeInsets.only(right: 5),
                                        width: 30,
                                        height: 35,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(3.0),
                                            border: Border.all(color: const Color(0xFFFC4242))),
                                        child: Align(
                                          alignment: Alignment.center,
                                          child: Text(result[0][index].toString(), style: const TextStyle(fontSize: 20,fontWeight: FontWeight.w700, height: 1, color: Colors.black),)));
                                  }),
                                ),
                                const SizedBox(height: 25,),
                                SizedBox(
                                  height: 40.0,
                                  child: ListView.builder(
                                  itemCount: result[1].length,
                                  scrollDirection: Axis.horizontal,
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  primary: false,
                                  itemBuilder: (BuildContext context, int index){
                                      return Container(
                                        margin: const EdgeInsets.only(right: 5),
                                        width: 30,
                                        height: 35,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(3.0),
                                            border: Border.all(color: const Color(0xFFFC4242))),
                                        child: Align(
                                          alignment: Alignment.center,
                                          child: Text(result[1][index].toString(), style: TextStyle(fontSize: 20,fontWeight: FontWeight.w700, height: 1, color: Colors.black),)));
                                  }),
                                ),
                            ],
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(right: 10),
                            width: 30,
                            height: 35,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(3.0),
                                border: Border.all(color: const Color(0xFF611789))),
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(finalResult[0].toString(), style: TextStyle(fontSize: 20,fontWeight: FontWeight.w700, height: 1, color: Colors.black),))),
                          const SizedBox(height: 30,),
                          Container(
                            margin: const EdgeInsets.only(right: 10),
                            width: 30,
                            height: 35,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(3.0),
                                border: Border.all(color: const Color(0xFF611789))),
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(finalResult[1].toString(), style: TextStyle(fontSize: 20,fontWeight: FontWeight.w700, height: 1, color: Colors.black),)))
                        ],
                      ),
                    ],
                  )
                ),
              ]),
            ),
          ),
        ));
  }
  showVictoryDialog(String playerName) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Align(
          alignment: Alignment.center,
          child: Text("Victory")),
          contentPadding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.3,),
          content: Text(playerName,style: TextStyle(fontSize: 20, color: Colors.red),),  
          buttonPadding: EdgeInsets.all(0),
          actions: <Widget>[
            Column(
              children: [
                Container(
                  width: double.infinity,
                  height: 1,
                  color: Colors.white,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      child: const Text('ok'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ],
            )
          ],
        );
      },
    );
  }
}
