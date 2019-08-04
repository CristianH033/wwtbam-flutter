import 'package:flutter/material.dart';
//import 'package:wwtbam_flutter/models/PartidaModel.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';

class LogoSVG extends StatelessWidget {
  // a property on this class
  // a constructor for this class
  final width;
  final height;
  LogoSVG({Key key, @required this.width, this.height}) : super(key: key);
  // LogoSVG();

  Widget build(context) {
    MediaQueryData queryData = MediaQuery.of(context);
    final String assetName = 'assets/images/Logo.svg';
    final Widget svgLogo = new SvgPicture.asset(
      assetName,
      width: width != null ? width : queryData.size.width,
      semanticsLabel: 'Empresa Logo'
    );
    return svgLogo;
  }
}
