import 'package:astroverse/db/db.dart';
import 'package:astroverse/models/service.dart';
import 'package:astroverse/utils/resource.dart';

class OrderRepo {
  final _db = Database();

  Future<Resource<Service>> fetchService(String uid, String serviceId) =>
      _db.fetchService(uid, serviceId);
}
