import 'package:flutter/cupertino.dart';

class Constants{

  static const int maxEmailLength = 320;
  static const int minPasswordLength = 8;
  static const int maxPasswordLength = 32;
  static const int minUsernameLength = 4;
  static const int maxUsernameLength = 32;
  static const int maxFullNameLength = 64;

  static const int maxCourseNameLength = 50;
  static const int maxCourseDescriptionLength = 500;

  static const int maxChapterNameLength = 50;
  static const int maxChapterDescriptionLength = 500;

  static const int maxBlockTextLength = 10000;

  static const int maxYouTubeLinkLength = 500;

  static const int maxQuizQuestionLength = 1000;
  static const int maxQuizAnswerLength = 500;

  static const double markdownBaseFontSize = 16.0;

  static const int coursesToShowAtFirst = 3;
  static const int coursesToFurtherLoadAtRequest = 3;
  static const int coursesToShowAtFirstTabletHomepage = 4;
  static const int coursesToShowAtFirstTablet = 8;
  static const int coursesToFurtherLoadAtRequestTabletHomepage = 4;
  static const int coursesToFurtherLoadAtRequestTablet = 8;

  static const int usersToShowAtFirst = 10;
  static const int usersToFurtherLoadAtRequest = 10;
  static const int reviewsToShowAtFirst = 3;
  static const int reviewsToFurtherLoadAtRequest = 3;

  static const int maxCoursesToFetch = 50;
  static const int maxNotificationsToFetch = 50;

  static const double textAreaContainerHeight = 200.0;

  static const int snackBarDuration = 2;

  static const int notificationCheckSeconds = 10;

  static const int maxReviewLength = 300;
  static const int maxReviewTitleLength = 20;

  static const double fontSizeTablet = 26;
  static const double fontSizeNotTablet = 20;
  static const double heightTablet = 64;
  static const double heightNotTablet = 48;

  static const EdgeInsetsDirectional tabletPaddingWelcomePages = EdgeInsetsDirectional.fromSTEB(45, 0, 45, 0);
  static const EdgeInsetsDirectional tabletPadding = EdgeInsetsDirectional.fromSTEB(20, 0, 20, 0);
  static const EdgeInsetsDirectional tabletPaddingBloqoFilledButton = EdgeInsetsDirectional.fromSTEB(65, 15, 65, 15);
  static const EdgeInsetsDirectional tabletPaddingBreadcrumbs = EdgeInsetsDirectional.fromSTEB(40, 10, 40, 10);

}