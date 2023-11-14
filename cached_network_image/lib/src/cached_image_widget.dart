import 'package:cached_network_image/cached_network_image.dart';
import 'package:cached_network_image/src/cached_image_widget_origin.dart';
import 'package:cached_network_image_platform_interface/cached_network_image_platform_interface.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

/// We have faced issue with this library with rendering images on WEB specifically for DTC/KNIGHT white labels
/// Issue reproduces because of wrong [CachedNetworkImageProvider] in conjunction with WEB [canvaskit] renderer
/// Reformatting image didn't bring any benefits so just replacing this cashe with default one where it is possible
///
/// Library declare lack of WEB support https://pub.dev/packages/cached_network_image
/// The CachedNetworkImage can be used directly or through the ImageProvider. Both the CachedNetworkImage as CachedNetworkImageProvider have minimal support for web. It currently doesn't include caching.
///
/// Adding stacktrace for more issue explanation
/*
DELETE ImageHandler error Invalid argument: offset is out of bounds stackTrace http://localhost:62764/lib/_engine/engine/canvaskit/image.dart 206:11                       <fn>
http://localhost:62764/lib/_engine/engine/dom.dart 1664:15                                  read
http://localhost:62764/dart-sdk/lib/_internal/js_dev_runtime/patch/async_patch.dart 45:50   <fn>
http://localhost:62764/dart-sdk/lib/async/zone.dart 1407:47                                 _rootRunUnary
http://localhost:62764/dart-sdk/lib/async/zone.dart 1308:19                                 runUnary
http://localhost:62764/dart-sdk/lib/async/future_impl.dart 156:18                           handleValue
http://localhost:62764/dart-sdk/lib/async/future_impl.dart 840:44                           handleValueCallback
http://localhost:62764/dart-sdk/lib/async/future_impl.dart 869:13                           _propagateToListeners
http://localhost:62764/dart-sdk/lib/async/future_impl.dart 641:5                            [_completeWithValue]
http://localhost:62764/dart-sdk/lib/async/future_impl.dart 715:7                            <fn>
http://localhost:62764/dart-sdk/lib/async/zone.dart 1399:13                                 _rootRun
http://localhost:62764/dart-sdk/lib/async/zone.dart 1301:19                                 run
http://localhost:62764/dart-sdk/lib/async/zone.dart 1209:7                                  runGuarded
http://localhost:62764/dart-sdk/lib/async/zone.dart 1249:23                                 callback
http://localhost:62764/dart-sdk/lib/async/schedule_microtask.dart 40:11                     _microtaskLoop
http://localhost:62764/dart-sdk/lib/async/schedule_microtask.dart 49:5                      _startMicrotaskLoop
http://localhost:62764/dart-sdk/lib/_internal/js_dev_runtime/patch/async_patch.dart 181:15  <fn>
 */
class CashedNetworkImage extends CachedNetworkImageOrigin {
  // CashedNetworkImage({required super.imageUrl});

  CashedNetworkImage({
    super.key,
    required super.imageUrl,
    super.httpHeaders,
    super.imageBuilder,
    super.placeholder,
    super.progressIndicatorBuilder,
    super.errorWidget,
    super.fadeOutDuration = const Duration(milliseconds: 1000),
    super.fadeOutCurve = Curves.easeOut,
    super.fadeInDuration = const Duration(milliseconds: 500),
    super.fadeInCurve = Curves.easeIn,
    super.width,
    super.height,
    super.fit,
    super.alignment = Alignment.center,
    super.repeat = ImageRepeat.noRepeat,
    super.matchTextDirection = false,
    super.cacheManager,
    super.useOldImageOnUrlChange = false,
    super.color,
    super.filterQuality = FilterQuality.low,
    super.colorBlendMode,
    super.placeholderFadeInDuration,
    super.memCacheWidth,
    super.memCacheHeight,
    super.cacheKey,
    super.maxWidthDiskCache,
    super.maxHeightDiskCache,
    super.errorListener,
    super.imageRenderMethodForWeb = ImageRenderMethodForWeb.HtmlImage,
  });

  // final String imageUrl;
  // final LoadingErrorWidgetBuilder? errorWidget;
  // final BoxFit? fit;
  // final double? width;
  // final double? height;

  // /// Widget displayed while the target [imageUrl] is loading.
  // final PlaceholderWidgetBuilder? placeholder;
  //
  // const CashedNetworkImage({
  //   super.key,
  //   required this.imageUrl,
  //   this.fit,
  //   this.width,
  //   this.height,
  //   this.errorWidget,
  //   this.placeholder,
  // });

  @override
  Widget build(BuildContext context) {
    return kIsWeb
        ? Image.network(
            imageUrl,
            height: height,
            width: width,
            fit: fit,
            errorBuilder: errorWidget!=null ?(
              BuildContext context,
              Object error,
              StackTrace? stackTrace,
            ) {
              return errorWidget!.call(context, imageUrl, error);
            }:null,
          )
        : CachedNetworkImageOrigin(
            imageUrl: imageUrl,
            fit: fit,
            errorWidget: errorWidget,
          );
  }
}
