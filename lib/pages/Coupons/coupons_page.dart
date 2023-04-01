import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:safaqtek/blocs/CouponsBloc/coupons_bloc.dart';
import 'package:safaqtek/blocs/CouponsBloc/coupons_event.dart';
import 'package:safaqtek/blocs/CouponsBloc/coupons_state.dart';
import 'package:safaqtek/constants/app_colors.dart';
import 'package:safaqtek/constants/app_styles.dart';
import 'package:safaqtek/constants/main_tab_enum.dart';
import 'package:safaqtek/generated/l10n.dart';
import 'package:safaqtek/models/Coupons/coupon.dart';
import 'package:safaqtek/pages/Coupons/coupons_list_widget.dart';
import 'package:safaqtek/pages/Coupons/empty_coupons_widget.dart';
import 'package:safaqtek/providers/tabs_provider.dart';
import 'package:safaqtek/widgets/app_flushbar.dart';
import 'package:safaqtek/widgets/main_scaffold.dart';

class CouponsPage extends StatefulWidget {
  const CouponsPage({Key? key}) : super(key: key);

  @override
  _CouponsPageState createState() => _CouponsPageState();
}

class _CouponsPageState extends State<CouponsPage> {
  final ValueNotifier<bool> isLoading = ValueNotifier(true);

  @override
  void initState() {

    _couponsBloc.add(const GetCoupons());
    super.initState();
  }



  late final CouponsBloc _couponsBloc = BlocProvider.of<CouponsBloc>(context);

  ValueNotifier<List<Coupon>> coupons = ValueNotifier(List.empty(growable: true));
  @override
  Widget build(BuildContext context) {
    TabsProvider tabsProvider = Provider.of<TabsProvider>(context);
    return WillPopScope(
      onWillPop: (){
        tabsProvider.setCurrentTab(currentTab: Tabs.home);
        return Future.delayed(const Duration(milliseconds: 1));
      },
      child: BlocListener(
        listener: (context, state) {
          isLoading.value = false;
          if (state is CouponsSuccessState){
            coupons.value = state.couponsData.data;
          }
          if (state is CouponsErrorState){
            AppFlushBar.showFlushbar(message: state.error.error).show(context);
          }
        },
        bloc: _couponsBloc,
        listenWhen: (previous, current){
          return previous != current;
        },
        child: ValueListenableBuilder<List<Coupon>>(
          valueListenable: coupons,
          builder: (context, val, child){
            return MainScaffold(
              body: SafeArea(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 25.0,
                        vertical: 15,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: () {
                              tabsProvider.setCurrentTab(currentTab: Tabs.home);
                            },
                            icon: Icon(
                              Icons.arrow_back_ios,
                              color: AppColors.whiteLilac,
                            ),
                          ),
                          Text(
                            S.of(context).coupons,
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
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.whiteLilac,
                            borderRadius: BorderRadius.circular(40),
                          ),
                          child: ValueListenableBuilder<bool>(
                            valueListenable: isLoading,
                            builder: (context, _, child) {
                              if (isLoading.value) {
                                return SpinKitPulse(
                                  color: AppColors.dirtyPurple,
                                  duration: const Duration(seconds: 2),
                                );
                              }
                              return child!;
                            },
                            child: Column(
                              children: [
                                if (coupons.value.isEmpty)
                                  const EmptyCouponsWidget(),
                                if (coupons.value.isNotEmpty)
                                  Expanded(child: CouponsListWidget(coupons: coupons.value,)),
                                if (coupons.value.isNotEmpty)
                                Row(
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: TextButton(
                                          onPressed: () {
                                            tabsProvider.setCurrentTab(currentTab: Tabs.home);
                                          },
                                          child: Text(
                                            S.of(context).buyMore,
                                            style: AppStyles.h2.copyWith(
                                              color: AppColors.whiteLilac,
                                            ),
                                          ),
                                          style: ButtonStyle(
                                            backgroundColor: MaterialStateProperty.all<Color>(
                                              AppColors.frenchBlue,
                                            ),
                                            shape: MaterialStateProperty.all<OutlinedBorder>(
                                              RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(25),
                                              ),
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
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 80,
                    ),
                  ],
                ),
              ),
            );
        },
        ),
      ),
    );
  }
}
