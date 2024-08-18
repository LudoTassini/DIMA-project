import 'package:bloqo/model/bloqo_published_course.dart';
import 'package:bloqo/pages/from_any/user_profile_page.dart';
import 'package:bloqo/utils/localization.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '../../model/bloqo_user.dart';
import '../../style/bloqo_colors.dart';
import '../../utils/bloqo_exception.dart';
import '../popups/bloqo_error_alert.dart';

class BloqoUserDetailsShort extends StatelessWidget{

  const BloqoUserDetailsShort({
    super.key,
    required this.user,
    required this.onPush,
    required this.onNavigateToPage
  });

  final BloqoUser user;
  final void Function(Widget) onPush;
  final void Function(int) onNavigateToPage;

  @override
  Widget build(BuildContext context) {
    String? url;
    if(user.pictureUrl != "none"){
      url = user.pictureUrl;
    }
    var localizedText = getAppLocalizations(context)!;
    return Padding(
      padding: const EdgeInsets.all(20),
      child: ElevatedButton(
        style: ButtonStyle(
          padding: WidgetStateProperty.resolveWith((states) => const EdgeInsets.all(15)),
          backgroundColor: WidgetStateProperty.resolveWith((states) => BloqoColors.seasalt),
          shape: WidgetStateProperty.resolveWith((states) => RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: const BorderSide(
              color: BloqoColors.seasalt,
              width: 0,
            ),
          )),
        ),
        onPressed: () async {
          await _tryGoToProfilePage(context: context, localizedText: localizedText);
        },
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Flexible(
              flex: 1,
              child: Stack(
                alignment: const AlignmentDirectional(0, 1),
                children: [
                  AspectRatio(
                    aspectRatio: 1.0,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: url != null
                          ? FadeInImage.assetNetwork(
                        placeholder: "assets/images/portrait_placeholder.png",
                        image: url,
                        fit: BoxFit.cover,
                        placeholderFit: BoxFit.cover,
                      )
                          : Image.asset(
                        "assets/images/portrait_placeholder.png",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Align(
                    alignment: const AlignmentDirectional(1, 1),
                    child: Container(
                      decoration: const BoxDecoration(
                        color: BloqoColors.russianViolet,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(0),
                          bottomRight: Radius.circular(8),
                          topLeft: Radius.circular(0),
                          topRight: Radius.circular(0),
                        ),
                      ),
                    )
                  ),
                ],
              ),
            ),
            Flexible(
              flex: 3,
              child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(15, 0, 0, 0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 10, 0),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if(user.isFullNameVisible)
                                    Text(
                                      user.fullName,
                                      textAlign: TextAlign.start,
                                      style: Theme.of(context).textTheme.displayMedium?.copyWith(
                                        color: BloqoColors.secondaryText,
                                        fontSize: 14,
                                        letterSpacing: 0,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  Text(
                                    user.username,
                                    textAlign: TextAlign.start,
                                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                                      color: BloqoColors.primaryText,
                                      fontSize: 18,
                                      letterSpacing: 0,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                        child: Wrap(
                          spacing: 15.0,
                          runSpacing: 0.0,
                          children: [
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 15, 0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 5, 0),
                                    child: Text(
                                      localizedText.followers,
                                      style: Theme.of(context).textTheme.displayMedium?.copyWith(
                                        fontSize: 14
                                      )
                                    )
                                  ),
                                  Text(
                                    user.followers.length.toString(),
                                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 15, 0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 5, 0),
                                    child: Text(
                                      localizedText.following,
                                      style: Theme.of(context).textTheme.displayMedium?.copyWith(
                                          fontSize: 14
                                      )
                                    )
                                  ),
                                  Text(
                                    user.following.length.toString(),
                                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
              ),
            ),
            const Icon(
              Icons.play_circle,
              color: BloqoColors.russianViolet,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _tryGoToProfilePage({required BuildContext context, required var localizedText}) async {
    context.loaderOverlay.show();
    try{
      List<BloqoPublishedCourse> publishedCourses = await getPublishedCoursesFromAuthorId(localizedText: localizedText, authorId: user.id);
      if(!context.mounted) return;
      context.loaderOverlay.hide();
      onPush(
          UserProfilePage(
              onPush: onPush,
              onNavigateToPage: onNavigateToPage,
              author: user,
              publishedCourses: publishedCourses
          )
      );
    }
    on BloqoException catch(e) {
      if(!context.mounted) return;
      context.loaderOverlay.hide();
      showBloqoErrorAlert(
        context: context,
        title: localizedText.error_title,
        description: e.message,
      );
    }
  }

}