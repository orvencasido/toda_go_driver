import 'package:flutter/material.dart';
import 'package:toda_go_driver/core/constants/app_colors.dart';

class RatingsReviewsScreen extends StatelessWidget {
  const RatingsReviewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Standard mock reviews
    final List<_ReviewItem> reviews = [
      const _ReviewItem(
        name: 'Maria Santos',
        date: 'May 14, 2025',
        rating: 5,
        comment: 'Very smooth ride and courteous driver. Highly recommended! The tricycle was clean and smelled good.',
      ),
      const _ReviewItem(
        name: 'John Doe',
        date: 'May 13, 2025',
        rating: 5,
        comment: 'Arrived on time. The tricycle was clean and the driver was very polite.',
      ),
      const _ReviewItem(
        name: 'Alden Richards',
        date: 'May 12, 2025',
        rating: 5,
        comment: 'Safe driving and polite driver. Great navigation skills!',
      ),
      const _ReviewItem(
        name: 'Maine Mendoza',
        date: 'May 10, 2025',
        rating: 4,
        comment: 'Friendly driver and fast transaction. Highly recommended.',
      ),
      const _ReviewItem(
        name: 'Vice Ganda',
        date: 'May 08, 2025',
        rating: 5,
        comment: 'Super clean and cool ride! Had an amazing conversation with the driver.',
      ),
      const _ReviewItem(
        name: 'Coco Martin',
        date: 'May 06, 2025',
        rating: 5,
        comment: 'Highly recommended for safe trips around the city. Driver was very professional.',
      ),
      const _ReviewItem(
        name: 'Kathryn Bernardo',
        date: 'May 04, 2025',
        rating: 5,
        comment: 'Very professional, clean vehicle, and smooth ride. Excellent service.',
      ),
      const _ReviewItem(
        name: 'Daniel Padilla',
        date: 'May 02, 2025',
        rating: 4,
        comment: 'Responsive and kind. Arrived just a bit late but the ride was pleasant.',
      ),
      const _ReviewItem(
        name: 'Liza Soberano',
        date: 'April 30, 2025',
        rating: 5,
        comment: 'Excellent service! Very helpful with my heavy baggage.',
      ),
      const _ReviewItem(
        name: 'Enrique Gil',
        date: 'April 28, 2025',
        rating: 5,
        comment: 'Good driver, safe ride, and friendly personality. Will book again.',
      ),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF3F5FA),
      body: Column(
        children: [
          // ── Header ────────────────────────────────────────────────────────
          Container(
            width: double.infinity,
            color: AppColors.primaryNavy,
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 8,
              bottom: 16,
              left: 8,
              right: 16,
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
                  onPressed: () => Navigator.pop(context),
                ),
                const Expanded(
                  child: Text(
                    'Ratings & Reviews',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 48), // spacer to center the title
              ],
            ),
          ),

          // ── Scrollable Content ───────────────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // ── Overview Card ──────────────────────────────────────────
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Large Rating Number
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              '4.8',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 44,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryNavy,
                                height: 1.1,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Row(
                              children: List.generate(
                                5,
                                (index) => Icon(
                                  index < 4 ? Icons.star_rounded : Icons.star_half_rounded,
                                  color: const Color(0xFFFFC107),
                                  size: 18,
                                ),
                              ),
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              '128 reviews',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textLight,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 20),
                        // Vertical Divider
                        Container(
                          width: 1.5,
                          height: 80,
                          color: Colors.grey.shade200,
                        ),
                        const SizedBox(width: 20),
                        // Star Breakdown bars
                        Expanded(
                          child: Column(
                            children: [
                              _buildBreakdownRow(5, 0.85),
                              const SizedBox(height: 4),
                              _buildBreakdownRow(4, 0.10),
                              const SizedBox(height: 4),
                              _buildBreakdownRow(3, 0.03),
                              const SizedBox(height: 4),
                              _buildBreakdownRow(2, 0.01),
                              const SizedBox(height: 4),
                              _buildBreakdownRow(1, 0.01),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ── Feedback Title ─────────────────────────────────────────
                  Row(
                    children: const [
                      Text(
                        'Passenger Feedback',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryNavy,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // ── Reviews List ──────────────────────────────────────────
                  ...reviews.map((review) => _buildReviewCard(review)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBreakdownRow(int starCount, double percentage) {
    return Row(
      children: [
        Text(
          '$starCount',
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: AppColors.textLight,
          ),
        ),
        const SizedBox(width: 4),
        const Icon(Icons.star_rounded, color: Color(0xFFFFC107), size: 12),
        const SizedBox(width: 8),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(
              value: percentage,
              backgroundColor: const Color(0xFFF3F5FA),
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFFFC107)),
              minHeight: 6,
            ),
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 26,
          child: Text(
            '${(percentage * 100).toInt()}%',
            textAlign: TextAlign.right,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.textLight,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildReviewCard(_ReviewItem review) {
    final String initial = review.name.isNotEmpty ? review.name[0].toUpperCase() : 'P';
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Initial circle
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: AppColors.profileCardBg,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  initial,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryNavy,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Name and Date
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.name,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryNavy,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      review.date,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 11,
                        color: AppColors.textLight,
                      ),
                    ),
                  ],
                ),
              ),
              // Stars
              Row(
                children: List.generate(
                  5,
                  (index) => Icon(
                    Icons.star_rounded,
                    color: index < review.rating ? const Color(0xFFFFC107) : Colors.grey.shade200,
                    size: 16,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            review.comment,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 13,
              height: 1.4,
              color: AppColors.primaryNavy,
            ),
          ),
        ],
      ),
    );
  }
}

class _ReviewItem {
  final String name;
  final String date;
  final int rating;
  final String comment;

  const _ReviewItem({
    required this.name,
    required this.date,
    required this.rating,
    required this.comment,
  });
}
