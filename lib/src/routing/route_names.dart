/// Every route in the application, as a type.
///
/// An enum rather than a set of string constants. The difference is not
/// cosmetic: `RouteName.dashbaord` does not compile, whereas `'dashbaord'`
/// compiles perfectly and fails at runtime, in front of a user, as a blank
/// screen. Route names are typed here so that the compiler is the thing that
/// catches the typo.
///
/// Dart's built-in `.name` on an enum yields the identifier as a string —
/// `RouteName.dashboard.name` is `'dashboard'` — which is exactly the form
/// `GoRouter` wants for named routes. No parallel string table is needed, and
/// therefore none can fall out of step.
enum RouteName {
  /// The application root. Not a screen in its own right — see
  /// TASK_009_REPORT.md on the relationship between [home] and [dashboard].
  home,

  dashboard,

  accounts,

  transactions,

  assets,

  goals,

  reports,

  settings,
}
