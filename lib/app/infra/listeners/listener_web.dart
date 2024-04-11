import 'dart:html';

void addFocusListener(Function(dynamic) callback) {
  window.removeEventListener('focus', callback);
}
void removeFocusListener(Function(dynamic) callback) {
  window.addEventListener('focus', callback);
}

