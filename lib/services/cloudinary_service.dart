import 'package:cloudinary_public/cloudinary_public.dart';

final cloudinary = CloudinaryPublic(
  'de3gkhirr', // e.g. 'demo'
  'image-auth', // your preset name
  cache: false,
);

Future<String> uploadImageToCloudinary(String filePath) async {
  final response = await cloudinary.uploadFile(
    CloudinaryFile.fromFile(filePath, resourceType: CloudinaryResourceType.Image),
  );
  return response.secureUrl;
}
