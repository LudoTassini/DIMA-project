import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/courses/bloqo_chapter.dart';
import '../model/courses/bloqo_course.dart';

class EditorCourseAppState with ChangeNotifier{

  BloqoCourse? _course;
  List<BloqoChapter>? _chapters;
  bool _fromHome = false;

  BloqoCourse? _getCourse() {
    return _course;
  }

  List<BloqoChapter>? _getChapters(){
    return _chapters;
  }

  void _set(BloqoCourse? course, List<BloqoChapter>? chapters){
    _course = course;
    _chapters = chapters;
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

List<BloqoChapter>? getEditorCourseChaptersFromAppState({required BuildContext context}){
  return Provider.of<EditorCourseAppState>(context, listen: false)._getChapters();
}

void saveEditorCourseToAppState({required BuildContext context, required BloqoCourse course, required List<BloqoChapter> chapters, bool comingFromHome = false}){
  Provider.of<EditorCourseAppState>(context, listen: false)._set(course, chapters);
  if(comingFromHome) {
    Provider.of<EditorCourseAppState>(context, listen: false)._updateComingFromHomePrivilege(true);
  }
}

void deleteEditorCourseFromAppState({required BuildContext context}) {
  Provider.of<EditorCourseAppState>(context, listen: false)._set(null, null);
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