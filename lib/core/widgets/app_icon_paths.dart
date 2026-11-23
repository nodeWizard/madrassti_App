// Stroke icon set of the Madrassti mockups.
//
// Every entry is the verbatim SVG path data from the `Icon` component of
// `mockups/composants.html`, inside a `0 0 24 24` viewBox with
// `fill: none`, `stroke: currentColor`, round caps and round joins.
//
// 39 glyphs come straight from the mockups. `eye` and `eye-off` were added for
// the login screen's show/hide toggle, drawn to the same conventions
// (see `docs/SPEC.md` §B2).

/// Names of every available glyph.
abstract final class AppIcons {
  static const bell = 'bell';
  static const home = 'home';
  static const calendar = 'calendar';
  static const book = 'book';
  static const message = 'message';
  static const user = 'user';
  static const users = 'users';
  static const clock = 'clock';
  static const pin = 'pin';
  static const swap = 'swap';
  static const mega = 'mega';
  static const file = 'file';
  static const chevron = 'chevron';
  static const back = 'back';
  static const check = 'check';
  static const pencil = 'pencil';
  static const download = 'download';
  static const upload = 'upload';
  static const send = 'send';
  static const plus = 'plus';
  static const search = 'search';
  static const settings = 'settings';
  static const logout = 'logout';
  static const globe = 'globe';
  static const shield = 'shield';
  static const sparkle = 'sparkle';
  static const school = 'school';
  static const x = 'x';
  static const clip = 'clip';
  static const lock = 'lock';
  static const speaker = 'speaker';
  static const flask = 'flask';
  static const palette = 'palette';
  static const ball = 'ball';
  static const phone = 'phone';
  static const info = 'info';
  static const alert = 'alert';
  static const moon = 'moon';
  static const sun = 'sun';

  // Added for the login screen — not present in the mockups.
  static const eye = 'eye';
  static const eyeOff = 'eye-off';
}

/// A primitive shape inside a glyph.
///
/// The mockups use `<path>`, `<circle>` and `<rect>`; each is kept as its own
/// kind so it can be stroked exactly as the browser would.
sealed class IconShape {
  const IconShape();
}

class IconPath extends IconShape {
  const IconPath(this.d);

  /// SVG path data, in the `0 0 24 24` viewBox.
  final String d;
}

class IconCircle extends IconShape {
  const IconCircle(this.cx, this.cy, this.r);
  final double cx;
  final double cy;
  final double r;
}

class IconRect extends IconShape {
  const IconRect(this.x, this.y, this.w, this.h, this.rx);
  final double x;
  final double y;
  final double w;
  final double h;
  final double rx;
}

