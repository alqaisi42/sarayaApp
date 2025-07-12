

import 'dart:math';


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:newsapp/config/colors.dart';
import 'package:newsapp/config/constants.dart';




import '../../../Model/membership_model.dart';
import '../../../bloc/memberShipPlanBloc/membership_bloc.dart';
import '../../../bloc/memberShipPlanBloc/membership_event.dart';
import '../../../bloc/memberShipPlanBloc/membership_state.dart';
import '../../../bloc/paymentSettingsBloc/paymentsettings_bloc.dart';
import '../../../bloc/paymentSettingsBloc/paymentsettings_event.dart';
import '../../../bloc/paymentSettingsBloc/paymentsettings_state.dart';
import '../../../config/helper/helper_functions.dart';
import '../../../config/hiveLocalStorage/hive_storage.dart';
import '../../../config/paymentGateway/payment_gateway_option.dart';
import '../../../config/shimmer.dart';

import '../../../l10n/app_localizations.dart';

class MembershipScreen extends StatefulWidget {
  const MembershipScreen({super.key});

  @override
  State<MembershipScreen> createState() => _MembershipScreenState();
}

class _MembershipScreenState extends State<MembershipScreen>
    with TickerProviderStateMixin {
  int _selectedPlan = 1;
  late TabController _tabController;
  late AnimationController _backgroundAnimationController;
  List<MembershipPlan> _plans = [];

  final Map<int, int> _selectedTenureIndexes = {};

  final List<List<Color>> _planGradients = [
    [Color(0xFF6D67E4), Color(0xFF9C89FF)],
    [Color(0xFF3A86FF), Color(0xFF00C2FF)],
    [Color(0xFFFFA500), Color(0xFF474545)],
    // 5 additional color combinations
    [Color(0xFF4CAF50), Color(0xFF8BC34A)],
    [Color(0xFFE91E63), Color(0xFFF48FB1)],
    [Color(0xFF9C27B0), Color(0xFFCE93D8)],
    [Color(0xFF2196F3), Color(0xFF90CAF9)],
    [Color(0xFFFF5722), Color(0xFFFFAB91)],
  ];

  final List<IconData> _planIcons = [
    Icons.calendar_today_rounded,
    Icons.calendar_month_rounded,
    Icons.event_available_rounded,
    // 5 additional icons
    Icons.date_range_rounded,
    Icons.event_note_rounded,
    Icons.event_available_sharp,
    Icons.event_rounded,
    Icons.calendar_today_rounded
  ];

  @override
  void initState() {
    super.initState();


    _backgroundAnimationController = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    )..repeat();


    _tabController = TabController(length: 3, vsync: this, initialIndex: _selectedPlan);

    context.read<MembershipBloc>().add(FetchMembershipPlans());



    context.read<PaymentSettingsBloc>().add(FetchPaymentSettings());
  }

  @override
  void dispose() {
    _tabController.dispose();
    _backgroundAnimationController.dispose();
    super.dispose();
  }





  List<MembershipPlan> _convertToUiModel(MembershipPlansModel apiModel) {
    final List<MembershipPlan> uiPlans = [];



    for (var i = 0; i < apiModel.data.plans.length; i++) {
      final plan = apiModel.data.plans[i];

      if (plan.isActivePlan == true) {

        _selectedPlan = i;
      }




      if (plan.planTenures.isEmpty) continue;

      List<PlanTenureUI> tenures = [];


      for (var tenure in plan.planTenures) {
        int savePercent = 0;
        final originalPrice = double.tryParse(tenure.price) ?? 0;
        final discountPrice = double.tryParse(tenure.discountPrice) ?? 0;

        if (originalPrice > 0 && discountPrice > 0) {
          savePercent = ((originalPrice - discountPrice) / originalPrice * 100).round();
        }

        // Create price text with null safety
        String priceText = '${apiModel.data.currencySymbol}${
            double.tryParse(tenure.discountPrice) != 0.0
                ? tenure.discountPrice
                : tenure.price
        }';



        tenures.add(PlanTenureUI(
          id: tenure.id ,
          duration: tenure.duration,
          price: double.tryParse(tenure.price) ?? 0,
          discountPrice: double.tryParse(tenure.discountPrice) ?? 0,
          priceText: priceText,
          durationText: '${tenure.duration} ${AppLocalizations.of(context)!.month}${(tenure.duration) == 1 ? '' : 's'}',
          savePercent: savePercent,
          isActivePlan: plan.isActivePlan,
        ));
      }




      tenures.sort((a, b) => a.duration.compareTo(b.duration));


      if (!_selectedTenureIndexes.containsKey(plan.id)) {
        _selectedTenureIndexes[plan.id ] = 0;
      }


      final features = plan.features.isNotEmpty == true ? plan.features[0] : null;




      List<String> featuresList = [];
      if (features != null) {
        if (features.isAdsFree == true) {
          featuresList.add(AppLocalizations.of(context)!.adFreeExperience);
        }
        featuresList.add('${AppLocalizations.of(context)!.accessTo} ${features.numberOfArticles} ${AppLocalizations.of(context)!.articles} ');
        featuresList.add('${AppLocalizations.of(context)!.accessTo}  ${features.numberOfStories } ${AppLocalizations.of(context)!.stories}');
      }

      uiPlans.add(
        MembershipPlan(
          id: plan.id,
          title: plan.name.toString(),
          tenures: tenures,
          features: featuresList,
          gradientColors: _planGradients[i % _planGradients.length],
          icon: _planIcons[i % _planIcons.length],
           currecnySymbol: apiModel.data.currencySymbol.toString(), isActivePlan: plan.isActivePlan,
        ),
      );
    }

    return uiPlans;
  }

  PlanTenureUI getSelectedTenure(MembershipPlan plan) {
    final tenureIndex = _selectedTenureIndexes[plan.id] ?? 0;
    return plan.tenures[tenureIndex < plan.tenures.length ? tenureIndex : 0];
  }


  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;


    return MultiBlocListener(
      listeners: [
        BlocListener<MembershipBloc, MembershipState>(
          listener: (context, state) {
            if (state is MembershipSuccessState) {

              setState(() {

                _plans = _convertToUiModel(state.membershipPlanData[0]);




                // _selectedPlan = _plans.length > 1 ? 1 : 0;


                if (_selectedPlan >= _plans.length) {
                  _selectedPlan = _plans.isEmpty ? 0 : _plans.length - 1;
                }

                _tabController.dispose();
                _tabController = TabController(
                  length: _plans.isNotEmpty ? _plans.length : 1,
                  vsync: this,
                  initialIndex: _selectedPlan < _plans.length ? _selectedPlan : 0,
                );

                _tabController.addListener(() {
                  if (!_tabController.indexIsChanging) {
                    setState(() {
                      _selectedPlan = _tabController.index;
                    });
                  }
                });
              });



            }
          },
        ),
        BlocListener<PaymentSettingsBloc, PaymentSettingsState>(
          listener: (context, state) {

            if (state is PaymentSettingsErrorState) {
              CustomFloatingSnackBar.showCustomSnackBar(context, state.errorMessage, 0);
            }
          },
        ),
      ],
      child: BlocBuilder<MembershipBloc, MembershipState>(
        builder: (context, state) {
         bool? hasActiveSubscription =  false;
          if(state is MembershipSuccessState){
            hasActiveSubscription = state.membershipPlanData[0].data.activeSubscription.status;
          }


          if (state is MembershipLoadingState) {

            return SubscriptionLoadingScreen();
          }


          if (state is MembershipErrorState) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    state.errorMessage,
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      context.read<MembershipBloc>().add(FetchMembershipPlans());
                      context.read<PaymentSettingsBloc>().add(FetchPaymentSettings());
                    },
                    child: Text(AppLocalizations.of(context)!.retry),
                  ),
                ],
              ),
            );
          }

          if (_plans.isEmpty) {
            return EmptyMembershipState(
              onRetry: () {
                context.read<MembershipBloc>().add(FetchMembershipPlans());
                context.read<PaymentSettingsBloc>().add(FetchPaymentSettings());
              },
            );
          }

          if (_selectedPlan >= _plans.length) {
            _selectedPlan = _plans.length - 1;
          }

          final selectedPlan = _plans[_selectedPlan];
          final selectedTenure = getSelectedTenure(selectedPlan);

          return Scaffold(
            backgroundColor: AppColors.darkScondryColor,
            body: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverAppBar(
                  expandedHeight: size.height * 0.25,
                  pinned: true,
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Stack(
                      fit: StackFit.expand,
                      children: [
                        ShaderMask(
                          shaderCallback: (rect) {
                            return LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors:
                                  [const Color(0xFF1A1B2E), const Color(0xFF121212)]


                            ).createShader(rect);
                          },
                          blendMode: BlendMode.src,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black
                            ),
                          ),
                        ),
                        AnimatedBuilder(
                          animation: _backgroundAnimationController,
                          builder: (context, _) {
                            return CustomPaint(
                              painter: BackgroundPatternPainter(
                                isDark: false,
                                animation: _backgroundAnimationController,
                              ),
                            );
                          },
                        ),
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha:0.2),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.workspace_premium,
                                  size: 45,
                                  color: Colors.white.withValues(alpha:0.95),
                                ),
                              ),
                              SizedBox(height: 15),
                              Text(
                                AppLocalizations.of(context)!.elevateExperience,
                                style: TextStyle(
                                  fontSize: 22,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: -0.5,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha:0.15),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  AppLocalizations.of(context)!.joinMillions,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400,
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
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 25, 20, 0),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: selectedPlan.gradientColors,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.star_rounded,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            AppLocalizations.of(context)!.selectYourPlan,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.5,
                              color: Colors.white
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Container(
                    margin: EdgeInsets.fromLTRB(20, 8, 20, 20),
                    child: Text(
                      AppLocalizations.of(context)!.unlockPremiumExperience,
                      style: TextStyle(
                        fontSize: 15,
                        color:  Colors.grey[400] ,
                        height: 1.4,
                      ),
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverToBoxAdapter(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[800]!.withValues(alpha:0.5),

                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: TabBar(
                        dividerColor: Colors.transparent,
                        controller: _tabController,
                        labelColor: Colors.white,
                        unselectedLabelColor: Colors.grey[400],
                        indicatorSize: TabBarIndicatorSize.tab,
                        indicator: BoxDecoration(
                          gradient: LinearGradient(
                            colors: selectedPlan.gradientColors,
                          ),
                          borderRadius: BorderRadius.circular(50),
                          boxShadow: [
                            BoxShadow(
                              color: selectedPlan
                                  .gradientColors
                                  .first
                                  .withValues(alpha:0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(3),
                        labelPadding: const EdgeInsets.symmetric(horizontal: 5),
                        tabs: _plans
                            .map((plan) => Tab(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 5),
                            child: Text(
                              plan.title,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                                letterSpacing: -0.3,
                              ),
                            ),
                          ),
                        ))
                            .toList(),
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 470,
                    child: TabBarView(
                      controller: _tabController,
                      physics: const BouncingScrollPhysics(),
                      children: _plans.map((plan) {
                        final isSelected = _plans[_selectedPlan].id == plan.id;
                        return AnimatedPlanCardWithTenures(
                          plan: plan,
                          isSelected: isSelected,
                          selectedTenureIndex: _selectedTenureIndexes[plan.id] ?? 0,
                          onTenureChanged: (index) {
                            setState(() {
                              _selectedTenureIndexes[plan.id ?? 0] = index;
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),

                bottomNavigationBar: !hasActiveSubscription ?
                SafeArea(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFF1F1F1F),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha:0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  // Use layout builder to adapt to available width
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Price information with flexible width
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              alignment: Alignment.centerLeft,
                              child: Row(
                                children: [
                                  Text(
                                    selectedTenure.priceText,
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  if (selectedTenure.savePercent > 0)
                                    Container(
                                      margin: const EdgeInsets.only(left: 8),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: selectedPlan.gradientColors,
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        '${AppLocalizations.of(context)!.save} ${selectedTenure.savePercent}%',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              selectedTenure.durationText,
                              style: TextStyle(
                                fontSize: 14,
                                color:Colors.grey[400],
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      // Button with flexible width
                      Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: selectedPlan
                                  .gradientColors
                                  .first
                                  .withValues(alpha:0.3),
                              blurRadius: 12,
                              offset: const Offset(0, 5),
                            ),
                          ],
                          borderRadius: BorderRadius.circular(24),
                          gradient: LinearGradient(
                            colors: selectedPlan.gradientColors,
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: ElevatedButton(
                          onPressed: () async {
                            final token = await HiveStorage().getToken();
                            final planAmount = selectedTenure.discountPrice > 0
                                ? selectedTenure.discountPrice
                                : selectedTenure.price;

                            if (token != null) {

                              if (context.mounted) {
                                PaymentGatewayOptions(
                                  context: context,
                                  planAmount: planAmount,
                                  selectedPlan: '${selectedPlan.title} - ${selectedTenure.durationText}',
                                  tenureId: selectedTenure.id,
                                  planId: selectedPlan.id ?? 0,
                                ).showPaymentOptions();
                              }
                            } else {

                              if (context.mounted) {
                                GoRouter.of(context).push('/signin');
                              }
                            }
                          }
                          ,
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                              horizontal: constraints.maxWidth < 350 ? 16 : 24,
                              vertical: 12,
                            ),
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                AppLocalizations.of(context)!.getStarted,
                                style: TextStyle(
                                  fontSize: constraints.maxWidth < 350 ? 14 : 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Icon(
                                Icons.arrow_forward_rounded,
                                color: Colors.white,
                                size: constraints.maxWidth < 350 ? 16 : 18,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ) : null,
        );
      },

      )
      );

  }
}

class EmptyMembershipState extends StatelessWidget {
  final VoidCallback onRetry;

  const EmptyMembershipState({
    super.key,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkScondryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 180,
              width: 180,
              decoration: BoxDecoration(
                color: Color(0xFF292939),
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha:  0.15),
                    blurRadius: 20,
                    offset: Offset(0, 10),
                  ),
                ],
                border: Border.all(
                  color: Colors.white.withValues(alpha:0.1),
                  width: 1.5,
                ),
              ),
              child: Center(
                child: ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    colors: [Color(0xFF6D67E4), Color(0xFF3A86FF)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ).createShader(bounds),
                  child: Icon(
                    Icons.subscriptions_outlined,
                    size: 85,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(height: 35),
            // Title with gradient text
            ShaderMask(
              shaderCallback: (bounds) => LinearGradient(
                colors: [Color(0xFF6D67E4), Color(0xFF3A86FF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ).createShader(bounds),
              child: Text(
                AppLocalizations.of(context)!.noPlansAvailable,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: fontType
                ),
              ),
            ),
            SizedBox(height: 15),
            // Description text
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Text(

                    AppLocalizations.of(context)!.noPlansDescription,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[400],
                  fontFamily: fontType,
                  height: 1.5,
                ),
              ),
            ),
            SizedBox(height: 40),
            // Retry button with gradient
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF6D67E4), Color(0xFF3A86FF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFF6D67E4).withValues(alpha:0.3),
                    blurRadius: 15,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: onRetry,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 45, vertical: 16),
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.refresh_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                    SizedBox(width: 8),
                    Text(
                      AppLocalizations.of(context)?.retry ?? 'Try Again',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AnimatedPlanCardWithTenures extends StatefulWidget {
  final MembershipPlan plan;
  final bool isSelected;
  final int selectedTenureIndex;
  final Function(int) onTenureChanged;

  const AnimatedPlanCardWithTenures({
    super.key,
    required this.plan,
    required this.isSelected,
    required this.selectedTenureIndex,
    required this.onTenureChanged,
  });

  @override
  State<AnimatedPlanCardWithTenures> createState() => _AnimatedPlanCardWithTenuresState();
}

class _AnimatedPlanCardWithTenuresState extends State<AnimatedPlanCardWithTenures> {
  final ScrollController _scrollController = ScrollController();
  bool _showLeadingFade = false;
  bool _showTrailingFade = true;

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(_updateFades);

    // Wait for layout to complete before checking if trailing fade is needed
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateFades();
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_updateFades);
    _scrollController.dispose();
    super.dispose();
  }

  void _updateFades() {
    if (!_scrollController.hasClients) return;

    setState(() {
      // Show leading fade if scrolled away from start
      _showLeadingFade = _scrollController.offset > 10;

      // Show trailing fade if not at the end
      _showTrailingFade = _scrollController.position.maxScrollExtent - _scrollController.offset > 10;
    });
  }

  @override
  Widget build(BuildContext context) {


    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Color(0xFF292939),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: Offset(0, 5),
          ),
        ],
        border: Border.all(
          color: widget.isSelected
              ? widget.plan.gradientColors.first.withValues(alpha: 0.7)
              : Colors.transparent,
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: widget.plan.gradientColors,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  widget.plan.icon,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  widget.plan.title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color:
                    Colors.white ,
                  ),
                ),
              ),


              if (widget.plan.isActivePlan == true)

                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.green.shade600, Colors.green.shade400],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.active,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                )

            ],
          ),
          SizedBox(height: 25),

          // Tenure Selection
          Text(
            AppLocalizations.of(context)!.selectDuration,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white70 ,
            ),
          ),
          SizedBox(height: 10),


          Stack(
            children: [

              SizedBox(
                height: 50,
                child: ListView.builder(
                  controller: _scrollController,
                  scrollDirection: Axis.horizontal,
                  physics: BouncingScrollPhysics(),
                  itemCount: widget.plan.tenures.length,
                  itemBuilder: (context, index) {
                    final tenure = widget.plan.tenures[index];
                    final isSelectedTenure = index == widget.selectedTenureIndex;

                    return Container(
                      margin: EdgeInsets.only(right: 8),
                      child: GestureDetector(
                        onTap: () => widget.onTenureChanged(index),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(
                            gradient: isSelectedTenure
                                ? LinearGradient(colors: widget.plan.gradientColors)
                                : null,
                            color: isSelectedTenure
                                ? null
                                : Colors.grey[800] ,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: isSelectedTenure
                                ? [
                              BoxShadow(
                                color: widget.plan.gradientColors.first.withValues(alpha: 0.3),
                                blurRadius: 5,
                                offset: Offset(0, 2),
                              ),
                            ]
                                : null,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                tenure.durationText,
                                style: TextStyle(
                                  color: isSelectedTenure
                                      ? Colors.white
                                      : Colors.white70 ,
                                  fontWeight: isSelectedTenure ? FontWeight.bold : FontWeight.normal,
                                ),
                              ),
                              if (tenure.savePercent > 0) ...[
                                SizedBox(width: 8),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: isSelectedTenure ? 0.3 : 0.7),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    "Save ${tenure.savePercent}%",
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: isSelectedTenure
                                          ? Colors.white
                                          : widget.plan.gradientColors.first,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Left fade effect (only when scrolled)
              if (_showLeadingFade)
                Positioned(
                  left: 0,
                  top: 0,
                  bottom: 0,
                  width: 40,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerRight,
                        end: Alignment.centerLeft,
                        colors: [
                          ( Color(0xFF292939) ).withValues(alpha:0.0),
                          (Color(0xFF292939)),
                        ],
                      ),
                    ),
                  ),
                ),

              // Right fade effect (only when there's more content)
              if (_showTrailingFade)
                Positioned(
                  right: 0,
                  top: 0,
                  bottom: 0,
                  width: 40,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          (Color(0xFF292939)).withValues(alpha:0.0),
                          (Color(0xFF292939) ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),

          SizedBox(height: 25),

          // Price display
          if (widget.plan.tenures.isNotEmpty && widget.selectedTenureIndex < widget.plan.tenures.length) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  widget.plan.tenures[widget.selectedTenureIndex].priceText,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white ,
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  "/ ${widget.plan.tenures[widget.selectedTenureIndex].durationText}",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[400] ,
                  ),
                ),
              ],
            ),
          ],

          SizedBox(height: 5),
          Divider(height: 0.2),
          SizedBox(height: MediaQueryHelper.screenHeight(context) * 0.04),
          // "Included Features" title
          Row(
            children: [
              Container(
                margin: EdgeInsets.only(top: 3),
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: widget.plan.gradientColors,
                  ),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 12,
                ),
              ),
              SizedBox(width: 10),
              Text(
                AppLocalizations.of(context)!.includedFeatures,
                style: TextStyle(
                  fontSize: 17,
                  color: Colors.grey[300],
                  height: 1.4,
                ),
              )
            ],
          ),
          SizedBox(height: 12),


          ListView(
            shrinkWrap: true,
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.zero,
            children: widget.plan.features.map((feature) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 3),
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: widget.plan.gradientColors,
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 12,
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      feature,
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey[300],
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            )).toList(),
          )

        ],
      ),
    );
  }
}

