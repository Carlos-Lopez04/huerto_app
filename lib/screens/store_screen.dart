import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:huerto_app/models/user_model.dart';
import 'package:huerto_app/services/user_service.dart';
import 'package:huerto_app/themes/app_theme.dart';
import 'package:huerto_app/themes/app_font.dart';

/// Tienda de eco-money: artículos de vestimenta (camisas, lentes, sombreros)
/// que se desbloquean por nivel y se compran con monedas.
class StoreScreen extends StatefulWidget {
  const StoreScreen({super.key});

  @override
  State<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  final UserService _userService = UserService();

  // Artículos: value se aplica al avatar según la categoría.
  static const List<Map<String, dynamic>> _items = [
    // ---- Camisas (vestimenta) ----
    {
      'id': 'camiseta_verde',
      'name': 'Camiseta Verde',
      'category': 'camisa',
      'value': 'camiseta',
      'cost': 50,
      'level': 1,
      'icon': Icons.checkroom,
      'color': Color(0xFF2E7D32),
    },
    {
      'id': 'overol',
      'name': 'Overol de Jardinero',
      'category': 'camisa',
      'value': 'overol',
      'cost': 90,
      'level': 2,
      'icon': Icons.agriculture,
      'color': Color(0xFF4E6E3B),
    },
    {
      'id': 'camiseta_azul',
      'name': 'Camiseta Azul',
      'category': 'camisa',
      'value': 'camiseta_azul',
      'cost': 70,
      'level': 3,
      'icon': Icons.checkroom,
      'color': Color(0xFF1976D2),
    },
    {
      'id': 'camisa_formal',
      'name': 'Camisa Formal',
      'category': 'camisa',
      'value': 'formal',
      'cost': 120,
      'level': 5,
      'icon': Icons.business_center,
      'color': Color(0xFF42A5F5),
    },
    {
      'id': 'chaqueta',
      'name': 'Chaqueta',
      'category': 'camisa',
      'value': 'chaqueta',
      'cost': 200,
      'level': 7,
      'icon': Icons.dry_cleaning,
      'color': Color(0xFF6D4C41),
    },
    // ---- Lentes ----
    {
      'id': 'lentes_redondos',
      'name': 'Lentes Redondos',
      'category': 'lentes',
      'value': 'redonda',
      'cost': 60,
      'level': 2,
      'icon': Icons.visibility,
      'color': Color(0xFF37474F),
    },
    {
      'id': 'lentes_sol',
      'name': 'Lentes de Sol',
      'category': 'lentes',
      'value': 'sol',
      'cost': 100,
      'level': 4,
      'icon': Icons.wb_sunny,
      'color': Color(0xFF212121),
    },
    {
      'id': 'gafas_deportivas',
      'name': 'Gafas Deportivas',
      'category': 'lentes',
      'value': 'deportiva',
      'cost': 150,
      'level': 6,
      'icon': Icons.sports,
      'color': Color(0xFF1976D2),
    },
    // ---- Sombreros ----
    {
      'id': 'gorra',
      'name': 'Gorra',
      'category': 'sombrero',
      'value': 'gorra',
      'cost': 40,
      'level': 1,
      'icon': Icons.sports_baseball,
      'color': Color(0xFF2E7D32),
    },
    {
      'id': 'sombrero_paja',
      'name': 'Sombrero de Paja',
      'category': 'sombrero',
      'value': 'sombrero_paja',
      'cost': 90,
      'level': 3,
      'icon': Icons.emoji_nature,
      'color': Color(0xFFF0C75E),
    },
    {
      'id': 'sombrero_jardinero',
      'name': 'Sombrero de Jardinero',
      'category': 'sombrero',
      'value': 'sombrero_jardinero',
      'cost': 130,
      'level': 5,
      'icon': Icons.agriculture,
      'color': Color(0xFF4E6E3B),
    },
  ];

