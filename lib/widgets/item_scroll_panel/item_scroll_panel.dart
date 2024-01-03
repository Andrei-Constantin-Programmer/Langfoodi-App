part of 'package:recipe_social_media/widgets/shared_widgets.dart';

class ItemScrollPanel extends StatelessWidget {
  const ItemScrollPanel(
      {super.key,
      required this.items,
      required this.scrollDirection,
      required this.imageAspectRatio,
      this.onTap,
      this.titleFontSize = 18,
      this.subtitleFontSize = 16,
      this.imageBorderRadius = 20});

  final double titleFontSize;
  final double subtitleFontSize;
  final double imageBorderRadius;
  final double imageAspectRatio;
  final List<ScrollItem> items;
  final Axis scrollDirection;
  final Function? onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: ListView.separated(
            padding: const EdgeInsets.all(8),
            scrollDirection: scrollDirection,
            itemBuilder: (context, index) => buildScrollItem(context, items[index]),
            separatorBuilder: (context, _) => const SizedBox(width: 12),
            itemCount: items.length));
  }

  Widget buildScrollItem(BuildContext context, ScrollItem item) {
    return GestureDetector(
      onTap: () => onTap?.call(item),
      child: Container(
      width: 200,
      padding: const EdgeInsets.only(top: 8.0),
      child: Column(
        children: <Widget>[
          AspectRatio(
              aspectRatio: imageAspectRatio,
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(imageBorderRadius),
                  child: context.read<ImageBuilder>().decideOnAndDisplayImage(
                    isAsset: true,
                    imageUrl: item.urlImage ?? "assets/images/no_image.png",
                    transformationType: ImageTransformationType.standard,
                    errorBuilder: (context, obj1, obj2) {
                      return const CustomIconTile(
                        icon: Icons.close,
                        iconColor: Colors.red,
                        tileColor: Colors.red,
                        borderRadius: 20,
                      );
                    },
                  )
              )),
          const SizedBox(height: 4),
          Text(item.title, style: TextStyle(fontSize: titleFontSize, fontWeight: FontWeight.normal)),
          Text(item.subtitle ?? "", style: TextStyle(fontSize: subtitleFontSize, color: Colors.grey)),
        ],
      ),
    ));
  }
}
