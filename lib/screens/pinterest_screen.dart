import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:menu_pinterest_app/widgets/pinterest_menu.dart';
import 'package:provider/provider.dart';

//**************************** PinterestScreen *******************************

class PinterestScreen extends StatelessWidget {
  const PinterestScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => _MenuModel(),
      child: Scaffold(
          appBar: AppBar(
            title: Text('Pinterest'),
            centerTitle: true,
          ),
          body: Stack(
            children: [
              PinterestGrid(),
              _PinterestMenuLocation(),
            ],
          )),
    );
  }
}

//**************************** _PinterestMenuLocation ********************
class _PinterestMenuLocation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final widthPantalla = MediaQuery.of(context).size.width;
    final mostrar = Provider.of<_MenuModel>(context).mostrar;
    return Positioned(
      bottom: 10,
      child: Container(
        width: widthPantalla,
        child: Align(
          child: PinterestMenu(
            mostrar: mostrar,
            backgroundColor: Colors.white,
            activeColor: Colors.purple,
            inactiveColor: Colors.cyan,
            items: [
              PinterestButton(
                  icon: Icons.pie_chart,
                  onPressed: () {
                    print('Icon pie_chart');
                  }),
              PinterestButton(
                  icon: Icons.search,
                  onPressed: () {
                    print('Icon search');
                  }),
              PinterestButton(
                  icon: Icons.notifications,
                  onPressed: () {
                    print('Icon notifications');
                  }),
              PinterestButton(
                  icon: Icons.supervised_user_circle,
                  onPressed: () {
                    print('Icon supervised_user_circle');
                  }),
            ],
          ),
        ),
      ),
    );
  }
}

//**************************** PinterestGrid *******************************

class PinterestGrid extends StatefulWidget {
  @override
  State<PinterestGrid> createState() => _PinterestGridState();
}

class _PinterestGridState extends State<PinterestGrid> {
//---------------------------- Variables ------------------------------
  final List<int> items = List.generate(200, (index) => index);
  ScrollController controller = ScrollController();
  double scrollAnterior = 0;

//---------------------------- Pantalla ------------------------------
  @override
  void initState() {
    controller.addListener(() {
      //print("ScrollListener ${controller.offset}");
      if (controller.offset > scrollAnterior && controller.offset > 150) {
        //print("Ocultar Menú)");
        Provider.of<_MenuModel>(context, listen: false).mostrar = false;
      } else {
        //print("Mostrar Menú)");
        Provider.of<_MenuModel>(context, listen: false).mostrar = true;
      }
      scrollAnterior = controller.offset;
    });
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

//---------------------------- Pantalla ------------------------------
  @override
  Widget build(BuildContext context) {
    return GridView.custom(
      controller: controller,
      physics: BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 10),
      gridDelegate: SliverWovenGridDelegate.count(
        crossAxisCount: 2,
        pattern: [
          WovenGridTile(1),
          WovenGridTile(
            5 / 7,
            crossAxisRatio: 0.9,
            alignment: AlignmentDirectional.centerEnd,
          ),
        ],
      ),
      childrenDelegate: SliverChildBuilderDelegate(
          (context, index) => _PinterestItem(index: index),
          childCount: items.length),
    );
  }
}

//**************************** _PinterestItem *******************************

class _PinterestItem extends StatelessWidget {
  final int index;
  const _PinterestItem({required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.all(Radius.circular(30))),
      child: Center(
        child: CircleAvatar(
          backgroundColor: Colors.white,
          child: Text('$index'),
        ),
      ),
    );
  }
}

//**************************** _MenuModel *******************************
class _MenuModel with ChangeNotifier {
  bool _mostrar = true;

  bool get mostrar => this._mostrar;

  set mostrar(bool valor) {
    this._mostrar = valor;
    notifyListeners();
  }
}