class BackgroundPatternPainter extends CustomPainter {
  final Animation<double>? animation;
  final bool isDark;

  BackgroundPatternPainter({required this.isDark, this.animation}) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    // Use a color that will show up in both light and dark modes
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.05)

      ..style = PaintingStyle.fill;

    // Calculate animated positions using the animation value if available
    final animationValue = animation?.value ?? 0.0;

    // Animate first circle with pulsating effect
    final circle1Radius = size.width * 0.15 * (1.0 + 0.1 * sin(animationValue * 2 * pi));
    canvas.drawCircle(
      Offset(size.width * 0.9, size.height * 0.2),
      circle1Radius,
      paint,
    );

    // Animate second circle with floating motion
    final circle2Y = size.height * 0.8 + (size.height * 0.02 * sin(animationValue * 2 * pi));
    canvas.drawCircle(
      Offset(size.width * 0.1, circle2Y),
      size.width * 0.1,
      paint,
    );

    // Animate third circle with horizontal movement
    final circle3X = size.width * 0.5 + (size.width * 0.03 * cos(animationValue * 2 * pi));
    canvas.drawCircle(
      Offset(circle3X, size.height * 1.1),
      size.width * 0.2,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    if (oldDelegate is BackgroundPatternPainter) {
      return animation != oldDelegate.animation ||  oldDelegate.isDark;
    }
    return true;
  }
}

