import 'package:bloc_list/bloc_list.dart';
import 'package:example/data/data_service.dart';
import 'package:example/models/chat_model.dart';

class ChatBloc extends ListBloc<ChatModel> {
  final DataService dataService;
  ChatBloc(this.dataService)
      : super(
          dataProvider: ([id]) => dataService.getChatList(id),
          dataAdder: (item) => dataService.addChat(item),
        );
}
