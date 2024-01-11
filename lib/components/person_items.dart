import 'package:astroverse/components/loading_middle_ware.dart';
import 'package:astroverse/components/my_service_item.dart';
import 'package:astroverse/models/save_service.dart';
import 'package:astroverse/repo/service_repo.dart';
import 'package:astroverse/screens/mart_item_full/mart_item_full_screen.dart';
import 'package:flutter/material.dart';

class PersonItems extends StatelessWidget {
  final List<SaveService> list;

  const PersonItems({super.key, required this.list});

  @override
  Widget build(BuildContext context) {
    if (list.isEmpty) return const Text("no posts");
    return ListView.separated(
        itemBuilder: (context, index) => MyServiceItem(
              list[index],
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => LoadingMiddleWare(
                      asyncData: ServiceRepo().fetchService(list[index].id),
                      onLoad: (p0) => MartItemFullScreen(item: p0.data)),
                ));
              },
            ),
        separatorBuilder: (context, index) => const Divider(),
        itemCount: list.length);
  }
}
