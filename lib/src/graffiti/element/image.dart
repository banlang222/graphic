import 'dart:ui';

import 'package:flutter/painting.dart';

import 'element.dart';

// TODO: Image loading functions.

/// The style of [ImageElement].
class ImageStyle extends BlockStyle {
  /// Creates an image style.
  ImageStyle({
    this.blendMode,
    Offset? offset,
    double? rotation,
    Alignment? align,
  }) : super(
          offset: offset,
          rotation: rotation,
          align: align,
        );

  /// The blend mode of the image.
  final BlendMode? blendMode;

  @override
  ImageStyle lerpFrom(covariant ImageStyle from, double t) => ImageStyle(
        blendMode: blendMode,
        offset: Offset.lerp(from.offset, offset, t),
        rotation: lerpDouble(from.rotation, rotation, t),
        align: Alignment.lerp(from.align, align, t),
      );

  @override
  bool operator ==(Object other) =>
      other is ImageStyle && super == other && blendMode == other.blendMode;
}

/// An image element.
class ImageElement extends BlockElement<ImageStyle> {
  /// Creates an image element.
  ImageElement({
    required this.image,
    required Offset anchor,
    Alignment defaultAlign = Alignment.center,
    required ImageStyle style,
    String? tag,
  }) : super(
          anchor: anchor,
          defaultAlign: defaultAlign,
          style: style,
          tag: tag,
        ) {
    paintPoint = getBlockPaintPoint(
        rotationAxis!,
        image.width.toDouble(),
        image.height.toDouble(),
        this.style.align ??
            this.defaultAlign); // TODO: Image width height pixel ratio.
  }

  /// The image to display.
  final Image image;

  @override
  void draw(Canvas canvas) => canvas.drawImage(image, paintPoint, Paint());

  @override
  ImageElement lerpFrom(covariant ImageElement from, double t) => ImageElement(
        image: image,
        anchor: Offset.lerp(from.anchor, anchor, t)!,
        defaultAlign: Alignment.lerp(from.defaultAlign, defaultAlign, t)!,
        style: style.lerpFrom(from.style, t),
        tag: tag,
      );

  @override
  bool operator ==(Object other) =>
      other is ImageElement && super == other && image == other.image;
}
