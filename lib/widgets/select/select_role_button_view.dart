import 'package:flutter/material.dart';
import 'package:werewolves/models/role.dart';

Widget selectRoleButtonView(Role role, bool isSelected, onPressed) {
  return Card(
    color: isSelected ? Colors.grey[300] : Colors.white,
    child: InkWell(
        onTap: () => onPressed(),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Image.asset(role.getIcon()),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Text(
                          role.getName(),
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          overflow: TextOverflow.fade,
                        ),
                      ),
                      Text(
                        role.getDescription(),
                        style: const TextStyle(fontSize: 12, color: Colors.black54),
                        overflow: TextOverflow.fade,
                      ),
                    ],
                  ),
                ),
              ),
              
              Icon(Icons.check_rounded, color: isSelected ? Colors.black : Colors.white,)
            ],
          ),
        )),
  );
}
