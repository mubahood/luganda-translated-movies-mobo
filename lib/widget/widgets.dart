import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../utils/Utilities.dart';


Widget training_widget(session) {
  return Container(
    padding: const EdgeInsets.only(
        left: 15, right: 15, top: 0, bottom: 10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FxContainer(
          color: Colors.white,
          borderColor: Colors.grey.shade300,
          bordered: true,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
                crossAxisAlignment:
                CrossAxisAlignment.center,
                children: [
                  FxContainer(
                    color: session.status == 'Pending'
                        ? Colors.orange.shade100
                        : session.status == 'Ongoing'
                        ? Colors.green.shade100
                        : session.status == 'Conducted'
                        ? Colors.red.shade100
                        : Colors.grey.shade100,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 4),
                    child: FxText.bodySmall(
                      color: Colors.black,
                      session.status
                          .toString()
                          .toUpperCase(),
                      fontWeight: 800,
                    ),
                  ),
                  FxText.bodyLarge(
                    color: Colors.grey.shade600,
                    Utils.to_date_1(session.created_at),
                    fontWeight: 800,
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              FxText.bodyLarge(
                session.name,
                fontWeight: 600,
              )
              /*Row(
                                              children: [
                                                FxText.bodyLarge(
                                                  session.name,
                                                  fontWeight: 600,
                                                ),
                                                const Icon(
                                                  Icons.arrow_forward,
                                                  size: 18,
                                                  color: Colors.grey,
                                                ),
                                                FxText.bodyLarge(
                                                  session.venue,
                                                  fontWeight: 600,
                                                ),
                                              ],
                                            )*/
              ,
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  const Icon(
                    Icons.access_time,
                    size: 14,
                    color: Colors.grey,
                  ),
                  const SizedBox(
                    width: 3,
                  ),
                  FxText.bodySmall(
                    Utils.to_date_3(session.created_at),
                    fontWeight: 600,
                    color: Colors.grey,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  const Icon(
                    Icons.person,
                    size: 14,
                    color: Colors.grey,
                  ),
                  const SizedBox(
                    width: 2,
                  ),
                  FxText.bodySmall(
                    '${session.status} Seats',
                    color: Colors.grey,
                  ),
                  const Spacer(),
                  const SizedBox(
                    width: 2,
                  ),
                  FxText.bodySmall(
                    'UGX ${Utils.moneyFormat(session.status)}',
                    color: Colors.grey,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
Widget myListLoaderWidget() {
  return ListView(
    children: [
      singleLoadingWidget(),
      singleLoadingWidget(),
      singleLoadingWidget(),
      singleLoadingWidget(),
      singleLoadingWidget(),
    ],
  );
}

Widget singleLoadingWidget() {
  return Padding(
    padding: const EdgeInsets.only(
      left: 15,
      right: 10,
      top: 8,
      bottom: 8,
    ),
    child: Flex(
      direction: Axis.horizontal,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Shimmer.fromColors(
          baseColor: Colors.grey.shade50,
          highlightColor: Colors.grey.shade300,
          child: FxContainer(
            width: Get.width / 4,
            height: Get.width / 4,
            color: Colors.grey,
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
            child: Shimmer.fromColors(
              baseColor: Colors.grey.shade50,
              highlightColor: Colors.grey.shade300,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FxContainer(
                    color: Colors.grey,
                    height: Get.width / 30,
                    width: Get.width / 3,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  FxContainer(
                    height: Get.width / 14,
                    color: Colors.grey,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  FxContainer(
                    height: Get.width / 14,
                    color: Colors.grey,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Flex(
                    direction: Axis.horizontal,
                    children: [
                      FxContainer(
                        color: Colors.grey,
                        height: Get.width / 30,
                        width: Get.width / 6,
                      ),
                      const Spacer(),
                      FxContainer(
                        color: Colors.grey,
                        height: Get.width / 30,
                        width: Get.width / 6,
                      ),
                    ],
                  )
                ],
              ),
            ))
      ],
    ),
  );
}

Widget ShimmerLoadingWidget(
    {double width = double.infinity,
    double height = 200,
    bool is_circle = false,
    double padding = 0.0}) {
  return Padding(
    padding: EdgeInsets.all(padding),
    child: SizedBox(
      width: width,
      height: height,
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade50,
        highlightColor: Colors.grey.shade300,
        child: const FxContainer(),
      ),
    ),
  );
}
