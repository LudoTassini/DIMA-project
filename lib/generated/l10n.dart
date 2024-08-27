// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `We are unable to complete the action due to an unknown error. Please try again.`
  String get generic_error {
    return Intl.message(
      'We are unable to complete the action due to an unknown error. Please try again.',
      name: 'generic_error',
      desc: '',
      args: [],
    );
  }

  /// `Welcome!`
  String get welcome {
    return Intl.message(
      'Welcome!',
      name: 'welcome',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get email {
    return Intl.message(
      'Email',
      name: 'email',
      desc: '',
      args: [],
    );
  }

  /// `e.g. bloqo@domain.com`
  String get email_hint {
    return Intl.message(
      'e.g. bloqo@domain.com',
      name: 'email_hint',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get password {
    return Intl.message(
      'Password',
      name: 'password',
      desc: '',
      args: [],
    );
  }

  /// `type your password here`
  String get password_hint {
    return Intl.message(
      'type your password here',
      name: 'password_hint',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get login {
    return Intl.message(
      'Login',
      name: 'login',
      desc: '',
      args: [],
    );
  }

  /// `Your device is not connected to Internet. Please check your connection status and try again.`
  String get network_error {
    return Intl.message(
      'Your device is not connected to Internet. Please check your connection status and try again.',
      name: 'network_error',
      desc: '',
      args: [],
    );
  }

  /// `Internet connection is required to login. Please check your connection status and try again.`
  String get login_network_error {
    return Intl.message(
      'Internet connection is required to login. Please check your connection status and try again.',
      name: 'login_network_error',
      desc: '',
      args: [],
    );
  }

  /// `Wrong credentials. Please check them and try again.`
  String get login_credentials_error {
    return Intl.message(
      'Wrong credentials. Please check them and try again.',
      name: 'login_credentials_error',
      desc: '',
      args: [],
    );
  }

  /// `Forgot your password?`
  String get forgot_password {
    return Intl.message(
      'Forgot your password?',
      name: 'forgot_password',
      desc: '',
      args: [],
    );
  }

  /// `New here?`
  String get new_here {
    return Intl.message(
      'New here?',
      name: 'new_here',
      desc: '',
      args: [],
    );
  }

  /// `Register now!`
  String get register_now {
    return Intl.message(
      'Register now!',
      name: 'register_now',
      desc: '',
      args: [],
    );
  }

  /// `Thank you for joining the bloQo community!`
  String get register_thank_you {
    return Intl.message(
      'Thank you for joining the bloQo community!',
      name: 'register_thank_you',
      desc: '',
      args: [],
    );
  }

  /// `We want you to have the best experience.\nThat's why we are asking a few data about you.`
  String get register_explanation {
    return Intl.message(
      'We want you to have the best experience.\nThat\'s why we are asking a few data about you.',
      name: 'register_explanation',
      desc: '',
      args: [],
    );
  }

  /// `Username`
  String get username {
    return Intl.message(
      'Username',
      name: 'username',
      desc: '',
      args: [],
    );
  }

  /// `e.g. iluvbloqo00`
  String get username_hint {
    return Intl.message(
      'e.g. iluvbloqo00',
      name: 'username_hint',
      desc: '',
      args: [],
    );
  }

  /// `Full name`
  String get full_name {
    return Intl.message(
      'Full name',
      name: 'full_name',
      desc: '',
      args: [],
    );
  }

  /// `e.g. Vanessa Visconti`
  String get full_name_hint {
    return Intl.message(
      'e.g. Vanessa Visconti',
      name: 'full_name_hint',
      desc: '',
      args: [],
    );
  }

  /// `Full name visible to others`
  String get full_name_visible {
    return Intl.message(
      'Full name visible to others',
      name: 'full_name_visible',
      desc: '',
      args: [],
    );
  }

  /// `Register`
  String get register {
    return Intl.message(
      'Register',
      name: 'register',
      desc: '',
      args: [],
    );
  }

  /// `Already have an account? Log in!`
  String get back_to_login {
    return Intl.message(
      'Already have an account? Log in!',
      name: 'back_to_login',
      desc: '',
      args: [],
    );
  }

  /// `Oops, an error occurred!`
  String get error_title {
    return Intl.message(
      'Oops, an error occurred!',
      name: 'error_title',
      desc: '',
      args: [],
    );
  }

  /// `The username is already taken. Please choose another one.`
  String get username_already_taken {
    return Intl.message(
      'The username is already taken. Please choose another one.',
      name: 'username_already_taken',
      desc: '',
      args: [],
    );
  }

  /// `There's already an account with the given email. Please login or try entering another one.`
  String get register_email_already_taken {
    return Intl.message(
      'There\'s already an account with the given email. Please login or try entering another one.',
      name: 'register_email_already_taken',
      desc: '',
      args: [],
    );
  }

  /// `Internet connection is required to register. Please check your connection status and try again.`
  String get register_network_error {
    return Intl.message(
      'Internet connection is required to register. Please check your connection status and try again.',
      name: 'register_network_error',
      desc: '',
      args: [],
    );
  }

  /// `Oops, something went wrong. Please try again.`
  String get register_error {
    return Intl.message(
      'Oops, something went wrong. Please try again.',
      name: 'register_error',
      desc: '',
      args: [],
    );
  }

  /// `All fields are required. Please complete them.`
  String get register_incomplete_error {
    return Intl.message(
      'All fields are required. Please complete them.',
      name: 'register_incomplete_error',
      desc: '',
      args: [],
    );
  }

  /// `Welcome`
  String get home_page_title {
    return Intl.message(
      'Welcome',
      name: 'home_page_title',
      desc: '',
      args: [],
    );
  }

  /// `Learn`
  String get learn_page_title {
    return Intl.message(
      'Learn',
      name: 'learn_page_title',
      desc: '',
      args: [],
    );
  }

  /// `Search`
  String get search_page_title {
    return Intl.message(
      'Search',
      name: 'search_page_title',
      desc: '',
      args: [],
    );
  }

  /// `Editor`
  String get editor_page_title {
    return Intl.message(
      'Editor',
      name: 'editor_page_title',
      desc: '',
      args: [],
    );
  }

  /// `Account and Settings`
  String get user_page_title {
    return Intl.message(
      'Account and Settings',
      name: 'user_page_title',
      desc: '',
      args: [],
    );
  }

  /// `Tell us what you are looking for.`
  String get search_page_header_1 {
    return Intl.message(
      'Tell us what you are looking for.',
      name: 'search_page_header_1',
      desc: '',
      args: [],
    );
  }

  /// `Every field is optional. Freely choose your filters and sorting options.`
  String get search_page_header_2 {
    return Intl.message(
      'Every field is optional. Freely choose your filters and sorting options.',
      name: 'search_page_header_2',
      desc: '',
      args: [],
    );
  }

  /// `Course name`
  String get course_name {
    return Intl.message(
      'Course name',
      name: 'course_name',
      desc: '',
      args: [],
    );
  }

  /// `e.g. Basic English for Italian Speakers`
  String get course_name_hint {
    return Intl.message(
      'e.g. Basic English for Italian Speakers',
      name: 'course_name_hint',
      desc: '',
      args: [],
    );
  }

  /// `Author username`
  String get author_username {
    return Intl.message(
      'Author username',
      name: 'author_username',
      desc: '',
      args: [],
    );
  }

  /// `e.g. Vanessa Visconti`
  String get author_username_hint {
    return Intl.message(
      'e.g. Vanessa Visconti',
      name: 'author_username_hint',
      desc: '',
      args: [],
    );
  }

  /// `Minimum publication date`
  String get minimum_publication_date {
    return Intl.message(
      'Minimum publication date',
      name: 'minimum_publication_date',
      desc: '',
      args: [],
    );
  }

  /// `e.g. 01/01/2024`
  String get minimum_publication_date_hint {
    return Intl.message(
      'e.g. 01/01/2024',
      name: 'minimum_publication_date_hint',
      desc: '',
      args: [],
    );
  }

  /// `Maximum publication date`
  String get maximum_publication_date {
    return Intl.message(
      'Maximum publication date',
      name: 'maximum_publication_date',
      desc: '',
      args: [],
    );
  }

  /// `e.g. 31/01/2024`
  String get maximum_publication_date_hint {
    return Intl.message(
      'e.g. 31/01/2024',
      name: 'maximum_publication_date_hint',
      desc: '',
      args: [],
    );
  }

  /// `Show public courses`
  String get show_public_courses {
    return Intl.message(
      'Show public courses',
      name: 'show_public_courses',
      desc: '',
      args: [],
    );
  }

  /// `Show private courses`
  String get show_private_courses {
    return Intl.message(
      'Show private courses',
      name: 'show_private_courses',
      desc: '',
      args: [],
    );
  }

  /// `You can also filter by tag.`
  String get search_page_tag_header {
    return Intl.message(
      'You can also filter by tag.',
      name: 'search_page_tag_header',
      desc: '',
      args: [],
    );
  }

  /// `Language Tag`
  String get language_tag {
    return Intl.message(
      'Language Tag',
      name: 'language_tag',
      desc: '',
      args: [],
    );
  }

  /// `Subject Tag`
  String get subject_tag {
    return Intl.message(
      'Subject Tag',
      name: 'subject_tag',
      desc: '',
      args: [],
    );
  }

  /// `Duration Tag`
  String get duration_tag {
    return Intl.message(
      'Duration Tag',
      name: 'duration_tag',
      desc: '',
      args: [],
    );
  }

  /// `Modality Tag`
  String get modality_tag {
    return Intl.message(
      'Modality Tag',
      name: 'modality_tag',
      desc: '',
      args: [],
    );
  }

  /// `Difficulty Tag`
  String get difficulty_tag {
    return Intl.message(
      'Difficulty Tag',
      name: 'difficulty_tag',
      desc: '',
      args: [],
    );
  }

  /// `Finally, you can sort your results.`
  String get search_page_sort_header {
    return Intl.message(
      'Finally, you can sort your results.',
      name: 'search_page_sort_header',
      desc: '',
      args: [],
    );
  }

  /// `Sort by`
  String get sort_by {
    return Intl.message(
      'Sort by',
      name: 'sort_by',
      desc: '',
      args: [],
    );
  }

  /// `Reset Search Criteria`
  String get reset_search_criteria {
    return Intl.message(
      'Reset Search Criteria',
      name: 'reset_search_criteria',
      desc: '',
      args: [],
    );
  }

  /// `QR Code`
  String get scan_qr_code {
    return Intl.message(
      'QR Code',
      name: 'scan_qr_code',
      desc: '',
      args: [],
    );
  }

  /// `Search`
  String get search {
    return Intl.message(
      'Search',
      name: 'search',
      desc: '',
      args: [],
    );
  }

  /// `Do you mind some learning today?`
  String get homepage_learning {
    return Intl.message(
      'Do you mind some learning today?',
      name: 'homepage_learning',
      desc: '',
      args: [],
    );
  }

  /// `"The greatest enemy of knowledge is not ignorance, it is the illusion of knowledge." - Stephen Hawking`
  String get homepage_learning_quote {
    return Intl.message(
      '"The greatest enemy of knowledge is not ignorance, it is the illusion of knowledge." - Stephen Hawking',
      name: 'homepage_learning_quote',
      desc: '',
      args: [],
    );
  }

  /// `You are not enrolled in any courses. Why not searching for new courses?`
  String get homepage_no_enrolled_courses {
    return Intl.message(
      'You are not enrolled in any courses. Why not searching for new courses?',
      name: 'homepage_no_enrolled_courses',
      desc: '',
      args: [],
    );
  }

  /// `Take me there!`
  String get take_me_there_button {
    return Intl.message(
      'Take me there!',
      name: 'take_me_there_button',
      desc: '',
      args: [],
    );
  }

  /// `You have some work yet to be completed.`
  String get homepage_editing {
    return Intl.message(
      'You have some work yet to be completed.',
      name: 'homepage_editing',
      desc: '',
      args: [],
    );
  }

  /// `"Tell me and I forget. Teach me and I remember. Involve me and I learn." - Benjamin Franklin`
  String get homepage_editing_quote {
    return Intl.message(
      '"Tell me and I forget. Teach me and I remember. Involve me and I learn." - Benjamin Franklin',
      name: 'homepage_editing_quote',
      desc: '',
      args: [],
    );
  }

  /// `You have not created any courses yet. Go to the Editor and create a new one now!`
  String get homepage_no_created_courses {
    return Intl.message(
      'You have not created any courses yet. Go to the Editor and create a new one now!',
      name: 'homepage_no_created_courses',
      desc: '',
      args: [],
    );
  }

  /// `% of course completed`
  String get progress_bar_completion {
    return Intl.message(
      '% of course completed',
      name: 'progress_bar_completion',
      desc: '',
      args: [],
    );
  }

  /// `Load more`
  String get load_more {
    return Intl.message(
      'Load more',
      name: 'load_more',
      desc: '',
      args: [],
    );
  }

  /// `None`
  String get none {
    return Intl.message(
      'None',
      name: 'none',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid email address.`
  String get error_enter_valid_email {
    return Intl.message(
      'Please enter a valid email address.',
      name: 'error_enter_valid_email',
      desc: '',
      args: [],
    );
  }

  /// `The password cannot be empty.`
  String get error_password_empty {
    return Intl.message(
      'The password cannot be empty.',
      name: 'error_password_empty',
      desc: '',
      args: [],
    );
  }

  /// `The username must be at least {num} characters long.`
  String error_username_short(String num) {
    return Intl.message(
      'The username must be at least $num characters long.',
      name: 'error_username_short',
      desc: '',
      args: [num],
    );
  }

  /// `The username must be alphanumeric.`
  String get error_username_alphanumeric {
    return Intl.message(
      'The username must be alphanumeric.',
      name: 'error_username_alphanumeric',
      desc: '',
      args: [],
    );
  }

  /// `The full name must not be empty.`
  String get error_full_name_empty {
    return Intl.message(
      'The full name must not be empty.',
      name: 'error_full_name_empty',
      desc: '',
      args: [],
    );
  }

  /// `The full name must be alphanumeric (spaces are allowed).`
  String get error_full_name_alphanumeric {
    return Intl.message(
      'The full name must be alphanumeric (spaces are allowed).',
      name: 'error_full_name_alphanumeric',
      desc: '',
      args: [],
    );
  }

  /// `Password must be at least {num} characters long.`
  String error_password_short(String num) {
    return Intl.message(
      'Password must be at least $num characters long.',
      name: 'error_password_short',
      desc: '',
      args: [num],
    );
  }

  /// `Password must be at most {num} characters long.`
  String error_password_long(String num) {
    return Intl.message(
      'Password must be at most $num characters long.',
      name: 'error_password_long',
      desc: '',
      args: [num],
    );
  }

  /// `Password must contain at least one special character.`
  String get error_password_special_char {
    return Intl.message(
      'Password must contain at least one special character.',
      name: 'error_password_special_char',
      desc: '',
      args: [],
    );
  }

  /// `Password must contain at least one number.`
  String get error_password_number {
    return Intl.message(
      'Password must contain at least one number.',
      name: 'error_password_number',
      desc: '',
      args: [],
    );
  }

  /// `Password must contain at least one uppercase letter.`
  String get error_password_uppercase {
    return Intl.message(
      'Password must contain at least one uppercase letter.',
      name: 'error_password_uppercase',
      desc: '',
      args: [],
    );
  }

  /// `Password must contain at least one lowercase letter.`
  String get error_password_lowercase {
    return Intl.message(
      'Password must contain at least one lowercase letter.',
      name: 'error_password_lowercase',
      desc: '',
      args: [],
    );
  }

  /// `Invalid format.`
  String get error_invalid_date_format {
    return Intl.message(
      'Invalid format.',
      name: 'error_invalid_date_format',
      desc: '',
      args: [],
    );
  }

  /// `Out of range.`
  String get error_date_out_of_range {
    return Intl.message(
      'Out of range.',
      name: 'error_date_out_of_range',
      desc: '',
      args: [],
    );
  }

  /// `Yes`
  String get yes {
    return Intl.message(
      'Yes',
      name: 'yes',
      desc: '',
      args: [],
    );
  }

  /// `No `
  String get no {
    return Intl.message(
      'No ',
      name: 'no',
      desc: '',
      args: [],
    );
  }

  /// `Home`
  String get home {
    return Intl.message(
      'Home',
      name: 'home',
      desc: '',
      args: [],
    );
  }

  /// `Learn`
  String get learn {
    return Intl.message(
      'Learn',
      name: 'learn',
      desc: '',
      args: [],
    );
  }

  /// `Editor`
  String get editor {
    return Intl.message(
      'Editor',
      name: 'editor',
      desc: '',
      args: [],
    );
  }

  /// `Account`
  String get account {
    return Intl.message(
      'Account',
      name: 'account',
      desc: '',
      args: [],
    );
  }

  /// `OK`
  String get ok {
    return Intl.message(
      'OK',
      name: 'ok',
      desc: '',
      args: [],
    );
  }

  /// `For everyone`
  String get for_everyone {
    return Intl.message(
      'For everyone',
      name: 'for_everyone',
      desc: '',
      args: [],
    );
  }

  /// `For experts`
  String get for_experts {
    return Intl.message(
      'For experts',
      name: 'for_experts',
      desc: '',
      args: [],
    );
  }

  /// `1 hour or less`
  String get one_hour_less {
    return Intl.message(
      '1 hour or less',
      name: 'one_hour_less',
      desc: '',
      args: [],
    );
  }

  /// `1-2 hours`
  String get one_two_hours {
    return Intl.message(
      '1-2 hours',
      name: 'one_two_hours',
      desc: '',
      args: [],
    );
  }

  /// `2-3 hours`
  String get two_three_hours {
    return Intl.message(
      '2-3 hours',
      name: 'two_three_hours',
      desc: '',
      args: [],
    );
  }

  /// `3 hours or more`
  String get three_hours_more {
    return Intl.message(
      '3 hours or more',
      name: 'three_hours_more',
      desc: '',
      args: [],
    );
  }

  /// `Lessons only`
  String get lessons_only {
    return Intl.message(
      'Lessons only',
      name: 'lessons_only',
      desc: '',
      args: [],
    );
  }

  /// `Quizzes only`
  String get quizzes_only {
    return Intl.message(
      'Quizzes only',
      name: 'quizzes_only',
      desc: '',
      args: [],
    );
  }

  /// `Lessons and quizzes`
  String get lessons_quizzes {
    return Intl.message(
      'Lessons and quizzes',
      name: 'lessons_quizzes',
      desc: '',
      args: [],
    );
  }

  /// `Figurative Arts`
  String get figurative_arts {
    return Intl.message(
      'Figurative Arts',
      name: 'figurative_arts',
      desc: '',
      args: [],
    );
  }

  /// `Technology`
  String get technology {
    return Intl.message(
      'Technology',
      name: 'technology',
      desc: '',
      args: [],
    );
  }

  /// `Natural Sciences`
  String get natural_sciences {
    return Intl.message(
      'Natural Sciences',
      name: 'natural_sciences',
      desc: '',
      args: [],
    );
  }

  /// `History`
  String get history {
    return Intl.message(
      'History',
      name: 'history',
      desc: '',
      args: [],
    );
  }

  /// `Philosophy`
  String get philosophy {
    return Intl.message(
      'Philosophy',
      name: 'philosophy',
      desc: '',
      args: [],
    );
  }

  /// `Languages`
  String get languages {
    return Intl.message(
      'Languages',
      name: 'languages',
      desc: '',
      args: [],
    );
  }

  /// `Music`
  String get music {
    return Intl.message(
      'Music',
      name: 'music',
      desc: '',
      args: [],
    );
  }

  /// `Health`
  String get health {
    return Intl.message(
      'Health',
      name: 'health',
      desc: '',
      args: [],
    );
  }

  /// `Cooking`
  String get cooking {
    return Intl.message(
      'Cooking',
      name: 'cooking',
      desc: '',
      args: [],
    );
  }

  /// `Sports`
  String get sports {
    return Intl.message(
      'Sports',
      name: 'sports',
      desc: '',
      args: [],
    );
  }

  /// `Economics`
  String get economics {
    return Intl.message(
      'Economics',
      name: 'economics',
      desc: '',
      args: [],
    );
  }

  /// `Politics`
  String get politics {
    return Intl.message(
      'Politics',
      name: 'politics',
      desc: '',
      args: [],
    );
  }

  /// `Society`
  String get society {
    return Intl.message(
      'Society',
      name: 'society',
      desc: '',
      args: [],
    );
  }

  /// `Psychology`
  String get psychology {
    return Intl.message(
      'Psychology',
      name: 'psychology',
      desc: '',
      args: [],
    );
  }

  /// `Sustainability`
  String get sustainability {
    return Intl.message(
      'Sustainability',
      name: 'sustainability',
      desc: '',
      args: [],
    );
  }

  /// `Literature`
  String get literature {
    return Intl.message(
      'Literature',
      name: 'literature',
      desc: '',
      args: [],
    );
  }

  /// `Mathematics`
  String get mathematics {
    return Intl.message(
      'Mathematics',
      name: 'mathematics',
      desc: '',
      args: [],
    );
  }

  /// `Education`
  String get education {
    return Intl.message(
      'Education',
      name: 'education',
      desc: '',
      args: [],
    );
  }

  /// `Esotericism`
  String get esotericism {
    return Intl.message(
      'Esotericism',
      name: 'esotericism',
      desc: '',
      args: [],
    );
  }

  /// `Architecture`
  String get architecture {
    return Intl.message(
      'Architecture',
      name: 'architecture',
      desc: '',
      args: [],
    );
  }

  /// `Design`
  String get design {
    return Intl.message(
      'Design',
      name: 'design',
      desc: '',
      args: [],
    );
  }

  /// `Fashion`
  String get fashion {
    return Intl.message(
      'Fashion',
      name: 'fashion',
      desc: '',
      args: [],
    );
  }

  /// `Visual Arts`
  String get visual_arts {
    return Intl.message(
      'Visual Arts',
      name: 'visual_arts',
      desc: '',
      args: [],
    );
  }

  /// `Law`
  String get law {
    return Intl.message(
      'Law',
      name: 'law',
      desc: '',
      args: [],
    );
  }

  /// `Medicine`
  String get medicine {
    return Intl.message(
      'Medicine',
      name: 'medicine',
      desc: '',
      args: [],
    );
  }

  /// `Geography`
  String get geography {
    return Intl.message(
      'Geography',
      name: 'geography',
      desc: '',
      args: [],
    );
  }

  /// `Performative Arts`
  String get performative_arts {
    return Intl.message(
      'Performative Arts',
      name: 'performative_arts',
      desc: '',
      args: [],
    );
  }

  /// `Other`
  String get other {
    return Intl.message(
      'Other',
      name: 'other',
      desc: '',
      args: [],
    );
  }

  /// `Publication date (latest first)`
  String get publication_date_latest {
    return Intl.message(
      'Publication date (latest first)',
      name: 'publication_date_latest',
      desc: '',
      args: [],
    );
  }

  /// `Publication date (oldest first)`
  String get publication_date_oldest {
    return Intl.message(
      'Publication date (oldest first)',
      name: 'publication_date_oldest',
      desc: '',
      args: [],
    );
  }

  /// `Course name (alphabetical)`
  String get course_name_az {
    return Intl.message(
      'Course name (alphabetical)',
      name: 'course_name_az',
      desc: '',
      args: [],
    );
  }

  /// `Course name (reverse alphabetical)`
  String get course_name_za {
    return Intl.message(
      'Course name (reverse alphabetical)',
      name: 'course_name_za',
      desc: '',
      args: [],
    );
  }

  /// `Author username (alphabetical)`
  String get author_username_az {
    return Intl.message(
      'Author username (alphabetical)',
      name: 'author_username_az',
      desc: '',
      args: [],
    );
  }

  /// `Author username (reverse alphabetical)`
  String get author_username_za {
    return Intl.message(
      'Author username (reverse alphabetical)',
      name: 'author_username_za',
      desc: '',
      args: [],
    );
  }

  /// `Best rated`
  String get best_rated {
    return Intl.message(
      'Best rated',
      name: 'best_rated',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `English`
  String get english {
    return Intl.message(
      'English',
      name: 'english',
      desc: '',
      args: [],
    );
  }

  /// `Italian`
  String get italian {
    return Intl.message(
      'Italian',
      name: 'italian',
      desc: '',
      args: [],
    );
  }

  /// `followers`
  String get followers {
    return Intl.message(
      'followers',
      name: 'followers',
      desc: '',
      args: [],
    );
  }

  /// `following`
  String get following {
    return Intl.message(
      'following',
      name: 'following',
      desc: '',
      args: [],
    );
  }

  /// `Account Settings`
  String get account_settings_title {
    return Intl.message(
      'Account Settings',
      name: 'account_settings_title',
      desc: '',
      args: [],
    );
  }

  /// `Browse and update your user data and preferences.`
  String get account_settings_description {
    return Intl.message(
      'Browse and update your user data and preferences.',
      name: 'account_settings_description',
      desc: '',
      args: [],
    );
  }

  /// `Notification Settings`
  String get notification_settings_title {
    return Intl.message(
      'Notification Settings',
      name: 'notification_settings_title',
      desc: '',
      args: [],
    );
  }

  /// `Choose which notifications you wish to receive.`
  String get notification_settings_description {
    return Intl.message(
      'Choose which notifications you wish to receive.',
      name: 'notification_settings_description',
      desc: '',
      args: [],
    );
  }

  /// `External Accounts`
  String get external_accounts_title {
    return Intl.message(
      'External Accounts',
      name: 'external_accounts_title',
      desc: '',
      args: [],
    );
  }

  /// `Manage which external accounts you want to link to bloQo.`
  String get external_accounts_description {
    return Intl.message(
      'Manage which external accounts you want to link to bloQo.',
      name: 'external_accounts_description',
      desc: '',
      args: [],
    );
  }

  /// `Sign Out`
  String get sign_out_title {
    return Intl.message(
      'Sign Out',
      name: 'sign_out_title',
      desc: '',
      args: [],
    );
  }

  /// `Log out of the application.`
  String get sign_out_description {
    return Intl.message(
      'Log out of the application.',
      name: 'sign_out_description',
      desc: '',
      args: [],
    );
  }

  /// `Save Settings`
  String get save_settings {
    return Intl.message(
      'Save Settings',
      name: 'save_settings',
      desc: '',
      args: [],
    );
  }

  /// `Done.`
  String get done {
    return Intl.message(
      'Done.',
      name: 'done',
      desc: '',
      args: [],
    );
  }

  /// `Warning!`
  String get warning {
    return Intl.message(
      'Warning!',
      name: 'warning',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to log out of the application? If you confirm, the next time you open bloQo you will have to log in.`
  String get logout_confirmation {
    return Intl.message(
      'Are you sure you want to log out of the application? If you confirm, the next time you open bloQo you will have to log in.',
      name: 'logout_confirmation',
      desc: '',
      args: [],
    );
  }

  /// `In progress`
  String get in_progress {
    return Intl.message(
      'In progress',
      name: 'in_progress',
      desc: '',
      args: [],
    );
  }

  /// `These are the courses you are creating.`
  String get editor_page_header_1 {
    return Intl.message(
      'These are the courses you are creating.',
      name: 'editor_page_header_1',
      desc: '',
      args: [],
    );
  }

  /// `These are the courses you published.`
  String get editor_page_header_2 {
    return Intl.message(
      'These are the courses you published.',
      name: 'editor_page_header_2',
      desc: '',
      args: [],
    );
  }

  /// `Publish`
  String get publish {
    return Intl.message(
      'Publish',
      name: 'publish',
      desc: '',
      args: [],
    );
  }

  /// `New Course`
  String get new_course {
    return Intl.message(
      'New Course',
      name: 'new_course',
      desc: '',
      args: [],
    );
  }

  /// `You are currently creating no course. Start creating one now!`
  String get editor_page_no_in_progress_courses {
    return Intl.message(
      'You are currently creating no course. Start creating one now!',
      name: 'editor_page_no_in_progress_courses',
      desc: '',
      args: [],
    );
  }

  /// `chapters`
  String get chapters {
    return Intl.message(
      'chapters',
      name: 'chapters',
      desc: '',
      args: [],
    );
  }

  /// `sections`
  String get sections {
    return Intl.message(
      'sections',
      name: 'sections',
      desc: '',
      args: [],
    );
  }

  /// `View statistics`
  String get view_statistics {
    return Intl.message(
      'View statistics',
      name: 'view_statistics',
      desc: '',
      args: [],
    );
  }

  /// `Dismiss`
  String get dismiss {
    return Intl.message(
      'Dismiss',
      name: 'dismiss',
      desc: '',
      args: [],
    );
  }

  /// `Published`
  String get published {
    return Intl.message(
      'Published',
      name: 'published',
      desc: '',
      args: [],
    );
  }

  /// `Enrollings`
  String get enrollings {
    return Intl.message(
      'Enrollings',
      name: 'enrollings',
      desc: '',
      args: [],
    );
  }

  /// `Completed`
  String get completed {
    return Intl.message(
      'Completed',
      name: 'completed',
      desc: '',
      args: [],
    );
  }

  /// `These are the courses you are enrolled in.`
  String get learn_page_header_1 {
    return Intl.message(
      'These are the courses you are enrolled in.',
      name: 'learn_page_header_1',
      desc: '',
      args: [],
    );
  }

  /// `These are the courses you completed.`
  String get learn_page_header_2 {
    return Intl.message(
      'These are the courses you completed.',
      name: 'learn_page_header_2',
      desc: '',
      args: [],
    );
  }

  /// `You are not enrolled in any courses. Start learning now!`
  String get learn_page_no_in_progress_courses {
    return Intl.message(
      'You are not enrolled in any courses. Start learning now!',
      name: 'learn_page_no_in_progress_courses',
      desc: '',
      args: [],
    );
  }

  /// `You have no completed courses.`
  String get learn_page_no_completed_courses {
    return Intl.message(
      'You have no completed courses.',
      name: 'learn_page_no_completed_courses',
      desc: '',
      args: [],
    );
  }

  /// `You have published no course for the community yet. Go create one now and publish it!`
  String get editor_page_no_published_courses {
    return Intl.message(
      'You have published no course for the community yet. Go create one now and publish it!',
      name: 'editor_page_no_published_courses',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get delete {
    return Intl.message(
      'Delete',
      name: 'delete',
      desc: '',
      args: [],
    );
  }

  /// `By confirming, this course will be permanently deleted and cannot be restored in any way. Do you wish to proceed?`
  String get delete_course_confirmation {
    return Intl.message(
      'By confirming, this course will be permanently deleted and cannot be restored in any way. Do you wish to proceed?',
      name: 'delete_course_confirmation',
      desc: '',
      args: [],
    );
  }

  /// `Content`
  String get content {
    return Intl.message(
      'Content',
      name: 'content',
      desc: '',
      args: [],
    );
  }

  /// `Continue learning!`
  String get continue_learning {
    return Intl.message(
      'Continue learning!',
      name: 'continue_learning',
      desc: '',
      args: [],
    );
  }

  /// `By confirming, this chapter will be permanently deleted and cannot be restored in any way. Do you wish to proceed?`
  String get delete_chapter_confirmation {
    return Intl.message(
      'By confirming, this chapter will be permanently deleted and cannot be restored in any way. Do you wish to proceed?',
      name: 'delete_chapter_confirmation',
      desc: '',
      args: [],
    );
  }

  /// `By confirming, this section will be permanently deleted and cannot be restored in any way. Do you wish to proceed?`
  String get delete_section_confirmation {
    return Intl.message(
      'By confirming, this section will be permanently deleted and cannot be restored in any way. Do you wish to proceed?',
      name: 'delete_section_confirmation',
      desc: '',
      args: [],
    );
  }

  /// `By confirming, this block will be permanently deleted and cannot be restored in any way. Do you wish to proceed?`
  String get delete_block_confirmation {
    return Intl.message(
      'By confirming, this block will be permanently deleted and cannot be restored in any way. Do you wish to proceed?',
      name: 'delete_block_confirmation',
      desc: '',
      args: [],
    );
  }

  /// `By confirming, this file will be permanently deleted and cannot be restored in any way. Do you wish to proceed?`
  String get delete_file_confirmation {
    return Intl.message(
      'By confirming, this file will be permanently deleted and cannot be restored in any way. Do you wish to proceed?',
      name: 'delete_file_confirmation',
      desc: '',
      args: [],
    );
  }

  /// `By confirming, this answer will be permanently deleted and cannot be restored in any way. Do you wish to proceed?`
  String get delete_answer_confirmation {
    return Intl.message(
      'By confirming, this answer will be permanently deleted and cannot be restored in any way. Do you wish to proceed?',
      name: 'delete_answer_confirmation',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get name {
    return Intl.message(
      'Name',
      name: 'name',
      desc: '',
      args: [],
    );
  }

  /// `Description`
  String get description {
    return Intl.message(
      'Description',
      name: 'description',
      desc: '',
      args: [],
    );
  }

  /// `Enter the course name here`
  String get editor_course_name_hint {
    return Intl.message(
      'Enter the course name here',
      name: 'editor_course_name_hint',
      desc: '',
      args: [],
    );
  }

  /// `Enter the course description here`
  String get editor_course_description_hint {
    return Intl.message(
      'Enter the course description here',
      name: 'editor_course_description_hint',
      desc: '',
      args: [],
    );
  }

  /// `Enter the chapter name here`
  String get editor_chapter_name_hint {
    return Intl.message(
      'Enter the chapter name here',
      name: 'editor_chapter_name_hint',
      desc: '',
      args: [],
    );
  }

  /// `Enter the chapter description here`
  String get editor_chapter_description_hint {
    return Intl.message(
      'Enter the chapter description here',
      name: 'editor_chapter_description_hint',
      desc: '',
      args: [],
    );
  }

  /// `Enter the section name here`
  String get editor_section_name_hint {
    return Intl.message(
      'Enter the section name here',
      name: 'editor_section_name_hint',
      desc: '',
      args: [],
    );
  }

  /// `Add Chapter`
  String get add_chapter {
    return Intl.message(
      'Add Chapter',
      name: 'add_chapter',
      desc: '',
      args: [],
    );
  }

  /// `Add Section`
  String get add_section {
    return Intl.message(
      'Add Section',
      name: 'add_section',
      desc: '',
      args: [],
    );
  }

  /// `Add Block`
  String get add_block {
    return Intl.message(
      'Add Block',
      name: 'add_block',
      desc: '',
      args: [],
    );
  }

  /// `Text Block`
  String get text_block {
    return Intl.message(
      'Text Block',
      name: 'text_block',
      desc: '',
      args: [],
    );
  }

  /// `Multimedia Block`
  String get multimedia_block {
    return Intl.message(
      'Multimedia Block',
      name: 'multimedia_block',
      desc: '',
      args: [],
    );
  }

  /// `Quiz Block`
  String get quiz_block {
    return Intl.message(
      'Quiz Block',
      name: 'quiz_block',
      desc: '',
      args: [],
    );
  }

  /// `Save Changes`
  String get save_changes {
    return Intl.message(
      'Save Changes',
      name: 'save_changes',
      desc: '',
      args: [],
    );
  }

  /// `Chapters`
  String get chapters_header {
    return Intl.message(
      'Chapters',
      name: 'chapters_header',
      desc: '',
      args: [],
    );
  }

  /// `Sections`
  String get sections_header {
    return Intl.message(
      'Sections',
      name: 'sections_header',
      desc: '',
      args: [],
    );
  }

  /// `Blocks`
  String get blocks_header {
    return Intl.message(
      'Blocks',
      name: 'blocks_header',
      desc: '',
      args: [],
    );
  }

  /// `This course has no chapters yet. Create one now!`
  String get edit_course_page_no_chapters {
    return Intl.message(
      'This course has no chapters yet. Create one now!',
      name: 'edit_course_page_no_chapters',
      desc: '',
      args: [],
    );
  }

  /// `This chapter has no sections yet. Create one now!`
  String get edit_chapter_page_no_sections {
    return Intl.message(
      'This chapter has no sections yet. Create one now!',
      name: 'edit_chapter_page_no_sections',
      desc: '',
      args: [],
    );
  }

  /// `This section has no blocks yet. Create one now!`
  String get edit_section_page_no_blocks {
    return Intl.message(
      'This section has no blocks yet. Create one now!',
      name: 'edit_section_page_no_blocks',
      desc: '',
      args: [],
    );
  }

  /// `This quiz has no answers yet. Create one now!`
  String get edit_block_quiz_page_no_answers {
    return Intl.message(
      'This quiz has no answers yet. Create one now!',
      name: 'edit_block_quiz_page_no_answers',
      desc: '',
      args: [],
    );
  }

  /// `Course`
  String get course {
    return Intl.message(
      'Course',
      name: 'course',
      desc: '',
      args: [],
    );
  }

  /// `Chapter`
  String get chapter {
    return Intl.message(
      'Chapter',
      name: 'chapter',
      desc: '',
      args: [],
    );
  }

  /// `Section`
  String get section {
    return Intl.message(
      'Section',
      name: 'section',
      desc: '',
      args: [],
    );
  }

  /// `Enrolled on:`
  String get enrolled_on {
    return Intl.message(
      'Enrolled on:',
      name: 'enrolled_on',
      desc: '',
      args: [],
    );
  }

  /// `Not completed`
  String get not_completed {
    return Intl.message(
      'Not completed',
      name: 'not_completed',
      desc: '',
      args: [],
    );
  }

  /// `View more`
  String get view_more {
    return Intl.message(
      'View more',
      name: 'view_more',
      desc: '',
      args: [],
    );
  }

  /// `Collapse`
  String get collapse {
    return Intl.message(
      'Collapse',
      name: 'collapse',
      desc: '',
      args: [],
    );
  }

  /// `These are the courses that match your search`
  String get search_results_header {
    return Intl.message(
      'These are the courses that match your search',
      name: 'search_results_header',
      desc: '',
      args: [],
    );
  }

  /// `It seems there are no corresponding courses. Search for a new one!`
  String get no_search_results {
    return Intl.message(
      'It seems there are no corresponding courses. Search for a new one!',
      name: 'no_search_results',
      desc: '',
      args: [],
    );
  }

  /// `Public`
  String get public {
    return Intl.message(
      'Public',
      name: 'public',
      desc: '',
      args: [],
    );
  }

  /// `Private`
  String get private {
    return Intl.message(
      'Private',
      name: 'private',
      desc: '',
      args: [],
    );
  }

  /// `Published on: `
  String get published_on {
    return Intl.message(
      'Published on: ',
      name: 'published_on',
      desc: '',
      args: [],
    );
  }

  /// `Enroll in Course`
  String get enroll_in {
    return Intl.message(
      'Enroll in Course',
      name: 'enroll_in',
      desc: '',
      args: [],
    );
  }

  /// `Unsubscribe`
  String get unsubscribe {
    return Intl.message(
      'Unsubscribe',
      name: 'unsubscribe',
      desc: '',
      args: [],
    );
  }

  /// `by `
  String get by {
    return Intl.message(
      'by ',
      name: 'by',
      desc: '',
      args: [],
    );
  }

  /// `Reviews`
  String get reviews {
    return Intl.message(
      'Reviews',
      name: 'reviews',
      desc: '',
      args: [],
    );
  }

  /// `There are no reviews yet.`
  String get no_reviews_yet {
    return Intl.message(
      'There are no reviews yet.',
      name: 'no_reviews_yet',
      desc: '',
      args: [],
    );
  }

  /// `Block`
  String get block {
    return Intl.message(
      'Block',
      name: 'block',
      desc: '',
      args: [],
    );
  }

  /// `Text`
  String get text {
    return Intl.message(
      'Text',
      name: 'text',
      desc: '',
      args: [],
    );
  }

  /// `Multimedia`
  String get multimedia {
    return Intl.message(
      'Multimedia',
      name: 'multimedia',
      desc: '',
      args: [],
    );
  }

  /// `Quiz`
  String get quiz {
    return Intl.message(
      'Quiz',
      name: 'quiz',
      desc: '',
      args: [],
    );
  }

  /// `Multimedia: Video`
  String get multimedia_video {
    return Intl.message(
      'Multimedia: Video',
      name: 'multimedia_video',
      desc: '',
      args: [],
    );
  }

  /// `Multimedia: Image`
  String get multimedia_image {
    return Intl.message(
      'Multimedia: Image',
      name: 'multimedia_image',
      desc: '',
      args: [],
    );
  }

  /// `Multimedia: Audio`
  String get multimedia_audio {
    return Intl.message(
      'Multimedia: Audio',
      name: 'multimedia_audio',
      desc: '',
      args: [],
    );
  }

  /// `Video`
  String get multimedia_video_short {
    return Intl.message(
      'Video',
      name: 'multimedia_video_short',
      desc: '',
      args: [],
    );
  }

  /// `Image`
  String get multimedia_image_short {
    return Intl.message(
      'Image',
      name: 'multimedia_image_short',
      desc: '',
      args: [],
    );
  }

  /// `Audio`
  String get multimedia_audio_short {
    return Intl.message(
      'Audio',
      name: 'multimedia_audio_short',
      desc: '',
      args: [],
    );
  }

  /// `Quiz: Multiple choice`
  String get quiz_multiple_choice {
    return Intl.message(
      'Quiz: Multiple choice',
      name: 'quiz_multiple_choice',
      desc: '',
      args: [],
    );
  }

  /// `Quiz: Open question`
  String get quiz_open_question {
    return Intl.message(
      'Quiz: Open question',
      name: 'quiz_open_question',
      desc: '',
      args: [],
    );
  }

  /// `Multiple choice`
  String get quiz_multiple_choice_short {
    return Intl.message(
      'Multiple choice',
      name: 'quiz_multiple_choice_short',
      desc: '',
      args: [],
    );
  }

  /// `Open question`
  String get quiz_open_question_short {
    return Intl.message(
      'Open question',
      name: 'quiz_open_question_short',
      desc: '',
      args: [],
    );
  }

  /// `Write your text here`
  String get write_text_here {
    return Intl.message(
      'Write your text here',
      name: 'write_text_here',
      desc: '',
      args: [],
    );
  }

  /// `Preview`
  String get preview {
    return Intl.message(
      'Preview',
      name: 'preview',
      desc: '',
      args: [],
    );
  }

  /// `Choose the multimedia type`
  String get choose_multimedia_type {
    return Intl.message(
      'Choose the multimedia type',
      name: 'choose_multimedia_type',
      desc: '',
      args: [],
    );
  }

  /// `Choose the quiz type`
  String get choose_quiz_type {
    return Intl.message(
      'Choose the quiz type',
      name: 'choose_quiz_type',
      desc: '',
      args: [],
    );
  }

  /// `Upload an audio`
  String get upload_audio {
    return Intl.message(
      'Upload an audio',
      name: 'upload_audio',
      desc: '',
      args: [],
    );
  }

  /// `Upload an image`
  String get upload_image {
    return Intl.message(
      'Upload an image',
      name: 'upload_image',
      desc: '',
      args: [],
    );
  }

  /// `Upload a video`
  String get upload_video {
    return Intl.message(
      'Upload a video',
      name: 'upload_video',
      desc: '',
      args: [],
    );
  }

  /// `Upload from device`
  String get upload_from_device {
    return Intl.message(
      'Upload from device',
      name: 'upload_from_device',
      desc: '',
      args: [],
    );
  }

  /// `Embed from YouTube`
  String get embed_from_youtube {
    return Intl.message(
      'Embed from YouTube',
      name: 'embed_from_youtube',
      desc: '',
      args: [],
    );
  }

  /// `Delete file`
  String get delete_file {
    return Intl.message(
      'Delete file',
      name: 'delete_file',
      desc: '',
      args: [],
    );
  }

  /// `YouTube link`
  String get youtube_link {
    return Intl.message(
      'YouTube link',
      name: 'youtube_link',
      desc: '',
      args: [],
    );
  }

  /// `Enter your YouTube link here`
  String get enter_youtube_link {
    return Intl.message(
      'Enter your YouTube link here',
      name: 'enter_youtube_link',
      desc: '',
      args: [],
    );
  }

  /// `Embed`
  String get embed {
    return Intl.message(
      'Embed',
      name: 'embed',
      desc: '',
      args: [],
    );
  }

  /// `Oops, we are not able to find that YouTube video. Please try again with another link.`
  String get invalid_link {
    return Intl.message(
      'Oops, we are not able to find that YouTube video. Please try again with another link.',
      name: 'invalid_link',
      desc: '',
      args: [],
    );
  }

  /// `Enter a question`
  String get enter_question {
    return Intl.message(
      'Enter a question',
      name: 'enter_question',
      desc: '',
      args: [],
    );
  }

  /// `Save quiz changes`
  String get save_quiz_changes {
    return Intl.message(
      'Save quiz changes',
      name: 'save_quiz_changes',
      desc: '',
      args: [],
    );
  }

  /// `Question`
  String get question {
    return Intl.message(
      'Question',
      name: 'question',
      desc: '',
      args: [],
    );
  }

  /// `Enter your question here`
  String get enter_question_here {
    return Intl.message(
      'Enter your question here',
      name: 'enter_question_here',
      desc: '',
      args: [],
    );
  }

  /// `Enter your answer here`
  String get enter_answer_here {
    return Intl.message(
      'Enter your answer here',
      name: 'enter_answer_here',
      desc: '',
      args: [],
    );
  }

  /// `Enter the possible answers`
  String get enter_possible_answers {
    return Intl.message(
      'Enter the possible answers',
      name: 'enter_possible_answers',
      desc: '',
      args: [],
    );
  }

  /// `You cannot submit a quiz with an empty question!`
  String get question_not_empty_error {
    return Intl.message(
      'You cannot submit a quiz with an empty question!',
      name: 'question_not_empty_error',
      desc: '',
      args: [],
    );
  }

  /// `You cannot submit a quiz with an empty answer!`
  String get answer_not_empty_error {
    return Intl.message(
      'You cannot submit a quiz with an empty answer!',
      name: 'answer_not_empty_error',
      desc: '',
      args: [],
    );
  }

  /// `You cannot submit a multiple choice quiz without a correct answer!`
  String get no_correct_answer_error {
    return Intl.message(
      'You cannot submit a multiple choice quiz without a correct answer!',
      name: 'no_correct_answer_error',
      desc: '',
      args: [],
    );
  }

  /// `You cannot submit a multiple choice quiz with no answers!`
  String get no_answers_error {
    return Intl.message(
      'You cannot submit a multiple choice quiz with no answers!',
      name: 'no_answers_error',
      desc: '',
      args: [],
    );
  }

  /// `Add answer`
  String get add_answer {
    return Intl.message(
      'Add answer',
      name: 'add_answer',
      desc: '',
      args: [],
    );
  }

  /// `Answer`
  String get answer {
    return Intl.message(
      'Answer',
      name: 'answer',
      desc: '',
      args: [],
    );
  }

  /// `Is this answer correct?`
  String get is_answer_correct {
    return Intl.message(
      'Is this answer correct?',
      name: 'is_answer_correct',
      desc: '',
      args: [],
    );
  }

  /// `Enter the answer`
  String get enter_answer {
    return Intl.message(
      'Enter the answer',
      name: 'enter_answer',
      desc: '',
      args: [],
    );
  }

  /// `Trim extra whitespaces at the beginning and at the end?`
  String get trim_extra_whitespaces {
    return Intl.message(
      'Trim extra whitespaces at the beginning and at the end?',
      name: 'trim_extra_whitespaces',
      desc: '',
      args: [],
    );
  }

  /// `Should comparison ignore case?`
  String get comparison_ignore_case {
    return Intl.message(
      'Should comparison ignore case?',
      name: 'comparison_ignore_case',
      desc: '',
      args: [],
    );
  }

  /// `Play Audio`
  String get play_audio {
    return Intl.message(
      'Play Audio',
      name: 'play_audio',
      desc: '',
      args: [],
    );
  }

  /// `Pause Audio`
  String get pause_audio {
    return Intl.message(
      'Pause Audio',
      name: 'pause_audio',
      desc: '',
      args: [],
    );
  }

  /// `Publish your course for the bloQo community!`
  String get publish_course_page_header_1 {
    return Intl.message(
      'Publish your course for the bloQo community!',
      name: 'publish_course_page_header_1',
      desc: '',
      args: [],
    );
  }

  /// `You cannot modify the course once it is published, so check it carefully before continuing.`
  String get publish_course_page_header_2 {
    return Intl.message(
      'You cannot modify the course once it is published, so check it carefully before continuing.',
      name: 'publish_course_page_header_2',
      desc: '',
      args: [],
    );
  }

  /// `Choose the best tags for your course`
  String get publish_course_page_tag_header {
    return Intl.message(
      'Choose the best tags for your course',
      name: 'publish_course_page_tag_header',
      desc: '',
      args: [],
    );
  }

  /// `Choose whether your course will be public or private`
  String get publish_course_page_public_private_header {
    return Intl.message(
      'Choose whether your course will be public or private',
      name: 'publish_course_page_public_private_header',
      desc: '',
      args: [],
    );
  }

  /// `Should your course be freely accessible by anyone?`
  String get publish_course_page_public_private_question {
    return Intl.message(
      'Should your course be freely accessible by anyone?',
      name: 'publish_course_page_public_private_question',
      desc: '',
      args: [],
    );
  }

  /// `You need to select a tag for every kind of tag to be able to publish a course!`
  String get missing_tag_error {
    return Intl.message(
      'You need to select a tag for every kind of tag to be able to publish a course!',
      name: 'missing_tag_error',
      desc: '',
      args: [],
    );
  }

  /// `By confirming, this course will be published. Do you wish to continue?`
  String get course_publish_confirmation {
    return Intl.message(
      'By confirming, this course will be published. Do you wish to continue?',
      name: 'course_publish_confirmation',
      desc: '',
      args: [],
    );
  }

  /// `You cannot enroll in a course you created!`
  String get creator_cannot_subscribe {
    return Intl.message(
      'You cannot enroll in a course you created!',
      name: 'creator_cannot_subscribe',
      desc: '',
      args: [],
    );
  }

  /// `By confirming, you will be unsubscribed from this course and will loose every progress made so far with respect to the course. Do you wish to proceed?`
  String get unsubscribe_confirmation {
    return Intl.message(
      'By confirming, you will be unsubscribed from this course and will loose every progress made so far with respect to the course. Do you wish to proceed?',
      name: 'unsubscribe_confirmation',
      desc: '',
      args: [],
    );
  }

  /// `Start learning!`
  String get start_learning {
    return Intl.message(
      'Start learning!',
      name: 'start_learning',
      desc: '',
      args: [],
    );
  }

  /// `Statistics`
  String get statistics {
    return Intl.message(
      'Statistics',
      name: 'statistics',
      desc: '',
      args: [],
    );
  }

  /// `users enrolled in this course`
  String get users_enrolled {
    return Intl.message(
      'users enrolled in this course',
      name: 'users_enrolled',
      desc: '',
      args: [],
    );
  }

  /// `users completed this course`
  String get users_completed {
    return Intl.message(
      'users completed this course',
      name: 'users_completed',
      desc: '',
      args: [],
    );
  }

  /// `By confirming, this course will be removed from the bloQo community. This means that everyone who enrolled in this course will no more be able to access its content, and no one will be able to enroll in this course until you publish it again. Do you wish to continue?`
  String get course_dismiss_confirmation {
    return Intl.message(
      'By confirming, this course will be removed from the bloQo community. This means that everyone who enrolled in this course will no more be able to access its content, and no one will be able to enroll in this course until you publish it again. Do you wish to continue?',
      name: 'course_dismiss_confirmation',
      desc: '',
      args: [],
    );
  }

  /// `Courses created by `
  String get published_courses_by_author {
    return Intl.message(
      'Courses created by ',
      name: 'published_courses_by_author',
      desc: '',
      args: [],
    );
  }

  /// `Your answer`
  String get your_answer {
    return Intl.message(
      'Your answer',
      name: 'your_answer',
      desc: '',
      args: [],
    );
  }

  /// `Correct!`
  String get correct {
    return Intl.message(
      'Correct!',
      name: 'correct',
      desc: '',
      args: [],
    );
  }

  /// `The correct answer is: `
  String get correct_answer {
    return Intl.message(
      'The correct answer is: ',
      name: 'correct_answer',
      desc: '',
      args: [],
    );
  }

  /// `Wrong...`
  String get wrong {
    return Intl.message(
      'Wrong...',
      name: 'wrong',
      desc: '',
      args: [],
    );
  }

  /// `Confirm`
  String get confirm {
    return Intl.message(
      'Confirm',
      name: 'confirm',
      desc: '',
      args: [],
    );
  }

  /// `Learned!`
  String get learned {
    return Intl.message(
      'Learned!',
      name: 'learned',
      desc: '',
      args: [],
    );
  }

  /// `You learned everything!`
  String get learned_all {
    return Intl.message(
      'You learned everything!',
      name: 'learned_all',
      desc: '',
      args: [],
    );
  }

  /// `Get QR Code`
  String get get_qr_code {
    return Intl.message(
      'Get QR Code',
      name: 'get_qr_code',
      desc: '',
      args: [],
    );
  }

  /// `Notifications`
  String get notifications {
    return Intl.message(
      'Notifications',
      name: 'notifications',
      desc: '',
      args: [],
    );
  }

  /// `There are no notifications to show.`
  String get no_notifications {
    return Intl.message(
      'There are no notifications to show.',
      name: 'no_notifications',
      desc: '',
      args: [],
    );
  }

  /// `There are no users to show.`
  String get no_users {
    return Intl.message(
      'There are no users to show.',
      name: 'no_users',
      desc: '',
      args: [],
    );
  }

  /// `has requested access to the following course:`
  String get has_requested_access {
    return Intl.message(
      'has requested access to the following course:',
      name: 'has_requested_access',
      desc: '',
      args: [],
    );
  }

  /// `has granted access to the following course:`
  String get has_granted_access {
    return Intl.message(
      'has granted access to the following course:',
      name: 'has_granted_access',
      desc: '',
      args: [],
    );
  }

  /// `has published a new course:`
  String get has_published_new_course {
    return Intl.message(
      'has published a new course:',
      name: 'has_published_new_course',
      desc: '',
      args: [],
    );
  }

  /// `Accept`
  String get accept {
    return Intl.message(
      'Accept',
      name: 'accept',
      desc: '',
      args: [],
    );
  }

  /// `Deny`
  String get deny {
    return Intl.message(
      'Deny',
      name: 'deny',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to allow the access to your course?`
  String get accept_enrollment_confirmation {
    return Intl.message(
      'Are you sure you want to allow the access to your course?',
      name: 'accept_enrollment_confirmation',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to deny the access to your course?`
  String get deny_enrollment_confirmation {
    return Intl.message(
      'Are you sure you want to deny the access to your course?',
      name: 'deny_enrollment_confirmation',
      desc: '',
      args: [],
    );
  }

  /// `Request Access`
  String get request_access {
    return Intl.message(
      'Request Access',
      name: 'request_access',
      desc: '',
      args: [],
    );
  }

  /// `You have already requested access to this course, and the course author has to review it. Please wait and try again.`
  String get already_requested_access_error {
    return Intl.message(
      'You have already requested access to this course, and the course author has to review it. Please wait and try again.',
      name: 'already_requested_access_error',
      desc: '',
      args: [],
    );
  }

  /// `Rate`
  String get rate {
    return Intl.message(
      'Rate',
      name: 'rate',
      desc: '',
      args: [],
    );
  }

  /// `Rated`
  String get rated {
    return Intl.message(
      'Rated',
      name: 'rated',
      desc: '',
      args: [],
    );
  }

  /// `Your review`
  String get your_review {
    return Intl.message(
      'Your review',
      name: 'your_review',
      desc: '',
      args: [],
    );
  }

  /// `Review`
  String get review {
    return Intl.message(
      'Review',
      name: 'review',
      desc: '',
      args: [],
    );
  }

  /// `What do you think of this course?`
  String get review_headliner_to_rate {
    return Intl.message(
      'What do you think of this course?',
      name: 'review_headliner_to_rate',
      desc: '',
      args: [],
    );
  }

  /// `Here is your review!`
  String get review_headliner_rated {
    return Intl.message(
      'Here is your review!',
      name: 'review_headliner_rated',
      desc: '',
      args: [],
    );
  }

  /// `Review title`
  String get review_title {
    return Intl.message(
      'Review title',
      name: 'review_title',
      desc: '',
      args: [],
    );
  }

  /// `Title`
  String get title {
    return Intl.message(
      'Title',
      name: 'title',
      desc: '',
      args: [],
    );
  }

  /// `Okay!`
  String get okay {
    return Intl.message(
      'Okay!',
      name: 'okay',
      desc: '',
      args: [],
    );
  }

  /// `Follow`
  String get follow {
    return Intl.message(
      'Follow',
      name: 'follow',
      desc: '',
      args: [],
    );
  }

  /// `Unfollow`
  String get unfollow {
    return Intl.message(
      'Unfollow',
      name: 'unfollow',
      desc: '',
      args: [],
    );
  }

  /// `Users who follow `
  String get users_who_follow {
    return Intl.message(
      'Users who follow ',
      name: 'users_who_follow',
      desc: '',
      args: [],
    );
  }

  /// `Users who are followed by `
  String get users_who_are_followed_by {
    return Intl.message(
      'Users who are followed by ',
      name: 'users_who_are_followed_by',
      desc: '',
      args: [],
    );
  }

  /// `Get certificate`
  String get get_certificate {
    return Intl.message(
      'Get certificate',
      name: 'get_certificate',
      desc: '',
      args: [],
    );
  }

  /// `Course Completion Certificate`
  String get course_completion_certificate {
    return Intl.message(
      'Course Completion Certificate',
      name: 'course_completion_certificate',
      desc: '',
      args: [],
    );
  }

  /// `assigned to:`
  String get assigned_to {
    return Intl.message(
      'assigned to:',
      name: 'assigned_to',
      desc: '',
      args: [],
    );
  }

  /// `for successfully completing the following course:`
  String get for_successfully_completing_course {
    return Intl.message(
      'for successfully completing the following course:',
      name: 'for_successfully_completing_course',
      desc: '',
      args: [],
    );
  }

  /// `Date`
  String get date {
    return Intl.message(
      'Date',
      name: 'date',
      desc: '',
      args: [],
    );
  }

  /// `Application Settings`
  String get application_settings_title {
    return Intl.message(
      'Application Settings',
      name: 'application_settings_title',
      desc: '',
      args: [],
    );
  }

  /// `Modify your experience with bloQo to best use the application.`
  String get application_settings_description {
    return Intl.message(
      'Modify your experience with bloQo to best use the application.',
      name: 'application_settings_description',
      desc: '',
      args: [],
    );
  }

  /// `Language`
  String get language {
    return Intl.message(
      'Language',
      name: 'language',
      desc: '',
      args: [],
    );
  }

  /// `Theme`
  String get theme {
    return Intl.message(
      'Theme',
      name: 'theme',
      desc: '',
      args: [],
    );
  }

  /// `Purple Orchid`
  String get purple_orchid {
    return Intl.message(
      'Purple Orchid',
      name: 'purple_orchid',
      desc: '',
      args: [],
    );
  }

  /// `Ocean Cornflower`
  String get ocean_cornflower {
    return Intl.message(
      'Ocean Cornflower',
      name: 'ocean_cornflower',
      desc: '',
      args: [],
    );
  }

  /// `You haven't finished all the quizzes.`
  String get section_is_not_completed {
    return Intl.message(
      'You haven\'t finished all the quizzes.',
      name: 'section_is_not_completed',
      desc: '',
      args: [],
    );
  }

  /// `Completed`
  String get completed_section {
    return Intl.message(
      'Completed',
      name: 'completed_section',
      desc: '',
      args: [],
    );
  }

  /// `Course completed!`
  String get course_completed {
    return Intl.message(
      'Course completed!',
      name: 'course_completed',
      desc: '',
      args: [],
    );
  }

  /// `You already completed the course, so you cannot unsubscribe to it.`
  String get cannot_unsubscribe_course_completed {
    return Intl.message(
      'You already completed the course, so you cannot unsubscribe to it.',
      name: 'cannot_unsubscribe_course_completed',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'it'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
