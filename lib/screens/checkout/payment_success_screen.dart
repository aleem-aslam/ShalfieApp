import 'package:flutter/material.dart';

class PaymentSuccessScreen extends StatefulWidget {
  final String orderId; // we keep this for future tracking

  const PaymentSuccessScreen({super.key, required this.orderId});

  @override
  State<PaymentSuccessScreen> createState() => _PaymentSuccessScreenState();
}

class _PaymentSuccessScreenState extends State<PaymentSuccessScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;
  late final Animation<double> _opacity;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _scale = CurvedAnimation(parent: _controller, curve: Curves.easeOutBack);

    _opacity = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    // start the animation as soon as screen appears
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // top row with close
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    // go back to previous screen (Cart)
                    Navigator.of(context).pop();
                  },
                ),
              ),

              const Spacer(),

              FadeTransition(
                opacity: _opacity,
                child: ScaleTransition(
                  scale: _scale,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      child: Image.asset(
                        'assets/images/check_box.png',
                        width: 150,
                        height: 150,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 18),

              const Text(
                'Payment received!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 8),
              const Text(
                'Your order has been validated.',
                style: TextStyle(fontSize: 14, color: Colors.black54),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 24),

              // Text(
              //   'Order ID: ${widget.orderId}\nYou can track this order in your account under "My Orders".',
              //   style: const TextStyle(fontSize: 12, color: Colors.black54),
              //   textAlign: TextAlign.center,
              // ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
