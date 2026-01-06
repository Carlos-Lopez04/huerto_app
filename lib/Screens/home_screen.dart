import 'package:flutter/material.dart';
import 'package:huerto_app/themes/app_theme.dart';
import 'package:huerto_app/config/widgets/cards_custom.dart';
import 'package:huerto_app/themes/app_font.dart';
import 'package:huerto_app/config/menu_app.dart';
import 'package:huerto_app/themes/gradients.dart';
import 'package:huerto_app/screens/profile_screen.dart';
import 'package:huerto_app/config/widgets/bottom_nav_custom.dart'; // NUEVA IMPORTACIÓN

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Controlador para el menú desplegable
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _currentIndex = 1; // Índice para "Inicio"

  // Método para navegar a la pantalla de perfil - CORREGIDO: con parámetro BuildContext
  void _navigateToProfile(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfileScreen(
          user: MenuApp.currentUser,
          onUserUpdated: (updatedUser) {
            MenuApp.updateUser(updatedUser);
            setState(() {});
          },
        ),
      ),
    );
  }

  // Manejo de la navegación del bottom bar
  void _handleNavigation(int index, BuildContext context) {
    setState(() {
      _currentIndex = index;
    });

    switch (index) {
      case 0: // Anterior
        Navigator.pop(context);
        break;
      case 1: // Inicio
        // Ya estamos en home, no hacer nada
        break;
      case 2: // Cuenta
        _navigateToProfile(context);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: emeraldLeaf,

      // MENÚ LATERAL (DRAWER) - AHORA DESDE ARCHIVO SEPARADO
      drawer: MenuApp.buildDrawer(context),
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
          icon: const Icon(Icons.menu, color: cloudWhite),
        ),
        title: Transform.translate(
          offset: const Offset(-20, 0),
          child: Row(
            children: [
              Image.asset(
                'lib/images/app_logo.png',
                height: 50,
              ),
              const SizedBox(width: 2),
              Text(
                'Eco-Huerto',
                style: AppFont.appBarTitle.copyWith(color: cloudWhite),
              ),
            ],
          ),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: AppGradients.appBarPrimary,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle, color: cloudWhite),
            onPressed: () =>
                _navigateToProfile(context), // CORREGIDO: con contexto
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          gradient: AppGradients.plantCard,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            CustomCards.plantasHuerto(context),
            const SizedBox(height: 8),
            CustomCards.calendarioSiembra(context),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: verdeGelido,
                borderRadius: BorderRadius.circular(10),
                boxShadow: AppGradients.cardShadow,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      const Icon(Icons.home, size: 40, color: forestDepth),
                      const SizedBox(height: 4),
                      Text(
                        'Tienda',
                        style: AppFont.bodySmall.copyWith(color: forestDepth),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      const Icon(Icons.attach_money,
                          size: 40, color: forestDepth),
                      const SizedBox(height: 4),
                      Text(
                        'Eco-money',
                        style: AppFont.bodySmall.copyWith(color: forestDepth),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      // BOTTOM NAVIGATION BAR - AHORA DESDE ARCHIVO SEPARADO
      bottomNavigationBar: CustomBottomNav(
        currentIndex: _currentIndex,
        onTap: (index) => _handleNavigation(index, context),
      ),
    );
  }
}
