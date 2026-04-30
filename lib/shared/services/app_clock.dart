import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Debug-only simulated clock.
///
/// When an override is active, [now] returns the picked instant plus the
/// real-wall-clock delta since the override was set, so simulated time still
/// ticks forward naturally. Persisted across launches via [SharedPreferences];
/// only consulted in `kDebugMode` UI gates.
class AppClock extends ChangeNotifier {
  AppClock(this._prefs) {
    _load();
  }

  static const _overrideKey = 'debug_clock_override_iso';
  static const _setRealKey = 'debug_clock_override_set_real_iso';

  final SharedPreferences _prefs;

  DateTime? _overrideAt;
  DateTime? _overrideSetRealAt;

  bool get hasOverride => _overrideAt != null && _overrideSetRealAt != null;

  DateTime now() {
    final at = _overrideAt;
    final setAt = _overrideSetRealAt;
    if (at == null || setAt == null) return DateTime.now();
    final delta = DateTime.now().difference(setAt);
    return at.add(delta);
  }

  Future<void> setOverride(DateTime simulated) async {
    final realNow = DateTime.now();
    _overrideAt = simulated;
    _overrideSetRealAt = realNow;
    notifyListeners();
    try {
      await _prefs.setString(_overrideKey, simulated.toIso8601String());
      await _prefs.setString(_setRealKey, realNow.toIso8601String());
    } on Exception {
      // Roll back persisted state so we never leave half-written keys behind.
      await _prefs.remove(_overrideKey);
      await _prefs.remove(_setRealKey);
    }
  }

  Future<void> clearOverride() async {
    _overrideAt = null;
    _overrideSetRealAt = null;
    notifyListeners();
    await _prefs.remove(_overrideKey);
    await _prefs.remove(_setRealKey);
  }

  void _load() {
    final at = _prefs.getString(_overrideKey);
    final setAt = _prefs.getString(_setRealKey);
    if (at == null || setAt == null) return;
    _overrideAt = DateTime.tryParse(at);
    _overrideSetRealAt = DateTime.tryParse(setAt);
  }
}
