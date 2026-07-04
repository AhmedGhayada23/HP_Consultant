import 'package:hb/core/data/models/chat_model.dart';
import 'package:hb/core/domain/repository/chat_repository.dart';

class GetChatUsecase {
  final ChatRepository repository;

  GetChatUsecase(this.repository);

  Future<List<ChatModel>> call({String? search, int perPage = 20}) async {
    return await repository.fetchChats(search: search, perPage: perPage);
  }
}
