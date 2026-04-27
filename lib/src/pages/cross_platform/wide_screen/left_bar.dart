import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/cupertino.dart';
import 'package:tencent_chat_i18n_tool/tencent_chat_i18n_tool.dart';
import 'package:tencent_cloud_chat_flutter/src/pages/home_page.dart';
import 'package:tencent_cloud_chat_flutter/src/provider/theme.dart';
import 'package:provider/provider.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';
import 'package:tencent_cloud_chat_flutter/src/pages/cross_platform/wide_screen/user_avatar.dart';
import 'package:tencent_cloud_chat_uikit/theme/color.dart';

class LeftBar extends StatefulWidget {
  final int index;
  final ValueChanged<int> onChange;

  const LeftBar({Key? key, required this.index, required this.onChange})
      : super(key: key);

  @override
  State<LeftBar> createState() => _LeftBarState();
}

class _LeftBarState extends State<LeftBar> {
  List<NavigationBarData> getBottomNavigatorList(theme) {
    return [
      NavigationBarData(
        index: 0,
        title: TIM_t("消息"),
        selectedIcon: Stack(
          clipBehavior: Clip.none,
          children: [
            ColorFiltered(
              child: Image.asset(
                "assets/chat_active.png",
                width: 24,
                height: 24,
              ),
              colorFilter: ColorFilter.mode(
                  theme.primaryColor ?? CommonColor.primaryColor,
                  BlendMode.srcATop),
            ),
            Positioned(
              top: -5,
              right: -6,
              child: UnconstrainedBox(
                child: TIMUIKitConversationTotalUnread(width: 16, height: 16),
              ),
            )
          ],
        ),
        unselectedIcon: Stack(
          clipBehavior: Clip.none,
          children: [
            ColorFiltered(
                child: Image.asset(
                  "assets/chat.png",
                  width: 24,
                  height: 24,
                ),
                colorFilter:
                    ColorFilter.mode(hexToColor("d9dbe2"), BlendMode.srcATop)),
            Positioned(
              top: -5,
              right: -6,
              child: UnconstrainedBox(
                child: TIMUIKitConversationTotalUnread(width: 16, height: 16),
              ),
            )
          ],
        ),
      ),
      NavigationBarData(
        index: 1,
        title: TIM_t("通讯录"),
        selectedIcon: Stack(
          clipBehavior: Clip.none,
          children: [
            ColorFiltered(
              child: Image.asset(
                "assets/contact_active.png",
                width: 24,
                height: 24,
              ),
              colorFilter: ColorFilter.mode(
                  theme.primaryColor ?? CommonColor.primaryColor,
                  BlendMode.srcATop),
            ),
            const Positioned(
              top: -5,
              right: -6,
              child: UnconstrainedBox(
                child: TIMUIKitUnreadCount(
                  width: 16,
                  height: 16,
                ),
              ),
            )
          ],
        ),
        unselectedIcon: Stack(
          clipBehavior: Clip.none,
          children: [
            ColorFiltered(
                child: Image.asset(
                  "assets/contact.png",
                  width: 24,
                  height: 24,
                ),
                colorFilter:
                    ColorFilter.mode(hexToColor("d9dbe2"), BlendMode.srcATop)),
            const Positioned(
              top: -5,
              right: -6,
              child: UnconstrainedBox(
                child: TIMUIKitUnreadCount(
                  width: 16,
                  height: 16,
                ),
              ),
            )
          ],
        ),
      ),
      NavigationBarData(
        index: 2,
        title: TIM_t("我的"),
        selectedIcon: ColorFiltered(
            child: Image.asset(
              "assets/profile_active.png",
              width: 24,
              height: 24,
            ),
            colorFilter:
                ColorFilter.mode(hexToColor("3370ff"), BlendMode.srcATop)),
        unselectedIcon: ColorFiltered(
            child: Image.asset(
              "assets/profile.png",
              width: 24,
              height: 24,
            ),
            colorFilter:
                ColorFilter.mode(hexToColor("d9dbe2"), BlendMode.srcATop)),
      ),
    ];
  }

  List<Widget> bottomNavigatorList(theme) {
    return bottomNavigatorListWithStyle(theme);
  }

  List<Widget> bottomNavigatorListWithStyle(
    theme, {
    double itemExtent = 60,
    bool showLabel = true,
  }) {
    return getBottomNavigatorList(theme).map((e) {
      return Container(
        width: itemExtent,
        height: itemExtent,
        decoration: BoxDecoration(
          color: widget.index == e.index ? hexToColor("273044") : null,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: GestureDetector(
          onTap: () {
            widget.onChange(e.index!);
          },
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  child: widget.index == e.index
                      ? e.selectedIcon
                      : e.unselectedIcon,
                ),
                if (showLabel) const SizedBox(height: 4),
                if (showLabel)
                  Text(
                    e.title,
                    style: TextStyle(
                      color: hexToColor("d9dbe2"),
                      fontSize: 10,
                    ),
                  )
              ],
            ),
          ),
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<DefaultThemeData>(context).theme;
    return LayoutBuilder(builder: (context, constraints) {
      final double maxHeight = constraints.maxHeight;
      final bool compactLayout = maxHeight < 320;
      final bool hideLabels = maxHeight < 240;
      final double topHeight = compactLayout
          ? maxHeight.clamp(12.0, 40.0)
          : 40;
      final double itemExtent = hideLabels
          ? 44
          : compactLayout
              ? 52
              : 60;

      if (!compactLayout) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: topHeight,
              child: MoveWindow(
                child: Container(),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: bottomNavigatorList(theme),
            ),
            Expanded(
                child: MoveWindow(
              child: Container(),
            )),
            UserAvatar(
              onChangeIndex: widget.onChange,
            ),
          ],
        );
      }

      return SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: maxHeight),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: topHeight,
                child: MoveWindow(
                  child: Container(),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: bottomNavigatorListWithStyle(
                  theme,
                  itemExtent: itemExtent,
                  showLabel: !hideLabels,
                ),
              ),
              SizedBox(height: hideLabels ? 8 : 12),
              SizedBox(
                height: hideLabels ? 52 : 72,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.topCenter,
                  child: UserAvatar(
                    onChangeIndex: widget.onChange,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
