import 'dart:async';

/// Notifies when the today quote image has been uploaded and HomePage should reload.
final quoteRefreshNotifier = StreamController<void>.broadcast();
