import 'package:flutter/material.dart';
import 'package:common/models/product_model.dart';

class MenuItemCard extends StatelessWidget {
  final MenuItem item;

  const MenuItemCard({super.key, required this.item});



  @override
  Widget build(BuildContext context) {
    final tm = Theme.of(context);


    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              bottomLeft: Radius.circular(12),
            ),
            child: Image.asset(
              item.imageUrl,
              width: 120,
              height: 120,
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: tm.textTheme.titleLarge,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.description,
                    style: tm.textTheme.bodyMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [

                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          border: BoxBorder.all(color: tm.colorScheme.outlineVariant),
                          color: tm.colorScheme.secondaryContainer,),

                        child: Text('500g - ${item.price500g} rs.',style: tm.textTheme.bodySmall!.copyWith(color: tm.colorScheme.onSurfaceVariant),),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          border: BoxBorder.all(color: tm.colorScheme.outlineVariant),
                          color: tm.colorScheme.secondaryContainer,),

                        child: Text('1kg - ${item.price1kg} rs.',style: tm.textTheme.bodySmall!.copyWith(color: tm.colorScheme.onSurfaceVariant),),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}