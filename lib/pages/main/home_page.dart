import 'package:bloqo/components/buttons/bloqo_help_button.dart';
import 'package:bloqo/components/containers/bloqo_seasalt_container.dart';
import 'package:bloqo/components/navigation/bloqo_nav_bar.dart';
import 'package:bloqo/style/app_colors.dart';
import 'package:flutter/material.dart';
import '../../components/containers/bloqo_main_container.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentPageIndex = 0;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const BloqoNavBar(),

      // appBar: BloqoAppBar.get(context: context, title: widget.title),
      appBar: AppBar(
        backgroundColor: AppColors.russianViolet,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title, // FIXME: non riesco a passare title
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                fontFamily: 'Outfit',
                color: AppColors.seasalt,
                fontSize: 22,),
              ),
            const BloqoHelpButton(), // FIXME: spero vada bene
          ],
        ),
        centerTitle: false,
        elevation: 2,
      ),
      body: BloqoMainContainer(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Flexible(
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 0),
                child: Text(
                  'Do you mind some learning today?',
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    color: AppColors.seasalt,
                    fontSize: 30,
                  ),
                ),
              ),
            ),
            BloqoSeasaltContainer(
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 15),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding:
                      const EdgeInsetsDirectional.fromSTEB(15, 15, 15, 0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Flexible(
                            child: Text(
                              '"The greatest enemy of knowledge is not ignorance, it is the illusion of knowledge." - Stephen Hawking',
                              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                fontStyle: FontStyle.italic,
                                color: AppColors.russianViolet,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        BloqoSeasaltContainer(
                          child: Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      child: Align(
                                        alignment:
                                        const AlignmentDirectional(-1, 0),
                                        child: Column(
                                          mainAxisSize:
                                          MainAxisSize.max,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding:
                                              const EdgeInsetsDirectional
                                                  .fromSTEB(10, 10,
                                                  10, 0),
                                              child: Row(
                                                mainAxisSize:
                                                MainAxisSize.max,
                                                children: [
                                                  const Padding(
                                                    padding:
                                                    EdgeInsetsDirectional
                                                        .fromSTEB(
                                                        0,
                                                        0,
                                                        5,
                                                        0),
                                                    child: Icon(
                                                      Icons.menu_book_rounded,
                                                      color: AppColors.russianViolet,
                                                      size: 24,
                                                    ),
                                                  ),
                                                  Flexible(
                                                    child: Align(
                                                      alignment:
                                                      const AlignmentDirectional(
                                                          -1, 0),
                                                      child: Text(
                                                        'DIMA Crash Course',
                                                        style: FlutterFlowTheme.of(
                                                            context)
                                                            .bodyMedium
                                                            .override(
                                                          fontFamily:
                                                          'Readex Pro',
                                                          fontSize:
                                                          16,
                                                          letterSpacing:
                                                          0,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                              const EdgeInsetsDirectional
                                                  .fromSTEB(
                                                  10, 0, 10, 5),
                                              child: Row(
                                                mainAxisSize:
                                                MainAxisSize.max,
                                                children: [
                                                  Padding(
                                                    padding:
                                                    const EdgeInsetsDirectional
                                                        .fromSTEB(
                                                        0,
                                                        0,
                                                        5,
                                                        0),
                                                    child: Icon(
                                                      Icons.person,
                                                      color: FlutterFlowTheme
                                                          .of(context)
                                                          .russianViolet2,
                                                      size: 24,
                                                    ),
                                                  ),
                                                  Text(
                                                    'ViscoVanessa',
                                                    style: FlutterFlowTheme
                                                        .of(context)
                                                        .bodyMedium
                                                        .override(
                                                      fontFamily:
                                                      'Readex Pro',
                                                      fontSize: 14,
                                                      letterSpacing:
                                                      0,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                              const EdgeInsetsDirectional
                                                  .fromSTEB(
                                                  10, 0, 10, 0),
                                              child: Row(
                                                mainAxisSize:
                                                MainAxisSize.max,
                                                children: [
                                                  Padding(
                                                    padding:
                                                    const EdgeInsetsDirectional
                                                        .fromSTEB(
                                                        0,
                                                        0,
                                                        5,
                                                        0),
                                                    child: Icon(
                                                      Icons
                                                          .bookmark_outlined,
                                                      color: FlutterFlowTheme
                                                          .of(context)
                                                          .russianViolet2,
                                                      size: 24,
                                                    ),
                                                  ),
                                                  Flexible(
                                                    child: Text(
                                                      'Section 2-3: DIMA projects',
                                                      style: FlutterFlowTheme
                                                          .of(context)
                                                          .bodyMedium
                                                          .override(
                                                        fontFamily:
                                                        'Readex Pro',
                                                        fontSize:
                                                        20,
                                                        letterSpacing:
                                                        0,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Column(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(0, 0, 10, 0),
                                          child: Icon(
                                            Icons.play_circle,
                                            color: FlutterFlowTheme.of(
                                                context)
                                                .russianViolet2,
                                            size: 24,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: FlutterFlowTheme.of(
                                              context)
                                              .russianViolet2,
                                          borderRadius:
                                          BorderRadius.circular(6),
                                          border: Border.all(
                                            color: FlutterFlowTheme.of(
                                                context)
                                                .russianViolet2,
                                          ),
                                        ),
                                        child: LinearPercentIndicator(
                                          percent: 0.5,
                                          width: 295,
                                          lineHeight: 15,
                                          animation: true,
                                          animateFromLastPercent: true,
                                          progressColor:
                                          FlutterFlowTheme.of(
                                              context)
                                              .success,
                                          backgroundColor:
                                          FlutterFlowTheme.of(
                                              context)
                                              .accent4,
                                          center: Text(
                                            '50% of course completed',
                                            style: FlutterFlowTheme.of(
                                                context)
                                                .headlineSmall
                                                .override(
                                              fontFamily: 'Outfit',
                                              fontSize: 10,
                                              letterSpacing: 0,
                                            ),
                                          ),
                                          barRadius: Radius.circular(5),
                                          padding: EdgeInsets.zero,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 0),
                  child: Text(
                    'You have some work yet to be completed.',
                    textAlign: TextAlign.end,
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'Readex Pro',
                      color: FlutterFlowTheme.of(context).seasalt2,
                      fontSize: 30,
                      letterSpacing: 0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Container(
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).secondaryBackground,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding:
                          EdgeInsetsDirectional.fromSTEB(15, 15, 15, 0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Flexible(
                                child: RichText(
                                  textScaler:
                                  MediaQuery.of(context).textScaler,
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text:
                                        '\"Tell me and I forget. Teach me and I remember. Involve me and I learn.\"',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                          fontFamily: 'Readex Pro',
                                          color:
                                          FlutterFlowTheme.of(context)
                                              .primaryText,
                                          fontSize: 12,
                                          letterSpacing: 0,
                                          fontWeight: FontWeight.w500,
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                      TextSpan(
                                        text: ' - Benjamin Franklin',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                          fontFamily: 'Readex Pro',
                                          fontSize: 12,
                                          letterSpacing: 0,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      )
                                    ],
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                      fontFamily: 'Readex Pro',
                                      letterSpacing: 0,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  15, 15, 15, 0),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  shape: BoxShape.rectangle,
                                  border: Border.all(
                                    color: FlutterFlowTheme.of(context)
                                        .chineseViolet2,
                                    width: 3,
                                  ),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Align(
                                          alignment:
                                          AlignmentDirectional(-1, 0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsetsDirectional
                                                    .fromSTEB(10, 10, 10, 0),
                                                child: Row(
                                                  mainAxisSize:
                                                  MainAxisSize.max,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                      const EdgeInsetsDirectional
                                                          .fromSTEB(
                                                          0, 0, 5, 0),
                                                      child: Icon(
                                                        Icons
                                                            .menu_book_rounded,
                                                        color: FlutterFlowTheme
                                                            .of(context)
                                                            .russianViolet2,
                                                        size: 24,
                                                      ),
                                                    ),
                                                    Flexible(
                                                      child: Align(
                                                        alignment:
                                                        AlignmentDirectional(
                                                            -1, 0),
                                                        child: Text(
                                                          'Math Basics',
                                                          style: FlutterFlowTheme
                                                              .of(context)
                                                              .bodyMedium
                                                              .override(
                                                            fontFamily:
                                                            'Readex Pro',
                                                            fontSize: 16,
                                                            letterSpacing:
                                                            0,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(10, 5, 10, 10),
                                                child: Text(
                                                  '2 chapters, 15 sections',
                                                  style: FlutterFlowTheme.of(
                                                      context)
                                                      .bodyMedium
                                                      .override(
                                                    fontFamily:
                                                    'Readex Pro',
                                                    fontSize: 12,
                                                    letterSpacing: 0,
                                                    fontWeight:
                                                    FontWeight.w300,
                                                    fontStyle:
                                                    FontStyle.italic,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                          EdgeInsetsDirectional.fromSTEB(
                                              0, 0, 10, 0),
                                          child: Icon(
                                            Icons.play_circle,
                                            color:
                                            FlutterFlowTheme.of(context)
                                                .russianViolet2,
                                            size: 24,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  15, 15, 15, 0),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  shape: BoxShape.rectangle,
                                  border: Border.all(
                                    color: FlutterFlowTheme.of(context)
                                        .chineseViolet2,
                                    width: 3,
                                  ),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Flexible(
                                          child: Align(
                                            alignment:
                                            AlignmentDirectional(0, 0),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.max,
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding:
                                                  EdgeInsetsDirectional
                                                      .fromSTEB(
                                                      10, 10, 10, 0),
                                                  child: Row(
                                                    mainAxisSize:
                                                    MainAxisSize.max,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(0,
                                                            0, 5, 0),
                                                        child: Icon(
                                                          Icons
                                                              .menu_book_rounded,
                                                          color: FlutterFlowTheme
                                                              .of(context)
                                                              .russianViolet2,
                                                          size: 24,
                                                        ),
                                                      ),
                                                      Flexible(
                                                        child: Align(
                                                          alignment:
                                                          AlignmentDirectional(
                                                              -1, 0),
                                                          child: Text(
                                                            'Synchronization Techniques in Distributed Systems',
                                                            style: FlutterFlowTheme
                                                                .of(context)
                                                                .bodyMedium
                                                                .override(
                                                              fontFamily:
                                                              'Readex Pro',
                                                              fontSize:
                                                              16,
                                                              letterSpacing:
                                                              0,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                  EdgeInsetsDirectional
                                                      .fromSTEB(
                                                      10, 5, 10, 10),
                                                  child: Text(
                                                    '5 chapters, 60 sections',
                                                    style: FlutterFlowTheme
                                                        .of(context)
                                                        .bodyMedium
                                                        .override(
                                                      fontFamily:
                                                      'Readex Pro',
                                                      fontSize: 12,
                                                      letterSpacing: 0,
                                                      fontWeight:
                                                      FontWeight.w300,
                                                      fontStyle: FontStyle
                                                          .italic,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                          EdgeInsetsDirectional.fromSTEB(
                                              0, 0, 10, 0),
                                          child: Icon(
                                            Icons.play_circle,
                                            color:
                                            FlutterFlowTheme.of(context)
                                                .russianViolet2,
                                            size: 24,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  15, 15, 15, 0),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  shape: BoxShape.rectangle,
                                  border: Border.all(
                                    color: FlutterFlowTheme.of(context)
                                        .chineseViolet2,
                                    width: 3,
                                  ),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Align(
                                          alignment:
                                          AlignmentDirectional(-1, 0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(10, 10, 10, 0),
                                                child: Row(
                                                  mainAxisSize:
                                                  MainAxisSize.max,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                      EdgeInsetsDirectional
                                                          .fromSTEB(
                                                          0, 0, 5, 0),
                                                      child: Icon(
                                                        Icons
                                                            .menu_book_rounded,
                                                        color: FlutterFlowTheme
                                                            .of(context)
                                                            .russianViolet2,
                                                        size: 24,
                                                      ),
                                                    ),
                                                    Flexible(
                                                      child: Align(
                                                        alignment:
                                                        AlignmentDirectional(
                                                            -1, 0),
                                                        child: Text(
                                                          'Geometry Basics',
                                                          style: FlutterFlowTheme
                                                              .of(context)
                                                              .bodyMedium
                                                              .override(
                                                            fontFamily:
                                                            'Readex Pro',
                                                            fontSize: 16,
                                                            letterSpacing:
                                                            0,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(10, 5, 10, 10),
                                                child: Text(
                                                  '5 chapters, 9 sections',
                                                  style: FlutterFlowTheme.of(
                                                      context)
                                                      .bodyMedium
                                                      .override(
                                                    fontFamily:
                                                    'Readex Pro',
                                                    fontSize: 12,
                                                    letterSpacing: 0,
                                                    fontWeight:
                                                    FontWeight.w300,
                                                    fontStyle:
                                                    FontStyle.italic,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                          EdgeInsetsDirectional.fromSTEB(
                                              0, 0, 10, 0),
                                          child: Icon(
                                            Icons.play_circle,
                                            color:
                                            FlutterFlowTheme.of(context)
                                                .russianViolet2,
                                            size: 24,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Align(
                              alignment: AlignmentDirectional(1, -1),
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    15, 15, 15, 0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(0),
                                    shape: BoxShape.rectangle,
                                  ),
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0, 0, 0, 10),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Align(
                                          alignment:
                                          AlignmentDirectional(1, 0),
                                          child: Text(
                                            'View more',
                                            textAlign: TextAlign.start,
                                            style: FlutterFlowTheme.of(
                                                context)
                                                .bodyMedium
                                                .override(
                                              fontFamily: 'Readex Pro',
                                              color: FlutterFlowTheme.of(
                                                  context)
                                                  .secondaryText,
                                              fontSize: 14,
                                              letterSpacing: 0,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                        Icon(
                                          Icons.keyboard_arrow_right_sharp,
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryText,
                                          size: 25,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  }

}