/// Glyph name to shapes, transcribed from the mockups.
const Map<String, List<IconShape>> kIconShapes = {
  AppIcons.bell: [
    IconPath('M6 8a6 6 0 0 1 12 0c0 7 3 9 3 9H3s3-2 3-9'),
    IconPath('M10.3 21a1.94 1.94 0 0 0 3.4 0'),
  ],
  AppIcons.home: [
    IconPath('M3 10.5 12 3l9 7.5V20a1 1 0 0 1-1 1h-5v-6h-6v6H4a1 1 0 0 1-1-1z'),
  ],
  AppIcons.calendar: [
    IconRect(3, 4, 18, 17, 3),
    IconPath('M8 2v4'),
    IconPath('M16 2v4'),
    IconPath('M3 10h18'),
  ],
  AppIcons.book: [
    IconPath('M4 4.5A2.5 2.5 0 0 1 6.5 2H20v17H6.5A2.5 2.5 0 0 0 4 21.5z'),
    IconPath('M4 21.5v-17'),
  ],
  AppIcons.message: [
    IconPath('M21 12a8 8 0 0 1-11.6 7.1L4 20l1-4.6A8 8 0 1 1 21 12z'),
  ],
  AppIcons.user: [
    IconCircle(12, 8, 4),
    IconPath('M4 21c0-4 4-6 8-6s8 2 8 6'),
  ],
  AppIcons.users: [
    IconCircle(9, 8, 3.5),
    IconPath('M2 20c0-3.5 3-5.5 7-5.5s7 2 7 5.5'),
    IconPath('M16 4.5a3.5 3.5 0 0 1 0 7'),
    IconPath('M18 14.6c2.4 0.6 4 2.4 4 5.4'),
  ],
  AppIcons.clock: [
    IconCircle(12, 12, 9),
    IconPath('M12 7v5l3 2'),
  ],
  AppIcons.pin: [
    IconPath('M12 21s7-6 7-11a7 7 0 0 0-14 0c0 5 7 11 7 11z'),
    IconCircle(12, 10, 2.5),
  ],
  AppIcons.swap: [
    IconPath('M4 7h14'),
    IconPath('M15 4l3 3-3 3'),
    IconPath('M20 17H6'),
    IconPath('M9 14l-3 3 3 3'),
  ],
  AppIcons.mega: [
    IconPath('M3 11v2a1 1 0 0 0 1 1h3l6 4V6L7 10H4a1 1 0 0 0-1 1z'),
    IconPath('M17 9a4 4 0 0 1 0 6'),
  ],
  AppIcons.file: [
    IconPath('M14 3H7a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h10a2 2 0 0 0 2-2V8z'),
    IconPath('M14 3v5h5'),
  ],
  AppIcons.chevron: [IconPath('M9 6l6 6-6 6')],
  AppIcons.back: [IconPath('M15 6l-6 6 6 6')],
  AppIcons.check: [IconPath('M5 12.5l4.5 4.5L19 7')],
  AppIcons.pencil: [
    IconPath('M4 20h4L19 9l-4-4L4 16z'),
    IconPath('M13.5 6.5l4 4'),
  ],
  AppIcons.download: [
    IconPath('M12 4v11'),
    IconPath('M7 10l5 5 5-5'),
    IconPath('M5 20h14'),
  ],
  AppIcons.upload: [
    IconPath('M12 16V5'),
    IconPath('M7 10l5-5 5 5'),
    IconPath('M5 20h14'),
  ],
  AppIcons.send: [
    IconPath('M21 3 3 10.5l7 3 3 7.5z'),
    IconPath('M10 13.5 21 3'),
  ],
  AppIcons.plus: [
    IconPath('M12 5v14'),
    IconPath('M5 12h14'),
  ],
  AppIcons.search: [
    IconCircle(11, 11, 7),
    IconPath('M20 20l-3.5-3.5'),
  ],
  AppIcons.settings: [
    IconCircle(12, 12, 3.5),
    IconPath('M12 2v3M12 19v3M4.9 4.9l2.1 2.1M17 17l2.1 2.1M2 12h3M19 12h3M4.9 19.1 7 17M17 7l2.1-2.1'),
  ],
  AppIcons.logout: [
    IconPath('M15 4h3a2 2 0 0 1 2 2v12a2 2 0 0 1-2 2h-3'),
    IconPath('M10 8l-4 4 4 4'),
    IconPath('M6 12h10'),
  ],
  AppIcons.globe: [
    IconCircle(12, 12, 9),
    IconPath('M3 12h18'),
    IconPath('M12 3c3 3.5 3 14.5 0 18'),
    IconPath('M12 3c-3 3.5-3 14.5 0 18'),
  ],
  AppIcons.shield: [
    IconPath('M12 3l8 3v6c0 4.5-3.5 8-8 9-4.5-1-8-4.5-8-9V6z'),
  ],
  AppIcons.sparkle: [
    IconPath('M11 3l1.8 5.2L18 10l-5.2 1.8L11 17l-1.8-5.2L4 10l5.2-1.8z'),
    IconPath('M19 15l0.8 2.2L22 18l-2.2 0.8L19 21l-0.8-2.2L16 18l2.2-0.8z'),
  ],
  AppIcons.school: [
    IconPath('M3 9l9-5 9 5-9 5z'),
    IconPath('M7 11.5V16c0 1.5 2.5 3 5 3s5-1.5 5-3v-4.5'),
    IconPath('M21 9v5'),
  ],
  AppIcons.x: [
    IconPath('M6 6l12 12'),
    IconPath('M18 6 6 18'),
  ],
  AppIcons.clip: [
    IconPath('M21 11.5l-8.5 8.5a5 5 0 0 1-7-7L14 4.5a3.3 3.3 0 0 1 4.7 4.7l-8.6 8.6a1.7 1.7 0 0 1-2.4-2.4L15.5 7.5'),
  ],
  AppIcons.lock: [
    IconRect(5, 11, 14, 10, 2),
    IconPath('M8 11V8a4 4 0 0 1 8 0v3'),
  ],
  AppIcons.speaker: [
    IconPath('M4 9v6h4l5 4V5L8 9z'),
    IconPath('M16.5 9a4 4 0 0 1 0 6'),
    IconPath('M19 6.5a8 8 0 0 1 0 11'),
  ],
  AppIcons.flask: [
    IconPath('M9 3h6'),
    IconPath('M10 3v6L5 19a1.5 1.5 0 0 0 1.3 2h11.4a1.5 1.5 0 0 0 1.3-2L14 9V3'),
    IconPath('M7.5 15h9'),
  ],
  AppIcons.palette: [
    IconPath('M12 3a9 9 0 1 0 0 18c1.4 0 2-0.9 2-1.9 0-1.1-1-1.5-1-2.6 0-1 0.9-1.5 2-1.5h2a4 4 0 0 0 4-4c0-4.4-4-8-9-8z'),
    IconCircle(7.5, 11, 1),
    IconCircle(10, 7, 1),
    IconCircle(15, 7, 1),
  ],
  AppIcons.ball: [
    IconCircle(12, 12, 9),
    IconPath('M5.6 5.6c3 2.8 3 10 0 12.8'),
    IconPath('M18.4 5.6c-3 2.8-3 10 0 12.8'),
  ],
  AppIcons.phone: [
    IconPath('M5 4h4l2 5-2.5 1.5a11 11 0 0 0 5 5L15 13l5 2v4a2 2 0 0 1-2 2A16 16 0 0 1 3 6a2 2 0 0 1 2-2z'),
  ],
  AppIcons.info: [
    IconCircle(12, 12, 9),
    IconPath('M12 11v5'),
    IconPath('M12 7.5v0.01'),
  ],
  AppIcons.alert: [
    IconPath('M12 3 2 20h20z'),
    IconPath('M12 10v4'),
    IconPath('M12 17v0.01'),
  ],
  AppIcons.moon: [
    IconPath('M20 14.5A8 8 0 1 1 9.5 4a6.5 6.5 0 0 0 10.5 10.5z'),
  ],
  AppIcons.sun: [
    IconCircle(12, 12, 4),
    IconPath('M12 2v2M12 20v2M4.9 4.9l1.4 1.4M17.7 17.7l1.4 1.4M2 12h2M20 12h2M4.9 19.1l1.4-1.4M17.7 6.3l1.4-1.4'),
  ],

  // ---------------------------------------------- added for the login screen
  AppIcons.eye: [
    IconPath('M2 12s3.6-6 10-6 10 6 10 6-3.6 6-10 6-10-6-10-6z'),
    IconCircle(12, 12, 3),
  ],
  AppIcons.eyeOff: [
    IconPath('M10.6 6.2A9.6 9.6 0 0 1 12 6c6.4 0 10 6 10 6a17 17 0 0 1-2.7 3.2'),
    IconPath('M6.5 7.8A17 17 0 0 0 2 12s3.6 6 10 6a9.5 9.5 0 0 0 3.3-.55'),
    IconPath('M9.9 9.9a3 3 0 0 0 4.2 4.2'),
    IconPath('M3 3l18 18'),
  ],
};
