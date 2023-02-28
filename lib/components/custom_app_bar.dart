import 'package:yucatan/theme/custom_theme.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final AppBar appBar;
  final PreferredSizeWidget? bottom;
  final Widget? leading;
  final List<Widget>? actions;
  final bool centerTitle;
  final Color backgroundColor;

  CustomAppBar(
      {required this.title,
      required this.appBar,
      this.bottom,
      this.leading,
      this.actions,
      this.centerTitle = true,
      this.backgroundColor = CustomTheme.primaryColorDark});

  @override
  _CustomAppBarState createState() => _CustomAppBarState();

  @override
  Size get preferredSize => new Size.fromHeight(
      appBar.preferredSize.height + (bottom?.preferredSize?.height ?? 0));
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return buildAppBar();
  }

  buildAppBar() {
    var appBar = AppBar(
      title: Text(
        widget.title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: widget.centerTitle,
      bottom: widget.bottom,
      leading: widget.leading,
      actions: widget.actions ?? [],
      backgroundColor: widget.backgroundColor,
    );

    return appBar;
  }
}
