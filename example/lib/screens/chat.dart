import 'package:bloc_list/bloc_list.dart';
import 'package:example/blocs/chat_bloc.dart';
import 'package:example/models/chat_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Chat')),
        backgroundColor: Colors.white,
        body: SafeArea(
            child: Column(children: [
          _buildChatList(),
          _buildTextComposer(),
        ])));
  }

  _compaseMessage() {
    if (_textController.text.isEmpty) {
      return;
    }

    BlocProvider.of<ChatBloc>(context).add(AddDataEvent(ChatModel(
        message: _textController.text,
        incoming: false,
        created: DateTime.now(),
        isSent: false,
        isSending: true,
        id: 0,
        name: "Chris")));
    _textController.clear();
  }

  Widget _buildTextComposer() {
    return Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: <Widget>[
              Flexible(
                  child: TextField(
                controller: _textController,
                onSubmitted: (value) {
                  _compaseMessage();
                },
                decoration: InputDecoration(
                  focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(40.0)),
                    borderSide: BorderSide(width: 0, color: Colors.grey),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(40.0)),
                    borderSide: BorderSide(width: 0, color: Colors.grey),
                  ),
                  border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(40.0)),
                      borderSide: BorderSide(
                        width: 1,
                      )),
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.send),
                        onPressed: () {
                          _compaseMessage();
                        },
                      )
                    ],
                  ),
                  hintText: " Send a message",
                  fillColor: Colors.grey.withOpacity(0.1),
                  filled: true,
                  contentPadding:
                      const EdgeInsets.only(left: 10, right: 10, top: 20),
                ),
              ))
            ],
          ),
        ));
  }

  Widget _buildChatList() {
    return Expanded(
        child: BlocList<ChatModel, ChatBloc, ListState>(
            listAction: ListAction.append,
            emptyBuilder: (context, state) {
              return Container();
            },
            loadBuilder: (context, state) {
              return const Center(
                  child: CircularProgressIndicator(
                color: Colors.black,
              ));
            },
            onItemAdded: (addedItem) {
              addedItem.isSending = false;
              addedItem.isSent = true;
            },
            loadData: () async {
              BlocProvider.of<ChatBloc>(context).add(LoadDataEvent());
            },
            stateCondition: (state) => state,
            itemBuilder: (context, index, item) {
              return _buildMessage(context, index, item);
            }));
  }

  Widget _buildMessage(BuildContext context, int index, item) {
    var outputFormat = DateFormat('HH:mm');
    var date = outputFormat.format(item.created);

    return Row(
      mainAxisAlignment:
          item.incoming ? MainAxisAlignment.start : MainAxisAlignment.end,
      crossAxisAlignment:
          item.incoming ? CrossAxisAlignment.center : CrossAxisAlignment.end,
      children: [
        item.incoming
            ? Padding(
                padding: const EdgeInsets.only(left: 10, right: 0),
                child: CircleAvatar(
                  radius: 16,
                  backgroundImage:
                      Image.asset("assets/images/person.jpeg").image,
                ))
            : Container(),
        Flexible(
          child: Column(
            crossAxisAlignment: item.incoming
                ? CrossAxisAlignment.start
                : CrossAxisAlignment.end,
            children: [
              Card(
                color: item.incoming ? Colors.green : Colors.blue,
                elevation: 0,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                margin: const EdgeInsets.only(left: 10, right: 0, top: 10),
                child: Padding(
                    padding: const EdgeInsets.only(
                        left: 20, right: 20, top: 10, bottom: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          item.message,
                          style: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        Padding(
                            padding: item.incoming
                                ? const EdgeInsets.only(
                                    left: 0, right: 0, top: 1)
                                : const EdgeInsets.only(
                                    left: 0, right: 0, top: 1),
                            child: Text(
                              date,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 10),
                            ))
                      ],
                    )),
              ),
            ],
          ),
        ),
        Padding(
            padding: const EdgeInsets.only(right: 5, bottom: 5),
            child: _buildSentState(item))
      ],
    );
  }

  Widget _buildSentState(ChatModel item) {
    if (item.incoming) {
      return Container();
    }
    if (item.isSending) {
      return const Padding(
          padding: EdgeInsets.only(left: 2, right: 0, top: 1),
          child: SizedBox(
              width: 10,
              height: 10,
              child: CircularProgressIndicator(
                color: Colors.black,
                strokeWidth: 2,
              )));
    } else if (item.isSent) {
      return const Padding(
          padding: EdgeInsets.only(left: 2, right: 0, top: 1),
          child: Icon(
            Icons.done_all,
            color: Colors.black87,
            size: 16,
          ));
    } else {
      return Container();
    }
  }
}
