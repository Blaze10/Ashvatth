import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class ImageSlider extends StatelessWidget {
  final List<String> imageList = [
    'https://firebasestorage.googleapis.com/v0/b/surgimall-admin-dev.appspot.com/o/Ads-Master%2F0RkR1EUC2JbPwmRe3mSt_1590911385683?alt=media&token=99428782-024f-4d23-b1f6-b21f05d408f8',
    'https://firebasestorage.googleapis.com/v0/b/surgimall-admin-dev.appspot.com/o/Ads-Master%2FF5lXsGOOl1V6oUS0PQoM_1590911252278?alt=media&token=19f1106d-5cbf-4609-b773-51cfa364f46b',
    'https://firebasestorage.googleapis.com/v0/b/surgimall-admin-dev.appspot.com/o/Ads-Master%2FrmcAkZi57ooElbFoj6Bi_1590730556320?alt=media&token=92dfe602-eb20-4527-ad44-326022905601'
  ];

  @override
  Widget build(BuildContext context) {
    return _showSwiper(context);
  }

  // swiper
  Widget _showSwiper(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(
        color: Theme.of(context).primaryColor,
        width: 2,
      ))),
      height: MediaQuery.of(context).size.height * 0.27,
      width: MediaQuery.of(context).size.width,
      child: Swiper(
        autoplayDisableOnInteraction: false,
        curve: Curves.easeInOut,
        plugins: [
          SwiperControl(
            color: Theme.of(context).accentColor,
          ),
        ],
        fade: 0.6,
        autoplay: true,
        itemBuilder: (BuildContext context, int index) {
          return CachedNetworkImage(
            imageUrl: imageList[index],
            fit: BoxFit.fill,
            placeholder: (context, url) {
              return Center(child: CircularProgressIndicator());
            },
            errorWidget: (context, url, error) {
              print(error.toString());
              return Center(
                child: Icon(Icons.error_outline,
                    color: Theme.of(context).errorColor),
              );
            },
          );
        },
        itemCount: imageList.length,
        pagination: new SwiperPagination(),
        control: new SwiperControl(),
      ),
    );
  }
}
