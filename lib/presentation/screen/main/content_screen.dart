import 'package:fiqah/data/models/content_model.dart';
import 'package:fiqah/data/services/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provider remains the same
final contentProvider =
    FutureProvider.family<Content?, String>((ref, subMenuTitle) async {
  return DatabaseHelper().getContentBySubMenuTitle(subMenuTitle);
});

class ContentScreen extends ConsumerWidget {
  final String title;
  final String category;

  const ContentScreen({
    Key? key,
    required this.title,
    required this.category,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncContent = ref.watch(contentProvider(title));
    final textTheme = Theme.of(context).textTheme;
    final theme = Theme.of(context);

    return Scaffold(
      // extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        // backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: asyncContent.when(
        data: (contentData) {
          if (contentData == null) {
            return const Center(child: Text('Konten tidak ditemukan.'));
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildCategoryHeader(context),
                const SizedBox(height: 24),
                Text(
                  'Materi Pembahasan',
                  style: textTheme.headlineSmall
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),

                // ======== KEY CHANGE: FROM Text TO MarkdownBody ========
                MarkdownBody(
                  data: contentData.content,
                  styleSheet: MarkdownStyleSheet(
                    p: textTheme.bodyLarge?.copyWith(height: 1.6),
                    h3: textTheme.titleLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                    listBullet: textTheme.bodyLarge,
                    // Gaya untuk teks di dalam kutipan (blockquote)
                    blockquote: textTheme.bodyLarge?.copyWith(
                      color:
                          theme.textTheme.bodyMedium?.color?.withOpacity(0.9),
                    ),

                    // Dekorasi untuk kotak di belakang kutipan
                    blockquoteDecoration: BoxDecoration(
                      color: theme.colorScheme.primary
                          .withOpacity(0.1), // Warna latar adaptif
                      borderRadius: BorderRadius.circular(8.0),
                    ),

                    // Padding di dalam kotak kutipan
                    blockquotePadding: const EdgeInsets.all(16),
                  ),
                ),
                // =======================================================

                const SizedBox(height: 32),

                // ======== NEW WIDGET: DISPLAY REFERENCES ========
                if (contentData.reference != null &&
                    contentData.reference!.isNotEmpty)
                  _buildReferenceCard(context, contentData.reference!),
                // ================================================
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }

  // Helper widget for the category header
  Widget _buildCategoryHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: Theme.of(context).primaryColor),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Kategori: $category',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper widget to display references beautifully
  Widget _buildReferenceCard(BuildContext context, String references) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Referensi Ilmiah',
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Text(
            references,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  height: 1.7,
                  color: Colors.grey.shade700,
                ),
          ),
        ),
      ],
    );
  }
}