  @override
  Widget build(BuildContext context) {
    final user = _userService.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tienda Eco-money'),
        backgroundColor: forestDepth,
        foregroundColor: Colors.white,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        actions: [
          Center(
            child: Container(
              margin: const EdgeInsets.only(right: 16),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: goldenSun,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  const Icon(Icons.monetization_on,
                      size: 16, color: forestDepth),
                  const SizedBox(width: 4),
                  Text(
                    '${user.ecoCoins}',
                    style: AppFont.bodyMedium.copyWith(
                      color: forestDepth,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Desbloquea artículos por nivel y cómpralos con tus monedas.',
            style: AppFont.bodyMedium,
          ),
          const SizedBox(height: 16),
          for (final category in const ['camisa', 'lentes', 'sombrero']) ...[
            _sectionHeader(_categoryLabel(category)),
            for (final item in _items.where((i) => i['category'] == category))
              _buildItemCard(item, user),
            const SizedBox(height: 8),
          ],
        ],
      ),
    );
  }

  String _categoryLabel(String category) {
    switch (category) {
      case 'camisa':
        return 'Camisas';
      case 'lentes':
        return 'Lentes';
      case 'sombrero':
        return 'Sombreros';
      default:
        return '';
    }
  }

  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      child: Text(
        title,
        style: AppFont.titleMedium.copyWith(color: forestDepth),
      ),
    );
  }

  Widget _buildItemCard(Map<String, dynamic> item, UserModel user) {
    final name = item['name'] as String;
    final cost = item['cost'] as int;
    final level = item['level'] as int;
    final icon = item['icon'] as IconData;
    final color = item['color'] as Color;

    final locked = user.level < level;
    final equipped = _isEquipped(item, user);
    final canAfford = user.ecoCoins >= cost;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: color.withValues(alpha: 0.2),
          child: Icon(icon, color: locked ? Colors.grey : color),
        ),
        title: Text(
          name,
          style: AppFont.bodyMedium.copyWith(fontWeight: FontWeight.bold),
        ),
        subtitle: Row(
          children: [
            const Icon(Icons.monetization_on, size: 14, color: goldenSun),
            const SizedBox(width: 4),
            Text('$cost monedas', style: AppFont.bodySmall),
            const SizedBox(width: 8),
            Icon(
              locked ? Icons.lock : Icons.workspace_premium,
              size: 14,
              color: locked ? Colors.grey : emeraldLeaf,
            ),
            const SizedBox(width: 4),
            Text('Nivel $level', style: AppFont.bodySmall),
            if (equipped) ...[
              const SizedBox(width: 8),
              const Text('(equipado)',
                  style: TextStyle(
                      color: emeraldLeaf, fontWeight: FontWeight.bold)),
            ],
          ],
        ),
        trailing: ElevatedButton(
          onPressed: (locked || !canAfford) ? null : () => _buy(item),
          style: ElevatedButton.styleFrom(
            backgroundColor: equipped ? emeraldLeaf : goldenSun,
            foregroundColor: forestDepth,
          ),
          child: Text(
            locked
                ? 'Nivel $level'
                : (equipped ? 'Equipado' : 'Comprar'),
          ),
        ),
      ),
    );
  }

  bool _isEquipped(Map<String, dynamic> item, UserModel user) {
    final category = item['category'] as String;
    final value = item['value'] as String;
    switch (category) {
      case 'camisa':
        return user.outfit == value;
      case 'lentes':
        return user.glassesStyle == value;
      case 'sombrero':
        return user.accessory == value;
      default:
        return false;
    }
  }

  Future<void> _buy(Map<String, dynamic> item) async {
    final name = item['name'] as String;
    final cost = item['cost'] as int;
    final category = item['category'] as String;
    final value = item['value'] as String;

    final ok = await _userService.spendCoins(cost);
    if (!ok) {
      _snack('No tienes suficientes monedas.');
      return;
    }

    var updated = _userService.currentUser;
    switch (category) {
      case 'camisa':
        updated = updated.copyWith(outfit: value);
        break;
      case 'lentes':
        updated = updated.copyWith(hasGlasses: true, glassesStyle: value);
        break;
      case 'sombrero':
        updated = updated.copyWith(accessory: value);
        break;
    }
    _userService.updateUser(updated);

    if (mounted) {
      setState(() {});
      _snack('¡Has equipado "$name"!');
    }
  }

  void _snack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: forestDepth,
        behavior: SnackBarBehavior.floating,
        content: Text(message, style: const TextStyle(color: Colors.white)),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
