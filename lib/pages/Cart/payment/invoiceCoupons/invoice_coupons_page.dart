import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:safaqtek/GetIt/main_app.dart';
import 'package:safaqtek/constants/app_colors.dart';
import 'package:safaqtek/constants/app_styles.dart';
import 'package:safaqtek/constants/invoice_coupons_page_tabs.dart';
import 'package:safaqtek/constants/main_tab_enum.dart';
import 'package:safaqtek/generated/l10n.dart';
import 'package:safaqtek/locator.dart';
import 'package:safaqtek/models/Payment/payment_data.dart';
import 'package:safaqtek/pages/Cart/payment/invoiceCoupons/coupons_tab.dart';
import 'package:safaqtek/pages/Cart/payment/invoiceCoupons/invoice_tab.dart';
import 'package:safaqtek/providers/tabs_provider.dart';
import 'package:safaqtek/services/fcm_services.dart';
import 'package:safaqtek/widgets/main_scaffold.dart';
import 'package:flutter/services.dart';

class InvoiceCouponsPage extends StatefulWidget {
  final PaymentData paymentData;

  const InvoiceCouponsPage({
    Key? key,
    required this.paymentData,
  }) : super(key: key);

  @override
  _InvoiceCouponsPageState createState() => _InvoiceCouponsPageState();
}

class _InvoiceCouponsPageState extends State<InvoiceCouponsPage> {
  ValueNotifier<InvoiceCouponsPageTabs> selectedTab = ValueNotifier(InvoiceCouponsPageTabs.coupons);
  final RoundedLoadingButtonController nextBtnController = RoundedLoadingButtonController();

  static const platform = MethodChannel('com.company.safaqtek/sendEmail');

  Future<void> sendEmail() async {
    final arguments = {
      'recipient': locator<MainApp>().currentUser!.email,
      'subject': S().congratulations,
      'body': S().yourPaymentCompletedSuccessfully,
    };
    await platform.invokeMethod('SendEmail', arguments);
  }

  @override
  void initState() {
    sendEmail();
    FCMServices().showLocalNotification(
      title: 'Congratulations',
      body: 'Your payment completed successfully',
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TabsProvider tabsProvider = Provider.of<TabsProvider>(context, listen: true);
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.pop(context);
        return Future.delayed(
          const Duration(
            milliseconds: 1,
          ),
          () => true,
        );
      },
      child: MainScaffold(
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(
                height: 50,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.whiteLilac,
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.asset(
                                'assets/images/check-circle.png',
                                height: 90,
                              ),
                            ),
                            Text(
                              S.of(context).thankYou,
                              style: TextStyle(
                                fontSize: 22,
                                color: AppColors.gunPowder,
                                letterSpacing: 1,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 15.0),
                              child: Text(
                                S.of(context).pleaseFindBelowYourInvoiceAndCoupons,
                                style: AppStyles.h2.copyWith(color: AppColors.gray),
                              ),
                            ),
                            ValueListenableBuilder(
                              valueListenable: selectedTab,
                              builder: (context, val, child) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10),
                                      child: Stack(
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                width: MediaQuery.of(context).size.width / 1.9,
                                                child: TextButton(
                                                  onPressed: () {
                                                    selectedTab.value = InvoiceCouponsPageTabs.invoice;
                                                  },
                                                  child: Padding(
                                                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                                    child: Text(
                                                      S.of(context).invoice,
                                                      style: AppStyles.h3.copyWith(color: AppColors.whiteLilac),
                                                    ),
                                                  ),
                                                  style: ButtonStyle(
                                                    backgroundColor: MaterialStateProperty.all<Color>(
                                                      selectedTab.value == InvoiceCouponsPageTabs.invoice
                                                          ? AppColors.dirtyPurple
                                                          : AppColors.gray,
                                                    ),
                                                    shape: MaterialStateProperty.all<OutlinedBorder>(
                                                      RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(25),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              SizedBox(
                                                width: MediaQuery.of(context).size.width / 2.1,
                                                child: TextButton(
                                                  onPressed: () {
                                                    selectedTab.value = InvoiceCouponsPageTabs.coupons;
                                                  },
                                                  child: Padding(
                                                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                                    child: Text(
                                                      S.of(context).coupons,
                                                      style: AppStyles.h3.copyWith(color: AppColors.whiteLilac),
                                                    ),
                                                  ),
                                                  style: ButtonStyle(
                                                    backgroundColor: MaterialStateProperty.all<Color>(
                                                      selectedTab.value == InvoiceCouponsPageTabs.coupons
                                                          ? AppColors.dirtyPurple
                                                          : AppColors.gray,
                                                    ),
                                                    shape: MaterialStateProperty.all<OutlinedBorder>(
                                                      RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(25),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    selectedTab.value == InvoiceCouponsPageTabs.invoice
                                        ? InvoiceTab(
                                            transactionNumber: widget.paymentData.transactionData.transactionId,
                                            total: widget.paymentData.transactionData.amount,
                                            purchasedOn: widget.paymentData.transactionData.createdAt,
                                            products: widget.paymentData.transactionData.cart,
                                          )
                                        : CouponsTab(
                                            coupons: widget.paymentData.transactionData.coupons,
                                          )
                                  ],
                                );
                              },
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                bottom: 15,
                                top: 8,
                                right: 8,
                                left: 8,
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: RoundedLoadingButton(
                                      color: AppColors.frenchBlue,
                                      onPressed: () {
                                        tabsProvider.setCurrentTab(currentTab: Tabs.home);
                                        Navigator.pop(
                                          context,
                                        );
                                        Navigator.pop(
                                          context,
                                        );
                                        Navigator.pop(
                                          context,
                                        );
                                      },
                                      controller: nextBtnController,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                                        child: Text(
                                          S.of(context).next,
                                          style: AppStyles.h2.copyWith(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
