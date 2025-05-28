import 'package:flutter/material.dart';

class CombatResultWidget extends StatelessWidget {
  final String result;
  final VoidCallback onRestart;

  const CombatResultWidget({
    Key? key,
    required this.result,
    required this.onRestart,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildResultText(),
          const SizedBox(height: 32),
          _buildRestartButton(),
        ],
      ),
    );
  }

  Widget _buildResultText() {
    final isVictory = result.toLowerCase().contains('victory');

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color:
            isVictory
                ? Colors.green.withOpacity(0.1)
                : Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isVictory ? Colors.green : Colors.red,
          width: 2,
        ),
      ),
      child: Text(
        result,
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: isVictory ? Colors.green.shade700 : Colors.red.shade700,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildRestartButton() {
    return ElevatedButton.icon(
      onPressed: onRestart,
      icon: const Icon(Icons.refresh),
      label: const Text('Nouvelle bataille', style: TextStyle(fontSize: 16)),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
