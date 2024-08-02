import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/courses/bloqo_chapter.dart';
import '../model/courses/bloqo_course.dart';
import '../model/courses/bloqo_section.dart';

class EditorCourseAppState with ChangeNotifier{

  BloqoCourse? _course;
  List<BloqoChapter>? _chapters;
  Map<String, List<BloqoSection>>? _sections;
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

  void _set(BloqoCourse? course, List<BloqoChapter>? chapters, Map<String, List<BloqoSection>>? sections){
    _course = course;
    _chapters = chapters;
    _sections = sections;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  void _removeChapter(String chapterId) {
    if (_course != null && _chapters != null) {
      _course!.chapters.removeWhere((id) => id == chapterId);
      _chapters!.removeWhere((chapter) => chapter.id == chapterId);

      _chapters!.sort((a, b) => a.number.compareTo(b.number));

      for (int i = 0; i < _chapters!.length; i++) {
        _chapters![i].number = i + 1;
      }

      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
    }
  }

  bool _getComingFromHomePrivilege(){
    return _fromHome;
  }

  void _updateComingFromHomePrivilege(bool newValue) {
    _fromHome = newValue;
  }

}

BloqoCourse? getEditorCourseFromAppState({required BuildContext context}){
  return Provider.of<EditorCourseAppState>(context, listen: false)._getCourse();
}

BloqoChapter? getEditorCourseChapterFromAppState({required BuildContext context, required String chapterId}){
  return Provider.of<EditorCourseAppState>(context, listen: false)._getChapterFromId(chapterId);
}

List<BloqoChapter>? getEditorCourseChaptersFromAppState({required BuildContext context}){
  return Provider.of<EditorCourseAppState>(context, listen: false)._getChapters();
}

List<BloqoSection>? getEditorCourseChapterSectionsFromAppState({required BuildContext context, required String chapterId}){
  return Provider.of<EditorCourseAppState>(context, listen: false)._getSectionsFromChapter(chapterId);
}

Map<String, List<BloqoSection>>? getEditorCourseSectionsFromAppState({required BuildContext context}){
  return Provider.of<EditorCourseAppState>(context, listen: false)._getSections();
}

void saveEditorCourseToAppState({required BuildContext context, required BloqoCourse course, required List<BloqoChapter> chapters, required Map<String, List<BloqoSection>> sections, bool comingFromHome = false}){
  Provider.of<EditorCourseAppState>(context, listen: false)._set(course, chapters, sections);
  if(comingFromHome) {
    Provider.of<EditorCourseAppState>(context, listen: false)._updateComingFromHomePrivilege(true);
  }
}

void deleteEditorCourseFromAppState({required BuildContext context}) {
  Provider.of<EditorCourseAppState>(context, listen: false)._set(null, null, null);
}

void deleteChapterFromEditorCourseAppState({required BuildContext context, required String chapterId}) {
  Provider.of<EditorCourseAppState>(context, listen: false)._removeChapter(chapterId);
}

bool getComingFromHomeEditorPrivilegeFromAppState({required BuildContext context}){
  return Provider.of<EditorCourseAppState>(context, listen: false)._getComingFromHomePrivilege();
}

void setComingFromHomeEditorPrivilegeToAppState({required BuildContext context}){
  Provider.of<EditorCourseAppState>(context, listen: false)._updateComingFromHomePrivilege(true);
}

void useComingFromHomeEditorPrivilegeFromAppState({required BuildContext context}){
  Provider.of<EditorCourseAppState>(context, listen: false)._updateComingFromHomePrivilege(false);
}