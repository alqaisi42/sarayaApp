import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../config/constants.dart';
import 'news_model.dart';


class NewsRepository {
  Future<List<NewsModel>> fetchBreakingNews() async {
    await Future.delayed(Duration(seconds: 1)); // simulate network delay

    return [
      NewsModel(
        id: 1,
        title: 'ترامب مصاب بالقصور الوريدي المزمن .. ما أسبابه وأعراضه؟',
        slug: 'fire-downtown',
        image: 'https://www.sarayanews.com/image.php?token=9e5728b3534aada97f2ef460a76881d5&size=xxlarge&d',
        pubDate: '2025-07-13',
      ),
      NewsModel(
        id: 2,
        title: 'الأمم المتحدة: سوريا تواجه حلقة من العنف تعرض الانتقال السياسي السلمي للخطر',
        slug: 'highway-accident',
        image: 'https://www.sarayanews.com/image.php?token=9595170abde268cff66e14befa6f7f0f&size=',
        pubDate: '2025-07-13',
      ),
      NewsModel(
        id: 3,
        title: 'الأردن في مجلس الأمن: أمن سورية من أمننا والهجمات الإسرائيلية اعتداء سافر',
        slug: 'flood-warning',
        image: 'https://www.sarayanews.com/image.php?token=a9f40653c3ac4d0df705c77c8c370ea4&size=',
        pubDate: '2025-07-13',
      ),
    ];
  }

}
