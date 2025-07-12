
import 'package:flutter/material.dart';


import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:newsapp/config/colors.dart';


import '../../../Model/transaction_model.dart';
import '../../../bloc/transactionBloc/transaction_bloc.dart';
import '../../../bloc/transactionBloc/transaction_event.dart';
import '../../../bloc/transactionBloc/transaction_state.dart';
import '../../../config/shimmer.dart';
import '../../../l10n/app_localizations.dart';



class Transaction extends StatefulWidget {
  const Transaction({super.key});

  @override
  State<Transaction> createState() => _TransactionState();
}

class _TransactionState extends State<Transaction> {
  @override
  void initState() {
    super.initState();

    context.read<TransactionBloc>().add(FetchTransaction());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title:  Text(
          AppLocalizations.of(context)!.transactionHistory,
        ),
        elevation: 0,

      ),
      body: BlocBuilder<TransactionBloc, TransactionState>(
        builder: (context, state) {
          if (state is TransactionLoading) {
            return _buildLoadingShimmer();
          } else if (state is TransactionSuccessState) {

            if(state.transactionData[0].data!.isEmpty){
              return EmptyTransactionView();
            }

            return TransactionListView(transactions: state.transactionData);
          } else if (state is TransactionErrorState) {
            return ErrorView(errorMessage: state.errorMessasge);
          }

          return const Center(
            child: Text(""),
          );
        },
      ),
    );
  }
}

Widget _buildLoadingShimmer() {
  return ListView.builder(
    itemCount: 8,
    itemBuilder: (context, index) {
      return ShimmerWidget(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.1,
        margin: EdgeInsets.only(
          top: MediaQuery.of(context).size.height * 0.02,
          left: MediaQuery.of(context).size.width * 0.03,
          right: MediaQuery.of(context).size.width * 0.03,
        ),
      );
    },
  );
}



class EmptyTransactionView extends StatelessWidget {
  const EmptyTransactionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.receipt_long,
              size: 80,
              color: Colors.grey[400],
            ),
             SizedBox(height: 20),
            Text(
              AppLocalizations.of(context)!.noTransactionsYet,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
             SizedBox(height: 12),
            Text(
              AppLocalizations.of(context)!.onceYouStartMakingTransactions,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class ErrorView extends StatelessWidget {
  final String errorMessage;

  const ErrorView({super.key, required this.errorMessage});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            errorMessage,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
           SizedBox(height: 20),
          ElevatedButton.icon(
            icon:  Icon(Icons.refresh),
            label:  Text("Try Again"),
            style: ElevatedButton.styleFrom(
              padding:  EdgeInsets.symmetric(horizontal: 30, vertical: 12),
            ),
            onPressed: () {
              context.read<TransactionBloc>().add(FetchTransaction());
            },
          ),
        ],
      ),
    );
  }
}

class TransactionListView extends StatelessWidget {
  final List<TransactionModel> transactions;

  const TransactionListView({super.key, required this.transactions});

  @override
  Widget build(BuildContext context) {
    // Group transactions by month
    Map<String, List<Data>> groupedTransactions = {};

    for (var transaction in transactions) {
      if (transaction.data != null) {
        for (var data in transaction.data!) {
          if (data.createdAt != null) {
            final date = DateTime.parse(data.createdAt!);
            final monthYear = DateFormat('MMMM yyyy').format(date);

            if (!groupedTransactions.containsKey(monthYear)) {
              groupedTransactions[monthYear] = [];
            }
            groupedTransactions[monthYear]!.add(data);
          }
        }
      }
    }

    final sortedMonths = groupedTransactions.keys.toList()
      ..sort((a, b) {
        final dateA = DateFormat('MMMM yyyy').parse(a);
        final dateB = DateFormat('MMMM yyyy').parse(b);
        return dateB.compareTo(dateA); // Sort in descending order (newest first)
      });

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: sortedMonths.length,
      itemBuilder: (context, index) {
        final monthYear = sortedMonths[index];
        final monthTransactions = groupedTransactions[monthYear]!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            ...monthTransactions.map((data) => TransactionCard(transaction: data)),
            const SizedBox(height: 8),
          ],
        );
      },
    );
  }
}

class TransactionCard extends StatelessWidget {
  final Data transaction;

  const TransactionCard({super.key, required this.transaction});

  Color _getStatusColor() {
    if (transaction.status == null) return Colors.grey;

    switch (transaction.status!.toLowerCase()) {
      case 'success':
      case 'completed':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'failed':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _formatDate(String? dateString) {
    if (dateString == null) return 'N/A';
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('dd MMM yyyy, HH:mm').format(date);
    } catch (e) {
      return dateString;
    }
  }

  @override
  Widget build(BuildContext context) {
    final planName = transaction.planDetails?.plan?.planName ?? 'Subscription';
    final amount = transaction.amount ?? '0';
    final statusColor = _getStatusColor();
    final date = _formatDate(transaction.createdAt);

    // Generate a consistent random pastel color based on the plan name
    final int hashCode = planName.hashCode;
    final double hue = (hashCode % 360).toDouble();
    final Color avatarColor = HSLColor.fromAHSL(1.0, hue, 0.6, 0.8).toColor();

    return Card(
      margin:  EdgeInsets.only(bottom: 12),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: AppColors(context).isDark
              ? (Colors.grey[400] ?? Colors.grey)
              : (Colors.grey[600] ?? Colors.grey),
        ),

      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Plan avatar/icon
            CircleAvatar(
              backgroundColor: avatarColor,
              radius: 24,
              child: Text(
                planName.isNotEmpty ? planName[0].toUpperCase() : 'S',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            const SizedBox(width: 16),
            // Transaction details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    planName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _getTenureInfo(),
                    style: TextStyle(
                    color: AppColors(context).isDark ? Colors.grey[400] : Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Type: ${transaction.paymentGateway?.toUpperCase()}',
                    style: TextStyle(
                      color: AppColors(context).isDark ? Colors.grey[350] : Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            // Amount and status
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '\$$amount',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    transaction.status!.toUpperCase(),
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                 SizedBox(height: 4),
                Text(
                  date,
                  style: TextStyle(
                    color: AppColors(context).isDark ? Colors.grey[350] : Colors.grey[600] ,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getTenureInfo() {
    if (transaction.planDetails?.tenures != null && transaction.planDetails!.tenures!.isNotEmpty) {
      final tenure = transaction.planDetails!.tenures!.first;
      return '${tenure.tenureName ?? ''} (${tenure.duration ?? ''})';
    }
    return transaction.paymentGateway ?? 'Payment';
  }
}