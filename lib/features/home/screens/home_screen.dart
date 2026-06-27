import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../features/auth/providers/auth_provider.dart';
import '../../../features/notifications/providers/notification_provider.dart';
import '../../../shared/providers/vendor_provider.dart';
import '../../../shared/models/models.dart';
import '../../../core/widgets/gj_widgets.dart';
import '../../../core/widgets/gj_vendor_card.dart';
import '../../../core/theme/design_tokens.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animCtrl;
  late final List<Animation<double>> _sectionAnims;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _sectionAnims = List.generate(5, (i) {
      final start = i * 0.12;
      return CurvedAnimation(
        parent: _animCtrl,
        curve: Interval(start, (start + 0.28).clamp(0.0, 1.0),
            curve: Curves.easeOutCubic),
      );
    });
    _animCtrl.forward();
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vendorsAsync = ref.watch(vendorsListProvider);
    final categoriesAsync = ref.watch(categoriesProvider);
    final authState = ref.watch(authProvider);
    final activeFilter = ref.watch(vendorFilterProvider);
    final userName = authState.user?.name.split(' ').first ?? 'Pengguna';
    final notifCount = ref.watch(notificationsProvider).unreadCount;

    return Scaffold(
      backgroundColor: GJColors.surface,
      body: SafeArea(
        child: RefreshIndicator(
          color: GJColors.primary,
          onRefresh: () async {
            ref.invalidate(vendorsListProvider);
            ref.invalidate(categoriesProvider);
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(userName, notifCount),
                _buildSearchBar(),
                const SizedBox(height: GJSpacing.xl),
                _buildCategoriesSection(categoriesAsync, activeFilter),
                const SizedBox(height: GJSpacing.xxl),
                _buildFeaturedSection(vendorsAsync),
                const SizedBox(height: GJSpacing.xxl),
                _buildAllVendorsSection(vendorsAsync),
                const SizedBox(height: GJSpacing.xxl),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(String userName, int notifCount) {
    return FadeTransition(
      opacity: _sectionAnims[0],
      child: Padding(
        padding: const EdgeInsets.fromLTRB(GJSpacing.xxl, GJSpacing.xl, GJSpacing.lg, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text.rich(
                  TextSpan(
                    text: 'Halo, ',
                    style: TextStyle(
                      fontSize: 20,
                      color: GJColors.textSoft,
                      height: 1.2,
                    ),
                    children: [
                      TextSpan(
                        text: userName,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: GJColors.ink,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Icon(Icons.location_on_rounded, size: 14, color: GJColors.accent),
                    const SizedBox(width: 4),
                    Text(
                      'Indonesia',
                      style: TextStyle(fontSize: 13, color: GJColors.textSoft, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ],
            ),
            IconButton(
              icon: Stack(
                clipBehavior: Clip.none,
                children: [
                  Icon(Icons.notifications_outlined, color: GJColors.ink),
                  if (notifCount > 0)
                    Positioned(
                      right: -2,
                      top: -2,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: GJColors.danger,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                        child: Text(
                          '$notifCount',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              onPressed: () => context.push('/notifications'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return FadeTransition(
      opacity: _sectionAnims[1],
      child: Padding(
        padding: const EdgeInsets.fromLTRB(GJSpacing.xxl, GJSpacing.lg, GJSpacing.xxl, 0),
        child: InkWell(
          onTap: () => context.push('/search'),
          borderRadius: BorderRadius.circular(GJRadius.lg),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: GJSpacing.lg, vertical: 14),
            decoration: BoxDecoration(
              color: GJColors.card,
              borderRadius: BorderRadius.circular(GJRadius.lg),
              border: Border.all(color: GJColors.border),
              boxShadow: GJShadow.sm,
            ),
            child: Row(
              children: [
                Icon(Icons.search_rounded, color: GJColors.textSoft),
                const SizedBox(width: GJSpacing.md),
                Text(
                  'Cari salon, bengkel, klinik...',
                  style: TextStyle(color: GJColors.textSoft, fontSize: 15),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: GJColors.primarySoft,
                    borderRadius: BorderRadius.circular(GJRadius.sm),
                  ),
                  child: Text(
                    'Cari',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: GJColors.primary),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoriesSection(
      AsyncValue<List<CategoryModel>> categoriesAsync, VendorFilter activeFilter) {
    return FadeTransition(
      opacity: _sectionAnims[2],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: GJSpacing.xxl),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Kategori Layanan',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: GJColors.ink,
                  ),
                ),
                if (activeFilter.categoryId != null)
                  GestureDetector(
                    onTap: () => ref.read(vendorFilterProvider.notifier).setCategory(null),
                    child: Text(
                      'Reset',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: GJColors.primary,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: GJSpacing.md),
          categoriesAsync.when(
            data: (categories) => SizedBox(
              height: 48,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: GJSpacing.lg),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final cat = categories[index];
                  final isSelected = activeFilter.categoryId == cat.id;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: ChoiceChip(
                      label: Text(cat.name),
                      selected: isSelected,
                      onSelected: (selected) {
                        ref.read(vendorFilterProvider.notifier).setCategory(
                          selected ? cat.id : null,
                        );
                      },
                      selectedColor: GJColors.primary,
                      backgroundColor: GJColors.card,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : GJColors.ink,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(GJRadius.pill),
                        side: BorderSide(
                          color: isSelected ? Colors.transparent : GJColors.border,
                          width: 1.5,
                        ),
                      ),
                      elevation: isSelected ? 2 : 0,
                      pressElevation: 3,
                      shadowColor: GJColors.primary.withValues(alpha: 0.3),
                    ),
                  );
                },
              ),
            ),
            loading: () => SizedBox(
              height: 48,
              child: Center(
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    color: GJColors.primary,
                    strokeWidth: 2,
                  ),
                ),
              ),
            ),
            error: (_, __) => const SizedBox(height: 48),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedSection(AsyncValue<List<VendorModel>> vendorsAsync) {
    return FadeTransition(
      opacity: _sectionAnims[3],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: GJSpacing.xxl),
            child: Text(
              'Vendor Unggulan',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: GJColors.ink,
              ),
            ),
          ),
          const SizedBox(height: GJSpacing.md),
          vendorsAsync.when(
            data: (vendors) {
              final featured = vendors.where((v) => v.isFeatured == true).toList();
              if (featured.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: GJSpacing.xxl),
                  child: Container(
                    padding: const EdgeInsets.all(GJSpacing.xl),
                    decoration: BoxDecoration(
                      color: GJColors.surfaceAlt,
                      borderRadius: BorderRadius.circular(GJRadius.lg),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.auto_awesome_outlined, color: GJColors.textSoft, size: 20),
                        const SizedBox(width: GJSpacing.md),
                        Text(
                          'Tidak ada vendor unggulan saat ini.',
                          style: TextStyle(color: GJColors.textSoft, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                );
              }
              return SizedBox(
                height: 230,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: GJSpacing.lg),
                  itemCount: featured.length,
                  itemBuilder: (context, index) {
                    final vendor = featured[index];
                    final delay = index * 0.08;
                    return _FeaturedVendorCard(
                      vendor: vendor,
                      delay: delay,
                    );
                  },
                ),
              );
            },
            loading: () => SizedBox(
              height: 230,
              child: Center(
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    color: GJColors.primary,
                    strokeWidth: 2.5,
                  ),
                ),
              ),
            ),
            error: (err, _) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: GJSpacing.xxl),
              child: Container(
                padding: const EdgeInsets.all(GJSpacing.lg),
                decoration: BoxDecoration(
                  color: GJColors.dangerSoft,
                  borderRadius: BorderRadius.circular(GJRadius.lg),
                ),
                child: Row(
                  children: [
                    Icon(Icons.error_outline, color: GJColors.danger, size: 20),
                    const SizedBox(width: GJSpacing.md),
                    Expanded(
                      child: Text(
                        '$err',
                        style: TextStyle(color: GJColors.danger, fontSize: 13),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAllVendorsSection(AsyncValue<List<VendorModel>> vendorsAsync) {
    return FadeTransition(
      opacity: _sectionAnims[4],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: GJSpacing.xxl),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Semua Vendor',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: GJColors.ink,
                  ),
                ),
                Text(
                  'Lihat semua',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: GJColors.primary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: GJSpacing.md),
          vendorsAsync.when(
            data: (vendors) {
              if (vendors.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: GJSpacing.xxl),
                  child: GJEmptyState(
                    icon: Icons.storefront_outlined,
                    title: 'Belum ada vendor',
                    subtitle: 'Vendor yang tersedia akan muncul di sini.',
                  ),
                );
              }
              return ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(horizontal: GJSpacing.xxl),
                itemCount: vendors.length,
                itemBuilder: (context, index) {
                  final vendor = vendors[index];
                  return _VendorCardItem(
                    vendor: vendor,
                    index: index,
                  );
                },
              );
            },
            loading: () => Padding(
              padding: const EdgeInsets.symmetric(horizontal: GJSpacing.xxl),
              child: GJShimmer(
                child: Column(
                  children: List.generate(
                    3,
                    (_) => Padding(
                      padding: const EdgeInsets.only(bottom: GJSpacing.md),
                      child: GJShimmer.vendorCard(),
                    ),
                  ),
                ),
              ),
            ),
            error: (err, _) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: GJSpacing.xxl),
              child: Container(
                padding: const EdgeInsets.all(GJSpacing.lg),
                decoration: BoxDecoration(
                  color: GJColors.dangerSoft,
                  borderRadius: BorderRadius.circular(GJRadius.lg),
                ),
                child: Row(
                  children: [
                    Icon(Icons.error_outline, color: GJColors.danger, size: 20),
                    const SizedBox(width: GJSpacing.md),
                    Expanded(
                      child: Text(
                        'Gagal memuat vendor',
                        style: TextStyle(color: GJColors.danger, fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FeaturedVendorCard extends StatefulWidget {
  final VendorModel vendor;
  final double delay;

  const _FeaturedVendorCard({required this.vendor, required this.delay});

  @override
  State<_FeaturedVendorCard> createState() => _FeaturedVendorCardState();
}

class _FeaturedVendorCardState extends State<_FeaturedVendorCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _anim = CurvedAnimation(
      parent: _ctrl,
      curve: Curves.easeOutCubic,
    );
    Future.delayed(Duration(milliseconds: (widget.delay * 1000).toInt()), _ctrl.forward);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vendor = widget.vendor;
    final imageUrl = vendor.photos.isNotEmpty
        ? vendor.photos.first.url
        : 'https://picsum.photos/seed/${vendor.id}/400/200';

    return AnimatedBuilder(
      animation: _anim,
      builder: (context, child) {
        return Opacity(
          opacity: _anim.value,
          child: Transform.translate(
            offset: Offset(0, 24 * (1 - _anim.value)),
            child: child,
          ),
        );
      },
      child: Container(
        width: 280,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        child: Material(
          color: GJColors.card,
          borderRadius: GJRadius.card,
          elevation: 0,
          child: InkWell(
            onTap: () => context.push('/vendor/${vendor.slug}'),
            borderRadius: GJRadius.card,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
                  child: Stack(
                    children: [
                      Image.network(
                        imageUrl,
                        height: 130,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          height: 130,
                          color: GJColors.surfaceAlt,
                          child: const Icon(Icons.image, color: GJColors.textSoft),
                        ),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: GJColors.accent,
                            borderRadius: BorderRadius.circular(GJRadius.sm),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.star_rounded, size: 12, color: Colors.white),
                              SizedBox(width: 2),
                              Text(
                                'Unggulan',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(GJSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        vendor.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: GJColors.ink,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.star_rounded, size: 15, color: GJColors.accent),
                          const SizedBox(width: 4),
                          Text(
                            vendor.ratingAvg.toStringAsFixed(1),
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: GJColors.ink,
                            ),
                          ),
                          Text(
                            ' (${vendor.ratingCount})',
                            style: const TextStyle(
                              fontSize: 12,
                              color: GJColors.textSoft,
                            ),
                          ),
                          const Spacer(),
                          Icon(Icons.location_on_rounded, size: 13, color: GJColors.primary),
                          const SizedBox(width: 2),
                          Flexible(
                            child: Text(
                              vendor.city,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: GJColors.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _VendorCardItem extends StatefulWidget {
  final VendorModel vendor;
  final int index;

  const _VendorCardItem({required this.vendor, required this.index});

  @override
  State<_VendorCardItem> createState() => _VendorCardItemState();
}

class _VendorCardItemState extends State<_VendorCardItem>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _anim = CurvedAnimation(
      parent: _ctrl,
      curve: Curves.easeOutCubic,
    );
    Future.delayed(Duration(milliseconds: 200 + widget.index * 80), _ctrl.forward);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (context, child) {
        return Opacity(
          opacity: _anim.value,
          child: Transform.translate(
            offset: Offset(24 * (1 - _anim.value), 0),
            child: child,
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: GJSpacing.md),
        child: GJVendorCard(vendor: widget.vendor),
      ),
    );
  }
}
