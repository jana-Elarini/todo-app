import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../app-colors.dart';
import '../../provider/app_config_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ThemeBottomSheet extends StatefulWidget {
  const ThemeBottomSheet({Key? key}) : super(key: key);

  @override
  State<ThemeBottomSheet> createState() => _ThemeBottomSheetState();
}

class _ThemeBottomSheetState extends State<ThemeBottomSheet> {
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AppConfigProvider>(context);
    return Container(
      margin: EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: InkWell(
                onTap: () {
                  provider.changeTheme(ThemeMode.light);
                },
                child: provider.appMode == ThemeMode.light
                    ? getSelectedItemWidget(AppLocalizations.of(context)!.light)
                    : getUnSelectedItemWidget(
                        AppLocalizations.of(context)!.light)),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: InkWell(
                onTap: () {
                  provider.changeTheme(ThemeMode.dark);
                },
                child: provider.appMode == ThemeMode.dark
                    ? getSelectedItemWidget(AppLocalizations.of(context)!.dark)
                    : getUnSelectedItemWidget(
                        AppLocalizations.of(context)!.dark)),
          ),
        ],
      ),
    );
  }

  Widget getSelectedItemWidget(String text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          text,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
              //t3mlk copy mn ay design 3ndk

              color: AppColors.primaryColor),
        ),
        Icon(Icons.check, size: 30, color: AppColors.primaryColor)
      ],
    );
  }

  Widget getUnSelectedItemWidget(String text) {
    return Text(text, style: Theme.of(context).textTheme.bodySmall);
  }
}
