import 'package:cached_network_image/cached_network_image.dart';
import 'package:code_test_flutter/data/api/entities/photo_api_model.dart';
import 'package:code_test_flutter/inject/app_injector.dart';
import 'package:code_test_flutter/data/api/photos_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:code_test_flutter/screens/home/home_bloc.dart';
import 'package:code_test_flutter/screens/home/home_contract.dart';
import 'package:code_test_flutter/core/load_state.dart';
import 'package:code_test_flutter/extensions/context_extensions.dart';
import 'package:code_test_flutter/gen/colors.gen.dart';
import 'package:code_test_flutter/res/styles.dart';
import 'package:code_test_flutter/ui/util/touch_effects.dart';

import 'package:code_test_flutter/extensions/navigation_extensions.dart';
import 'package:code_test_flutter/core/routes.dart';

import '../../res/strings.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeBloc>(
      create: (_) => HomeBloc(getIt<PhotosApi>())..add(const HomeEvent.init()),
      child: BlocBuilder<HomeBloc, HomeData>(
        builder: (context, state) {
          return Scaffold(
            body: RefreshIndicator(
              onRefresh: () async {
                final bloc = context.read<HomeBloc>();
                final future = bloc.stream.firstWhere(
                  (s) => s.loadState != LoadState.loading,
                );
                bloc.add(const HomeEvent.refresh());
                await future;
              },
              child: _BodySwitcher(state: state),
            ),
          );
        },
      ),
    );
  }
}

class _BodySwitcher extends StatelessWidget {
  final HomeData state;

  const _BodySwitcher({required this.state});

  @override
  Widget build(BuildContext context) {
    switch (state.loadState) {
      case LoadState.loading:
      case LoadState.empty:
        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: const Center(child: CircularProgressIndicator()),
          ),
        );
      case LoadState.error:
        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Center(
              child: Text(
                state.errorMessage ?? '',
                style: TextStyles.textNormal,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        );
      case LoadState.data:
        return _PhotosSectionContent(state.photos);
    }
  }
}

class _PhotosSectionContent extends StatelessWidget {
  final List<PhotoApiModel> photos;

  const _PhotosSectionContent(this.photos);

  @override
  Widget build(BuildContext context) {
    if (photos.isEmpty) {
      return Center(
        child: Text(
          context.translations.noItems,
          style: TextStyles.textNormal,
        ),
      );
    }
    return GridView.builder(
      padding: const EdgeInsets.only(right: 64, top: 8, bottom: 8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 24,
        mainAxisSpacing: 16,
        mainAxisExtent: 200,
      ),
      itemCount: photos.length,
      itemBuilder: (context, index) {
        return _PhotoItem(photo: photos[index]);
      },
    );
  }
}

class _PhotoItem extends StatelessWidget {
  final PhotoApiModel photo;

  const _PhotoItem({required this.photo});

  @override
  Widget build(BuildContext context) {
    final radius = Radius.circular(8);
    return RippleEffect(
      onTap: () {
        context.navigate(Routes.photoDetailScreen, extra: photo);
      },
      child: ClipRRect(
        borderRadius: BorderRadius.all(radius),
        child: Stack(
          children: <Widget>[
            _PhotoImage(
              image: photo.urls.thumb,
              photoId: photo.id,
            ),
            _PhotoInfo(photo: photo)
          ],
        ),
      ),
    );
  }
}

class _PhotoInfo extends StatelessWidget {
  final PhotoApiModel photo;

  const _PhotoInfo({required this.photo});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        decoration: BoxDecoration(color: ColorName.secondary),
        child: Text(
          (photo.description?.isNotEmpty ?? false) ? photo.description! : Strings.noContentPlaceholder,
          maxLines: 1,
          style: TextStyles.textNormal,
        ),
      ),
    );
  }
}

class _PhotoImage extends StatelessWidget {
  final String image;
  final String photoId;

  const _PhotoImage({required this.image, required this.photoId});

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: photoId,
      child: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: CachedNetworkImage(
          imageUrl: image,
          fit: BoxFit.cover,
          height: 180,
        ),
      ),
    );
  }
}
