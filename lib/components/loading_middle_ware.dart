import 'dart:ui';

import 'package:astroverse/utils/resource.dart';
import 'package:flutter/material.dart';

class LoadingMiddleWare<T> extends StatefulWidget {
  final Future<Resource<T>> asyncData;
  final Widget Function(Success<T>) onLoad;

  const LoadingMiddleWare(
      {super.key, required this.asyncData, required this.onLoad});

  @override
  State<LoadingMiddleWare<T>> createState() => _LoadingMiddleWareState<T>();
}

class _LoadingMiddleWareState<T>
    extends State<LoadingMiddleWare<T>> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Resource<T>>(
        future: widget.asyncData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.isFailure) {
              return const Center(
                child: Text("Could not find"),
              );
            } else {
              return widget.onLoad(snapshot.data! as Success<T>);
            }
          } else {
            return const Center(
              child: SizedBox(
                height: 50,
                width: 50,
                child: CircularProgressIndicator(),
              ),
            );
          }
        },
      ),
    );
  }
}

