import 'package:flutter/material.dart';

class Variables{

  ///This is the entire multi-level list displayed by this app
  static List<Entry> sideBarMenuList(){
    final List<Entry> data = <Entry>[
      Entry('Orders',Icons.category_outlined, <Entry>[
        Entry('Regular Orders'),
      ]),

      Entry('Product',Icons.category_outlined, <Entry>[
        Entry('Add Product'),
        Entry('All Product'),

      ]),

      Entry('Package',Icons.category_outlined, <Entry>[
        Entry('Add Package'),
        Entry('All Package'),

      ]),
      Entry('Category Info',Icons.category_outlined, <Entry>[
        Entry('Category'),
        Entry('Subcategory'),

      ]),
      Entry('Deposit',Icons.category_outlined, <Entry>[
        Entry('Deposit'),
        Entry('Insurance'),
      ]),
      Entry('Transaction',Icons.category_outlined, <Entry>[
        Entry('Withdraw'),
        Entry('Add Amount'),
      ]),

    ];
    return data;
  }
}

class Entry {
  final String title;
  final IconData? iconData;
  final List<Entry>children; //Since this is an expansion list...children can be another list of entries.

  Entry(this.title,[this.iconData,this.children = const <Entry>[]]);
}
