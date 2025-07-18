import '../../../config/api_routes.dart';
import '../../../bloc/blocRepository/get_api_repo.dart';
import 'news_model.dart';


class NewsRepository {
  Future<List<NewsModel>> fetchBreakingNews() async {
    final apiRepo = GetapiRepo<NewsModel>(
      url: '$breakingNewsUrl?page=1&per_page=10',
      fromJson: NewsModel.fromJson,
      isToken: false,
    );

    return await apiRepo.getData();
  }
}
