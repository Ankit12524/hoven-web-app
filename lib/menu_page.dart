import 'package:flutter/material.dart';
import 'package:common/models/product_model.dart';
import 'menu_item_card.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  late Map<String, bool> _categoryExpansionState;

  @override
  void initState() {
    super.initState();
    _categoryExpansionState = {
      for (var category in menuCategories) category.name: true,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: const Text('Our Menu'),
            pinned: true,
            expandedHeight: 150,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Pastries',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
              ...menuCategories.map((category) => _buildCategorySection(category)).toList(),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySection(MenuCategory category) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ExpansionPanelList(
        elevation: 0,
        expandedHeaderPadding: EdgeInsets.zero,
        expansionCallback: (int index, bool isExpanded) {
          setState(() {
            _categoryExpansionState[category.name] = isExpanded;
          });
        },
        children: [
          ExpansionPanel(
            headerBuilder: (BuildContext context, bool isExpanded) {
              return ListTile(
                title: Text(
                  category.name,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              );
            },
            body: Column(
              children: category.items.map((item) => MenuItemCard(item: item)).toList(),
            ),
            isExpanded: _categoryExpansionState[category.name] ?? true,
          ),
        ],
      ),
    );
  }
}