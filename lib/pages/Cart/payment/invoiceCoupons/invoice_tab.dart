import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:safaqtek/GetIt/main_app.dart';
import 'package:safaqtek/constants/app_colors.dart';
import 'package:safaqtek/constants/app_styles.dart';
import 'package:safaqtek/generated/l10n.dart';
import 'package:safaqtek/locator.dart';
import 'package:safaqtek/models/Payment/cart.dart';

class InvoiceTab extends StatefulWidget {
  final String transactionNumber;
  final String purchasedOn;
  final List<Cart> products;
  final int total;

  const InvoiceTab({
    Key? key,
    required this.transactionNumber,
    required this.purchasedOn,
    required this.products,
    required this.total,
  }) : super(key: key);

  @override
  _InvoiceTabState createState() => _InvoiceTabState();
}

class _InvoiceTabState extends State<InvoiceTab> {
  String getCreationDate() {
    late DateTime date = DateTime.now();

    try{
      date = Intl.withLocale('en', () => DateFormat("MM/dd/yyyy").parse(widget.purchasedOn));
    }
    catch(e){
      date = DateTime.now();
    }
    return '${DateFormat.MMMM().format(date)} ${date.day}, ${DateFormat.y().format(date)}';
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${S.of(context).transactionNo} ${widget.transactionNumber}',
              style: AppStyles.h3.copyWith(color: AppColors.gray),
            ),
            Text(
              getCreationDate(),
              style: AppStyles.h3.copyWith(color: AppColors.gray),
            ),
            Row(
              children: [
                Expanded(
                  child: DataTable(
                    dataTextStyle: AppStyles.h3,
                    headingTextStyle: AppStyles.h3,
                    columns: [
                      DataColumn(
                        label: Expanded(
                          child: Text(
                            S.of(context).products,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Expanded(
                          child: Text(
                            S.of(context).quantity,
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Expanded(
                          child: Text(
                            S.of(context).subTotal,
                          ),
                        ),
                      ),
                    ],
                    rows: widget.products
                        .map(
                          (product) =>DataRow(
                            cells: [
                              DataCell(
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        product.name,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              DataCell(
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        product.quantity,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              DataCell(
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        '${product.price} ${product.currency}',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                        .toList(),
                  ),
                ),
              ],
            ),
            Divider(
              color: AppColors.lightGray,
              thickness: 4,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    S.of(context).total,
                    style: AppStyles.h2,
                  ),
                  Text(
                    '${widget.total} ${locator<MainApp>().currentUser?.currency?.toUpperCase()??S.of(context).AED.toUpperCase()}',
                    style: AppStyles.h2,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
