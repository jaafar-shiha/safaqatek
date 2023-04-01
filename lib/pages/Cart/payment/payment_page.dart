import 'package:credit_card_validator/validation_results.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:safaqtek/GetIt/main_app.dart';
import 'package:safaqtek/constants/app_colors.dart';
import 'package:safaqtek/constants/app_styles.dart';
import 'package:safaqtek/generated/l10n.dart';
import 'package:safaqtek/locator.dart';
import 'package:safaqtek/pages/Cart/payment/shipping_address.dart';
import 'package:safaqtek/providers/cart_products_provider.dart';
import 'package:safaqtek/widgets/app_flushbar.dart';
import 'package:safaqtek/widgets/main_scaffold.dart';
import 'package:credit_card_validator/credit_card_validator.dart';
import 'package:credit_card_type_detector/credit_card_type_detector.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({Key? key}) : super(key: key);

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  CreditCardValidator ccValidator = CreditCardValidator();
  ValueNotifier<CreditCardType> creditCardType = ValueNotifier(CreditCardType.unknown);
  final RoundedLoadingButtonController payBtnController = RoundedLoadingButtonController();

  late CartProductsProvider cartProductsProvider = Provider.of<CartProductsProvider>(context, listen: true);

  ValueNotifier<bool> isLoading = ValueNotifier(false);

  @override
  void initState() {
    Stripe.publishableKey = locator<MainApp>().appSettings!.data.stripeKey;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      body: SafeArea(
        child: ValueListenableBuilder<bool>(
          valueListenable: isLoading,
          builder: (context, _, child) {
            return ModalProgressHUD(
              inAsyncCall: isLoading.value,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 17.0, vertical: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: Icon(
                                Icons.arrow_back_ios,
                                color: AppColors.whiteLilac,
                              ),
                            ),
                            Text(
                              S.of(context).payment,
                              style: TextStyle(
                                fontSize: 22,
                                color: AppColors.whiteLilac,
                                letterSpacing: 1,
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                          ],
                        ),
                      ),
                      ...(locator<MainApp>().currentUser?.reusableCarts ?? [])
                          .map(
                            (reusableCart) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: AppColors.whiteLilac,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                        child: Image.asset(
                                          reusableCart.cartData.brand == 'visa'
                                              ? 'assets/images/visa.png'
                                              : 'assets/images/mastercard.png',
                                          color: reusableCart.cartData.brand == 'visa'
                                              ? AppColors.frenchBlue
                                              : null,
                                          height: 40,
                                        ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '${S.of(context).endingWith} ${reusableCart.cartData.last4}',
                                                style: AppStyles.h3,
                                              ),
                                              const SizedBox(
                                                height: 8.0,
                                              ),
                                              Text(
                                                '${S.of(context).expiryDate} ${reusableCart.cartData.expMonth}/${reusableCart.cartData.expYear}',
                                                style: AppStyles.h4.copyWith(
                                                  color: AppColors.gunPowder,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (BuildContext context) => ShippingAddress(
                                                paymentId: reusableCart.id,
                                              ),
                                            ),
                                          );
                                        },
                                        style: ButtonStyle(
                                          backgroundColor: MaterialStateProperty.all<Color>(
                                            AppColors.dirtyPurple,
                                          ),
                                          shape: MaterialStateProperty.all<OutlinedBorder>(
                                            RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                          ),
                                        ),
                                        child: Text(
                                          S.of(context).useCart,
                                          style: AppStyles.h2.copyWith(color: AppColors.whiteLilac),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          )
                          .toList(),

                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.whiteLilac,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 16.0,
                                  top: 16.0,
                                  right: 16.0,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      S.of(context).addAPaymentMethod,
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: AppColors.gunPowder,
                                          letterSpacing: 1,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Icon(
                                      Icons.navigate_next_outlined,
                                      color: AppColors.gunPowder,
                                    ),
                                  ],
                                ),
                              ),
                              CreditCardForm(
                                formKey: formKey,
                                obscureCvv: true,
                                cardNumber: cardNumber,
                                cvvCode: cvvCode,
                                isHolderNameVisible: false,
                                isCardNumberVisible: true,
                                isExpiryDateVisible: true,
                                cardHolderName: cardHolderName,
                                expiryDate: expiryDate,
                                cursorColor: AppColors.whiteLilac,
                                themeColor: Colors.blue,
                                textColor: Colors.white,
                                cardNumberDecoration: InputDecoration(
                                  hintText: S.of(context).cardNumber,
                                  hintStyle: AppStyles.h2.copyWith(color: AppColors.whiteLilac),
                                  filled: true,
                                  fillColor: AppColors.gray,
                                  suffix: ValueListenableBuilder(
                                    valueListenable: creditCardType,
                                    builder: (context, value, child) {
                                      return creditCardType.value == CreditCardType.mastercard ||
                                              creditCardType.value == CreditCardType.visa
                                          ? Padding(
                                              padding: const EdgeInsets.only(
                                                left: 8.0,
                                                right: 8.0,
                                                top: 8.0,
                                              ),
                                              child: Transform.scale(
                                                scale: 3,
                                                child: Image.asset(
                                                  creditCardType.value == CreditCardType.mastercard
                                                      ? 'assets/images/mastercard.png'
                                                      : 'assets/images/visa.png',
                                                  height: 15,
                                                  width: 15,
                                                ),
                                              ),
                                            )
                                          : const SizedBox(
                                              width: 10,
                                            );
                                    },
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: BorderSide(
                                      color: AppColors.gray,
                                      width: 2.0,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: BorderSide(
                                      color: AppColors.gray,
                                      width: 2.0,
                                    ),
                                  ),
                                ),
                                expiryDateDecoration: InputDecoration(
                                  hintStyle: AppStyles.h2.copyWith(color: AppColors.whiteLilac),
                                  filled: true,
                                  fillColor: AppColors.gray,
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: BorderSide(
                                      color: AppColors.gray,
                                      width: 2.0,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: BorderSide(
                                      color: AppColors.gray,
                                      width: 2.0,
                                    ),
                                  ),
                                  hintText: S.of(context).expiryDate,
                                ),
                                cvvCodeDecoration: InputDecoration(
                                  hintStyle: AppStyles.h2.copyWith(color: AppColors.whiteLilac),
                                  filled: true,
                                  fillColor: AppColors.gray,
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: BorderSide(
                                      color: AppColors.gray,
                                      width: 2.0,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: BorderSide(
                                      color: AppColors.gray,
                                      width: 2.0,
                                    ),
                                  ),
                                  hintText: S.of(context).cvv,
                                ),
                                cardHolderDecoration: InputDecoration(
                                  hintStyle: const TextStyle(color: Colors.white),
                                  labelStyle: const TextStyle(color: Colors.white),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.grey.withOpacity(0.7),
                                      width: 2.0,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.grey.withOpacity(0.7),
                                      width: 2.0,
                                    ),
                                  ),
                                  labelText: 'Card Holder',
                                ),
                                onCreditCardModelChange: onCreditCardModelChange,
                              ),
                              const SizedBox(
                                height: 20,
                              )
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextButton(
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all<Color>(AppColors.frenchBlue),
                                  shape: MaterialStateProperty.all<OutlinedBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                ),
                                onPressed: () async {
                                  if (cardNumber == '' || cvvCode == '' || expiryDate == '') {
                                    return;
                                  }
                                  isLoading.value = true;
                                  CardDetails _card = CardDetails(
                                    number: cardNumber,
                                    cvc: cvvCode,
                                    expirationMonth: int.parse(expiryDate.substring(0, 2)),
                                    expirationYear: int.parse(expiryDate.substring(3)) + 2000,
                                  );
                                  try {
                                    await Stripe.instance.dangerouslyUpdateCardDetails(_card);
                                    await Stripe.instance
                                        .createPaymentMethod(
                                      const PaymentMethodParams.card(),
                                    )
                                        .then((paymentMethod) {
                                      cardNumber = '';
                                      cvvCode = '';
                                      expiryDate = '';
                                      isLoading.value = false;
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (BuildContext context) => ShippingAddress(
                                            paymentId: paymentMethod.id,
                                          ),
                                        ),
                                      );
                                    });
                                  } on StripeException catch (e) {
                                    isLoading.value = false;
                                    cardNumber = '';
                                    cvvCode = '';
                                    expiryDate = '';
                                    AppFlushBar.showFlushbar(message: e.error.message ?? S().unknownError)
                                        .show(context);
                                  }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Text(
                                    '${S.of(context).pay} ${locator<MainApp>().currentUser?.currency?.toUpperCase() ?? 'AED'} ${cartProductsProvider.total}',
                                    style: AppStyles.h2.copyWith(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      //TODO: APPLE
                      // Padding(
                      //   padding: const EdgeInsets.symmetric(vertical: 8.0),
                      //   child: Text(
                      //     S.of(context).otherPaymentsMethods,
                      //     style: TextStyle(
                      //       fontSize: 18,
                      //       color: AppColors.whiteLilac,
                      //       fontWeight: FontWeight.bold,
                      //       letterSpacing: 1,
                      //     ),
                      //   ),
                      // ),
                      //TODO: Apple
                      // Padding(
                      //   padding: const EdgeInsets.all(15),
                      //   child: Row(
                      //     children: [
                      //       Expanded(
                      //         child: TextButton(
                      //           onPressed: () {},
                      //           style: ButtonStyle(
                      //             backgroundColor: MaterialStateProperty.all<Color>(AppColors.whiteLilac),
                      //             shape: MaterialStateProperty.all<OutlinedBorder>(
                      //               RoundedRectangleBorder(
                      //                 borderRadius: BorderRadius.circular(30),
                      //               ),
                      //             ),
                      //           ),
                      //           child: Row(
                      //             mainAxisAlignment: MainAxisAlignment.center,
                      //             children: [
                      //               Padding(
                      //                 padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      //                 child: Image.asset(
                      //                   'assets/images/apple.png',
                      //                   height: 35,
                      //                 ),
                      //               ),
                      //               Padding(
                      //                 padding: const EdgeInsets.symmetric(vertical: 8.0),
                      //                 child: Text(
                      //                   S.of(context).applePay,
                      //                   style: AppStyles.h2,
                      //                 ),
                      //               ),
                      //             ],
                      //           ),
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      const SizedBox(
                        height: 80,
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void onCreditCardModelChange(CreditCardModel? creditCardModel) {
    CCNumValidationResults ccNumValidationResults = ccValidator.validateCCNum(creditCardModel!.cardNumber);
    creditCardType.value = ccNumValidationResults.ccType;
    cardNumber = creditCardModel.cardNumber;
    expiryDate = creditCardModel.expiryDate;
    cardHolderName = creditCardModel.cardHolderName;
    cvvCode = creditCardModel.cvvCode;
  }
}
