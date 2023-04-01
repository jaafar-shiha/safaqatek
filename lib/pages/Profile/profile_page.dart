import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:safaqtek/GetIt/main_app.dart';
import 'package:safaqtek/constants/app_colors.dart';
import 'package:safaqtek/constants/app_styles.dart';
import 'package:safaqtek/constants/main_tab_enum.dart';
import 'package:safaqtek/generated/l10n.dart';
import 'package:safaqtek/locator.dart';
import 'package:safaqtek/models/User/user_data.dart';
import 'package:safaqtek/models/base_success_response.dart';
import 'package:safaqtek/pages/AboutUs/about_us.dart';
import 'package:safaqtek/pages/Account/account_page.dart';
import 'package:safaqtek/pages/ContactUs/contact_us.dart';
import 'package:safaqtek/pages/Levels/levels_page.dart';
import 'package:safaqtek/pages/LogIn/log_in_page.dart';
import 'package:safaqtek/pages/PrivacyPolicy/privacy_policy.dart';
import 'package:safaqtek/pages/Profile/memership_stepper.dart';
import 'package:safaqtek/pages/Profile/option_card.dart';
import 'package:safaqtek/pages/Settings/settings_page.dart';
import 'package:safaqtek/pages/Support/support_page.dart';
import 'package:safaqtek/pages/TermsAndConditions/terms_and_conditions.dart';
import 'package:safaqtek/pages/UserAgreement/user_agreement.dart';
import 'package:safaqtek/pages/Winners/winners_page.dart';
import 'package:safaqtek/providers/cart_products_provider.dart';
import 'package:safaqtek/providers/main_provider.dart';
import 'package:safaqtek/providers/tabs_provider.dart';
import 'package:safaqtek/services/authentication_services.dart';
import 'package:safaqtek/services/settings_services.dart';
import 'package:safaqtek/utils/result_classes.dart';
import 'package:safaqtek/widgets/app_dialog.dart';
import 'package:safaqtek/widgets/app_flushbar.dart';
import 'package:safaqtek/widgets/main_scaffold.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ImagePicker picker = ImagePicker();
  XFile? image;
  late MainProvider mainProvider;
  bool isLoading = false;

  final SettingsServices _settingsServices = SettingsServices();
  final AuthenticationServices _authenticationServices = AuthenticationServices();

  @override
  Widget build(BuildContext context) {
    mainProvider = Provider.of<MainProvider>(locator<MainApp>().context!, listen: false);
    return WillPopScope(
      onWillPop: (){
        Navigator.pop(context, mainProvider.refreshProductsList);
        return Future.delayed(const Duration(milliseconds: 1));
      },
      child: ModalProgressHUD(
        inAsyncCall: isLoading,
        child: MainScaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 15),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context, mainProvider.refreshProductsList);
                          },
                          icon: Icon(
                            Icons.arrow_back_ios,
                            color: AppColors.whiteLilac,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 17.0,
                    ),
                    child: ListTile(
                      leading: GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => AppDialog.showOptionDialog(
                              options: [
                                TextButton(
                                  onPressed: () async {
                                    image = await picker.pickImage(
                                      source: ImageSource.gallery,
                                    );
                                    Navigator.pop(context);
                                    setState(() {
                                      isLoading = true;
                                    });
                                    await _settingsServices
                                        .updateUserImage(
                                      imageFile: File(image!.path),
                                    )
                                        .then((value) async {
                                      setState(() {
                                        isLoading = false;
                                      });
                                      if (value is SuccessState<BaseSuccessResponse>) {
                                        await _authenticationServices
                                            .getUserProfile(
                                          token: locator<MainApp>().token!,
                                        )
                                            .then((userData) {
                                          if (userData is SuccessState<UserData>) {
                                            locator<MainApp>().currentUser = userData.data.user;
                                            mainProvider.setProfileUrl(userData.data.user.avatar);
                                            setState(() {});
                                          } else if (userData is ErrorState<UserData>) {
                                            AppFlushBar.showFlushbar(message: userData.error.error).show(context);
                                          }
                                        });
                                      } else if (value is ErrorState<BaseSuccessResponse>) {
                                        AppFlushBar.showFlushbar(message: value.error.error).show(context);
                                      }
                                    });
                                  },
                                  child: Text(
                                    S.of(context).selectFromGallery,
                                    style: AppStyles.h2,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    image = await picker.pickImage(
                                      source: ImageSource.camera,
                                    );
                                    Navigator.pop(context);
                                    setState(() {
                                      isLoading = true;
                                    });
                                    await _settingsServices
                                        .updateUserImage(
                                      imageFile: File(image!.path),
                                    )
                                        .then((value) async {
                                      setState(() {
                                        isLoading = false;
                                      });
                                      if (value is SuccessState<BaseSuccessResponse>) {
                                        await _authenticationServices
                                            .getUserProfile(
                                          token: locator<MainApp>().token!,
                                        )
                                            .then((userData) {
                                          if (userData is SuccessState<UserData>) {
                                            locator<MainApp>().currentUser = userData.data.user;
                                            mainProvider.setProfileUrl(userData.data.user.avatar);
                                            setState(() {});
                                          } else if (userData is ErrorState<UserData>) {
                                            AppFlushBar.showFlushbar(message: userData.error.error).show(context);
                                          }
                                        });
                                      } else if (value is ErrorState<BaseSuccessResponse>) {
                                        AppFlushBar.showFlushbar(message: value.error.error).show(context);
                                      }
                                    });
                                  },
                                  child: Text(
                                    S.of(context).takeAPicture,
                                    style: AppStyles.h2,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        child: Consumer<MainProvider>(
                          builder: (context, mainProvider, _) {
                            return CircleAvatar(
                              radius: 28,
                              backgroundImage: (mainProvider.profileUrl != null && mainProvider.profileUrl != '')
                                  ? NetworkImage(
                                      mainProvider.profileUrl!,
                                    )
                                  : const AssetImage('assets/images/default_profile_picture.png') as ImageProvider,
                              backgroundColor: AppColors.royalFuchsia,
                            );
                          },
                        ),
                      ),
                      title: Text(
                        '${locator<MainApp>().currentUser!.firstName} ${locator<MainApp>().currentUser!.lastName}',
                        style: AppStyles.h2.copyWith(color: AppColors.whiteLilac),
                      ),
                      subtitle: Text(
                        locator<MainApp>().currentUser!.email,
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.whiteLilac,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ),
                  const MembershipStepper(),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 20.0,
                      ),
                      child: Container(
                        decoration: BoxDecoration(color: AppColors.whiteLilac, borderRadius: BorderRadius.circular(40)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                OptionCard(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(builder: (context) => const AccountPage()),
                                    );
                                  },
                                  iconPath: 'assets/images/account.png',
                                  title: S.of(context).account,
                                ),
                                OptionCard(
                                  onTap: () {
                                    Provider.of<TabsProvider>(context, listen: false)
                                        .setCurrentTab(currentTab: Tabs.wishlist);
                                    Navigator.pop(context);
                                  },
                                  iconPath: 'assets/images/wishlist.png',
                                  title: S.of(context).wishlist,
                                ),
                                OptionCard(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => const LevelsPage()),
                                    );
                                  },
                                  iconPath: 'assets/images/levels.png',
                                  title: S.of(context).levels,
                                ),
                                OptionCard(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => const WinnersPage()),
                                    );
                                  },
                                  iconPath: 'assets/images/winners.png',
                                  title: S.of(context).winners,
                                ),
                                OptionCard(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(builder: (context) => const SettingsPage()),
                                    );
                                  },
                                  iconPath: 'assets/images/settings.png',
                                  title: S.of(context).settings,
                                ),
                                OptionCard(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(builder: (context) => const SupportPage()),
                                    );
                                  },
                                  iconPath: 'assets/images/support.png',
                                  title: S.of(context).support,
                                ),
                                OptionCard(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(builder: (context) => const ContactUs()),
                                    );
                                  },
                                  iconPath: 'assets/images/contact-us.png',
                                  title: S.of(context).contactUs,
                                ),
                                OptionCard(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(builder: (context) => const AboutUs()),
                                    );
                                  },
                                  iconPath: 'assets/images/about-us.png',
                                  title: S.of(context).aboutUS,
                                ),
                                OptionCard(
                                  onTap: () {},
                                  iconPath: 'assets/images/rate-us.png',
                                  title: S.of(context).rateUs,
                                ),
                                OptionCard(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(builder: (context) => const TermsAndConditions()),
                                    );
                                  },
                                  iconPath: 'assets/images/terms-policy-agreement.png',
                                  title: S.of(context).termsAndConditions,
                                ),
                                OptionCard(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(builder: (context) => const PrivacyPolicy()),
                                    );
                                  },
                                  iconPath: 'assets/images/terms-policy-agreement.png',
                                  title: S.of(context).privacyPolicy,
                                ),
                                OptionCard(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(builder: (context) => const UserAgreement()),
                                    );
                                  },
                                  iconPath: 'assets/images/terms-policy-agreement.png',
                                  title: S.of(context).userAgreement,
                                ),
                                OptionCard(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) =>
                                          AppDialog.showAlertDialog(title: S.of(context).doYouWantToLogOut, actions: [
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.pop(context);
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                            child: Text(
                                              S.of(context).no,
                                              style: AppStyles.h3,
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            //1 SharedPreferences prefs = Provider.of<MainProvider>(
                                            //   context,
                                            //   listen: false,
                                            // ).prefs!;
                                            Provider.of<CartProductsProvider>(context, listen: false).clear();
                                            Provider.of<MainProvider>(context, listen: false).setProfileUrl(
                                              null,
                                            );
                                            locator<MainApp>().sharedPreferences!.setBool('isLoggedIn', false);
                                            locator<MainApp>().sharedPreferences!.remove('user');
                                            locator<MainApp>().sharedPreferences!.remove('token');
                                            locator<MainApp>().currentUser = null;
                                            locator<MainApp>().token = null;
                                            Navigator.popUntil(context, (route) => route.isFirst);
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => const LogInPage(),
                                              ),
                                            );
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                            child: Text(
                                              S.of(context).yes,
                                              style: AppStyles.h3,
                                            ),
                                          ),
                                        )
                                      ]),
                                    );
                                  },
                                  iconPath: 'assets/images/logout.png',
                                  title: S.of(context).logout,
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
        ),
      ),
    );
  }
}
