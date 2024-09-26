import 'dart:math';
import 'dart:ui';

import 'package:graphic/src/algebra/varset.dart';
import 'package:graphic/src/coord/coord.dart';
import 'package:graphic/src/dataflow/tuple.dart';
import 'package:graphic/src/scale/discrete.dart';
import 'package:graphic/src/scale/scale.dart';

import 'modifier.dart';

/// The specification of a jitter modifier.
///
/// The jitter mothed moves objects randomly in their local neighborhood. The random
/// distribution is uniform.
class JitterModifier extends Modifier {
  /// Creates a jitter modifier.
  JitterModifier({
    this.ratio,
  });

  /// Ratio of the local neighborhood to the discrete band for each group.
  ///
  /// If null, a default 0.5 is set.
  double? ratio;

  @override
  bool equalTo(Object other) => other is JitterModifier && ratio == other.ratio;

  @override
  AttributesGroups modify(
      AttributesGroups groups,
      Map<String, ScaleConv<dynamic, num>> scales,
      AlgForm form,
      CoordConv coord,
      Offset origin) {
    final xField = form.first[0];
    final band = (scales[xField] as DiscreteScaleConv).band;

    final ratio = this.ratio ?? 0.5;

    final random = Random();

    final AttributesGroups rst = [];
    for (var group in groups) {
      final groupRst = <Attributes>[];
      for (var attributes in group) {
        final oldPosition = attributes.position;
        final bias = ratio * band * (random.nextDouble() - 0.5);
        groupRst.add(attributes.withPosition(oldPosition
            .map(
              (point) => Offset(point.dx + bias, point.dy),
            )
            .toList()));
      }
      rst.add(groupRst);
    }

    return rst;
  }
}
