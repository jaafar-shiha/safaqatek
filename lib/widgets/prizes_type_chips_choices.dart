import 'package:flutter/material.dart';
import 'package:chips_choice_null_safety/chips_choice_null_safety.dart';
import 'package:safaqtek/constants/app_colors.dart';
import 'package:safaqtek/constants/app_styles.dart';
import 'package:safaqtek/models/Setttings/product_category.dart';

class PrizesTypeChipsChoices extends StatefulWidget {
  final List<ProductCategory> categories;
  final Function(int) onChanged;

  const PrizesTypeChipsChoices({
    Key? key,
    required this.categories,
    required this.onChanged,
  }) : super(key: key);

  @override
  _PrizesTypeChipsChoicesState createState() => _PrizesTypeChipsChoicesState();
}

class _PrizesTypeChipsChoicesState extends State<PrizesTypeChipsChoices> {
  late ValueNotifier<ProductCategory> selectedPrizesType ;


  @override
  Widget build(BuildContext context) {
    selectedPrizesType = ValueNotifier(widget.categories.first);
    return ValueListenableBuilder<ProductCategory>(
      valueListenable: selectedPrizesType,
      builder: (context, val, child) {
        return ChipsChoice<ProductCategory>.single(
          value: selectedPrizesType.value,
          onChanged: (value) {
            selectedPrizesType.value = value;
            widget.onChanged(value.id);
          },
          choiceItems: C2Choice.listFrom<ProductCategory, String>(
            source: widget.categories.map((e) => e.name).toList(),
            value: (i, v) => widget.categories[i],
            label: (i, v) => v,
          ),
          choiceBuilder: (c) {
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 10.0,
                ),
                child: GestureDetector(
                  onTap: () {
                    c.select;
                    selectedPrizesType.value = c.value;
                    widget.onChanged(c.value.id);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: c.selected ? AppColors.dirtyPurple : AppColors.gray,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 10),
                      child: Row(
                        children: [
                          Text(
                            c.label,
                            style: AppStyles.h3.copyWith(
                              color: c.selected ? AppColors.dirtyPurple : AppColors.gray,
                            ),
                          ),
                          if (c.value.image != "")
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 4.0),
                              child: Image.network(
                                c.value.image!,
                                height: 20,
                                width: 20,
                                loadingBuilder: (context, child, loadingProgress) {
                                  if (loadingProgress == null) {
                                    return child;
                                  }
                                  return const SizedBox(
                                    height: 20,
                                    width: 20,
                                  );
                                },
                                errorBuilder: (context, child, errorBuilder) {
                                  return const SizedBox(
                                    height: 20,
                                    width: 20,
                                  );
                                },
                                color: c.selected ? AppColors.dirtyPurple : AppColors.gray,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
          choiceStyle: const C2ChoiceStyle(
            color: Colors.red,
            borderColor: Colors.red,
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
        );
      },
    );
  }
}
