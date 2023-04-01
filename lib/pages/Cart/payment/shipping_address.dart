import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:safaqtek/GetIt/main_app.dart';
import 'package:safaqtek/blocs/PaymentBloc/payment_bloc.dart';
import 'package:safaqtek/blocs/PaymentBloc/payment_event.dart';
import 'package:safaqtek/blocs/PaymentBloc/payment_state.dart';
import 'package:safaqtek/constants/app_colors.dart';
import 'package:safaqtek/constants/app_styles.dart';
import 'package:safaqtek/generated/l10n.dart';
import 'package:safaqtek/locator.dart';
import 'package:safaqtek/models/Payment/add_cart.dart';
import 'package:safaqtek/models/Payment/add_payment_data.dart';
import 'package:safaqtek/models/User/update_user_profile.dart';
import 'package:safaqtek/models/User/user_data.dart';
import 'package:safaqtek/models/base_success_response.dart';
import 'package:safaqtek/pages/Cart/payment/invoiceCoupons/invoice_coupons_page.dart';
import 'package:safaqtek/providers/cart_products_provider.dart';
import 'package:safaqtek/services/authentication_services.dart';
import 'package:safaqtek/services/settings_services.dart';
import 'package:safaqtek/utils/result_classes.dart';
import 'package:safaqtek/widgets/app_flushbar.dart';
import 'package:safaqtek/widgets/custom_container_clipper.dart';
import 'package:safaqtek/widgets/main_scaffold.dart';

class ShippingAddress extends StatefulWidget {
  final String paymentId;

  const ShippingAddress({
    Key? key,
    required this.paymentId,
  }) : super(key: key); //

  @override
  _ShippingAddressState createState() => _ShippingAddressState();
}

class _ShippingAddressState extends State<ShippingAddress> {
  final RoundedLoadingButtonController nextBtnController = RoundedLoadingButtonController();

  late PaymentBloc paymentBloc = BlocProvider.of<PaymentBloc>(context);

  final AuthenticationServices _authenticationServices = AuthenticationServices();
  final SettingsServices _settingsServices = SettingsServices();

  CameraPosition initialCameraPosition = CameraPosition(
    target: LatLng(
      (locator<MainApp>().currentUser?.latitude == null || locator<MainApp>().currentUser!.latitude == '') ?
      25.1876711 :
      double.parse(locator<MainApp>().currentUser!.latitude!),
        (locator<MainApp>().currentUser?.longitude == null || locator<MainApp>().currentUser!.longitude == '') ?
        55.2954627 :
        double.parse(locator<MainApp>().currentUser!.longitude!)

    ),
    zoom: 17,
  );

  final Completer<GoogleMapController> _googleMapController = Completer();

   Marker currentLocationMarker = Marker(
    markerId: const MarkerId('currentLocationMarker'),
    icon: BitmapDescriptor.defaultMarker,
    position: LatLng(
        (locator<MainApp>().currentUser?.latitude == null || locator<MainApp>().currentUser!.latitude == '') ?
        25.1876711 :
        double.parse(locator<MainApp>().currentUser!.latitude!),
        (locator<MainApp>().currentUser?.longitude == null || locator<MainApp>().currentUser!.longitude == '') ?
        55.2954627 :
        double.parse(locator<MainApp>().currentUser!.longitude!)

    ),
  );

