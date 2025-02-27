import 'dart:convert';

import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:example/plugin/AI/continue_to_write.dart';
import 'package:example/plugin/AI/auto_completion.dart';
import 'package:example/plugin/AI/gpt3.dart';
import 'package:example/plugin/AI/smart_edit.dart';
import 'package:flutter/material.dart';

class SimpleEditor extends StatelessWidget {
  const SimpleEditor({
    super.key,
    required this.jsonString,
    required this.themeData,
    required this.onEditorStateChange,
  });

  final Future<String> jsonString;
  final ThemeData themeData;
  final void Function(EditorState editorState) onEditorStateChange;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: jsonString,
      builder: (context, snapshot) {
        if (snapshot.hasData &&
            snapshot.connectionState == ConnectionState.done) {
          final editorState = EditorState(
            document: Document.fromJson(
              Map<String, Object>.from(
                json.decode(snapshot.data!),
              ),
            ),
          );
          editorState.logConfiguration
            ..handler = debugPrint
            ..level = LogLevel.all;
          onEditorStateChange(editorState);

          return AppFlowyEditor(
            editorState: editorState,
            themeData: themeData,
            autoFocus: editorState.document.isEmpty,
            selectionMenuItems: [
              // Open AI
              if (apiKey.isNotEmpty) ...[
                autoCompletionMenuItem,
                continueToWriteMenuItem,
              ]
            ],
            toolbarItems: [
              smartEditItem,
            ],
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
