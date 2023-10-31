import 'package:astroverse/models/user.dart';
import 'package:astroverse/res/img/images.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PublicProfilePortrait extends StatelessWidget {
  final BoxConstraints cons;
  static const _imageRadius = 60.00;

  const PublicProfilePortrait({super.key, required this.cons});

  @override
  Widget build(BuildContext context) {
    //final User user = Get.arguments;
    final ht = cons.maxHeight;
    const image = ProjectImages.planet;
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        surfaceTintColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: [
            Expanded(
                flex: 7,
                child: MaterialButton(
                  onPressed: () {},
                  color: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: const Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 10,
                    children: [
                      Icon(
                        Icons.call,
                        color: Colors.white,
                        size: 20,
                      ),
                      Text(
                        'Call',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 15),
                      ),
                    ],
                  ),
                )),
            const Spacer(
              flex: 1,
            ),
            Expanded(
                flex: 7,
                child: MaterialButton(
                    onPressed: () {},
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    color: Colors.blue,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: const Wrap(
                      spacing: 10,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Icon(
                          Icons.chat_bubble,
                          color: Colors.white,
                          size: 20,
                        ),
                        Text(
                          'Chat',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 15),
                        ),
                      ],
                    ))),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTopBanner(ht, image),
            const Padding(padding: EdgeInsets.symmetric(horizontal: 10),child: Column(
              children: [
                Text('Name'),
                Text('plan'),
                Text('name'),
              ],
            ),),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBanner(double ht, AssetImage image) {
    return SizedBox(
      height: ht * 0.18 + _imageRadius,
      child: Stack(
        children: [
          Image(
            image: ProjectImages.background,
            width: double.infinity,
            fit: BoxFit.fitWidth,
            height: ht * 0.18,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: CircleAvatar(
              backgroundColor: Colors.white,
              radius: _imageRadius,
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(_imageRadius)),
                child: Image(
                  image: image,
                  fit: BoxFit.fill,
                  height: 2 * (_imageRadius - 5),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
