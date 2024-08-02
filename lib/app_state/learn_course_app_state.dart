import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/courses/bloqo_chapter.dart';
import '../model/courses/bloqo_course.dart';
import '../model/courses/bloqo_section.dart';

class LearnCourseAppState with ChangeNotifier{

  BloqoCourse? _course;
  List<BloqoChapter>? _chapters;
  Map<String, List<BloqoSection>>? _sections;
  Timestamp? _enrollmentDate; //FIXME
  int? _numSectionsCompleted;
  int? _totNumSections;
  bool _fromHome = false;

  BloqoCourse? _getCourse() {
    return _course;
  }

  BloqoChapter? _getChapterFromId(String chapterId){
    return _chapters?.where((chapter) => chapter.id == chapterId).first;
  }

  List<BloqoChapter>? _getChapters(){
    return _chapters;
  }

  Map<String, List<BloqoSection>>? _getSections(){
    return _sections;
  }

  List<BloqoSection>? _getSectionsFromChapter(String chapterId){
    return _sections?[chapterId];
  }

  Timestamp? _getEnrollmentDate(){
    return _enrollmentDate;
  }

  int? _getNumSectionsCompleted(){
    return _numSectionsCompleted;
  }

  int? _getTotNumSections(){
    return _totNumSections;
  }

  void _set(BloqoCourse? course, List<BloqoChapter>? chapters, Map<String, List<BloqoSection>>? sections, Timestamp? enrollmentDate,
      int? numSectionsCompleted, int? totNumSections){
    _course = course;
    _chapters = chapters;
    _sections = sections;
    _enrollmentDate = enrollmentDate;
    _numSectionsCompleted = numSectionsCompleted;
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

}

BloqoCourse? getLearnCourseFromAppState({required BuildContext context}){
  return Provider.of<LearnCourseAppState>(context, listen: false)._getCourse();
}

BloqoChapter? getLearnCourseChapterFromAppState({required BuildContext context, required String chapterId}){
  return Provider.of<LearnCourseAppState>(context, listen: false)._getChapterFromId(chapterId);
}

List<BloqoChapter>? getLearnCourseChaptersFromAppState({required BuildContext context}){
  return Provider.of<LearnCourseAppState>(context, listen: false)._getChapters();
}

List<BloqoSection>? getLearnCourseChapterSectionsFromAppState({required BuildContext context, required String chapterId}){
  return Provider.of<LearnCourseAppState>(context, listen: false)._getSectionsFromChapter(chapterId);
}

Map<String, List<BloqoSection>>? getLearnCourseSectionsFromAppState({required BuildContext context}){
  return Provider.of<LearnCourseAppState>(context, listen: false)._getSections();
}

Timestamp? getLearnCourseEnrollmentDateFromAppState({required BuildContext context}){
  return Provider.of<LearnCourseAppState>(context, listen: false)._getEnrollmentDate();
}

int? getLearnCourseNumSectionsCompletedFromAppState({required BuildContext context}){
  return Provider.of<LearnCourseAppState>(context, listen: false)._getNumSectionsCompleted();
}

int? getLearnCourseTotNumSectionsFromAppState({required BuildContext context}){
  return Provider.of<LearnCourseAppState>(context, listen: false)._getTotNumSections();
}

void saveLearnCourseToAppState({required BuildContext context, required BloqoCourse course, required List<BloqoChapter> chapters,
  required Map<String, List<BloqoSection>> sections, required Timestamp enrollmentDate, required int numSectionsCompleted,
  required int totNumSections, bool comingFromHome = false}){
  Provider.of<LearnCourseAppState>(context, listen: false)._set(course, chapters, sections, enrollmentDate, numSectionsCompleted, totNumSections);
  if(comingFromHome) {
    Provider.of<LearnCourseAppState>(context, listen: false)._updateComingFromHomePrivilege(true);
  }
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