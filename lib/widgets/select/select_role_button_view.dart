import 'package:flutter/material.dart';
import 'package:werewolves/models/role.dart';

Widget selectRoleButtonView(
    Role role, bool isSelected, count, onPressed, onLongPress) {
  return Card(
    color: isSelected ? Colors.grey[200] : Colors.white,
    child: InkWell(
        onTap: () => onPressed(),
        onLongPress: () => onLongPress(),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(role.getIcon()),
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Text(
                          '${role.getName()} (x$count)',
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                          overflow: TextOverflow.fade,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Text(
                          role.isUnique ? 'Super role' : 'Normal role',
                          style: const TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ),
                      Text(
                        role.getDescription(),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black54,
                        ),
                        overflow: TextOverflow.fade,
                        textAlign: TextAlign.justify,
                      ),
                    ],
                  ),
                ),
              ),
              Icon(
                Icons.check_rounded,
                color: isSelected ? Colors.black : Colors.white,
              )
            ],
          ),
        )),
  );
}
