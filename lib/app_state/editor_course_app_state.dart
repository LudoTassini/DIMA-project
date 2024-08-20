import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../model/courses/bloqo_block_data.dart';
import '../model/courses/bloqo_chapter_data.dart';
import '../model/courses/bloqo_course_data.dart';
import '../model/courses/bloqo_section_data.dart';

class EditorCourseAppState with ChangeNotifier{

  BloqoCourseData? _course;
  List<BloqoChapterData>? _chapters;
  Map<String, List<BloqoSectionData>>? _sections;
  Map<String, List<BloqoBlockData>>? _blocks;
  bool _fromHome = false;

  BloqoCourseData? _getCourse() {
    return _course;
  }

  BloqoChapterData? _getChapterFromId(String chapterId){
    return _chapters?.where((chapter) => chapter.id == chapterId).first;
  }

  BloqoSectionData? _getSectionFromId(String chapterId, String sectionId){
    return _sections?[chapterId]?.where((section) => section.id == sectionId).first;
  }

  BloqoBlockData? _getBlockFromId(String sectionId, String blockId){
    return _blocks?[sectionId]?.where((block) => block.id == blockId).first;
  }

  List<BloqoChapterData>? _getChapters(){
    return _chapters;
  }

  Map<String, List<BloqoSectionData>>? _getSections(){
    return _sections;
  }

  Map<String, List<BloqoBlockData>>? _getBlocks(){
    return _blocks;
  }

  List<BloqoSectionData>? _getSectionsFromChapter(String chapterId){
    return _sections?[chapterId];
  }

  List<BloqoBlockData>? _getBlocksFromSection(String sectionId){
    return _blocks?[sectionId];
  }

  void _set(BloqoCourseData? course, List<BloqoChapterData>? chapters, Map<String, List<BloqoSectionData>>? sections, Map<String, List<BloqoBlockData>>? blocks){
    _course = course;
    _chapters = chapters;
    _sections = sections;
    _blocks = blocks;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  void _addChapter(BloqoChapterData chapter) {
    if (_chapters != null) {
      _chapters!.add(chapter);
      _course!.chapters.add(chapter.id);

      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
    }
  }

  void _addSection(String chapterId, BloqoSectionData section) {
    if (_chapters != null && _sections != null) {
      _chapters!.where((chapter) => chapter.id == chapterId).first.sections.add(section.id);

      if (_sections!.containsKey(chapterId)) {
        _sections![chapterId]!.add(section);
      } else {
        _sections![chapterId] = [section];
      }

      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
    }
  }

  void _addBlock(String chapterId, String sectionId, BloqoBlockData block) {
    if (_sections != null && _blocks != null) {
      _sections![chapterId]!.where((section) => section.id == sectionId).first.blocks.add(block.id);

      if (_blocks!.containsKey(sectionId)) {
        _blocks![sectionId]!.add(block);
      } else {
        _blocks![sectionId] = [block];
      }

      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
    }
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

  void _removeSection(String chapterId, String sectionId) {
    if (_chapters != null && _sections != null) {
      _chapters!.where((chapter) => chapter.id == chapterId).first.sections.removeWhere((id) => id == sectionId);
      _sections![chapterId]!.removeWhere((section) => section.id == sectionId);

      _sections![chapterId]!.sort((a, b) => a.number.compareTo(b.number));

      for (int i = 0; i < _sections![chapterId]!.length; i++) {
        var section = _sections![chapterId]![i];
        section.number = i + 1;
      }

      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
    }
  }

  void _removeBlock(String chapterId, String sectionId, String blockId) {
    if (_sections != null && _blocks != null) {
      _sections![chapterId]!.where((section) => section.id == sectionId).first.blocks.removeWhere((id) => id == blockId);
      _blocks![sectionId]!.removeWhere((block) => block.id == blockId);

      _blocks![sectionId]!.sort((a, b) => a.number.compareTo(b.number));

      for (int i = 0; i < _blocks![sectionId]!.length; i++) {
        var block = _blocks![sectionId]![i];
        block.number = i + 1;
      }

      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
    }
  }

  void _updateChapterName(String chapterId, String newName){
    if(_chapters != null){
      _chapters!.where((chapter) => chapter.id == chapterId).first.name = newName;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
    }
  }

  void _updateSectionName(String chapterId, String sectionId, String newName){
    if(_sections != null){
      _sections![chapterId]!.where((section) => section.id == sectionId).first.name = newName;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
    }
  }

  void _updateBlock(String sectionId, BloqoBlockData block) {
    if (_blocks != null && _blocks!.containsKey(sectionId)) {
      final sectionBlocks = _blocks![sectionId];
      final index = sectionBlocks!.indexWhere((blck) => blck.id == block.id);
      if (index != -1) {
        sectionBlocks[index] = block;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          notifyListeners();
        });
      }
    }
  }