  void _currentLocation() async {
    final GoogleMapController controller = await _googleMapController.future;
    LocationData? currentLocation;
    var location = Location();
    try {
      currentLocation = await location.getLocation();
      setState(() {
        currentLocationMarker = Marker(
          markerId: const MarkerId('currentLocationMarker'),
          icon: BitmapDescriptor.defaultMarker,
          position: LatLng(currentLocation!.latitude!, currentLocation.longitude!),
        );
      });
      _settingsServices
          .updateUserProfile(
        updateUserProfile: UpdateUserProfile(
          longitude: currentLocation.longitude!.toString(),
          latitude: currentLocation.latitude!.toString(),
          currency: null,
          residenceId: null,
          nationalId: null,
          sex: null,
          addresse: null,
          email: null,
          firstName: null,
          lang: null,
          avatar: null,
          lastName: null,
          allowNotifications: null,
          phone: null,
        ),
      )
          .then((userData) {
        if (userData is SuccessState<BaseSuccessResponse>) {
          locator<MainApp>().currentUser!.longitude = currentLocation!.longitude!.toString();
          locator<MainApp>().currentUser!.latitude = currentLocation.latitude!.toString();
        } else if (userData is ErrorState<BaseSuccessResponse>) {}
      });
    } on Exception {
      currentLocation = null;
    }

    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        bearing: 0,
        target: LatLng(currentLocation!.latitude!, currentLocation.longitude!),
        zoom: 17.0,
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    CartProductsProvider cartProductsProvider = Provider.of<CartProductsProvider>(context, listen: true);
    return BlocListener(
      listener: (context, state) {
        nextBtnController.reset();
        if (state is PayingWithCardSucceeded) {
          cartProductsProvider.clear();
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (BuildContext context) =>
                  InvoiceCouponsPage(
                    paymentData: state.paymentData,
                  ),
            ),
          );
          _authenticationServices.getUserProfile(token: locator<MainApp>().token!).then((userData) {
            if (userData is SuccessState<UserData>) {
              locator<MainApp>().currentUser = userData.data.user;
            } else if (userData is ErrorState<UserData>) {
              AppFlushBar.showFlushbar(message: userData.error.error).show(context);
            }
          });
        } else if (state is PayingWithCardFailed) {
          AppFlushBar.showFlushbar(message: state.baseErrorResponse.error).show(context);
        }
      },
      bloc: paymentBloc,
      listenWhen: (previous, current) {
        return previous != current;
      },
      child: MainScaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
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
                        S
                            .of(context)
                            .shippingAddress,
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
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.whiteLilac,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: ClipPath(
                              clipper: CustomContainerClipper(borderRadius: 20),
                              child: Scaffold(
                                body: GoogleMap(
                                  initialCameraPosition: initialCameraPosition,
                                  onMapCreated: (controller) => _googleMapController.complete(controller),
                                  zoomControlsEnabled: false,
                                  markers: {currentLocationMarker},
                                  onTap: (latLng) {
                                    setState(() {
                                      currentLocationMarker = Marker(
                                        markerId: const MarkerId('currentLocationMarker'),
                                        icon: BitmapDescriptor.defaultMarker,
                                        position: latLng,
                                      );
                                    });
                                  },
                                ),
                                floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
                                floatingActionButton: FloatingActionButton(
                                  onPressed: _currentLocation,
                                  backgroundColor: AppColors.whiteLilac,
                                  child: Icon(
                                    Icons.my_location,
                                    size: 28,
                                    color: AppColors.dirtyPurple,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Row(
                            children: [
                              Expanded(
                                child: RoundedLoadingButton(
                                  color: AppColors.frenchBlue,
                                  onPressed: () {
                                    _settingsServices
                                        .updateUserProfile(
                                      updateUserProfile: UpdateUserProfile(
                                        longitude: currentLocationMarker.position.longitude.toString(),
                                        latitude: currentLocationMarker.position.latitude.toString(),
                                        currency: null,
                                        residenceId: null,
                                        nationalId: null,
                                        sex: null,
                                        addresse: null,
                                        email: null,
                                        firstName: null,
                                        lang: null,
                                        avatar: null,
                                        lastName: null,
                                        allowNotifications: null,
                                        phone: null,
                                      ),
                                    )
                                        .then((userData) {
                                      if (userData is SuccessState<BaseSuccessResponse>) {
                                        locator<MainApp>().currentUser!.longitude = currentLocationMarker.position.longitude.toString();
                                        locator<MainApp>().currentUser!.latitude = currentLocationMarker.position.latitude.toString();
                                      } else if (userData is ErrorState<BaseSuccessResponse>) {}
                                    });
                                    paymentBloc.add(
                                      PayWithCart(
                                          addPaymentData: AddPaymentData(
                                              amount: cartProductsProvider.total,
                                              cart: cartProductsProvider.cartProducts
                                                  .map((cartProduct) =>
                                                  AddCart(
                                                    id: cartProduct.id,
                                                    quantity: cartProduct.countOfThisProductInCart,
                                                  ))
                                                  .toList(),
                                              longitude: currentLocationMarker.position.longitude.toString(),
                                              latitude: currentLocationMarker.position.latitude.toString(),
                                              paymentId: widget.paymentId,
                                              isDonate: cartProductsProvider.isDonate)),
                                    );
                                  },
                                  controller: nextBtnController,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                                    child: Text(
                                      S
                                          .of(context)
                                          .next,
                                      style: AppStyles.h2.copyWith(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
