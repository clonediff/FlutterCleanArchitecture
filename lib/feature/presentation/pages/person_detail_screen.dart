import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/common/app_colors.dart';
import 'package:flutter_clean_architecture/feature/domain/entities/person_entity.dart';
import 'package:flutter_clean_architecture/feature/presentation/widgets/person_cache_image_widget.dart';

class PersonDetailPage extends StatelessWidget {
  final PersonEntity person;

  const PersonDetailPage({
    super.key,
    required this.person,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Character'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const SizedBox(
              height: 24,
            ),
            Text(
              person.name,
              style: const TextStyle(
                fontSize: 28,
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            PersonCacheImage(
              width: 260,
              height: 260,
              imageUrl: person.image,
            ),
            const SizedBox(
              height: 16,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 12,
                  width: 12,
                  decoration: BoxDecoration(
                      color:
                          person.status == 'Alive' ? Colors.green : Colors.red,
                      borderRadius: BorderRadius.circular(8)),
                ),
                const SizedBox(
                  width: 8,
                ),
                Text(
                  person.status,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                  maxLines: 1,
                ),
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            if (person.type.isNotEmpty) ..._buildText('Type', person.type),
            ..._buildText('Gender:', person.gender),
            ..._buildText(
                'Number of episodes:', person.episode.length.toString()),
            ..._buildText('Species:', person.species),
            ..._buildText('Last known location:', person.location.name),
            ..._buildText('Origin:', person.origin.name),
            ..._buildText('Was created:', person.created.toIso8601String()),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildText(String text, String value) {
    return [
      Text(
        text,
        style: const TextStyle(
          color: AppColors.greyColor,
        ),
      ),
      const SizedBox(
        height: 4,
      ),
      Text(
        value,
        style: const TextStyle(
          color: Colors.white,
        ),
      ),
      const SizedBox(
        height: 12,
      ),
    ];
  }
}
