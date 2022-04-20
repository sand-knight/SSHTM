// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

FocusNode focusNodeToIgnoreDigitKeys = FocusNode(onKey: (node, event) {
  LogicalKeyboardKey whatkey = event.logicalKey;

  if (whatkey == LogicalKeyboardKey.digit0) return KeyEventResult.ignored;
  if (whatkey == LogicalKeyboardKey.digit1) return KeyEventResult.ignored;
  if (whatkey == LogicalKeyboardKey.digit2) return KeyEventResult.ignored;
  if (whatkey == LogicalKeyboardKey.digit3) return KeyEventResult.ignored;
  if (whatkey == LogicalKeyboardKey.digit4) return KeyEventResult.ignored;
  if (whatkey == LogicalKeyboardKey.digit5) return KeyEventResult.ignored;
  if (whatkey == LogicalKeyboardKey.digit6) return KeyEventResult.ignored;
  if (whatkey == LogicalKeyboardKey.digit7) return KeyEventResult.ignored;
  if (whatkey == LogicalKeyboardKey.digit8) return KeyEventResult.ignored;
  if (whatkey == LogicalKeyboardKey.digit9)
    return KeyEventResult.ignored;
  else
    return KeyEventResult.handled;
});

FocusNode focusNodeToAbsorbKeys = FocusNode(
    canRequestFocus: true,
    descendantsAreFocusable: false,
    onKey: (node, event) {
      LogicalKeyboardKey whatkey = event.logicalKey;

      if (whatkey == LogicalKeyboardKey.enter) return KeyEventResult.handled;
      if (whatkey == LogicalKeyboardKey.arrowUp) return KeyEventResult.handled;
      if (whatkey == LogicalKeyboardKey.arrowDown)
        return KeyEventResult.handled;
      else
        return KeyEventResult.ignored;
    });
