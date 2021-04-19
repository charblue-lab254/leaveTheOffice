import 'dart:async';

import 'package:leavetheoffice/data/att_data_format.dart';
import 'package:leavetheoffice/data/attendance.dart';
import 'package:leavetheoffice/provider.dart';

class Staff_info {
  // 기본 정보
  int id;
  String name;
  String roll;

  // DB
  static const String memTableName = "members";  //table name
  static const String columnId = "id";           //primary key
  static const String columnName = "name";
  static const String columnRole = "role";
  DateTime _workStartTime, _workEndTime;

  // 시간 계산
  Attendance _att;
  int startTimeSec;
  Timer timer;
  bool isWorking;

  Staff_info(String name, String role, {int id}) {
    this.name = name;
    this.roll = role;
    this.id = id;
    this.isWorking = false;   // 출근시간이 NOT NULL이고 퇴근시간이 NULL
                              // (_workStartTime != null && _workEndTime == null)일 때 TRUE
  }

  void switchIsWorking(){
    this.isWorking = !this.isWorking;
  }

  // DB
  void setStartTime(DateTime now){
    _att = new Attendance(id, Date(now.year, now.month, now.day), Time(now.hour, now.minute, now.second));
    isWorking = true;
    startTimeSec = now.hour * 360 + now.minute * 60 + now.second;
    getDataManager().addAttData(_att);
  }

  void setEndTime(DateTime now){
    _att.end = Time(now.hour, now.minute, now.second);
    isWorking = false;
    getDataManager().updateAttData(_att, id, _att.date);
  }

  // Timer
  void startTimer(Timer timer){
    this.timer = timer;
  }

  void endTimer(){
    this.timer?.cancel();
  }
}
