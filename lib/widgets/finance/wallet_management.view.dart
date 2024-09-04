import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:fuodz/constants/app_strings.dart';
import 'package:fuodz/constants/app_ui_settings.dart';
import 'package:fuodz/constants/sizes.dart';
import 'package:fuodz/extensions/string.dart';
import 'package:fuodz/services/auth.service.dart';
import 'package:fuodz/utils/ui_spacer.dart';
import 'package:fuodz/utils/utils.dart';
import 'package:fuodz/view_models/wallet.vm.dart';
import 'package:fuodz/views/pages/wallet/wallet.page.dart';
import 'package:fuodz/widgets/busy_indicator.dart';
import 'package:fuodz/widgets/buttons/custom_button.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

class WalletManagementView extends StatefulWidget {
  const WalletManagementView({
    this.viewmodel,
    this.padding,
    this.breif = true,
    Key? key,
  }) : super(key: key);

  final WalletViewModel? viewmodel;
  final EdgeInsetsGeometry? padding;
  final bool breif;

  @override
  State<WalletManagementView> createState() => _WalletManagementViewState();
}

class _WalletManagementViewState extends State<WalletManagementView>
    with WidgetsBindingObserver {
  WalletViewModel? mViewmodel;
  @override
  void initState() {
    super.initState();

    mViewmodel = widget.viewmodel;
    mViewmodel ??= WalletViewModel(context);
    if (widget.breif) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        //
        mViewmodel?.initialise();
      });
      WidgetsBinding.instance.addObserver(this);
    }
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      if (widget.breif) {
        mViewmodel?.initialise();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // final bgColor = Colors.grey.shade200;
    Color bgColor = context.cardColor;
    final textColor = Utils.textColorByColor(bgColor);
    //
    return Padding(
      padding: widget.padding ??
          const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
      child: ViewModelBuilder<WalletViewModel>.reactive(
        viewModelBuilder: () => mViewmodel!,
        disposeViewModel: widget.viewmodel == null,
        builder: (context, vm, child) {
          return StreamBuilder(
            stream: AuthServices.listenToAuthState(),
            builder: (ctx, snapshot) {
              //
              if (!snapshot.hasData) {
                return UiSpacer.emptySpace();
              }
              //view for full info
              if (!widget.breif) {
                return VStack(
                  [
                    //
                    Visibility(
                      visible: vm.isBusy,
                      child: BusyIndicator(),
                    ),

                    VStack(
                      [
                        //
                        "${AppStrings.currencySymbol} ${vm.wallet != null ? vm.wallet?.balance : 0.00}"
                            .currencyFormat()
                            .text
                            .color(textColor)
                            .xl3
                            .semiBold
                            .makeCentered(),
                        UiSpacer.verticalSpace(space: 5),
                        "Wallet Balance"
                            .tr()
                            .text
                            .color(textColor)
                            .makeCentered(),
                      ],
                    ),

                    UiSpacer.vSpace(10),
                    //buttons
                    Visibility(
                      visible: !vm.isBusy,
                      child: HStack(
                        [
                          //tranfer button
                          if (AppUISettings.allowWalletTransfer)
                            CustomButton(
                              shapeRadius: Sizes.radiusSmall,
                              onPressed: vm.showWalletTransferEntry,
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: VStack(
                                  [
                                    Icon(
                                      FlutterIcons.upload_fea,
                                      color: Utils.textColorByTheme(),
                                      size: Sizes.fontSizeLarge,
                                    ),

                                    //
                                    "Send"
                                        .tr()
                                        .text
                                        .size(Sizes.fontSizeExtraSmall)
                                        .color(Utils.textColorByTheme())
                                        .make(),
                                  ],
                                  crossAlignment: CrossAxisAlignment.center,
                                  alignment: MainAxisAlignment.center,
                                  spacing: 1,
                                ).py(0),
                              ),
                            ).expand(flex: 2),

                          //topup button
                          CustomButton(
                            shapeRadius: Sizes.radiusSmall,
                            onPressed: vm.showAmountEntry,
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: VStack(
                                [
                                  Icon(
                                    // Icons.add,
                                    FlutterIcons.plus_ant,
                                    color: Utils.textColorByTheme(),
                                    size: Sizes.fontSizeLarge,
                                  ),
                                  //
                                  "Top Up"
                                      .tr()
                                      .text
                                      .size(Sizes.fontSizeExtraSmall)
                                      .color(Utils.textColorByTheme())
                                      .make(),
                                ],
                                crossAlignment: CrossAxisAlignment.center,
                                alignment: MainAxisAlignment.center,
                                spacing: 1,
                              ).py(0),
                            ),
                          ).expand(flex: 3),

                          //tranfer button
                          if (AppUISettings.allowWalletTransfer)
                            CustomButton(
                              shapeRadius: Sizes.radiusSmall,
                              onPressed: vm.showMyWalletAddress,
                              loading: vm.busy(vm.showMyWalletAddress),
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: VStack(
                                  [
                                    Icon(
                                      FlutterIcons.download_fea,
                                      color: Utils.textColorByTheme(),
                                      size: Sizes.fontSizeLarge,
                                    ),

                                    //
                                    "Receive"
                                        .tr()
                                        .text
                                        .size(Sizes.fontSizeExtraSmall)
                                        .color(Utils.textColorByTheme())
                                        .make(),
                                  ],
                                  crossAlignment: CrossAxisAlignment.center,
                                  alignment: MainAxisAlignment.center,
                                  spacing: 1,
                                ).py(0),
                              ),
                            ).expand(flex: 2),
                        ],
                        spacing: 10,
                        alignment: MainAxisAlignment.center,
                        crossAlignment: CrossAxisAlignment.center,
                      ),
                    ),
                  ],
                  alignment: MainAxisAlignment.center,
                  crossAlignment: CrossAxisAlignment.center,
                )
                    .p12()
                    .box
                    .shadowXs
                    .color(bgColor)
                    .withRounded(value: Sizes.radiusSmall)
                    .make()
                    .wFull(context);
              }

              return VStack(
                [
                  HStack(
                    [
                      //loading
                      if (vm.isBusy) BusyIndicator(),
                      //
                      VStack(
                        [
                          //
                          "${AppStrings.currencySymbol} ${vm.wallet != null ? vm.wallet?.balance : 0.00}"
                              .currencyFormat()
                              .text
                              .color(textColor)
                              .xl3
                              .semiBold
                              .make(),
                          2.heightBox,
                          "Wallet Balance".tr().text.color(textColor).make(),
                        ],
                        crossAlignment: CrossAxisAlignment.start,
                        alignment: MainAxisAlignment.start,
                      ).expand(),

                      // top-up button
                      CustomButton(
                        shapeRadius: 12,
                        onPressed: vm.showAmountEntry,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: HStack(
                            [
                              //
                              "Top-Up"
                                  .tr()
                                  .text
                                  .lg
                                  .semiBold
                                  .color(Utils.textColorByTheme())
                                  .make(),
                              Icon(
                                // Icons.add,
                                FlutterIcons.plus_ant,
                                color: Utils.textColorByTheme(),
                              ),
                            ],
                            crossAlignment: CrossAxisAlignment.center,
                            alignment: MainAxisAlignment.center,
                            spacing: 6,
                          ),
                        ),
                      ),
                    ],
                    spacing: 20,
                  ),
                  "Tap for more info/action".tr().text.sm.makeCentered(),
                ],
                spacing: 3,
              )
                  .p12()
                  .box
                  .shadowXs
                  .color(bgColor)
                  .withRounded(value: Sizes.radiusSmall)
                  .make()
                  .wFull(context)
                  .onInkTap(
                () {
                  context.nextPage(WalletPage());
                },
              );
            },
          );
        },
      ),
    );
  }
}
