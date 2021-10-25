
import 'package:makb_admin_pannel/model/basic_tile.dart';

final basicTiles = <BasicTile>[

  BasicTile(title: 'Area And Hub', tiles: [
    BasicTile(title: 'Dhaka', tiles: buildHub()),
    BasicTile(title: 'Gazipur', tiles: buildHub()),

  ]),
];

List<BasicTile> buildHub() => [
      'D-Hub_01',
      'D-Hub_02',
      'D-Hub_03',
      'D-Hub_04',
      'D-Hub_05',
      'D-Hub_06',
    ].map<BasicTile>(buildMonth).toList();

BasicTile buildMonth(String month) => BasicTile(
    title: month,
  );
