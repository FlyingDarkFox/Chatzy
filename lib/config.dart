import 'package:camera/camera.dart';

import 'config.dart';

export 'package:get_storage/get_storage.dart';

export 'package:get/get.dart';
export 'package:flutter/material.dart';
export 'package:flutter_svg/flutter_svg.dart';

export 'common/theme/index.dart';
export 'package:chatzy_web/widgets/emoji_layout.dart';
export '../../routes/index.dart';
export '../widgets/directionality_rtl.dart';
export 'package:cached_network_image/cached_network_image.dart';
export '../../../controllers/index.dart';
export 'routes/screen_list.dart';
export 'package:chatzy_web/common/extension/text_style_extensions.dart';
export 'package:chatzy_web/common/extension/widget_extension.dart';

export '../common/extension/spacing.dart';
export '../common/extension/text_extension.dart';
export '../common/extension/text_span_extension.dart';
export 'packages_list.dart';
export 'package:chatzy_web/widgets/button_common.dart';
export 'common/assets/index.dart';

export '../../../responsive.dart';
export '../../../widgets/text_field_common.dart';

export '../../../../utils/general_utils.dart';
export '../../../widgets/validation.dart';

export '../../../../models/index.dart';


final appCtrl = Get.isRegistered<AppController>()
    ? Get.find<AppController>()
    : Get.put(AppController());

final firebaseCtrl = Get.isRegistered<FirebaseCommonController>()
    ? Get.find<FirebaseCommonController>()
    : Get.put(FirebaseCommonController());

List<CameraDescription> cameras = [];