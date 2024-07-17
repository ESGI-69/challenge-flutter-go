import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:move_together_app/Provider/auth_provider.dart';
import 'package:move_together_app/Widgets/modal_bottom_sheet_header.dart';
import 'package:move_together_app/core/models/photo.dart';
import 'package:gal/gal.dart';
import 'package:move_together_app/core/services/photo_service.dart';
import 'package:move_together_app/utils/show_unified_dialog.dart';

class PhotoInfo extends StatelessWidget {
  final int tripId;
  final Photo photo;
  final Function(Photo) onDeleteSuccess;

  const PhotoInfo({
    super.key,
    required this.tripId,
    required this.photo,
    required this.onDeleteSuccess,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ModalBottomSheetHeader(
          title: 'Détails',
          actions: [
            BottomShitHeaderAction(
              label: 'Enrigistrer dans la galerie',
              onPressed: () async {
                final imagePath =
                    await PhotoService(context.read<AuthProvider>())
                        .download(tripId, photo.id);
                await Gal.putImage(imagePath);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Photo enregistrée dans la galerie'),
                  ),
                );
              },
            ),
            BottomShitHeaderAction(
              label: 'Supprimer',
              onPressed: () {
                showUnifiedDialog(
                  context: context,
                  title: 'Supprimer la photo',
                  content: 'Êtes-vous sûr de vouloir supprimer cette photo ?',
                  cancelButtonText: 'Annuler',
                  okButtonText: 'Supprimer',
                  onCancelPressed: () => Navigator.of(context).pop(),
                  onOkPressed: () async {
                    await PhotoService(context.read<AuthProvider>())
                        .delete(tripId, photo.id);
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                    onDeleteSuccess(photo);
                  },
                  okButtonTextStyle: const TextStyle(
                    color: Colors.red,
                  ),
                );
              },
              desctructive: true,
            ),
          ],
        ),
        Expanded(
          child: Center(
              child: ExtendedImage.network(
            '${dotenv.env['API_ADDRESS']}${photo.uri}',
            fit: BoxFit.contain,
            headers: {
              'Authorization':
                  context.read<AuthProvider>().getAuthorizationHeader(),
            },
          )),
        ),
      ],
    );
  }
}
