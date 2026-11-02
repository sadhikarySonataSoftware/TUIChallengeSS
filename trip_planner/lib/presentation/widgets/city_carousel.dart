import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../core/config/api_config.dart';
import '../../domain/entities/city.dart';

class CityCarousel extends StatelessWidget {
  const CityCarousel({
    required this.cities,
    required this.onSelected,
    super.key,
  });

  final List<City> cities;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    if (cities.isEmpty) {
      return const SizedBox(
        height: 150,
        child: Center(child: Text('No destination illustrations available.')),
      );
    }

    return SizedBox(
      height: 200,
      child: ClipRect(
        child: PageView.builder(
          controller: PageController(viewportFraction: 0.90),
          itemCount: cities.length,
          padEnds: true,
          clipBehavior: Clip.hardEdge,
          itemBuilder: (context, index) {
            final city = cities[index];
            final imageUrl = _absoluteUrl(city.imageUrl);

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 12),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.white, width: 3),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.30),
                      blurRadius: 16,
                      spreadRadius: 2,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(21),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => onSelected(city.name),
                      child: Ink(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Color(0xFF172554), Color(0xFF2563EB)],
                          ),
                        ),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            if (imageUrl != null && imageUrl.isNotEmpty)
                              _RemoteCityImage(url: imageUrl),

                            const DecoratedBox(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.transparent,
                                    Color(0xCC020617),
                                  ],
                                ),
                              ),
                            ),

                            Positioned(
                              left: 18,
                              right: 18,
                              bottom: 16,
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.location_on,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      city.name,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge
                                          ?.copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700,
                                          ),
                                    ),
                                  ),
                                  const Icon(
                                    Icons.arrow_forward_rounded,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

String? _absoluteUrl(String? value) {
  if (value == null || value.trim().isEmpty) {
    return null;
  }

  final uri = Uri.tryParse(value);

  if (uri == null) {
    return null;
  }

  if (uri.hasScheme) {
    return value;
  }

  return Uri.parse(ApiConfig.baseUrl).resolve(value).toString();
}

class _RemoteCityImage extends StatelessWidget {
  const _RemoteCityImage({required this.url});

  final String url;

  @override
  Widget build(BuildContext context) {
    final lower = url.toLowerCase();

    if (lower.contains('.svg')) {
      return SvgPicture.network(
        url,
        fit: BoxFit.cover,
        placeholderBuilder: (_) => const SizedBox.shrink(),
      );
    }

    return Image.network(
      url,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      errorBuilder: (_, _, _) => const SizedBox.shrink(),
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) {
          return child;
        }

        return const SizedBox.shrink();
      },
    );
  }
}