  void _updateStatus(bool published){
    if(_course != null){
      _course!.published = published;
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

BloqoCourseData? getEditorCourseFromAppState({required BuildContext context}){
  return Provider.of<EditorCourseAppState>(context, listen: false)._getCourse();
}

BloqoChapterData? getEditorCourseChapterFromAppState({required BuildContext context, required String chapterId}){
  return Provider.of<EditorCourseAppState>(context, listen: false)._getChapterFromId(chapterId);
}

BloqoSectionData? getEditorCourseSectionFromAppState({required BuildContext context, required String chapterId, required String sectionId}){
  return Provider.of<EditorCourseAppState>(context, listen: false)._getSectionFromId(chapterId, sectionId);
}

BloqoBlockData? getEditorCourseBlockFromAppState({required BuildContext context, required String sectionId, required String blockId}){
  return Provider.of<EditorCourseAppState>(context, listen: false)._getBlockFromId(sectionId, blockId);
}

List<BloqoChapterData>? getEditorCourseChaptersFromAppState({required BuildContext context}){
  return Provider.of<EditorCourseAppState>(context, listen: false)._getChapters();
}

List<BloqoSectionData>? getEditorCourseChapterSectionsFromAppState({required BuildContext context, required String chapterId}){
  return Provider.of<EditorCourseAppState>(context, listen: false)._getSectionsFromChapter(chapterId);
}

List<BloqoBlockData>? getEditorCourseSectionBlocksFromAppState({required BuildContext context, required String sectionId}){
  return Provider.of<EditorCourseAppState>(context, listen: false)._getBlocksFromSection(sectionId);
}

Map<String, List<BloqoSectionData>>? getEditorCourseSectionsFromAppState({required BuildContext context}){
  return Provider.of<EditorCourseAppState>(context, listen: false)._getSections();
}

Map<String, List<BloqoBlockData>>? getEditorCourseBlocksFromAppState({required BuildContext context}){
  return Provider.of<EditorCourseAppState>(context, listen: false)._getBlocks();
}

void saveEditorCourseToAppState({required BuildContext context, required BloqoCourseData course, required List<BloqoChapterData> chapters, required Map<String, List<BloqoSectionData>> sections, required Map<String, List<BloqoBlockData>> blocks, bool comingFromHome = false}){
  Provider.of<EditorCourseAppState>(context, listen: false)._set(course, chapters, sections, blocks);
  if(comingFromHome) {
    Provider.of<EditorCourseAppState>(context, listen: false)._updateComingFromHomePrivilege(true);
  }
}

void addChapterToEditorCourseAppState({required BuildContext context, required BloqoChapterData chapter}){
  Provider.of<EditorCourseAppState>(context, listen: false)._addChapter(chapter);
}

void addSectionToEditorCourseAppState({required BuildContext context, required String chapterId, required BloqoSectionData section}){
  Provider.of<EditorCourseAppState>(context, listen: false)._addSection(chapterId, section);
}

void addBlockToEditorCourseAppState({required BuildContext context, required String chapterId, required String sectionId, required BloqoBlockData block}){
  Provider.of<EditorCourseAppState>(context, listen: false)._addBlock(chapterId, sectionId, block);
}

void updateEditorCourseChapterNameInAppState({required BuildContext context, required String chapterId, required String newName}){
  Provider.of<EditorCourseAppState>(context, listen: false)._updateChapterName(chapterId, newName);
}

void updateEditorCourseSectionNameInAppState({required BuildContext context, required String chapterId, required String sectionId, required String newName}){
  Provider.of<EditorCourseAppState>(context, listen: false)._updateSectionName(chapterId, sectionId, newName);
}

void updateEditorCourseBlockInAppState({required BuildContext context, required String sectionId, required BloqoBlockData block}){
  Provider.of<EditorCourseAppState>(context, listen: false)._updateBlock(sectionId, block);
}

void updateEditorCourseStatusInAppState({required BuildContext context, required bool published}){
  Provider.of<EditorCourseAppState>(context, listen: false)._updateStatus(published);
}

void deleteEditorCourseFromAppState({required BuildContext context}) {
  Provider.of<EditorCourseAppState>(context, listen: false)._set(null, null, null, null);
}

void deleteChapterFromEditorCourseAppState({required BuildContext context, required String chapterId}) {
  Provider.of<EditorCourseAppState>(context, listen: false)._removeChapter(chapterId);
}

void deleteSectionFromEditorCourseAppState({required BuildContext context, required String chapterId, required String sectionId}) {
  Provider.of<EditorCourseAppState>(context, listen: false)._removeSection(chapterId, sectionId);
}

void deleteBlockFromEditorCourseAppState({required BuildContext context, required String chapterId, required String sectionId, required String blockId}) {
  Provider.of<EditorCourseAppState>(context, listen: false)._removeBlock(chapterId, sectionId, blockId);
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