part of 'package:recipe_social_media/utilities/utilities.dart';

class ImageBuilder {
  ImageBuilder(this.imageTransformationBuilder);

  final ImageTransformationBuilder imageTransformationBuilder;

  Widget decideOnAndDisplayImage({required String imageUrl,
    required Widget Function(BuildContext context, dynamic obj1, dynamic obj2) errorBuilder,
    BoxFit? imageFit = BoxFit.cover, ImageTransformationType transformationType = ImageTransformationType.none})
  {
    if (FileSystemEntity.isFileSync(imageUrl)) {
      return displayLocalImage(
          imagePath: imageUrl,
          errorBuilder: errorBuilder,
          imageFit: imageFit);
    }

    return displayCloudinaryImage(
        imageUrl: imageUrl,
        errorBuilder: errorBuilder,
        imageFit: imageFit,
        transformationType: transformationType);
  }

  Widget displayCloudinaryImage({required String imageUrl,
      required Widget Function(BuildContext context, String url, Object error) errorBuilder,
      BoxFit? imageFit = BoxFit.cover, ImageTransformationType transformationType = ImageTransformationType.none})
  {
    return CldImageWidget(
      publicId: imageUrl,
      fit: imageFit,
      errorBuilder: errorBuilder,
      transformation: imageTransformationBuilder.getImageTransformation(transformationType),
    );
  }

  Widget displayLocalImage({required String imagePath,
      required Widget Function(BuildContext context, Object exception, StackTrace? stackTrace) errorBuilder,
      BoxFit? imageFit = BoxFit.cover})
  {
    return Image.file(
        File(imagePath),
        fit: imageFit,
        errorBuilder: errorBuilder);
  }
}