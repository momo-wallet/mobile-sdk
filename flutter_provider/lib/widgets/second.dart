
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_provider/model/location.dart';
import 'package:provider/provider.dart';

class SecondStreamWidget extends StatelessWidget {
  const SecondStreamWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var normalWonder = Provider.of<LocationModelNormal>(context);
    final _width = MediaQuery.of(context).size.width;

    print('Inside Second Widget');

    return Flexible(
      // child: Text(normalWonder),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text('${normalWonder.name}'),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: CachedNetworkImage(
              fit: BoxFit.cover,
              imageUrl: normalWonder.url,
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
