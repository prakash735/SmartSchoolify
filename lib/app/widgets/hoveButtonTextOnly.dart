import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HoverButtonTextOnly extends StatefulWidget {
  final String label;
  final VoidCallback onPressed;
  final Color buttonBgColor;
  final Color onHoverBorderColor;
  final Color onNotHoverBorderColor;
  final Color textColor;

  const HoverButtonTextOnly({super.key, required this.label, required this.onPressed, required this.buttonBgColor, required this.onHoverBorderColor, required this.onNotHoverBorderColor, required this.textColor});

  @override
  State<HoverButtonTextOnly> createState() => _HoverButtonTextOnlyState();
}

class _HoverButtonTextOnlyState extends State<HoverButtonTextOnly> {

  bool _isHovered = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 2),
        child: ElevatedButton(
          onPressed: widget.onPressed,
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.all(16),
            backgroundColor: widget.buttonBgColor,
            side: BorderSide(
              color: _isHovered ? widget.onHoverBorderColor : widget.onNotHoverBorderColor,
              width: 2.0,
            ),
            elevation: 0,
          ),
          child: Text(widget.label,
              style: GoogleFonts.lato(
                textStyle: TextStyle(
                  color: widget.textColor,
                  letterSpacing: 0.5,
                  fontWeight: FontWeight.w600,
                ),)
          ),
        ),
      ),
    );
  }
}
