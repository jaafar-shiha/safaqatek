import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:safaqtek/constants/app_colors.dart';
import 'package:safaqtek/constants/app_styles.dart';

class NotificationCard extends StatelessWidget {
  final String title;
  final String date;

  const NotificationCard({Key? key, required this.title, required this.date}) : super(key: key);

  String getFormattedTime(String dateString) {
    DateTime date;
    try{
      date = Intl.withLocale('en', () => DateFormat("MM/dd/yyyy").parse(dateString));
    }
    catch(e){
      date = DateTime.now();
    }
    return '${DateFormat.MMMM().format(date)} ${date.day}, ${DateFormat.y().format(date)}';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.whiteLilac,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppStyles.h2.copyWith(fontSize: 14),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    getFormattedTime(date),
                    style: AppStyles.h3,
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
