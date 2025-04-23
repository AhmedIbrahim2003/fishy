import 'dart:io';

import 'package:flutter/material.dart';

Future<dynamic> resultsBottomSheet(
    {required BuildContext context,
    required File? imageFile,
    required String fishClass,
    required double confidence}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  if (imageFile != null)
                    Container(
                      height: 300,
                      width: double.infinity,
                      margin: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Image.file(
                        imageFile,
                        fit: BoxFit.cover,
                      ),
                    ),
                  Container(
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withValues(alpha: 0.2),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Fish Classification Results',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Species: $fishClass',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Confidence: $confidence%',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
  }