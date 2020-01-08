import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_provider/model/location.dart';
import 'package:flutter_provider/widgets/third.dart';
import 'package:provider/provider.dart';

class FirstStreamWidget extends StatelessWidget {
  const FirstStreamWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var advancedWonder = Provider.of<LocationModelAdvanced>(context);

    final _width = MediaQuery.of(context).size.width;
    var isNavigation = advancedWonder.name.isNotEmpty;
    print('Inside First Widget');



    void markNeedsBuild() {
      if (isNavigation) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ThirdStreamWidget()),
        );
        advancedWonder.name = '';
        isNavigation = false;
      }
    }

    WidgetsBinding.instance.addPostFrameCallback((_){
      markNeedsBuild();
    });

    return Flexible(
      // child: Text(advancedWonder),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text('${advancedWonder.name}'),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
//            child: CachedNetworkImage(
//              imageUrl: advancedWonder.url,
//              imageBuilder: (context, imageProvider) => Container(
//                decoration: BoxDecoration(
//                  image: DecorationImage(
//                      image: imageProvider,
//                      fit: BoxFit.cover,
//                      colorFilter:
//                      ColorFilter.mode(Colors.red, BlendMode.colorBurn)),
//                ),
//              ),
//              placeholder: (context, url) => CircularProgressIndicator(),
//              errorWidget: (context, url, error) => Icon(Icons.error),
//            ),
            child: CachedNetworkImage(
              fit: BoxFit.cover,
              imageUrl: advancedWonder.url,
              fadeInDuration: Duration(milliseconds: 500),
              fadeInCurve: Curves.easeIn,
              placeholder: (context, url) => SizedBox(
                width: _width,
                child: const FlutterLogo(
                  style: FlutterLogoStyle.horizontal,
                ),
              ),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
          ),
        ],
      ),
    );
  }
}
