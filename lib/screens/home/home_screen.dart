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
          if (state.loadState == LoadState.empty) {
            return const Center(child: CircularProgressIndicator());
          }
          return Scaffold(
            body: _HomeContent(data: state),
          );
        },
      ),
    );
  }
}

class _HomeContent extends StatelessWidget {
  final HomeData data;

  const _HomeContent({required this.data});

  @override
  Widget build(BuildContext context) {
    switch (data.loadState) {
      case LoadState.data:
        return _PhotosSection(
          data.photos,
        );
      case LoadState.empty:
        return Container();
    }
  }
}

class _PhotosSection extends StatelessWidget {
  final List<PhotoApiModel> photos;

  const _PhotosSection(this.photos);

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        final bloc = context.read<HomeBloc>();
        final future =
            bloc.stream.firstWhere((s) => s.loadState == LoadState.data);
        bloc.add(const HomeEvent.refresh());
        await future;
      },
      child: Stack(
        children: [
          _PhotosSectionContent(photos),
        ],
      ),
    );
  }
}

class _PhotosSectionContent extends StatelessWidget {
  final List<PhotoApiModel> photos;
  final List<Widget> rows = [];

  _PhotosSectionContent(this.photos);

  @override
  Widget build(BuildContext context) {
    for (int i = 0; i < photos.length; i += 2) {
      rows.add(Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            // First photo (always present)
            Expanded(
              child: _PhotoItem(
                photo: photos[i],
                isLeftItem: true,
              ),
            ),

            const SizedBox(width: 8),

            // Second photo (if exists, else empty space)
            if (i + 1 < photos.length)
              Expanded(
                child: _PhotoItem(
                  photo: photos[i + 1],
                  isLeftItem: false,
                ),
              )
            else
              const Expanded(child: SizedBox()),
          ],
        ),
      ));
    }
    if (photos.isEmpty) {
      return Center(
        child: Text(
          context.translations.noItems,
          style: TextStyles.textNormal,
        ),
      );
    } else if (photos.isNotEmpty) {
      return SingleChildScrollView(
        padding: const EdgeInsets.only(right: 64),
        child: Column(
          children: rows,
        ),
      );
    } else {
      return SizedBox.shrink();
    }
  }
}

class _PhotoItem extends StatelessWidget {
  final PhotoApiModel photo;
  final bool isLeftItem;

  const _PhotoItem({required this.photo, required this.isLeftItem});

  @override
  Widget build(BuildContext context) {
    final radius = Radius.circular(8);
    return RippleEffect(
      onTap: () {},
      child: SizedBox(
        height: 200,
        child: Padding(
          padding: EdgeInsets.only(
            left: isLeftItem ? 0 : 8,
            right: !isLeftItem ? 0 : 8,
            bottom: 16,
          ),
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
          (photo.description?.isNotEmpty ?? false)
              ? photo.description!
              : Strings.noContentPlaceholder,
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