class AnimatedPlanCard extends StatefulWidget {
  final MembershipPlan plan;
  final bool isSelected;

  const AnimatedPlanCard({
    super.key,
    required this.plan,
    required this.isSelected,
  });

  @override
  State<AnimatedPlanCard> createState() => _AnimatedPlanCardState();
}
class _AnimatedPlanCardState extends State<AnimatedPlanCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _opacityAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {


    return Padding(
      padding:  EdgeInsets.only(left: MediaQueryHelper.screenWidth(context) * 0.04,right: MediaQueryHelper.screenWidth(context) * 0.04),
      child: FadeTransition(
        opacity: _opacityAnimation,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Container(
            margin: const EdgeInsets.fromLTRB(4, 20, 4, 8),
            decoration: BoxDecoration(
              color: const Color(0xFF1F1F1F) ,
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: widget.plan.gradientColors.first.withValues(alpha:0.15),
                  blurRadius: 15,
                  spreadRadius: 1,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: widget.plan.gradientColors,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(28),
                      topRight: Radius.circular(28),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha:0.25),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha:0.1),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Icon(
                              widget.plan.icon,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.plan.title,
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: -0.5,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                widget.plan.title,
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha:0.9),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                    ],
                  ),
                ),

                // Features
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: widget.plan.gradientColors,
                                ),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.check_rounded,
                                color: Colors.white,
                                size: 12,
                              ),
                            ),
                            const SizedBox(width: 10),
                             Text(
                              AppLocalizations.of(context)!.includedBenefits,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                letterSpacing: -0.3,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Expanded(
                          child: ListView.builder(
                            itemCount: widget.plan.features.length,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.zero,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 14),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(top: 2),
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: widget.plan.gradientColors,
                                        ),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.check,
                                        color: Colors.white,
                                        size: 12,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        widget.plan.features[index],
                                        style: TextStyle(
                                          fontSize: 15,
                                          height: 1.4,
                                          color: Colors.grey[300]

                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: Colors.grey[850]!.withValues(alpha:0.5)
                               ,
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color:
                                  Colors.grey[800]!,
                              width: 1,
                            ),
                          ),
                          child: Column(
                            children: [

                              const SizedBox(height: 4),
                              Text(
                                '${AppLocalizations.of(context)!.fullAccessFor} ${widget.plan.title}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[400]
                                      ,
                                ),
                              ),
                            ],
                          ),
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




// ======================================================================================== Model
class PlanTenureUI {
  final int id;
  final int duration;
  final double price;
  final double discountPrice;
  final String priceText;
  final String durationText;
  final int savePercent;
  final bool? isActivePlan;

  PlanTenureUI({
    required this.id,
    required this.duration,
    required this.price,
    required this.discountPrice,
    required this.priceText,
    required this.durationText,
    required this.savePercent,
    required this.isActivePlan,
  });
}

class MembershipPlan {
  final int? id;
  final String title;
  final List<PlanTenureUI> tenures;
  final List<String> features;
  final String currecnySymbol;
  final List<Color> gradientColors;
  final IconData icon;
  final bool? isActivePlan;

  MembershipPlan({
    required this.id,
    required this.title,
    required this.tenures,
    required this.features,

    required this.gradientColors,
    required this.icon,
    required this.currecnySymbol,
    required this.isActivePlan
  });
}
