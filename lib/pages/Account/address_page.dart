import 'package:flutter/material.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:safaqtek/constants/app_colors.dart';
import 'package:safaqtek/constants/app_styles.dart';
import 'package:safaqtek/generated/l10n.dart';
import 'package:safaqtek/widgets/main_scaffold.dart';

class AddressPage extends StatefulWidget {
  const AddressPage({Key? key}) : super(key: key);

  @override
  _AddressPageState createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  final RoundedLoadingButtonController _btnController = RoundedLoadingButtonController();
  String address = '';

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
        body: SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context,'');
                  },
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: AppColors.whiteLilac,
                  ),
                ),
                Text(
                  S.of(context).address,
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 15),
            child: TextField(
              style: AppStyles.h2.copyWith(color: AppColors.gunPowder),
              decoration: InputDecoration(
                fillColor: AppColors.whiteLilac,
                filled: true,
                hintText: S.of(context).writeAddress,
                hintStyle: AppStyles.h2.copyWith(color: AppColors.gunPowder),
                border: UnderlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: (value) {
                address = value;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15.0,horizontal: 8.0),
            child: RoundedLoadingButton(
              width: double.maxFinite,
              loaderStrokeWidth: 2.0,
              onPressed: () async {
                Navigator.pop(context,address);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 8),
                child: Text(
                  S.of(context).saveChanges,
                  style: AppStyles.h2.copyWith(color: Colors.white),
                ),
              ),
              color: AppColors.frenchBlue,
              controller: _btnController,
            ),
          ),
          const SizedBox(
            width: 10,
          ),
        ],
      ),
    ));
  }
}
