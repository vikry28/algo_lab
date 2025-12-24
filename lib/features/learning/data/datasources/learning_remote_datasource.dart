import '../models/learning_model.dart';

abstract class LearningRemoteDataSource {
  Future<List<LearningModel>> fetchLearningItems();
}

class LearningRemoteDataSourceImpl implements LearningRemoteDataSource {
  @override
  Future<List<LearningModel>> fetchLearningItems() async {
    await Future.delayed(const Duration(milliseconds: 500));

    return [
      // ----------------------------------------------------
      // SORTING ALGORITHMS
      // ----------------------------------------------------
      LearningModel(
        id: 'sort1',
        title: 'bubble_sort_title',
        description: 'bubble_sort_desc',
        hasCode: true,
        hasPlay: true,
        hasLink: true,
      ),
      LearningModel(
        id: 'sort2',
        title: 'quick_sort_title',
        description: 'quick_sort_desc',
        hasCode: true,
        hasPlay: true,
        hasLink: true,
      ),
      LearningModel(
        id: 'sort3',
        title: 'merge_sort_title',
        description: 'merge_sort_desc',
        hasCode: true,
        hasPlay: true,
        hasLink: true,
      ),
      LearningModel(
        id: 'sort4',
        title: 'insertion_sort_title',
        description: 'insertion_sort_desc',
        hasCode: true,
        hasPlay: true,
        hasLink: true,
      ),
      LearningModel(
        id: 'sort5',
        title: 'selection_sort_title',
        description: 'selection_sort_desc',
        hasCode: true,
        hasPlay: true,
        hasLink: true,
      ),
      LearningModel(
        id: 'sort6',
        title: 'heap_sort_title',
        description: 'heap_sort_desc',
        hasCode: true,
        hasPlay: true,
        hasLink: true,
      ),

      // ----------------------------------------------------
      // GRAPH ALGORITHMS
      // ----------------------------------------------------
      LearningModel(
        id: 'graph1',
        title: 'dijkstra_title',
        description: 'dijkstra_desc',
        hasCode: true,
        hasPlay: true,
        hasLink: true,
      ),
      LearningModel(
        id: 'graph2',
        title: 'bfs_title',
        description: 'bfs_desc',
        hasCode: true,
        hasPlay: true,
        hasLink: true,
      ),
      LearningModel(
        id: 'graph3',
        title: 'dfs_title',
        description: 'dfs_desc',
        hasCode: true,
        hasPlay: true,
        hasLink: true,
      ),
      LearningModel(
        id: 'graph4',
        title: 'bellman_ford_title',
        description: 'bellman_ford_desc',
        hasCode: true,
        hasPlay: true,
        hasLink: true,
      ),
      LearningModel(
        id: 'graph5',
        title: 'floyd_warshall_title',
        description: 'floyd_warshall_desc',
        hasCode: true,
        hasPlay: true,
        hasLink: true,
      ),
      LearningModel(
        id: 'graph6',
        title: 'kruskal_title',
        description: 'kruskal_desc',
        hasCode: true,
        hasPlay: true,
        hasLink: true,
      ),
      LearningModel(
        id: 'graph7',
        title: 'prim_title',
        description: 'prim_desc',
        hasCode: true,
        hasPlay: true,
        hasLink: true,
      ),

      // ----------------------------------------------------
      // SEARCH ALGORITHMS
      // ----------------------------------------------------
      LearningModel(
        id: 'search1',
        title: 'linear_search_title',
        description: 'linear_search_desc',
        hasCode: true,
        hasPlay: true,
        hasLink: false,
      ),
      LearningModel(
        id: 'search2',
        title: 'binary_search_title',
        description: 'binary_search_desc',
        hasCode: true,
        hasPlay: true,
        hasLink: true,
      ),
      LearningModel(
        id: 'search3',
        title: 'interpolation_search_title',
        description: 'interpolation_search_desc',
        hasCode: true,
        hasPlay: true,
        hasLink: false,
      ),

      // ----------------------------------------------------
      // CRYPTOGRAPHY
      // ----------------------------------------------------
      LearningModel(
        id: 'crypto1',
        title: 'caesar_cipher_title',
        description: 'caesar_cipher_desc',
        hasCode: true,
        hasPlay: true,
        hasLink: false,
      ),
      LearningModel(
        id: 'crypto2',
        title: 'vigenere_cipher_title',
        description: 'vigenere_cipher_desc',
        hasCode: true,
        hasPlay: true,
        hasLink: false,
      ),
      LearningModel(
        id: 'crypto3',
        title: 'rsa_title',
        description: 'rsa_desc',
        hasCode: true,
        hasPlay: false,
        hasLink: true,
      ),
      LearningModel(
        id: 'crypto4',
        title: 'aes_title',
        description: 'aes_desc',
        hasCode: true,
        hasPlay: false,
        hasLink: true,
      ),
      LearningModel(
        id: 'crypto5',
        title: 'sha256_title',
        description: 'sha256_desc',
        hasCode: true,
        hasPlay: false,
        hasLink: true,
      ),
    ];
  }
}
