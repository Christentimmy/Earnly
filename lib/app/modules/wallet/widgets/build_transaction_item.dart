import 'package:earnly/app/data/models/withdraw_model.dart';
import 'package:earnly/app/resources/colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Widget buildTransactionItem({required WithdrawModel withdraw}) {
  return Container(
    margin: const EdgeInsets.only(bottom: 12),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: AppColors.primaryColor.withOpacity(0.2),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(
        color: AppColors.accentGreen.withOpacity(0.1),
        width: 1,
      ),
    ),
    child: Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Colors.red.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            getIcon(network: withdraw.paymentDetails.network),
            color: Colors.red[400],
            size: 24,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                withdraw.paymentDetails.network,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                DateFormat("h:mm a, dd MMM yyyy").format(withdraw.createdAt),
                style: TextStyle(fontSize: 13, color: Colors.grey[400]),
              ),
            ],
          ),
        ),
        Text(
          '-${withdraw.amount}',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.red[400],
          ),
        ),
      ],
    ),
  );
}

IconData getIcon({required String network}) {
  switch (network) {
    case 'Bitcoin (BTC)':
      return Icons.currency_bitcoin;
    case 'Ethereum (ETH)':
      return Icons.hexagon;
    case 'Coinbase':
      return Icons.account_balance_wallet;
    case 'USDT (TRC20)':
      return Icons.toll;
    default:
      return Icons.currency_bitcoin;
  }
}
