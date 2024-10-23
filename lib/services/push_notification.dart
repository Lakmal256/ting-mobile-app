import 'package:app/themes/themes.dart';
import 'package:app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:gradient_borders/gradient_borders.dart';

class PushNotificationController extends ValueNotifier<List<Widget>> {
  PushNotificationController() : super([]);

  addItem(Widget widget) {
    value.add(widget);
    notifyListeners();
  }

  addItemFor(Widget widget, Duration duration) async {
    addItem(widget);
    await Future.delayed(duration, () => removeItem(widget));
  }

  removeItem(Widget widget) {
    value.remove(widget);
    notifyListeners();
  }

  clear() {
    value.clear();
    notifyListeners();
  }
}

class PushNotificationContainer extends StatelessWidget {
  const PushNotificationContainer({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SafeArea(
        child: Material(
          color: Colors.transparent,
          child: Column(children: children),
        ),
      ),
    );
  }
}

class DismissiblePushNotification extends StatelessWidget {
  const DismissiblePushNotification({
    super.key,
    required this.onDismiss,
    required this.color,
    required this.content,
  });

  final Function(Widget) onDismiss;
  final Color color;
  final String content;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: GlobalKey(),
      child: PushNotificationCard(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(AssestPath.assestLogoPath, width: 95.0, fit: BoxFit.cover),
            const SizedBox(width: 10),
            Flexible(
              child: CustomTextWidget(
                  text: MediaQuery.of(context).size.width >= 360
                      ? (() {
                          final fullText = content;
                          return fullText.length > 90 ? '${fullText.substring(0, 90)}...' : fullText;
                        })()
                      : (() {
                          final fullText = content;
                          return fullText.length > 60 ? '${fullText.substring(0, 60)}...' : fullText;
                        })(),
                  fontSize: 16,
                  color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

class PushNotificationCard extends StatelessWidget {
  const PushNotificationCard({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
          height: 90,
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [
                Color(0xFFCAC3BE),
                Color(0xFFCABFC3),
              ]),
              borderRadius: BorderRadius.all(Radius.circular(15)),
              border: GradientBoxBorder(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.kMainOranage,
                      AppColors.kMainPink,
                    ],
                  ),
                  width: 2)),
          child: child),
    );
  }
}
