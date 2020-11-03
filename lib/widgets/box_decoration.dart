import 'package:flutter/material.dart';

import 'shadows.dart';

Decoration imageBoxDecoration(imageName) {
  return BoxDecoration(
    image: DecorationImage(image: AssetImage(imageName)),
    boxShadow: [blackShadow()]
  );
}

Decoration whiteBoxDecoration() {
  return BoxDecoration(
    borderRadius: BorderRadius.circular(10.0),
    color: Colors.white,
    boxShadow: [blackShadow()],
  );
}


Decoration greyBoxDecoration() {
  return BoxDecoration(
    borderRadius: BorderRadius.circular(10.0),
    color: Color(0xFF333333),
    boxShadow: [blackShadow()],
  );
}

Decoration orangeBoxDecoration() {
  return BoxDecoration(
    borderRadius: BorderRadius.circular(10.0),
    color: Color(0xFFFF951A),
    boxShadow: [orangeShadow()],
  );
}