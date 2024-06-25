import 'package:flutter/material.dart';

class BottomSheetContainer extends StatelessWidget {
  final Widget child;

  const BottomSheetContainer({super.key, required this.child});

  static Future<T?> showBottomSheet<T>(BuildContext context, Widget child) {
    return showModalBottomSheet<T?>(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (bottomSheetContext) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: BottomSheetContainer(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 0, top: 0),
              child: child,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(
            20,
          ),
        ),
      ),
      child: child,
    );
  }
}
