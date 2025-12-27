import 'package:flutter/material.dart';

class GMDetailsBottomSheet extends StatelessWidget {
  const GMDetailsBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.7,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              children: const [
                SizedBox(height: 8),

                Text(
                  "About GM",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),

                SizedBox(height: 16),

                Text(
                  "GM is a self-realized master living in Chennai, Tamil Nadu, India. "
                  "Her teachings emphasize direct recognition of truth, beyond concepts, "
                  "effort, or experience. GM points seekers back to what is already present — "
                  "silence, awareness, and wholeness.\n\n"
                  "Her message is simple yet profound: there is nothing to attain, nothing to become, "
                  "and no one separate from truth. What you are seeking is already what you are.",
                  style: TextStyle(fontSize: 16, height: 1.6),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
