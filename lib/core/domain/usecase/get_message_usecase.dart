import 'package:hb/core/data/models/message_conversation_model.dart';
import 'package:hb/core/domain/repository/message_repository.dart';

class GetMessageUsecase {
  final MessageRepository repository;

  GetMessageUsecase(this.repository);

  Future<List<MessageConversationModel>> call({String? search, int perPage = 20}) async {
    return await repository.fetchConversations(search: search, perPage: perPage);
  }
}
