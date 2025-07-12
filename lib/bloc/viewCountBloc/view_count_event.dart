
import 'package:equatable/equatable.dart';

abstract class ViewCountEvent extends Equatable {
  @override
  List<Object?> get props => [];
}


class InitializeViewCounts extends ViewCountEvent {
  final Map<String, int> initialCounts;

  InitializeViewCounts({required this.initialCounts});

  @override
  List<Object?> get props => [initialCounts];
}

class UpdateViewCount extends ViewCountEvent {
  final String slug;
  final int apiViewCount;

  UpdateViewCount({
    required this.slug,
    required this.apiViewCount,
  });

  @override
  List<Object?> get props => [slug, apiViewCount];
}