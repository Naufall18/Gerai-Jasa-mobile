import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/design_tokens.dart';

class _NavItem {
  final String path;
  final IconData icon;
  final IconData activeIcon;
  final String label;
  const _NavItem(this.path, this.icon, this.activeIcon, this.label);
}

const _items = <_NavItem>[
  _NavItem('/home', Icons.home_outlined, Icons.home_rounded, 'Beranda'),
  _NavItem('/search', Icons.search_outlined, Icons.search_rounded, 'Cari'),
  _NavItem('/bookings', Icons.receipt_long_outlined, Icons.receipt_long_rounded, 'Booking'),
  _NavItem('/profile', Icons.person_outline_rounded, Icons.person_rounded, 'Profil'),
];

/// Shell dengan bottom navigation persisten untuk 4 tab utama.
/// Tab non-aktif → ikon garis abu; aktif → pill amber lembut + ikon/teks pine.
class GJScaffoldWithNav extends StatelessWidget {
  final Widget child;
  final String location;
  const GJScaffoldWithNav({super.key, required this.child, required this.location});

  int get _currentIndex {
    final i = _items.indexWhere((it) => location.startsWith(it.path));
    return i < 0 ? 0 : i;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: const Border(top: BorderSide(color: GJColors.border)),
          boxShadow: GJShadow.sm,
        ),
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: 64,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(_items.length, (i) {
                final item = _items[i];
                final active = i == _currentIndex;
                return Expanded(
                  child: InkWell(
                    onTap: () { if (!active) context.go(item.path); },
                    borderRadius: BorderRadius.circular(GJRadius.lg),
                    child: AnimatedContainer(
                      duration: GJMotion.fast,
                      curve: GJMotion.curve,
                      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                      decoration: BoxDecoration(
                        color: active ? GJColors.accentSoft : Colors.transparent,
                        borderRadius: BorderRadius.circular(GJRadius.lg),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            active ? item.activeIcon : item.icon,
                            size: 22,
                            color: active ? GJColors.primary : GJColors.textSoft,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            item.label,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                              color: active ? GJColors.primary : GJColors.textSoft,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
