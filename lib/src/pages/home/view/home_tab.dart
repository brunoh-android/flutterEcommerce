import 'package:add_to_cart_animation/add_to_cart_animation.dart';
import 'package:add_to_cart_animation/add_to_cart_icon.dart';
import 'package:app_quitanda/src/config/custom_colors.dart';
import 'package:app_quitanda/src/pages/base/controller/navigation_controller.dart';
import 'package:app_quitanda/src/pages/cart/controller/cart_controller.dart';
import 'package:app_quitanda/src/pages/common_widgets/custom_shimmer.dart';
import 'package:app_quitanda/src/pages/home/controller/home_controller.dart';
import 'package:app_quitanda/src/pages/home/view/components/item_tile.dart';
import 'package:app_quitanda/src/services/utlis_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common_widgets/app_name_widget.dart';
import 'components/category_tile.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  late Function(GlobalKey) runAddToCartAnimation;

  final UtilsService utilsService = UtilsService();
  final searchController = TextEditingController();
  final navigationController = Get.find<NavigationController>();

  GlobalKey<CartIconKey> globalKeyCartItems = GlobalKey<CartIconKey>();

  void itemSelectedCartAnimation(GlobalKey gkImage) {
    runAddToCartAnimation(gkImage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: const AppNameWidget(),
        actions: [
          Padding(
            padding: const EdgeInsets.only(top: 15, right: 15),
            child: GetBuilder<CartController>(
              builder: (controller) => GestureDetector(
                onTap: () {
                  navigationController.navigatePageView(NavigationTabs.cart);
                },
                child: Badge(
                  label: Text(
                    controller.cartItems.length.toString(),
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                  textColor: CustomColors.customContrastColor,
                  child: IconButton(
                    onPressed: () {},
                    icon: AddToCartIcon(
                      key: globalKeyCartItems,
                      icon: Icon(
                        Icons.shopping_cart,
                        color: CustomColors.customSwatchColor,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
      body: AddToCartAnimation(
        gkCart: globalKeyCartItems,
        previewDuration: const Duration(milliseconds: 100),
        previewCurve: Curves.ease,
        receiveCreateAddToCardAnimationMethod: (addToCardAnimationMethod) {
          runAddToCartAnimation = addToCardAnimationMethod;
        },
        child: Column(
          children: [
            GetBuilder<HomeController>(
              builder: (controller) => Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: TextFormField(
                  controller: searchController,
                  onChanged: (value) {
                    controller.searchTitle.value = value;
                  },
                  decoration: InputDecoration(
                    filled: true,
                    isDense: true,
                    hintText: 'Pesquise aqui ...',
                    hintStyle:
                        TextStyle(color: Colors.grey.shade400, fontSize: 14),
                    prefixIcon: Icon(
                      Icons.search,
                      color: CustomColors.customContrastColor,
                      size: 21,
                    ),
                    suffixIcon: controller.searchTitle.value.isNotEmpty
                        ? IconButton(
                            onPressed: () {
                              searchController.clear();
                              controller.searchTitle.value = '';
                              FocusScope.of(context).unfocus();
                            },
                            icon: Icon(Icons.close,
                                color: CustomColors.customContrastColor,
                                size: 21),
                          )
                        : null,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(60),
                      borderSide:
                          const BorderSide(width: 0, style: BorderStyle.none),
                    ),
                  ),
                ),
              ),
            ),
            GetBuilder<HomeController>(builder: (controller) {
              return Container(
                padding: const EdgeInsets.only(left: 25),
                height: 40,
                child: !controller.isCategoryLoading
                    ? ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (_, index) {
                          return CategoryTile(
                            category: controller.allCategories[index].title,
                            isSelected: controller.allCategories[index] ==
                                controller.currentCategory,
                            onPressed: () {
                              controller.selectCategory(
                                  controller.allCategories[index]);
                            },
                          );
                        },
                        separatorBuilder: (_, index) =>
                            const SizedBox(width: 10),
                        itemCount: controller.allCategories.length)
                    : ListView.builder(
                        itemCount: 4,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) => Container(
                          padding: const EdgeInsets.all(3.0),
                          child: Align(
                            alignment: Alignment.center,
                            child: CustomShimmer(
                              height: 20,
                              width: 80,
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      ),
              );
            }),
            GetBuilder<HomeController>(
              builder: (controller) {
                return Expanded(
                  child: !controller.isProductLoading
                      ? Visibility(
                          visible: (controller.currentCategory?.items ?? [])
                              .isNotEmpty,
                          replacement: Column(
                            children: [
                              Icon(
                                Icons.search_off,
                                size: 40,
                                color: CustomColors.customSwatchColor,
                              ),
                              const Text('Não há itens para apresentar')
                            ],
                          ),
                          child: GridView.builder(
                              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      mainAxisSpacing: 10,
                                      crossAxisSpacing: 10,
                                      childAspectRatio: 9 / 11.5),
                              itemCount: controller.allProducts.length,
                              itemBuilder: (_, index) {
                                if ((index + 1) ==
                                        controller.allProducts.length &&
                                    !controller.isLastPage) {
                                  controller.loadMoreProducts();
                                }

                                return ItemTile(
                                    item: controller.allProducts[index],
                                    cartAnimationMethod:
                                        itemSelectedCartAnimation);
                              }),
                        )
                      : GridView.count(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                          crossAxisCount: 2,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                          childAspectRatio: 9 / 11.5,
                          children: List.generate(
                            10,
                            (index) => CustomShimmer(
                              height: double.infinity,
                              width: double.infinity,
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
