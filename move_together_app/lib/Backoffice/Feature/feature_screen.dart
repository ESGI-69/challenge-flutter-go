import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:move_together_app/Backoffice/Feature/bloc/feature_bloc.dart';
import 'package:move_together_app/Backoffice/Feature/features_table.dart';
import 'package:move_together_app/Backoffice/Widgets/navigation_bar_backoffice.dart';

class BackofficeFeaturesScreen extends StatefulWidget {
  const BackofficeFeaturesScreen({
    super.key
  });

  @override
  State<BackofficeFeaturesScreen> createState() => _BackofficeFeaturesScreenState();
}

class _BackofficeFeaturesScreenState extends State<BackofficeFeaturesScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const NavigationBarBackoffice(),
      body: BlocProvider(
          create: (context) => FeatureBloc(context)..add(FeaturesDataFetch()),
          child: BlocBuilder<FeatureBloc, FeaturesState>(
              builder: (context, state) {
                if (state is FeaturesDataLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is FeaturesDataLoadingError) {
                  return Center(
                    child: Text(state.errorMessage),
                  );
                } else if (state is FeaturesDataLoadingSuccess) {
                  return SingleChildScrollView(
                    child: SizedBox(
                      width: double.infinity,
                      child: Column(
                        children: [
                          const Text(
                            'LIST OF FEATURES',
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF263238),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: FeaturesTable(
                              features: state.features,
                              patchFeature: (feature) {
                                context.read<FeatureBloc>().add(FeatureDataPatchFeature(feature));
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                }
                return const SizedBox();
              }
          )
      ),
    );
  }
}