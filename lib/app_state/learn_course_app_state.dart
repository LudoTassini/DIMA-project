import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/courses/bloqo_chapter_data.dart';
import '../model/courses/bloqo_course_data.dart';
import '../model/courses/bloqo_section_data.dart';

class LearnCourseAppState with ChangeNotifier{

  BloqoCourseData? _course;
  List<BloqoChapterData>? _chapters;
  Map<String, List<BloqoSectionData>>? _sections;
  Timestamp? _enrollmentDate;
  List<dynamic>? _sectionsCompleted;
  int? _totNumSections;
  List<dynamic>? _chaptersCompleted;
  bool _fromHome = false;

  BloqoCourseData? _getCourse() {
    return _course;
  }

  BloqoChapterData? _getChapterFromId(String chapterId){
    return _chapters?.where((chapter) => chapter.id == chapterId).first;
  }

  List<BloqoChapterData>? _getChapters(){
    return _chapters;
  }

  Map<String, List<BloqoSectionData>>? _getSections(){
    return _sections;
  }

  List<BloqoSectionData>? _getSectionsFromChapter(String chapterId){
    return _sections?[chapterId];
  }

  Timestamp? _getEnrollmentDate(){
    return _enrollmentDate;
  }

  List<dynamic>? _getSectionsCompleted(){
    return _sectionsCompleted;
  }

  List<dynamic>? _getChaptersCompleted(){
    return _chaptersCompleted;
  }

  int? _getTotNumSections(){
    return _totNumSections;
  }

  void _setSectionsCompleted(List<dynamic> sectionsCompleted){
    sectionsCompleted = _checkDuplicates(sectionsCompleted)!;
    _sectionsCompleted = sectionsCompleted;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  void _setChaptersCompleted(List<dynamic> chaptersCompleted){
    chaptersCompleted = _checkDuplicates(chaptersCompleted)!;
    _chaptersCompleted = chaptersCompleted;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  void _set(BloqoCourseData? course, List<BloqoChapterData>? chapters, Map<String, List<BloqoSectionData>>? sections, Timestamp? enrollmentDate,
      List<dynamic>? sectionsCompleted, List<dynamic>? chaptersCompleted, int? totNumSections){
    _course = course;
    _chapters = chapters;
    _sections = sections;
    _enrollmentDate = enrollmentDate;
    _sectionsCompleted = sectionsCompleted;
    _chaptersCompleted = chaptersCompleted;
    _totNumSections = totNumSections;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  bool _getComingFromHomePrivilege(){
    return _fromHome;
  }

  void _updateComingFromHomePrivilege(bool newValue){
    _fromHome = newValue;
  }

  //FIXME: sparire
  List<dynamic>? _checkDuplicates(List<dynamic>? list) {
    if (list == null) {
      return null;
    }
    List<dynamic> uniqueList = list.toSet().toList();
    return uniqueList;
  }

}

BloqoCourseData? getLearnCourseFromAppState({required BuildContext context}){
  return Provider.of<LearnCourseAppState>(context, listen: false)._getCourse();
}

BloqoChapterData? getLearnCourseChapterFromAppState({required BuildContext context, required String chapterId}){
  return Provider.of<LearnCourseAppState>(context, listen: false)._getChapterFromId(chapterId);
}

List<BloqoChapterData>? getLearnCourseChaptersFromAppState({required BuildContext context}){
  return Provider.of<LearnCourseAppState>(context, listen: false)._getChapters();
}

List<BloqoSectionData>? getLearnCourseChapterSectionsFromAppState({required BuildContext context, required String chapterId}){
  return Provider.of<LearnCourseAppState>(context, listen: false)._getSectionsFromChapter(chapterId);
}

Map<String, List<BloqoSectionData>>? getLearnCourseSectionsFromAppState({required BuildContext context}){
  return Provider.of<LearnCourseAppState>(context, listen: false)._getSections();
}

Timestamp? getLearnCourseEnrollmentDateFromAppState({required BuildContext context}){
  return Provider.of<LearnCourseAppState>(context, listen: false)._getEnrollmentDate();
}

List<dynamic>? getLearnCourseSectionsCompletedFromAppState({required BuildContext context}){
  return Provider.of<LearnCourseAppState>(context, listen: false)._getSectionsCompleted();
}

List<dynamic>? getLearnCourseChaptersCompletedFromAppState({required BuildContext context}){
  return Provider.of<LearnCourseAppState>(context, listen: false)._getChaptersCompleted();
}

int? getLearnCourseTotNumSectionsFromAppState({required BuildContext context}){
  return Provider.of<LearnCourseAppState>(context, listen: false)._getTotNumSections();
}

void saveLearnCourseToAppState({required BuildContext context, required BloqoCourseData course, required List<BloqoChapterData> chapters,
  required Map<String, List<BloqoSectionData>> sections, required Timestamp enrollmentDate, required List<dynamic> sectionsCompleted,
  required int totNumSections, required List<dynamic> chaptersCompleted, bool comingFromHome = false}){

  Provider.of<LearnCourseAppState>(context, listen: false)._set(course, chapters, sections, enrollmentDate, sectionsCompleted,
      chaptersCompleted, totNumSections);
  if(comingFromHome) {
    Provider.of<LearnCourseAppState>(context, listen: false)._updateComingFromHomePrivilege(true);
  }
}

void updateLearnCourseSectionsCompletedFromAppState({required BuildContext context, required List<dynamic> sectionsCompleted}){
  Provider.of<LearnCourseAppState>(context, listen: false)._setSectionsCompleted(sectionsCompleted);
}

void updateLearnCourseChaptersCompletedFromAppState({required BuildContext context, required List<dynamic> chaptersCompleted}){
  Provider.of<LearnCourseAppState>(context, listen: false)._setChaptersCompleted(chaptersCompleted);
}

bool getComingFromHomeLearnPrivilegeFromAppState({required BuildContext context}){
  return Provider.of<LearnCourseAppState>(context, listen: false)._getComingFromHomePrivilege();
}

void setComingFromHomeLearnPrivilegeToAppState({required BuildContext context}){
  Provider.of<LearnCourseAppState>(context, listen: false)._updateComingFromHomePrivilege(true);
}

void useComingFromHomeLearnPrivilegeFromAppState({required BuildContext context}){
  Provider.of<LearnCourseAppState>(context, listen: false)._updateComingFromHomePrivilege(false);
}