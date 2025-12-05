import 'package:bapa_sitaram/constants/app_colors.dart';
import 'package:bapa_sitaram/utils/font_styles.dart';
import 'package:flutter/material.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppbar({
    super.key,
    required this.title,
    this.actions,
    required this.showDrawerIcon,
    required this.onBackTap,
    this.onDrawerIconTap,
    this.isDrawerOpen=false,
  });

  final String title;
  final List<Widget>? actions;
  final bool showDrawerIcon;
  final bool isDrawerOpen;
  final VoidCallback onBackTap;
  final VoidCallback? onDrawerIconTap;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      titleSpacing: 5,
      actionsPadding: .only(right:10),
      backgroundColor: CustomColors().primaryColor,
      leading: showDrawerIcon
          ? InkWell(
          onTap: (){
            if(onDrawerIconTap!=null) {
              onDrawerIconTap!();
            }
          },
          child: Icon(Icons.menu, size: 24, color: CustomColors().white))
          : InkWell(
              onTap: () {
                onBackTap();
              },
              child: Icon(
                Icons.arrow_back_outlined,
                size: 24,
                color: CustomColors().white,
              ),
            ),
      title: Text(
        title,
        style: bolder(fontSize: 18, color: CustomColors().white),
      ),
      centerTitle: false,
      actions: actions,
      elevation: 0,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
