import 'package:flutter/material.dart';

class ReadMoreTextWidget extends StatefulWidget {
  final String text;
  final int trimLines;
  final TextStyle? textStyle;
  final TextStyle? linkStyle;

  const ReadMoreTextWidget({
    super.key,
    required this.text,
    this.trimLines = 2,
    this.textStyle,
    this.linkStyle,
    required EdgeInsets tilePadding,
  });

  @override
  State<ReadMoreTextWidget> createState() => _ReadMoreTextWidgetState();
}

class _ReadMoreTextWidgetState extends State<ReadMoreTextWidget> {
  bool _isExpanded = false;
  bool _isOverflowing = false;

  @override
  Widget build(BuildContext context) {
    final defaultTextStyle =
        widget.textStyle ??
        const TextStyle(
          fontSize: 14,
          height: 1.5,
          fontFamily: 'PlayfairDisplay',
        );

    final linkStyle =
        widget.linkStyle ??
        const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.blue,
        );

    return LayoutBuilder(
      builder: (context, constraints) {
        final textPainter = TextPainter(
          text: TextSpan(text: widget.text, style: defaultTextStyle),
          maxLines: widget.trimLines,
          textDirection: TextDirection.ltr,
        )..layout(maxWidth: constraints.maxWidth);

        _isOverflowing = textPainter.didExceedMaxLines;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.text,
              style: defaultTextStyle,
              maxLines: _isExpanded ? null : widget.trimLines,
              overflow: _isExpanded
                  ? TextOverflow.visible
                  : TextOverflow.ellipsis,
            ),

            if (_isOverflowing)
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isExpanded = !_isExpanded;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    _isExpanded ? "Read less" : "Read more",
                    style: linkStyle,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
