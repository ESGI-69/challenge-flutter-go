import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/models/feature.dart';

Map<FeatureNames, String> featureNames = {
  FeatureNames.document: 'document',
  FeatureNames.auth: 'auth',
  FeatureNames.chat: 'chat',
  FeatureNames.trip: 'trip',
  FeatureNames.note: 'note',
  FeatureNames.transport: 'transport',
  FeatureNames.accommodation: 'accommodation',
  FeatureNames.user: 'user',
  FeatureNames.photo: 'photo',
  FeatureNames.activity: 'activity',
};

class FeaturesTable extends StatelessWidget {
  final List<Feature> features;
  final Function patchFeature;

  const FeaturesTable({
    super.key,
    required this.features,
    required this.patchFeature,
  });

  @override
  Widget build(BuildContext context) {
    return Table(
      border: TableBorder.all(
        color: Colors.white,
        width: 2,
      ),
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: [
            const TableRow(
              decoration: BoxDecoration(
                color: Color(0xFFB9F6CA),
              ),
              children: [
                TableCell(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.title),
                          SizedBox(width: 8),
                          Text(
                            'Name',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF263238),
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                TableCell(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.date_range),
                          SizedBox(width: 8),
                          Text(
                            'Updated At',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF263238),
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                TableCell(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.supervised_user_circle),
                          SizedBox(width: 8),
                          Text(
                            'Modified By',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF263238),
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                TableCell(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        "Actions",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF263238),
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ] +
          features.map((feature) {
            return TableRow(
              decoration: const BoxDecoration(
                color: Color(0xFFE8F5E9),
              ),
              children: [
                TableCell(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      featureNames[feature.name]!,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF263238),
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                TableCell(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          DateFormat('kk:mm dd-MM-yyyy')
                              .format(feature.updatedAt),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF263238),
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                TableCell(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      feature.modifiedBy.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF263238),
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                TableCell(
                  child: Align(
                    alignment: Alignment.center,
                    child: Switch(
                        value: feature.isEnabled,
                        activeColor: Colors.green,
                        onChanged: (bool value) {
                          patchFeature(feature.copyWith(isEnabled: value));
                        }),
                  ),
                ),
              ],
            );
          }).toList(),
    );
  }
}
