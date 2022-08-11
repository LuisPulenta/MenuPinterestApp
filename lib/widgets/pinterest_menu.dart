import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PinterestMenu extends StatelessWidget {
  final bool mostrar;
  final Color backgroundColor;
  final Color activeColor;
  final Color inactiveColor;
  final List<PinterestButton> items;

  PinterestMenu(
      {this.mostrar = true,
      this.backgroundColor = Colors.white,
      this.activeColor = Colors.black,
      this.inactiveColor = Colors.blueGrey,
      required this.items});

//---------------------- Pantalla -----------------------
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => _MenuModel(),
      child: AnimatedOpacity(
        opacity: mostrar ? 1 : 0,
        duration: Duration(milliseconds: 300),
        child: Builder(
          builder: (BuildContext context) {
            Provider.of<_MenuModel>(context).backgroundColor = backgroundColor;
            Provider.of<_MenuModel>(context).activeColor = activeColor;
            Provider.of<_MenuModel>(context).inactiveColor = inactiveColor;
            return _PinterestMenuBackground(
              _MenuItems(items),
            );
          },
        ),
      ),
    );
  }
}

//********************* _PinterestMenuBackground *************************
class _PinterestMenuBackground extends StatelessWidget {
  final Widget child;

  const _PinterestMenuBackground(this.child);
  @override
  Widget build(BuildContext context) {
    Color backgroundColor = Provider.of<_MenuModel>(context).backgroundColor;
    Color activeColor = Provider.of<_MenuModel>(context).activeColor;
    Color inactiveColor = Provider.of<_MenuModel>(context).inactiveColor;
    return Container(
        child: child,
        width: 250,
        height: 60,
        decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: const BorderRadius.all(const Radius.circular(100)),
            boxShadow: [
              const BoxShadow(
                color: Colors.black38,
                offset: const Offset(10, 10),
                blurRadius: 10,
              )
            ]));
  }
}

//********************* _MenuItems *************************
class _MenuItems extends StatelessWidget {
  final List<PinterestButton> menuItems;

  const _MenuItems(this.menuItems);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(menuItems.length,
          (index) => _PinterestMenuButton(index, menuItems[index])),
    );
  }
}

//********************* _PinterestMenuButton *************************
class _PinterestMenuButton extends StatelessWidget {
  final int index;
  final PinterestButton item;

  const _PinterestMenuButton(this.index, this.item);

  @override
  Widget build(BuildContext context) {
    final itemSeleccionado = Provider.of<_MenuModel>(context).itemSeleccionado;
    final menuModel = Provider.of<_MenuModel>(context);
    return GestureDetector(
      child: Container(
        child: Icon(
          item.icon,
          size: itemSeleccionado == index ? 35 : 20,
          color: itemSeleccionado == index
              ? menuModel.activeColor
              : menuModel.inactiveColor,
        ),
      ),
      behavior: HitTestBehavior.translucent,
      onTap: () {
        Provider.of<_MenuModel>(context, listen: false).itemSeleccionado =
            index;
        item.onPressed();
      },
    );
  }
}

//********************* PinterestButton *************************
class PinterestButton {
  final Function onPressed;
  final IconData icon;

  PinterestButton({required this.onPressed, required this.icon});
}

//********************* _MenuModel *************************
class _MenuModel with ChangeNotifier {
  int _itemSeleccionado = 0;
  Color backgroundColor = Colors.white;
  Color activeColor = Colors.black;
  Color inactiveColor = Colors.blueGrey;

  int get itemSeleccionado => _itemSeleccionado;

  set itemSeleccionado(int index) {
    _itemSeleccionado = index;
    notifyListeners();
  }
}
